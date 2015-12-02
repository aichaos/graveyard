#!/usr/bin/perl -w

# AiChaos Leviathan
# Copyright (C) 2005 Cerone Kirsle

# This bot requires Perl 5.8 or higher.
require 5.8.00;

# Unlink the warnings log.
unlink ("./logs/warnings.txt") if (-e "./logs/warnings.txt");

# Declare the body hash.
our $chaos = {};
$| = 1;

# Setup signal handlers.
$chaos->{system}->{suppress} = 0;
$SIG{__WARN__} = sub {
	my ($warn) = @_;

	if ($chaos->{system}->{suppress} == 0) {
		print "$warn\n";
	}

	# Log it.
	if ($chaos->{config}->{warnings} == 1) {
		open (LOG, ">>./logs/warnings.txt");
		print LOG localtime() . ": $warn\n\n";
		close (LOG);
	}
};

# Data about this release.
$chaos->{version} = '2.0';
$chaos->{author}  = 'Cerone Kirsle';
$chaos->{debug} = 0;

# Command-line arguments.
$chaos->{system}->{restrict_listeners} = 0;
$chaos->{system}->{maintain}->{on} = 0;
$chaos->{system}->{maintain}->{msg} = '';
if (defined @ARGV) {
	foreach my $command (@ARGV) {
		$command = lc($command);
		if ($command eq '/?' || $command eq '-?') {
			print "AiChaos Leviathan\n"
				. "=================\n"
				. "Command-Line Arguments:\n"
				. "\t" . '/m - Start bots in Maintenance Mode' . "\n"
				. "\t" . '/s - Suppress Perl Warnings' . "\n"
				. "\t" . '/d - Enable Debug Mode' . "\n"
				. "\t" . '/aim - Only run AIM bots.' . "\n"
				. "\t" . '/msn - Only run MSN bots.' . "\n"
				. "\t" . '/irc - Only run IRC bots.' . "\n"
				. "\t" . '/toc - Only run TOC bots.' . "\n"
				. "\t" . '/http - Only run HTTP bots.' . "\n"
				. "\t" . '/smtp - Only run SMTP bots.' . "\n"
				. "\t" . '/cyan - Only run CYAN bots.' . "\n"
				. "\t" . '/yahoo - Only run YAHOO bots.' . "\n"
				. "\t" . '/jabber - Only run Jabber bots.' . "\n"
				. "Any number of these arguments can be used together.\n\n";
			exit (0);
		}
		elsif ($command =~ /^\/(aim|msn|irc|toc|jabber|http|smtp|yahoo|cyan)$/i) {
			my $im = $1;
			$chaos->{system}->{restrict_listeners} = 1;
			$chaos->{system}->{allowed_listeners}->{$im} = 1;
		}
		elsif ($command eq '/m') {
			# Maintenance Mode.
			$chaos->{system}->{maintain}->{on} = 1;
			$chaos->{system}->{maintain}->{msg} = "AIM Users: add AidenCKS to your buddylist.\nMSN: Add aiden\@aichaos.com";
		}
		elsif ($command eq '/s') {
			# Suppress Perl warnings.
			$chaos->{system}->{suppress} = 1;
		}
		elsif ($command eq '/d') {
			# Enable debug mode.
			$chaos->{debug} = 1;
		}
		else {
			print "\a" . "Invalid command-line argument! Use /? for help.\n\n";
			exit (0);
		}
	}
}

# Special start-up options?
my @special = ();
if ($chaos->{debug} == 1) {
	push (@special, "--Debug Mode Activated");
}
if ($chaos->{system}->{suppress} == 1) {
	push (@special, "--Suppressing Perl Warnings");
}
if ($chaos->{system}->{maintain}->{on} == 1) {
	push (@special, "--Starting Up in Maintenance Mode");
}
if ($chaos->{system}->{restrict_listeners} == 1) {
	my @listed = ();
	foreach my $allowed (keys %{$chaos->{system}->{allowed_listeners}}) {
		$allowed = uc($allowed);
		push (@listed, $allowed);
	}
	push (@special, "--Restricting Listeners (Only " . CORE::join (", ", @listed) . ")");
}

# Include modules.
use lib "./libtwo";
use lib "./lib";                 # Use local library.
use strict;                      # Better coding.
use warnings;                    # More warnings.
use File::Basename;              # Get the root of the bot.
use LWP::Simple;                 # Get URL's.
use URI::Escape;                 # URI Escaping.
use Games::Multiplayer::Manager; # For multiplayer gaming made easy!

# Declare the CKS::Panic sub in case any errors come up.
sub panic {
	my ($msg,$fatal) = @_;

	# Print the message.
	print "\t\a" . "CKS::Panic // $msg\n\n";

	# If fatal...
	if ($fatal == 1) {
		sleep (1000);
		exit(0);
	}
}

# Create a new game manager.
$chaos->{games} = new Games::Multiplayer::Manager (debug => 1);
$chaos->{games}->setHandler (broadcast => \&gamesend);

# Get back to the wanted working directory.
my $filepath = dirname($0);
chdir ($filepath);

# Do a startup timer (just to see how long it takes to initialize).
my $startup = time();

# Print the startup message.
print <<intro;
             ::.                   .:.
              .;;:  ..:::::::.  .,;:
                ii;,,::.....::,;;i:
              .,;ii:          :ii;;:
            .;, ,iii.         iii: .;,
           ,;   ;iii.         iii;   :;.
.         ,,   ,iii,          ;iii;   ,;
 ::       i  :;iii;     ;.    .;iii;.  ,,      .:;
  .,;,,,,;iiiiii;:     ,ii:     :;iiii;;i:::,,;:
    .:,;iii;;;,.      ;iiii:      :,;iiiiii;,:
         :;        .:,,:..:,,.        .:;..
          i.                  .        ,:
          :;.         ..:...          ,;
           ,;.    .,;iiiiiiii;:.     ,,
            .;,  :iiiii;;;;iiiii,  :;:
               ,iii,:        .,ii;;.
               ,ii,,,,:::::::,,,;i;
               ;;.   ...:.:..    ;i
               ;:                :;
               .:                ..
                ,                :
intro
print <<banner;
 +-----------------------------------------------+
 I AiChaos Leviathan version $chaos->{version} is starting...  I
 +-----------------------------------------------+
banner
if (@special) {
	print CORE::join ("\n", @special);
	print "\n";
}
sleep (3);

# Begin loading stuff.
print ":: Loading local library... Done!\n";

# Load the configuration files.
print ":: Loading configuration \"settings.cfg\"... ";
require "./config/settings.cfg";
print "Done!\n";

# Load the substitutions...
print ":: Loading substitution data... ";
open (SUBS, "./data/substitution.dat");
my @subs = <SUBS>;
close (SUBS);
chomp @subs;
foreach my $line (@subs) {
	next if length $line == 0;
	next if $line =~ /^\#/;

	my ($level,$in,$out) = split(/==/, $line, 3);

	$chaos->{system}->{substitution}->{$in}->{level} = $level;
	$chaos->{system}->{substitution}->{$in}->{replace} = $out;
}
print "Done!\n";

# Load Perl files.
print ":: Including Perl files...\n";
my @resdirs = (
	"1=./brains",
	"0=./clients",
	"0=./commands",
	"0=./config",
	"0=./data",
	"1=./handlers/aim",
	"1=./handlers/msn",
	"1=./handlers/irc",
	"1=./handlers/toc",
	"1=./handlers/yahoo",
	"1=./handlers/jabber",
	"1=./handlers/cyan",
	"1=./handlers/http",
	"1=./handlers/smtp",
	"0=./logs",
	"1=./subroutines",
);
foreach my $folder (@resdirs) {
	# Get data on this folder.
	my ($useperl,$name) = split(/=/, $folder, 2);
	&panic ("Missing required directory $name",1) unless (-e $name);

	# Get the directory type.
	my $dirtype;
	$dirtype = "subroutines" if $name eq './subroutines';
	$dirtype = "handlers" if $name =~ /^\.\/handlers/i;
	$dirtype = "brains" if $name eq './brains';
	$dirtype = "void" if $name =~ /^\.\/(bots|clients|commands|config|data|logs)/i;
	&panic ("Unknown directory type: $name",0) unless length $dirtype > 0;

	# If a Perl directory...
	if ($useperl == 1) {
		opendir (DIR, $name);
		foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
			# Get our Perl file extensions...
			my $perlext = $chaos->{config}->{files}->{perl};
			if ($file =~ /\.($perlext)$/i) {
				# Include it!
				print "\tIncluding $name/$file... ";
				my $fname = $file;
				$fname =~ s/\.($perlext)$//i if $dirtype eq 'brains';
				$chaos->{system}->{$dirtype}->{$fname} = require "$name/$file";
				print "Done!\n";
			}
		}
		closedir (DIR);
	}
}

# Anonymously call startup sub.
&startup();

# Index Commands.
print ":: Indexing Commands...\n";
&load_commands();

# Clear temporary data.
print ":: Clearing temporary files... ";
mkdir ("./data/temp") unless (-d "./data/temp");
opendir (TEMP, "./data/temp");
foreach my $file (sort(grep(!/^\./, readdir(TEMP)))) {
	unlink ("./data/temp/$file");
}
closedir (TEMP);
print "Done!\n";

# Load userdata.
print ":: Loading Userdata... ";
&load_userdata();
print "Done!\n";

# Listeners whose modules have been loaded?
my %loaded = (
	aim    => 0,
	msn    => 0,
	irc    => 0,
	jabber => 0,
	http   => 0,
	cyan   => 0,
);

# Load the bots.
print ":: Loading the bots... ";
opendir (DIR, "./bots");
foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
	next unless $file =~ /\.($chaos->{config}->{files}->{bots})$/i;
	my $data = do "./bots/$file";

	# Go through the mirrors.
	foreach my $id (keys %{$data->{mirrors}}) {
		# Restricting listeners?
		if ($chaos->{system}->{restrict_listeners} == 1) {
			# See if this one is allowed.
			my $listener = $data->{mirrors}->{$id}->{listener};
			$listener = lc($listener);
			if (!exists $chaos->{system}->{allowed_listeners}->{$listener}) {
				$data->{mirrors}->{$id}->{active} = 0;
			}
		}

		# Only continue if the mirror is active.
		if ($data->{mirrors}->{$id}->{active} == 1) {
			# Get this bot's screenname.
			my $sn = $data->{mirrors}->{$id}->{screenname};
			$sn = lc($sn);
			$sn =~ s/ //g;

			# Save toplevel data.
			$chaos->{bots}->{$sn}->{data}     = $data->{data};
			$chaos->{bots}->{$sn}->{brain}    = $data->{brain};
			$chaos->{bots}->{$sn}->{replies}  = $data->{replies};
			$chaos->{bots}->{$sn}->{listener} = $data->{listener};

			# Save parameters.
			foreach my $param (keys %{$data->{mirrors}->{$id}}) {
				my $value = $data->{mirrors}->{$id}->{$param};
				$param = lc($param);
				$param =~ s/ //g;
				$chaos->{bots}->{$sn}->{$param} = $value;
			}

			# Load modules for this listener.
			my $listener = $chaos->{bots}->{$sn}->{listener};
			$listener = lc($listener);
			if ($loaded{$listener} == 0) {
				my $mods;
				$mods = "use Net::OSCAR qw(:standard);" if $listener eq 'aim';
				$mods = "use Net::AIM;" if $listener eq 'toc';
				$mods = "use Net::IRC;" if $listener eq 'irc';
				$mods = "use MSN;" if $listener eq 'msn';
				$mods = "use HTTP::Daemon; use HTTP::Status; use HTTP::Headers; use HTTP::Response;" if $listener eq 'http';
				$mods = "use Net::Jabber qw(Client); use Net::Jabber::Message;" if $listener eq 'jabber';
				$mods = "use IO::Socket::INET; use Net::Server::Mail::SMTP;" if $listener eq 'smtp';
				$mods = "use Net::YIM;" if $listener eq 'yahoo';
				$mods = "use Net::CyanChat;" if $listener eq 'cyan';
				eval ($mods);
				$loaded{$listener} = 1;
			}
		}
	}
}
closedir (DIR);
print "Done!\n";

# Load bot data.
print ":: Loading bot profiles... ";
foreach my $bot (keys %{$chaos->{bots}}) {
	next if $chaos->{bots}->{$bot}->{listener} =~ /^smtp$/i;
	&load_botfile ($bot);
}
print "Done!\n";

# Load bots' reply data.
print ":: Loading bot reply data... ";
foreach my $bot (keys %{$chaos->{bots}}) {
	next if $chaos->{bots}->{$bot}->{listener} =~ /^smtp$/i;
	# Load its data.
	my $brain = $chaos->{bots}->{$bot}->{brain};
	my $reply = $chaos->{bots}->{$bot}->{replies};

	my $loaded = &load_brain ($bot,$brain,$reply);
	&panic ("Could not load brain for $bot: $loaded",1) unless $loaded eq '1';
}
print "Done!\n";

# Finally... connect the bots!
print ":: Connecting the bots...\n";
foreach my $key (keys %{$chaos->{bots}}) {
	# Start connecting them up!
	my $listener = $chaos->{bots}->{$key}->{listener};
	$listener = uc($listener);
	$listener =~ s/ //g;

	my $password = '';

	# Go through the listeners...
	if ($listener eq 'AIM') {
		# New AIM bot.
		print "\tSigning on $key to AIM... ";

		# Create a new Net::OSCAR instance.
		$chaos->{bots}->{$key}->{client} = new Net::OSCAR (capabilities => [qw(typing_status buddy_icons)]);

		# Setup all the AIM handlers.
		$chaos->{bots}->{$key}->{client}->set_callback_admin_error (\&aim_admin_error);
		$chaos->{bots}->{$key}->{client}->set_callback_admin_ok (\&aim_admin_ok);
		$chaos->{bots}->{$key}->{client}->set_callback_auth_challenge (\&aim_auth_challenge);
		$chaos->{bots}->{$key}->{client}->set_callback_buddy_in (\&aim_buddy_in);
		$chaos->{bots}->{$key}->{client}->set_callback_buddy_info (\&aim_buddy_info);
		$chaos->{bots}->{$key}->{client}->set_callback_buddy_out (\&aim_buddy_out);
		$chaos->{bots}->{$key}->{client}->set_callback_buddylist_error (\&aim_buddylist_error);
		$chaos->{bots}->{$key}->{client}->set_callback_buddylist_ok (\&aim_buddylist_ok);
		$chaos->{bots}->{$key}->{client}->set_callback_chat_buddy_in (\&aim_chat_buddy_in);
		$chaos->{bots}->{$key}->{client}->set_callback_chat_buddy_out (\&aim_chat_buddy_out);
		$chaos->{bots}->{$key}->{client}->set_callback_chat_closed (\&aim_chat_joined);
		$chaos->{bots}->{$key}->{client}->set_callback_chat_im_in (\&aim_chat_im_in);
		$chaos->{bots}->{$key}->{client}->set_callback_chat_invite (\&aim_chat_invite);
		$chaos->{bots}->{$key}->{client}->set_callback_chat_joined (\&aim_chat_joined);
		$chaos->{bots}->{$key}->{client}->set_callback_error (\&aim_error);
		$chaos->{bots}->{$key}->{client}->set_callback_evil (\&aim_evil);
		$chaos->{bots}->{$key}->{client}->set_callback_im_in (\&aim_im_in);
		$chaos->{bots}->{$key}->{client}->set_callback_rate_alert (\&aim_rate_alert);
		$chaos->{bots}->{$key}->{client}->set_callback_signon_done (\&aim_signon_done);
		$chaos->{bots}->{$key}->{client}->set_callback_new_buddy_icon (\&aim_new_buddy_icon);
		$chaos->{bots}->{$key}->{client}->set_callback_buddy_icon_uploaded (\&aim_buddy_icon_uploaded);
		$chaos->{bots}->{$key}->{client}->set_callback_buddy_icon_downloaded (\&aim_buddy_icon_downloaded);
		$chaos->{bots}->{$key}->{client}->set_callback_typing_status (\&aim_typing_status);

		# Sign on the bot.
		$password = $chaos->{bots}->{$key}->{password};

		$chaos->{bots}->{$key}->{client}->signon ($key,$password) or &panic ("Could not connect $key to AIM!",0);
		print "Connection received!\n";
	}
	elsif ($listener eq 'MSN') {
		# New MSN bot.
		print "\tSigning on $key to MSN... ";

		# Create a new MSN instance.
		$password = $chaos->{bots}->{$key}->{password};
		$chaos->{bots}->{$key}->{client} = MSN->new (
			Handle   => $key,
			Password => $password,
			Debug    => 0,
		);

		# Set the ClientCaps.
		$chaos->{bots}->{$key}->{client}->setClientCaps (
			'Client-Name' => "AiChaos Leviathan (BOT)/$chaos->{version}",
			'Client-Type' => 'BOT',
			'Chat-Logging' => 'Y',
		);

		# Set the font settings.
		my ($font,$color,$style) = &get_font ($key,'MSN');
		$chaos->{bots}->{$key}->{client}->setMessageStyle (
			Font   => $font,
			Color  => $color,
			Effect => $style,
		);

		# Setup MSN handlers.
		$chaos->{bots}->{$key}->{client}->setHandler (Connected             => \&msn_connected);
		$chaos->{bots}->{$key}->{client}->setHandler (Disconnected          => \&msn_disconnect);
		$chaos->{bots}->{$key}->{client}->setHandler (ClientCaps            => \&msn_clientcaps);
		$chaos->{bots}->{$key}->{client}->setHandler (ContactAddingUs       => \&msn_add);
		$chaos->{bots}->{$key}->{client}->setHandler (ContactRemovingUs     => \&msn_remove);
		$chaos->{bots}->{$key}->{client}->setHandler (Message               => \&msn_message);
		$chaos->{bots}->{$key}->{client}->setHandler (Typing                => \&msn_typing);
		$chaos->{bots}->{$key}->{client}->setHandler (Ring                  => \&msn_ring);
		$chaos->{bots}->{$key}->{client}->setHandler (Answer                => \&msn_answer);
		$chaos->{bots}->{$key}->{client}->setHandler (MemberJoined          => \&msn_join);
		$chaos->{bots}->{$key}->{client}->setHandler (RoomClosed            => \&msn_close);
		$chaos->{bots}->{$key}->{client}->setHandler (FileReceiveInvitation => \&msn_file);

		# Sign on the bot.
		$chaos->{bots}->{$key}->{client}->connect() or &panic ("Could not connect $key to MSN!",0);
		print "Connection received!\n";
	}
	elsif ($listener eq 'YAHOO') {
		# New Yahoo bot.
		my $password = $chaos->{bots}->{$key}->{password};
		print "\tSigning on $key to Yahoo... ";

		# Create a new Yahoo instance.
		$chaos->{bots}->{$key}->{client} = new Net::YIM (
			username => $key,
			password => $password,
			debug    => 1,
		);

		# Setup handlers.
		$chaos->{bots}->{$key}->{client}->setHandler (Connected => \&yahoo_connected);
		$chaos->{bots}->{$key}->{client}->setHandler (Message   => \&yahoo_message);

		# Connect.
		$chaos->{bots}->{$key}->{client}->connect() or &panic ("Could not connect $key to Yahoo!",0);
		print "Connection received!\n";
	}
	elsif ($listener eq 'IRC') {
		print "\tSigning on $key to IRC... ";

		my $irc_success = 1;

		# Create a new Net::IRC instance.
		$chaos->{bots}->{$key}->{client} = new Net::IRC;
		$chaos->{bots}->{$key}->{_conn} = $chaos->{bots}->{$key}->{client}->newconn (
			Nick     => $key,
			Password => $chaos->{bots}->{$key}->{password},
			Server   => $chaos->{bots}->{$key}->{server},
			Port     => $chaos->{bots}->{$key}->{port},
			Ircname  => "AiChaos Leviathan $chaos->{version}",
		) or $irc_success = 0;

		# If it wasn't successful...
		if ($irc_success == 0) {
			&panic ("Could not connect $key to IRC!",0);
			delete $chaos->{bots}->{$key};
			next;
		}

		# Set up handlers.
		$chaos->{bots}->{$key}->{_conn}->add_handler ('msg', \&irc_pm);
		$chaos->{bots}->{$key}->{_conn}->add_handler ('chat', \&irc_chat);
		$chaos->{bots}->{$key}->{_conn}->add_handler ('public', \&irc_public);
		$chaos->{bots}->{$key}->{_conn}->add_handler ('caction', \&irc_action);
		$chaos->{bots}->{$key}->{_conn}->add_handler ('umode', \&irc_umode);
		$chaos->{bots}->{$key}->{_conn}->add_handler ('cdcc', \&irc_dcc);
		$chaos->{bots}->{$key}->{_conn}->add_handler ('topic', \&irc_topic);
		$chaos->{bots}->{$key}->{_conn}->add_handler ('notopic', \&irc_topic);

		$chaos->{bots}->{$key}->{_conn}->add_global_handler ([ 251,252,253,254,302,255 ], \&irc_init);
		$chaos->{bots}->{$key}->{_conn}->add_global_handler ('disconnect', \&irc_disconnect);
		$chaos->{bots}->{$key}->{_conn}->add_global_handler (376, \&irc_connect);
		$chaos->{bots}->{$key}->{_conn}->add_global_handler (433, \&irc_nick_taken);
		$chaos->{bots}->{$key}->{_conn}->add_global_handler (353, \&irc_names);

		# Connect!
		print "Connection received!\n";
	}
	elsif ($listener eq 'TOC') {
		print "\tSigning on $key to TOC... ";

		my $password = $chaos->{bots}->{$key}->{password};

		# Create a TOC object.
		$chaos->{bots}->{$key}->{client} = new Net::AIM;
		$chaos->{bots}->{$key}->{client}->newconn (
			Screenname => $key,
			Password   => $password,
		) or &panic ("Could not connect to AIM TOC server: $!");
		$chaos->{bots}->{$key}->{client}->{botscreenname} = $key;

		# Set handlers.
		my $conn = $chaos->{bots}->{$key}->{client}->getconn;
		$conn->set_handler ('error', \&toc_error);
		$conn->set_handler ('im_in', \&toc_im_in);
		$conn->set_handler ('eviled', \&toc_evil);
		$conn->set_handler ('config', \&toc_signon_done);
		$conn->set_handler ('chat_join', \&toc_chat_join);
		$conn->set_handler ('chat_invite', \&toc_chat_invite);
		$conn->set_handler ('chat_update_buddy', \&toc_chat_update_buddy);
		$conn->set_handler ('chat_in', \&toc_chat_im_in);
		$conn->set_handler ('update_buddy', \&toc_update_buddy);

		# Connection complete.
		print "Connection received!\n";
	}
	elsif ($listener eq 'JABBER') {
		# Shorten some variables.
		my $user = $key;
		my $pass = $chaos->{bots}->{$key}->{password};
		my $host = $chaos->{bots}->{$key}->{server};

		$user =~ s/\@$host$//ig;

		print "\tSigning on $key to Jabber... ";

		# Create a new Jabber client object.
		$chaos->{bots}->{$key}->{client} = new Net::Jabber::Client();

		# Connect to the Jabber server.
		$chaos->{bots}->{$key}->{client}->Connect (hostname => $host);

		# Failure to connect?
		if (!$chaos->{bots}->{$key}->{client}->Connected) {
			&panic ("Could not connect $key to Jabber!",0);
			delete $chaos->{bots}->{$key};
			next;
		}

		# Send auth info.
		my @auth = $chaos->{bots}->{$key}->{client}->AuthSend (
			username => $user,
			password => $pass,
			resource => "AiChaos Leviathan $chaos->{version}",
		);

		# Set callbacks.
		my $jabber = $chaos->{bots}->{$key}->{client};
		$chaos->{bots}->{$key}->{client}->SetMessageCallBacks (chat => sub { &jabber_message ($jabber,$key,@_); });

		# Set our presence and get contact list.
		$chaos->{bots}->{$key}->{client}->PresenceSend();
		$chaos->{bots}->{$key}->{client}->RosterGet();

		# Connected!
		print "Connection received!\n";
	}
	elsif ($listener eq 'HTTP') {
		my ($host,$port) = split(/:/, $key, 2);
		$port = 80 unless defined $port;
		print "\tConnecting $host:$port to HTTP... ";

		# Create the daemon.
		$chaos->{bots}->{$key}->{client} = new HTTP::Daemon (
			LocalAddr => $host,
			LocalPort => $port,
			Timeout   => .1,
		);

		print "Connection received!\n";
	}
	elsif ($listener eq 'SMTP') {
		my ($host,$port) = split(/:/, $key, 2);
		$port = 25 unless defined $port;
		print "\tConnecting $host:$port to SMTP... ";

		# Create the server.
		$chaos->{bots}->{$key}->{client} = new IO::Socket::INET (
			Listen    => 1,
			LocalHost => $host,
			LocalPort => $port,
			Timeout   => .1,
		);

		print "Connection received!\n";
	}
	elsif ($listener eq 'CYAN') {
		print "\tConnecting $key to CyanChat... ";

		# Connect.
		$chaos->{bots}->{$key}->{client} = new Net::CyanChat (proto => 1, debug => 1);

		# Set up handlers.
		$chaos->{bots}->{$key}->{client}->setHandler (Connected        => \&cyan_connected);
		$chaos->{bots}->{$key}->{client}->setHandler (Welcome          => \&cyan_welcome);
		$chaos->{bots}->{$key}->{client}->setHandler (Message          => \&cyan_message);
		$chaos->{bots}->{$key}->{client}->setHandler (Private          => \&cyan_private);
		$chaos->{bots}->{$key}->{client}->setHandler (Ignored          => \&cyan_ignored);
		$chaos->{bots}->{$key}->{client}->setHandler (Chat_Buddy_In    => \&cyan_buddy_in);
		$chaos->{bots}->{$key}->{client}->setHandler (Chat_Buddy_Out   => \&cyan_buddy_out);
		$chaos->{bots}->{$key}->{client}->setHandler (Chat_Buddy_Here  => \&cyan_buddy_here);
		$chaos->{bots}->{$key}->{client}->setHandler (Name_Accepted    => \&cyan_name_accepted);
		$chaos->{bots}->{$key}->{client}->setHandler (Error            => \&cyan_error);

		# Stamp our nickname.
		$chaos->{bots}->{$key}->{client}->{_leviathan} = $key;

		# Connect.
		$chaos->{bots}->{$key}->{client}->connect();
	}
	else {
		# Unknown or Unsupported Messenger.
		&panic ("Unknown Messenger: \"$key\" signing onto \"$listener\"!",1);
	}
}
print ":: Initialization complete!\n\n";

# See how long it took.
my $elapse = time() - $startup;
print "--- Leviathan started up in $elapse seconds ---\n\n";

# Save some local data...
$chaos->{system}->{signon} = time();

open (SAVE, ">./data/local/signon.dat");
print SAVE $chaos->{system}->{signon};
close (SAVE);
open (VER, ">./data/local/version.dat");
print VER $chaos->{version};
close (VER);

# Start looping!
while (1) {
	&active();
}