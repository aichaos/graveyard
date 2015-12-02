package AI::Rive;

use 5.008004;
use strict;
use warnings;

our $VERSION = '0.01';

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;

	my $self = {
		debug        => 0,
		version      => $VERSION,
		name         => 'Casey Rive',
		sex          => 'male',
		path         => './rive',
		users        => {},
		capabilities => [
			'learn', 'reply', 'age',
			'mood', 'relationship', 'energy',
		],
		@_,
	};

	local $SIG{__WARN__} = sub {
		if ($self->{debug} == 1) {
			print $_[0];
		}
	};

	# Gender abbreviations work too.
	$self->{sex} = 'male'   if $self->{sex} =~ /^m/i;
	$self->{sex} = 'female' if $self->{sex} =~ /^f/i;

	bless ($self,$class);

	# If the path doesn't exist, create a new life form.
	if (!-d $self->{path}) {
		$self->createLife;
	}
	return $self;
}

sub createLife {
	my $self = shift;

	# Make the folder.
	mkdir ($self->{path}) || die "Cannot create new life form: $self->{path} cannot be created!";

	# Create sub-folders.
	my @sub = (
		"clients",
		"data",
		"data/brain",
		"data/count",
		"data/text",
		"data/users",
		"logs",
	);
	foreach my $dir (@sub) {
		mkdir ("$self->{path}/$dir");
	}

	# Come up with DNA.
	my %dna = ();
	if ($self->{sex} eq "male") {
		$dna{xy} = 'xy';
	}
	else {
		$dna{xy} = 'xx';
	}

	# Create initial files.
	open (MAIN, ">$self->{path}/rive.dat");
	print MAIN "# Rive Unique ID File - Don't edit unless you know what you're doing!\n"
		. "rivename  = $self->{name}\n"
		. "rivexy    = $dna{xy}\n"
		. "rivedob   = " . time() . "\n"
		. "riveage   = 0\n"
		. "rivemood  = 50\n"
		. "rivetrust = 50";
	close (MAIN);
	open (ID, ">$self->{path}/data/count/learnid.dat");
	print ID "0";
	close (ID);
	open (USR, ">$self->{path}/data/count/userid.dat");
	print USR "0";
	close (USR);

	return 1;
}

sub process {
	my $self = shift;
	my $chat = shift || 0;

	$self->{alive} = 1;

	# If the chat flag is turned on...
	if ($chat) {
		while ($self->{alive}) {
			# Prompt for input.
			print "input> ";
			my $msg = <STDIN>;
			chomp $msg;

			my ($out,$reply) = $self->processOnce (
				nick    => 'RIVE-local',
				message => $msg,
			);

			print "\n\n"
				. "$self->{name}> $reply\n";
		}
	}
	else {
		while ($self->{alive}) {
			$self->processOnce (
				nick    => 'RIVE-console',
				message => '',
			);
		}
	}
}

sub processOnce {
	my $self = shift;
	my %args = @_;

	# Update things real quick.
	$self->update();

	my $nick = $args{nick} || '';
	my $msg  = $args{message} || '';

	# Only process the message if it exists.
	if (length $args{message} > 0) {
		##########################################
		## Message/String Preparation           ##
		##########################################

		# Get this user's information (or, if doesn't exist, this is a new user).
		$self->loadUser ($nick);

		# Save an original copy of their message.
		my $omsg = $msg;

		# Format the message for easier matching.
		$msg = $self->filterString ($msg);

		# Update this user's message count.
		my $count = $self->{users}->{$nick}->{msgs};
		$count++;
		$self->sendUser ($nick,'msgs',$count);

		##########################################
		## Main RIVE Brain Begin                ##
		##########################################

		# Load word lists and update mood and relationships.
	#	$self->loadWords;
	#	$self->notation ($nick,$msg);

		##########################################
		## Message Processing, Reply / Learning ##
		##########################################

		print "BRAIN // Beginning message processing.\n" if $self->{debug};

		# Declare some local variables.
		my $reply = '';                   # The bot's reply.
		my $prevmsg = '';                 # User's previous message.
		my $pastmsg = '';                 # In brain scanning, the left part of the message.
		my ($a,$b)  = ('','');            # Copies of left/right in brain scanning.
		my $sentence = '';                # Sentence-cased version of your message.
		my $line = '';                    # The line, in brain scanning.
		my $item = '';                    # Used in foreach loops.
		my @list = ();                    # List of random responses.
		my @new = ();                     # New copy of the brain.
		my ($in,$out) = ('','');          # Left and right parts in brain scanning.
		my $id = 0;                       # Learning ID.
		my @brain = ();                   # Original brain array.

		# Sentence-case the original message.
		$sentence = $self->sentence ($omsg);

		# Existence of items.
		my %exists = (
			greet   => 0,
			past    => 0,
			past_p  => 0,
			present => 0,
		);

		# See if this user has chatted before in this session.
		my $inSession = $self->{users}->{$nick}->{session}->{in} || 0;

		# If in session, get the information.
		if ($inSession) {
			$prevmsg = $self->{users}->{$nick}->{session}->{prev};
		}

		# Get the current learning ID.
		if (-e "$self->{path}/data/count/learnid.dat") {
			open (ID, "$self->{path}/data/count/learnid.dat");
			$id = <ID>;
			close (ID);
		}
		else {
			$id = 0;
		}

		# Add one to the Learn ID (in case we learn something).
		$id++;

		# The learning tag, appended to each item we learn.
		my $tag = '<' . $self->{users}->{$nick}->{id} . ':' . $id . '>';

		print "BRAIN // \$msg = $msg\n"
			. "\tomsg = $omsg\n"
			. "\tsentence = $sentence\n"
			. "\tid = $id\n"
			. "\tprevmsg = $prevmsg\n"
			. "\tinSession = $inSession\n" if $self->{debug};

		# Load the original replies.
		if (-e "$self->{path}/data/brain/main.dat") {
			open (BRAIN, "$self->{path}/data/brain/main.dat");
			@brain = <BRAIN>;
			close (BRAIN);
			chomp @brain;
		}

		# See if the reply exists.
		print "BRAIN // Seeing if the reply exists as anything.\n" if $self->{debug};
		foreach my $line (@brain) {
			($in,$out) = split(/\]\[/, $line, 2);
			# Remove the ID's.
			$in =~ s/<(\d.?):(\d.?)>//ig;
			$out =~ s/<(\d.?):(\d.?)>//ig;
			$out =~ s/([^A-Za-z0-9 ])/\\$1/ig;

			if (length $in == 0) {
				print "\tExists as a greeting!\n" if $self->{debug};
				# Greeting type replies.
				@list = split(/\|/, $out);
				foreach $item (@list) {
					$item = $self->filterString ($item);
					if ($msg eq $item) {
						$exists{greet} = 1;
					}
				}
			}
			if ($in eq $msg && length $line > 0) {
				print "\tExists as a trigger!\n" if $self->{debug};
				$exists{past} = 1;
			}
			if (lc($prevmsg) eq $in && length $line > 0) {
				print "\tPrevmsg exists as a trigger!\n" if $self->{debug};
				$exists{past_p} = 1;
			}
			if ($omsg =~ /^$out$/i && length $line > 0) {
				print "\tPresent exists!\n" if $self->{debug};
				$exists{present} = 1;
			}
		}

		# At this point, Rive will learn if the message doesn't exist
		# in the database.

		# First message from the user?
		if ($inSession != 1) {
			print "BRAIN // This is the user's first message.\n" if $self->{debug};
			# It is their first message.
			if ($exists{greet} == 0) {
				print "\tLearning a new greeting: $sentence" . $tag . "\n" if $self->{debug};
				# Learn the new greeting.
				foreach $line (@brain) {
					($in,$out) = split(/\]\[/, $line, 2);
					# Remove the ID's.
					$a = $in;
					$b = $out;
					$a =~ s/<(\d.?):(\d.?)>//ig;
					$b =~ s/<(\d.?):(\d.?)>//ig;

					$a =~ s/[^\w\s]//g;
					if (length $a == 0) {
						$in = '';
						$out .= '|' unless length $out == 0;
						$out .= $sentence . $tag;
					}

					push (@new, "$in][$out");
				}

				# Save.
				open (SAVE, ">$self->{path}/data/brain/main.dat");
				print SAVE join ("\n", @new);
				close (SAVE);

				# Update the learn ID.
				open (COUNT, ">$self->{path}/data/count/learnid.dat");
				print COUNT $id;
				close (COUNT);
			}
		}
		else {
			print "BRAIN // Not their first message.\n" if $self->{debug};
			# Not their first message... start learning!
			if ($exists{past_p} == 1) {
				# Their message would be a random response.
				foreach $line (@brain) {
					($in,$out) = split(/\]\[/, $line, 2);
					# Remove the ID's.
					$a = $in;
					$b = $out;
					$a =~ s/<(\d.?):(\d.?)>//ig;
					$b =~ s/<(\d.?):(\d.?)>//ig;

					if (lc($a) eq lc($prevmsg)) {
						print "\tLearned a new random response to $a\n" if $self->{debug};
						# Learn a new random response.
						$out .= '|' if length $out == 0;
						$out .= $sentence . $tag;

						# Get a reply here.
						@list = split(/\|/, $out);
						$reply = $list [ int(rand(scalar(@list))) ];
					}

					push (@new, "$in][$out");
				}

				# Save.
				open (SAVE, ">$self->{path}/data/brain/main.dat");
				print SAVE join ("\n", @new);
				close (SAVE);

				# Update the learn ID.
				open (COUNT, ">$self->{path}/data/count/learnid.dat");
				print COUNT $id;
				close (COUNT);
			}
			else {
				# This is all new.
				print "\tLearning all new data\n" if $self->{debug};
				$prevmsg = $self->filterString ($prevmsg);
				$prevmsg = uc($prevmsg);
				$prevmsg =~ s/[^\w\s]//g;
				$prevmsg .= $tag;

				if (-e "$self->{path}/data/brain/main.dat") {
					open (NEW, ">>$self->{path}/data/brain/main.dat");
					print NEW "\n$prevmsg][$sentence" . $tag;
					close (NEW);
				}
				else {
					open (NEW, ">$self->{path}/data/brain/main.dat");
					print NEW "$prevmsg][$sentence" . $tag;
					close (NEW);
				}

				# Update the learn ID.
				open (COUNT, ">$self->{path}/data/count/learnid.dat");
				print COUNT $id;
				close (COUNT);
			}
		}

		# Set their last message.
		$self->{users}->{$nick}->{session}->{prev} = $msg;

		# They're in session now!
		$inSession = 1;
		$self->{users}->{$nick}->{session}->{in} = 1;
		$self->{users}->{$nick}->{session}->{time} = time();

		print "BRAIN // self->{users}->{$nick}->{session}->{prev} = $self->{users}->{$nick}->{session}->{prev}\n"
			. "\tself->{users}->{$nick}->{session}->{in} = $self->{users}->{$nick}->{session}->{in}\n"
			. "\tself->{users}->{$nick}->{session}->{time} = $self->{users}->{$nick}->{session}->{time}\n" if $self->{debug};

		# If we don't have a reply YET... go fetch one.
		my $tries = 0;
		my $replyID;
		if (length $reply == 0) {
			print "BRAIN // Still no reply, trying to fetch one.\n" if $self->{debug};
			while ($tries < 5) {
				$tries++;
				print "\tTry #$tries\n" if $self->{debug};
				foreach $line (@brain) {
					($in,$out) = split(/\]\[/, $line, 2);
					# Remove the ID's.
					$a = $in;
					$b = $out;
					$a =~ s/<(\d.?):(\d.?)>//ig;
					$b =~ s/<(\d.?):(\d.?)>//ig;

					# See if they match.
					if ($msg =~ /^$a$/i) {
						print "\tFound a match: $out!\n" if $self->{debug};
						# Get a reply.
						@list = split(/\|/, $out);
						$reply = $list [ int(rand(scalar(@list))) ];

						# Get this ID.
						if ($reply =~ /<(.*?)>$/i) {
							$replyID = $1;
						}
					}
				}
				last if length $reply > 0;
			}

			# Still no reply?
			if (length $reply == 0) {
				print "BRAIN // Still found no reply. ERROR!\n" if $self->{debug};
				$self->{users}->{$nick}->{rivemsg} = 'undefined';
				return (2,$omsg);
			}
		}

		# Save this reply's ID.
		$self->{users}->{$nick}->{rivemsg} = $replyID;

		# Remove the ID.
		$reply =~ s/<(.*?)>$//ig;

		print "BRAIN // self->{users}->{$nick}->{rivemsg} = $self->{users}->{$nick}->{rivemsg}\n"
			. "\treply = $reply\n" if $self->{debug} == 1;

		# Return the reply.
		return (1,$reply);
	}

	# Return test.
	return (1,"$args{message}");
}

sub loadUser {
	my ($self,$nick) = @_;

	# Exists?
	if (-e "$self->{path}/clients/$nick\.usr") {
		# Load the data.
		open (FILE, "$self->{path}/clients/$nick\.usr");
		my @data = <FILE>;
		close (FILE);
		chomp @data;

		foreach my $line (@data) {
			my ($what,$is) = split(/=/, $line, 2);
			$what = lc($what);
			$what =~ s/ //g;

			$self->{users}->{$nick}->{$what} = $is;
		}

		return 1;
	}
	else {
		# Get the current ID number.
		open (ID, "$self->{path}/data/count/userid.dat");
		my $id = <ID>;
		close (ID);
		$id++;
		open (NID, ">$self->{path}/data/count/userid.dat");
		print NID $id;
		close (NID);

		# Create this user's profile.
		open (NEW, ">$self->{path}/clients/$nick\.usr");
		print NEW "id=$id\n"
			. "msgs=0\n"
			. "relate=0";
		close (NEW);

		# Set this user's info.
		$self->{users}->{$nick} = {
			id     => $id,
			msgs   => 0,
			relate => 0,
		};

		return 1;
	}
}

sub sendUser {
	my ($self,$nick,$var,$value) = @_;

	return 0 unless (-e "$self->{path}/clients/$nick\.usr");

	my @new = ();
	open (DATA, "$self->{path}/clients/$nick\.usr");
	my @data = <DATA>;
	close (DATA);
	chomp @data;

	foreach my $line (@data) {
		my ($what,$is) = split(/=/, $line, 2);
		$what = lc($what);
		$what =~ s/ //g;

		if ($what eq $var) {
			$line = "$var=$value";
		}
		else {
			$line = "$what=$is";
		}

		push (@new, $line);
	}

	open (NEW, ">$self->{path}/clients/$nick\.usr");
	print NEW join ("\n", @new);
	close (NEW);

	return 1;
}

sub filterString {
	my ($self,$string) = @_;

	$string =~ s/[^A-Za-z0-9 ]//ig;

	return $string;
}

sub sentence {
	my ($self,$string) = @_;

	# Set our starting variables.
	my $in_a_sentence = 0;

	# Split the message.
	my @chars = split(//, $string);

	# Go through each one.
	my $complete;
	foreach my $item (@chars) {
		if ($in_a_sentence == 0) {
			if ($item ne ' ') {
				$item = uc($item);
				$in_a_sentence = 1;
			}
		}
		else {
			if ($item eq '.' || $item eq '?' || $item eq '!') {
				$in_a_sentence = 0;
			}
			else {
				$item = lc($item);
			}
		}
		$complete .= $item;
	}

	# Return the fixed string.
	return $complete;
}

sub update {
	my $self = shift;

	# Time out old sessions (a session lasts for 15 minutes).
	my $length = 60*15;
	foreach my $user (keys %{$self->{users}}) {
		if (exists $self->{users}->{$user}->{session}->{time}) {
			my $last = $self->{users}->{$user}->{session}->{time};
			if (time() - $last > $length) {
				# Expired!
				$self->{users}->{$user}->{session}->{in} = 0;
			}
		}
	}

	# Return now.
	return 1;
}

1;
__END__

=head1 NAME

AI::Rive - Rendering Intelligence Very Easily.

=head1 SYNOPSIS

  use AI::Rive;

  # Create a new Rive.
  my $rive = new AI::Rive (
    debug => 1,
    name  => "Casey Rive",
    sex   => "male",
    path  => "./my rive",
  );

  $rive->process (1);

=head1 DESCRIPTION

The RIVE project was created by AiChaos, Inc. as our first major attempt
at Artificial Intelligence--at least to the point of simulating a human
mind.

=head1 METHODS

=head2 new

Creates a new RIVE object. Include variables in a hash format (see synopsis).
See below for a list of the variables. Any module variables can be defined
at this point. Highly recommended fields are "name" and "path" - name is the
entity's name (defaults to Casey Rive), and path is where it will store all
its data (defaults to "./rive"). If the path doesn't exist, it will be created
as well as filled with default files and data.

  my $rive = new AI::Rive (
    debug => 1,
    name  => 'Casey Rive',
    sex   => 'male',
    path  => './my rive',
  );

=head2 process

Starts a never-ending loop of processing (would be best used if your entire
application was to let this bot live and thrive by itself). You can also
pass the optional parameter of "1" and the application will prompt you for
your input, to chat with your entity. If you can't chat with your entity, it
won't live the happiest life in the world, since it will be isolated from all
conversation.

  $rive->process (1);

=head2 processOnce

The module will go on a single process loop and then return, allowing your
application to do multiple things in the background. This is the best option,
especially for use with other looping interfaces (i.e. an MSN or AIM robot).

  $rive->processOnce (
     nick    => 'foo',
     message => 'Hello Rive!',
  );

=head1 INTERNAL METHODS

=head2 createLife

If the defined path doesn't exist, this method will create it and initialize
the default files and data. This method is called automatically from new().

=head2 loadUser

Loads the user's data into memory. By default the user's data consists only of
ID Number, Message Count, and Relationship. As Rive improves (and as this module
improves), the entity would slowly learn to add new variables such as name, age,
etc. that it learns from chat. This method is called on internally.

=head2 sendUser

Sends a profile item to a user's profile. Right now it doesn't support the
spontaneous creation of new variables, that feature will come about when the
module supports the common sense required to do such a thing.

=head2 filterString

Removes all the punctuation and other foreign symbols from a string.

  $string = $rive->filterString ($string);

=head2 sentence

Takes a string and returns it, with the proper format of a sentence cased string
(only for reply learning. Every educated bot must know how to use capitilization
and punctuation marks :P).

  $sentence = $rive->sentence ($string);

=head2 update

Update all activity timers and queues. This method is called on by the bot on
each processOnce call.

=head1 TO DO

- Message connotations and all the things that come with it (mood and relationship
changes, ability to create its own lists of positive and negative words, etc.)
- Many other things. Right now this thing just learns and repeats. =P

=head1 AUTHOR

Cerone Kirsle <lt>cjk "@" aichaos.com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Cerone Kirsle

  AI::Rive - Rendering Intelligence Very Easily.
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

=cut