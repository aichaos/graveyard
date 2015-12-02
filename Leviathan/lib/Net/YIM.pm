package Net::YIM;

use strict;
use warnings;
use IO::Socket;
use IO::Select;
use LWP::UserAgent;
use HTTP::Request;
use Data::Dumper;   # debugging

our $VERSION = '0.02';

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	my $self = {
		server     => 'dcs2.chat.dcn.yahoo.com',
		port       => 5050,
		authserv   => 'http://edit.my.yahoo.com',
		username   => '',
		password   => '',
		handlers   => {},
		select     => new IO::Select(),
		socket     => undef,
		yv         => undef,
		tz         => undef,
		identifier => 0,
		debug      => 0,
		lastping   => 0,
		@_,
	};

	bless ($self,$class);
	return $self;
}

sub debug {
	my ($self,$msg) = @_;
	return unless $self->{debug};
	print "Net::YIM // $msg\n";
}

sub connect {
	my $self = shift;
	if ($self->HTTPAuth()) {
		# Connect to Yahoo.
		$self->{socket} = new IO::Socket::INET (
			PeerAddr => $self->{server},
			PeerPort => $self->{port},
			Proto    => 'tcp',
		) or die "Net::YIM Connection error: $!";

		$self->{select}->add ($self->{socket});
		$self->sendraw (10,30,0,"\x30\xC0\x80$self->{username}\xC0\x801\xC0\x80$self->{username}\xC0\x806\xC0\x80$self->{yv}; $self->{tz}"."\xC0\x80");
		$self->{lastping} = time();
	}
	else {
		die "ERROR: HTTP Authentication Error";
	}
}

sub HTTPAuth {
	my $self = shift;

	my $req = HTTP::Request->new (POST => $self->{authserv});
	$req->content(".src=&login=$self->{username}&passwd=$self->{password}&n=1");
	return 0 unless ( ($self->{yv},$self->{tz}) = LWP::UserAgent->new()->request($req)->as_string =~ /(Y=v=.*?);.*?(T=z=.*?);/s );
	return 1;
}

sub sendraw {
	my ($self,$ver,$id,$ret,$body) = @_;
	my $packet = pack ("a4nNnN2","YMSG",$ver,length($body),$id,$ret,$self->{identifier}) . $body;
	$self->{socket}->send ($packet);
}

sub setHandler {
	my ($self, $event, $handler) = @_;

	die "setHandler EVENT not defined" unless defined $event;
	die "setHandler HANDLER not defined" unless defined $handler;

	$self->{handlers}->{$event} = $handler;
}

sub _event {
	my ($self,$event) = (shift,shift);
	my $function = $self->{handlers}->{$event};
	if (defined $function) {
		return &{$function} ($self,@_);
	}
	return undef;
}

sub do_one_loop {
	my $self = shift;

	# Ping again?
	if (time() >= ($self->{lastping} + 120)) {
		$self->sendraw (10,161,0,"109\xC0\x80$self->{username}\xC0\x80");
		$self->{lastping} = time();
	}

	my @ready = $self->{select}->can_read(.1);
	foreach my $sock (@ready) {
		my $buf = '';
		sysread ($sock, $buf, 2048, length ( $buf || '' ) );
		if (defined $buf) {
			my ($signature, $version, $length, $event_code, $return, $identifier, $data) = unpack ("a4nNnN2a*",$buf);
			$self->{identifier} = $identifier;

			if ($event_code == 85) {
				my ($listdata) = $data =~ /\xC0\x80(.*?)\xC0\x80/s;
				@{$self->{buddylist}->{$1}} = split(",", $2) while ($listdata =~ m/(.*?):(.*?)\n/gs);
				$self->sendraw (10,150,0,"1\xC0\x80$self->{username}\xC0\x806\xC0\x80abcdef\xC0\x8098\xC0\x80us\xC0\x80135\xC0\x80dc125\xC080");
				$self->_event ('Connected');
			}
			elsif ($event_code == 6) {
				my ($to,$from,$msg) = $data =~ /\xC0\x80(.*?)\xC0\x804\xC0\x80(.*?)\xC0\x80\d+\xC0\x80(.*?)\xC0\x80/;
				$self->_event ('Message',$from,$msg);
			}
			else {
				$self->debug ("Unknown event code: $event_code");
				$self->debug ("Data: $data");
			}
		}

		undef $buf;
	}
}

sub start {
	my $self = shift;

	while (1) {
		$self->do_one_loop();
	}
}

sub listGroups {
	my $self = shift;
	return keys %{$self->{buddylist}};
}
sub getBuddies {
	my ($self,$group) = @_;
	return @{$self->{buddylist}->{$group}};
}

sub sendMessage {
	my ($self,$to,$message,%data) = @_;

	# For easy usage, %data can be a hash setting up basic message data
	# (so you don't have to mess with ASCII codes yourself):
	# font => Font family
	# color => Color (HEX Codes)
	# style => B, I, U
	if (%data) {
		# (re)format the message.
		my $prefix = '';
		my $newmsg = $message;
		if (exists $data{color}) {
			$prefix = "\x1B[$data{color}m";
		}
		if (exists $data{font}) {
			$prefix .= "<font face=\"$data{font}\">";
		}
		if (exists $data{style}) {
			my @parts = split(//, $data{style});
			foreach my $part (@parts) {
				$part = uc($part);
				next unless $part =~ /^(B|I|U)$/i;
				$newmsg = "<$part>$newmsg</$part>";
			}
		}
		$message = join ("", $prefix, $newmsg);
	}

	my $body = "1\xC0\x80$self->{username}\xC0\x805\xC0\x80$to\xC0\x8014\xC0\x80$message\xC0\x8097\xC0\x801\xC0\x8063\xC0\x80;0\xC0\x8064\xC0\x800\xC0\x801002\xC0\x801\xC0\x80206\xC0\x802\xC080";
	$self->sendraw (0,32,1515563605,$body);
}

1;
__END__

=head1 NAME

Net::YIM - Perl interface to Yahoo Messenger.

=head1 SYNOPSIS

  use Net::YIM;

  # Create a new YIM connection.
  my $yahoo = new Net::YIM (
                  username => 'PerlYIM',
                  password => 'bigsecret',
  );

  # Set up handlers.
  $yahoo->setHandler (event => \&subroutine);

  # Connect and start looping.
  $yahoo->connect();
  $yahoo->start();

=head1 DESCRIPTION

Net::YIM provides an interface to connect to Yahoo Messenger via the CHAT2
protocol.

=head1 METHODS

=head2 new (ARGUMENTS)

Creates a new Net::YIM instance. Passed in are the username and password in
a hash form, and (optionally) anything else you may want, such as server and host.

  my $yahoo = new Net::YIM (username => 'PerlYIM', password => 'bigsecret');

=head2 connect

Connect to Yahoo Messenger via the CHAT2 protocol. This method should be called
after you have completed setting up your bot (i.e. specifying handlers).

  $yahoo->connect;

=head2 setHandler (EVENT_NAME => CODEREF)

Specify a handler for Net::YIM to use when handling certain server events.

  # example
  $yahoo->setHandler (Connected => \&on_connect);

=head2 start

Starts a loop of do_one_loops.

  $yahoo->start;

=head2 do_one_loop

Does a single loop on the CHAT2 server.

  $yahoo->do_one_loop;

=head2 sendMessage (TO, MESSAGE[, DATA])

Send a message to recipient TO. Optionally pass in hash "DATA" to define message font,
color, and style.

  $yahoo->sendMessage ("YahooMaster", "Greetings from Perl YIM!",
       font  => 'Comic Sans MS',
       color => '#ff0000', # red
       style => 'BI',      # bold italics
  );

=head2 listGroups

Returns an array containing each of your buddylist groups.

  my @groups = $yahoo->listGroups;

=head2 getBuddies (GROUP)

Returns an array of all your buddies in the specified GROUP.

  my @friends = $yahoo->getBuddies ("Friends");

=head1 AUTHOR

Cerone J. Kirsle, cerone[at]aichaos[dot]com

=head1 CHANGES

Version 0.02

  - Cleaned up the code (used \x escape codes instead of including actual ASCII characters, etc.)

Version 0.01

  - Initial release.

=head1 COPYRIGHT AND LICENSE

  Net::YIM - Perl interface to Yahoo Messenger
  Copyright (C) 2005  Cerone Kirsle

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

  - Used protocol docs from http://www.venkydude.com/articles/yahoo.htm
  - Some code referenced from Matt Austin's YahooSimple.pm (www.bot-depot.com)

=cut
