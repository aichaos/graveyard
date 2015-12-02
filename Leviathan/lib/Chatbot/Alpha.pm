package Chatbot::Alpha;

our $VERSION = '1.70';

# For debugging...
use strict;
use warnings;

# Syntax checking
use Chatbot::Alpha::Syntax;

sub new {
	my $proto = shift;

	my $class = ref($proto) || $proto;

	my $self = {
		debug   => 0,
		version => $VERSION,
		default => "I'm afraid I don't know how to reply to that!",
		stream  => undef,
		syntax  => new Chatbot::Alpha::Syntax(
			syntax   => 'strict',
			denytype => 'allow_all',
		),
		@_,
	};

	bless ($self,$class);

	return $self;
}

sub version {
	my $self = shift;

	return $self->{version};
}

sub debug {
	my ($self,$msg) = @_;

	# Only show if debug mode is on.
	if ($self->{debug} == 1) {
		print STDOUT "Alpha::Debug // $msg\n";
	}

	return 1;
}

sub load_folder {
	my ($self,$dir) = (shift,shift);
	my $type = shift || undef;

	# Open the folder.
	opendir (DIR, $dir) or return 0;
	foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
		if (defined $type) {
			if ($file !~ /\.$type$/i) {
				next;
			}
		}

		my $load = $self->load_file ("$dir/$file");
		return $load unless $load == 1;
	}
	closedir (DIR);

	return 1;
}

sub stream {
	my ($self,$code) = @_;

	# Must have Alpha code defined.
	if (!defined $code) {
		warn "Chatbot::Alpha::stream - no code included with call!\n";
		return 0;
	}

	# Stream the code.
	$self->{stream} = $code;
	$self->load_file (undef,1);
}

sub load_file {
	my ($self,$file,$stream) = @_;
	$stream = 0 unless defined $stream;
	$stream = 0 if defined $file;

	$self->debug ("load_file called for file: $file");

	# Open the file.
	my @data = ();
	if ($stream != 1) {
		# Syntax check this.
		$self->{syntax}->check ($file);

		open (FILE, "$file") or return 0;
		@data = <FILE>;
		close (FILE);
		chomp @data;
	}
	else {
		@data = split ("\n", $self->{stream});
	}

	# (Re)-define temporary variables.
	my $topic = 'random';
	my $inReply = 0;
	my $trigger = '';
	my $counter = 0;
	my $holder = 0;
	my $num = 0;

	# Go through the file.
	foreach my $line (@data) {
		$num++;
		$self->debug ("Line $num: $line");
		next if length $line == 0;
		next if $line =~ /^\//;
		$line =~ s/^\s+//g;
		$line =~ s/^\t+//g;
		$line =~ s/^\s//g;
		$line =~ s/^\t//g;

		# Get the command off.
		my ($command,$data) = split(//, $line, 2);

		# Go through commands...
		if ($command eq '>') {
			$self->debug ("> Command - Label Begin!");
			$data =~ s/^\s//g;
			my ($type,$text) = split(/\s+/, $data, 2);
			if ($type eq 'topic') {
				$self->debug ("Topic set to $data");
				$topic = $text;
			}
		}
		elsif ($command eq '<') {
			$self->debug ("< Command - Label Ender!");
			$data =~ s/^\s//g;
			if ($data eq 'topic' || $data eq '/topic') {
				$self->debug ("Topic reset");
				$topic = 'random';
			}
		}
		elsif ($command eq '+') {
			$self->debug ("+ Command - Reply Trigger!");
			if ($inReply == 1) {
				# New reply.
				$inReply = 0;
				$trigger = '';
				$counter = 0;
				$holder = 0;
			}

			# Reply trigger.
			$inReply = 1;

			$data =~ s/^\s//g;
			$data =~ s/([^A-Za-z0-9 ])/\\$1/ig;
			$data =~ s/\\\*/\(\.\*\?\)/ig;
			$trigger = $data;
			$self->debug ("Trigger: $trigger");

			# Set the trigger's topic.
			$self->{_replies}->{$topic}->{$trigger}->{topic} = $topic;
			$self->{_syntax}->{$topic}->{$trigger}->{ref} = "$file line $num";
		}
		elsif ($command eq '-') {
			$self->debug ("- Command - Reply Response!");
			if ($inReply != 1) {
				# Error.
				$self->debug ("Syntax Error at $file line $num");
				return -2;
			}

			# Reply response.
			$counter++;
			$data =~ s/^\s//g;

			$self->{_replies}->{$topic}->{$trigger}->{$counter} = $data;
			$self->debug ("Reply #$counter : $data");
			$self->{_syntax}->{$topic}->{$trigger}->{$counter}->{ref} = "$file line $num";
		}
		elsif ($command eq '^') {
			$self->debug ("^ Command - Reply Continuation");
			$data =~ s/^\s//g;
			$self->{_replies}->{$topic}->{$trigger}->{$counter} .= $data;
		}
		elsif ($command eq '@') {
			# A redirect.
			$self->debug ("\@ Command - A Redirect!");
			if ($inReply != 1) {
				# Error.
				$self->debug ("Syntax Error at $file line $num");
				return -2;
			}
			$data =~ s/^\s//g;
			$self->{_replies}->{$topic}->{$trigger}->{redirect} = $data;
			$self->{_syntax}->{$topic}->{$trigger}->{redirect}->{ref} = "$file line $num";
		}
		elsif ($command eq '*') {
			# A conditional.
			$self->debug ("* Command - A Conditional!");
			if ($inReply != 1) {
				# Error.
				$self->debug ("Syntax Error at $file line $num");
				return -2;
			}
			# Get the conditional's data.
			$data =~ s/^\s//g;
			$self->debug ("Counter: $counter");
			$self->{_replies}->{$topic}->{$trigger}->{conditions}->{$counter} = $data;
			$self->{_syntax}->{$topic}->{$trigger}->{conditions}->{$counter}->{ref} = "$file line $num";
		}
		elsif ($command eq '&') {
			# A conversation holder.
			$self->debug ("\& Command - A Conversation Holder!");
			if ($inReply != 1) {
				# Error.
				$self->debug ("Syntax Error at $file line $num");
				return -2;
			}

			# Save this.
			$data =~ s/^\s//g;
			$self->debug ("Holder: $holder");
			$self->{_replies}->{$topic}->{$trigger}->{convo}->{$holder} = $data;
			$self->{_syntax}->{$topic}->{$trigger}->{convo}->{$holder}->{ref} = "$file line $num";
			$holder++;
		}
		elsif ($command eq '#') {
			# A system command.
			$self->debug ("\# Command - A System Command!");
			if ($inReply != 1) {
				# Error.
				$self->debug ("Syntax Error at $file line $num");
				return -2;
			}

			# Save this.
			$data =~ s/^\s//g;
			$self->debug ("System Command: $data");
			$self->{_replies}->{$topic}->{$trigger}->{system}->{codes} .= $data;
			$self->{_syntax}->{$topic}->{$trigger}->{system}->{codes}->{ref} = "$file line $num";
		}
	}

	return 1;
}

sub default_reply {
	my ($self,$reply) = @_;

	return 0 if length $reply == 0;

	# Save the reply.
	$self->{default} = $reply;
}

sub sort_replies {
	my $self = shift;

	# Reset loop.
	$self->{loops} = 0;

	# Fail if replies hadn't been loaded.
	return 0 unless exists $self->{_replies};

	# Delete the replies array (if it exists).
	if (exists $self->{_array}) {
		delete $self->{_array};
	}

	$self->debug ("Sorting the replies...");

	# Count replies.
	my $count = 0;

	# Go through each reply.
	foreach my $topic (keys %{$self->{_replies}}) {
		my @trigNorm = ();
		my @trigWild = ();
		foreach my $key (keys %{$self->{_replies}->{$topic}}) {
			$self->debug ("Sorting key $key");
			$count++;
			# If it's a wildcard...
			if ($key =~ /\*/) {
				# Save to wildcard array.
				$self->debug ("Key $key is a wildcard!");
				push (@trigWild, $key);
			}
			else {
				# Save to normal array.
				$self->debug ("Key $key is normal!");
				push (@trigNorm, $key);
			}
		}
		# Order the array.
		$self->{_array}->{$topic} = [
			@trigNorm,
			@trigWild,
		];
	}

	# Save the count.
	$self->{replycount} = $count;

	# Return true.
	return 1;
}

sub set_variable {
	my ($self,$var,$value) = @_;
	return 0 unless defined $var;
	return 0 unless defined $value;

	$self->{vars}->{$var} = $value;
	return 1;
}

sub remove_variable {
	my ($self,$var) = @_;
	return 0 unless defined $var;

	delete $self->{vars}->{$var};
	return 1;
}

sub clear_variables {
	my $self = shift;

	delete $self->{vars};
	return 1;
}

sub search {
	my ($self,$msg) = @_;

	my @results = ();

	# Sort replies if it hasn't already been done.
	if (!exists $self->{_array}) {
		$self->sort_replies;
	}

	# Too many loops?
	if ($self->{loops} >= 15) {
		$self->{loops} = 0;
		my $topic = 'random';
		return "ERR: Deep Recursion (15+ loops in reply set) at $self->{_syntax}->{$topic}->{$msg}->{redirect}->{ref}";
	}

	my %star;
	my $reply;

	# Make sure some replies are loaded.
	if (!exists $self->{_replies}) {
		return "ERROR: No replies have been loaded!";
	}

	# Go through each reply.
	foreach my $topic (keys %{$self->{_array}}) {
		$self->debug ("On Topic: $topic");

		foreach my $in (@{$self->{_array}->{$topic}}) {
			$self->debug ("On Reply Trigger: $in");

			if ($msg =~ /^$in$/i) {
				# Add to the results.
				my $t = $in;
				$t =~ s/\(\.\*\?\)/\*/g;
				push (@results, "+ $t (topic: $topic) at $self->{_syntax}->{$topic}->{$in}->{ref}");
			}
		}
	}

	return @results;
}

sub reply {
	my ($self,$id,$msg) = @_;

	# Sort replies if it hasn't already been done.
	if (!exists $self->{_array}) {
		$self->sort_replies;
	}

	# Too many loops?
	if ($self->{loops} >= 15) {
		$self->{loops} = 0;
		my $topic = $self->{users}->{$id}->{topic} || 'random';
		return "ERR: Deep Recursion (15+ loops in reply set) at $self->{_syntax}->{$topic}->{$msg}->{redirect}->{ref}";
	}

	my %star;
	my $reply;

	# Topics?
	$self->{users}->{$id}->{topic} ||= 'random';

	$self->{users}->{$id}->{last} = '0' unless exists $self->{users}->{$id}->{last};

	$self->debug ("User Topic: $self->{users}->{$id}->{topic}");

	$self->debug ("Message: $msg");

	# Make sure some replies are loaded.
	if (!exists $self->{_replies}) {
		return "ERROR: No replies have been loaded!";
	}

	# Go through each reply.
	foreach my $topic (keys %{$self->{_array}}) {
		$self->debug ("On Topic: $topic");
		next unless $topic eq $self->{users}->{$id}->{topic};

		foreach my $in (@{$self->{_array}->{$topic}}) {
			$self->debug ("On Reply Trigger: $in");

			# Conversations?
			my $found_convo = 0;
			$self->debug ("Checking for conversation holders...");
			if (exists $self->{_replies}->{$topic}->{$in}->{convo}) {
				$self->debug ("This reply has a convo holder!");
				# See if this was our conversation.
				my $h = 0;
				for ($h = 0; exists $self->{_replies}->{$topic}->{$in}->{convo}->{$h}; $h++) {
					last if $found_convo == 1;
					$self->debug ("On Holder #$h");

					my $next = $self->{_replies}->{$topic}->{$in}->{convo}->{$h};

					$self->debug ("Last Msg: $self->{users}->{$id}->{last}");

					# See if this was for their last message.
					if ($self->{users}->{$id}->{last} =~ /^$in$/i) {
						if (!exists $self->{_replies}->{$topic}->{$in}->{convo}->{$self->{users}->{$id}->{hold}}) {
							delete $self->{users}->{$id}->{hold};
							$self->{users}->{$id}->{last} = $msg;
							last;
						}

						# Give the reply.
						$reply = $self->{_replies}->{$topic}->{$in}->{convo}->{$self->{users}->{$id}->{hold}};
						$self->{users}->{$id}->{hold}++;
						$star{msg} = $msg;
						$msg = $in;
						$found_convo = 1;
					}
				}
			}
			last if defined $reply;

			if ($msg =~ /^$in$/i) {
				$self->debug ("Reply Matched!");
				$star{1} = $1; $star{2} = $2; $star{3} = $3; $star{4} = $4; $star{5} = $5;
				$star{6} = $6; $star{7} = $7; $star{8} = $8; $star{9} = $9;

				# A redirect?
				$self->debug ("Checking for a redirection...");
				if (exists $self->{_replies}->{$topic}->{$in}->{redirect}) {
					$self->debug ("Redirection found! Getting new reply for $self->{_replies}->{$topic}->{$in}->{redirect}...");
					my $redirect = $self->{_replies}->{$topic}->{$in}->{redirect};

					# Filter in wildcards.
					for (my $s = 0; $s <= 9; $s++) {
						$redirect =~ s/<star$s>/$star{$s}/ig;
					}

					$self->{loops}++;
					$reply = $self->reply ($id,$redirect);
					return $reply;
				}

				# Conditionals?
				$self->debug ("Checking for conditionals...");
				if (exists $self->{_replies}->{$topic}->{$in}->{conditions}) {
					$self->debug ("This response DOES have conditionals!");
					# Go through each one.
					my $c = 0;
					for ($c = 0; exists $self->{_replies}->{$topic}->{$in}->{conditions}->{$c}; $c++) {
						$self->debug ("On Condition #$c");
						last if defined $reply;

						my $conditional = $self->{_replies}->{$topic}->{$in}->{conditions}->{$c};
						my ($condition,$happens) = split(/::/, $conditional, 2);
						$self->debug ("Condition: $condition");
						my @con = split(/ /, $condition, 4);
						$self->debug ("\@con = " . join (",", @con));
						$con[0] = lc($con[0]);
						if ($con[0] eq "if") {
							$self->debug ("A well-formed conditional.");
							# A good conditional.
							# ... see if the variable was defined.
							if (exists $self->{vars}->{$con[1]}) {
								$self->debug ("Variable asked for exists!");
								# Check values.
								if ($self->{vars}->{$con[1]} eq $con[3]) {
									$self->debug ("Values match!");
									# True. This is the reply.
									$reply = $happens;
									$self->debug ("Reply = $reply");
								}
							}
						}
					}
				}

				last if defined $reply;

				# A reply?
				return "ERROR: No reply set for \"$msg\"!" unless exists $self->{_replies}->{$topic}->{$in}->{1};

				my @replies;
				foreach my $key (keys %{$self->{_replies}->{$topic}->{$in}}) {
					next if $key =~ /[^0-9]/;
					push (@replies,$self->{_replies}->{$topic}->{$in}->{$key});
				}

				$reply = 'INFLOOP';
				while ($reply =~ /^(INFLOOP|HASH|SCALAR|ARRAY)/i) {
					$self->{loops}++;
					$reply = $replies [ int(rand(scalar(@replies))) ];
					if ($self->{loops} >= 20) {
						$reply = "ERR: Infinite Loop near $self->{_syntax}->{$topic}->{$in}->{ref}";
					}
				}

				$self->debug ("Checking system commands...");
				# Execute system commands?
				if (exists $self->{_replies}->{$topic}->{$in}->{system}->{codes}) {
					$self->debug ("Found System: $self->{_replies}->{$topic}->{$in}->{system}->{codes}");
					my $eval = eval ($self->{_replies}->{$topic}->{$in}->{system}->{codes}) || $@;
					$self->debug ("Eval Result: $eval");
				}
			}
		}
	}

	# A reply?
	if (defined $reply) {
		# Filter in stars...
		my $i;
		for ($i = 1; $i <= 9; $i++) {
			$reply =~ s/<star$i>/$star{$i}/ig;
		}
		$reply =~ s/<msg>/$star{msg}/ig if exists $star{msg};
	}
	else {
		if ($self->{default} =~ /\|/) {
			my @default = split(/\|/, $self->{default});
			$reply = $default [ int(rand(scalar(@default))) ];
		}
		else {
			$reply = $self->{default};
		}
	}

	# A topic setter?
	if ($reply =~ /\{topic=(.*?)\}/i) {
		my $to = $1;
		if ($to eq 'random') {
			$self->{users}->{$id}->{topic} = '';
		}
		else {
			$self->{users}->{$id}->{topic} = $to;
		}
		$reply =~ s/\{topic=(.*?)\}//g;
	}

	# Save this message.
	$self->debug ("Saving this as last msg...");
	$self->{users}->{$id}->{last} = $msg;
	$self->{users}->{$id}->{hold} ||= 0;

	# Reset the loop timer.
	$self->{loops} = 0;

	# There SHOULD be a reply now.
	# So, return it.
	return $reply;
}

1;
__END__

=head1 NAME

Chatbot::Alpha - A simple chatterbot brain.

=head1 SYNOPSIS

  use Chatbot::Alpha;
  
  # Create a new Alpha instance.
  my $alpha = new Chatbot::Alpha();
  
  # Load replies from a directory.
  $alpha->load_folder ("./replies");
  
  # Load an additional response file.
  $alpha->load_file ("./more_replies.txt");
  
  # Input even more replies directly from Perl.
  $alpha->stream ("+ what is alpha\n"
                . "- Alpha, aka Chatbot::Alpha, is a chatterbot brain created by AiChaos Inc.\n\n"
                . "+ who created alpha\n"
                . "- Chatbot::Alpha was created by Cerone Kirsle.");
  
  # Get a response.
  my $reply = $alpha->reply ("user", "hello alpha");

=head1 DESCRIPTION

The Alpha brain was developed by AiChaos, Inc. for our chatterbots. The Alpha brain's language is line-by-line,
command-driven. Alpha is a simplistic brain yet is very powerful for making impressive response systems.

=head1 METHODS

=head2 new (ARGUMENTS)

Creates a new Chatbot::Alpha object. Pass in any default arguments (in hash form). Avoid arguments with underscores
and the "stream" key. These are reserved.

Returns a Chatbot::Alpha instance.

=head2 version

Returns the version number of the module.

=head2 load_folder (DIRECTORY[, TYPES])

Loads a directory of response files. The directory name is required. TYPES is the file extension of your response files.
If TYPES is omitted, every file is considered a response file.

Just as a side note, the extension agreed upon for Alpha files is .CBA, but the extension is not important.

=head2 load_file (FILE_PATH[, STREAM])

Loads a single file. The "load_folder" method calls this for each valid file. If STREAM is 1, the current contents of
the stream cache will be loaded (assuming FILE_PATH is omitted). You shouldn't need to worry about using STREAM, see
the "stream" method below.

=head2 stream (ALPHA_CODE)

Inputs a set of Alpha code directly into the module ("streaming") rather than loading it from an external document.
See synopsis for an example.

=head2 default_reply (RANDOM|RANDOM|RANDOM)

Sets up a default response in case there is no trigger for the message in your reply code. Separate random replies
using pipes. See "Tips and Tricks" below for some clever ways to handle default_reply.

=head2 sort_replies

Sorts the replies already loaded: solid triggers go first, followed by triggers containing wildcards. If you fail to
call this method yourself, it will be called automatically when "reply" is called.

=head2 set_variable (VARIABLE, VALUE)

Sets an internal variable. These are used primarily in conditionals in your Alpha responses.

=head2 remove_variable (VARIABLE)

Removes an internal variable.

=head2 clear_variables

Clears all internal variables (only those set with set_variable).

=head2 reply (ID, MESSAGE)

Scans the loaded replies to find a response to MESSAGE. ID is a unique ID for the particular person requesting a response.
The ID is used for things such as topics and conversation holders. Returns a reply, or one of default_reply if a better
response wasn't found.

=head2 search (MESSAGE)

Scans the loaded replies to find any triggers that match MESSAGE. Will return an array containing every trigger that
matched the message, including their filenames and line numbers.

=head1 ALPHA LANGUAGE TUTORIAL

The Alpha response language is a line-by-line command-driven language. The first character on each line is the command
(prepent white spaces are ignored). Everything following the command are the command's arguments. The commands are as
follows:

=head2 + (Plus)

The + symbol indicates a trigger. Every Alpha reply begins with this command. The arguments are what the trigger is
(i.e. "hello chatbot"). If the message matches this trigger, then the rest of the response code is considered. Else,
the triggers are skipped over until a good match is found for the message.

=head2 - (Minus)

The - symbol indicates a response to a trigger. This and all other commands (except for > and <) always go below the +
command. A single + and a single - will be a one-way question/answer scenario. If more than one - is used, they will
become random replies to the trigger. If conditionals are used, the -'s will be considered if each conditional is false.
If a conversation holder is used, the - will be the first reply sent in the conversation. See the example code below
for examples.

=head2 ^ (Carat)

The ^ symbol indicates a continuation of your last - reply. This command can only be used after a - command, and adds
its arguments to the end of the arguments of the last - command. See the example code for an example.

=head2 @ (At)

The @ symbol indicates a redirection. Alpha triggers are "dead-on" triggers, meaning pipes can't be used to make multiple
matchibles for one reply. In the case you would want more than one trigger (i.e. "hello" and "hey"), you use the @ command
to redirect them to eachother. See the example code below.

=head2 * (Asterisk)

The * command is for conditionals. At this time conditionals are very primative:

  * if variable = value::this reply is sent back

More/better support for conditionals may or may not be added in the future.

=head2 & (Amperstand)

The & command is for conversation holders. Each & will be called in succession once the trigger has been matched. Each
message, no matter what it is, will call the next one down the line. This is also the rare case in which a "<msg>" tag
can be included in the response, for capturing the user's message. See the example code.

=head2 # (Pound)

The # command is for executing actual Perl codes within your Alpha responses. The # commands are executed last, after
all the other reply handling mechanisms are completed. So in this sense, it's always a good idea to include at least one
reply (-) to fall back on in case the Perl code fails.

=head2 > (Greater Than)

The > starts a labeled piece of code. At this time, the only label supported is "topic" -- see "TOPICS" below.

=head2 < (Less Than)

This command closes a label.

=head2 / (Forward Slash)

The / command is used for comments (actually two /'s is the standard, as in Java and C++).

=head1 EXAMPLE ALPHA CODE

  // Test Replies

  // Chatbot-Alpha 1.7 - A reply with continuation...
  + tell me a poem
  - Little Miss Muffet,\n
    ^ sat on her tuffet,\n
    ^ in a nonchalant sort of way.\n\n
    ^ With her forcefield around her,\n
    ^ the spider, the bounder\n
    ^ is not in the picture today.

  // Chatbot-Alpha 1.7 - Check syntax errors on deep recursion.
  + one
  @ two

  + two
  @ one
  
  // A standard reply to "hello", with multiple responses.
  + hello
  - Hello there!
  - What's up?
  - This is random, eh?
  
  // A simple one-reply response to "what's up"
  + what's up
  - Not much, you?
  
  // A test using <star1>
  + say *
  - Um.... "<star1>"
  
  // This reply is referred to below.
  + identify yourself
  - I am Alpha.
  
  // Refers the asker back to the reply above.
  + who are you
  @ identify yourself
  
  // Conditionals Test
  + am i your master
  * if master = 1::Yes, you are my master.
  - No, you are not my master.
  
  // Perl Evaluation Test
  + what is 2 plus 2
  # $reply = "2 + 2 = 4";
  
  // A Conversation Holder: Knock Knock!
  + knock knock
  - Who's there?
  & <msg> who?
  & Ha! <msg>! That's a good one!
  
  // A Conversation Holder: Rambling!
  + are you crazy
  - I was crazy once.
  & They locked me away...
  & In a room with padded walls.
  & There were rats there...
  & Did I mention I was crazy once?
  
  // Topic Test
  + you suck
  - And you're very rude. Apologize now!{topic=apology}
  
  > topic apology
  
     + *
     - No, apologize for being so rude to me.
  
     // Set {topic=random} to return to the default topic.
     + sorry
     - See, that wasn't too hard. I'll forgive you.{topic=random}
  
  < topic

=head1 TOPICS

As seen in the example code, Chatbot::Alpha has support for topics.

=head2 Setting a Topic

To set a topic, use the {topic} tag in a response:

  + play hangman
  - Alright, let's play hangman.{topic=hangman}

Use the > and < commands (labels) to specify a section of code for the topic to exist in.

  > topic hangman
    + *
    - 500 Internal Error. Type "quit" to quit.
    # $reply = &main::hangman ($msg);

    + quit
    - Done playing hangman.{topic=random}
  < topic

The default topic is "random" -- setting the topic to random breaks out of code-defined
topics. When in a topic, any triggers that aren't in that topic are not available for
reply matching. In this way, you can have the same trigger many times but under different
topics without them interfering with one another.

=head1 ERROR CATCHING

With Chatbot::Alpha 1.7, the module keeps filenames and line numbers with each command it finds
(kept in $alpha->{_syntax} in the same order as $alpha->{_replies}). In this way, internal errors
such as deep recursion can return filenames and line numbers. See the example code for a way to
provoke this error.

  ERR: Deep Recursion (15+ loops in reply set) at ./testreplies.txt line 17

=head1 TIPS AND TRICKS

=head2 Things to do with default_reply

One trick you can do with default_reply is set it to something totally random like "alpha no reply matched".
When you're getting a reply, if the reply turns out to be "alpha no reply matched" you can go back into
Alpha with another reply call, but call something like "wildcard" as the trigger. In your response code,
you could then add a trigger that would be called when nothing else could be found.

=head1 KNOWN BUGS

  - Conversation holders aren't always perfect. If a different trigger
    was matched 100% dead-on, the conversation may become broken.
  - If a bogus topic is started (a topic with no responses) there is
    no handler for repairing the topic.

=head1 CHANGES

  Version 1.7
  - Chatbot::Alpha::Syntax added.
  - ^ command added.
  - Module keeps filenames and line numbers internally, so on internal
    errors such as 'Deep Recursion' and 'Infinite Loop' it can point you
    to the source of the problem.
  - $alpha->search() method added.

  Version 1.61
  - Chatbot::Alpha::Sort completed.
  
  Version 1.6
  - Created Chatbot::Alpha::Sort for sorting your Alpha documents.
  
  Version 1.5
  - Added "stream" method, revised POD.
  
  Version 1.4
  - Fixed bug with wildcard subsitutitons.
  
  Version 1.3
  - Added the ">" and "<" commands, now used for topics.
  
  Version 1.2
  - "sort_replies" method added
  
  Version 1.1
  - Fixed a bug in reply matching with wildcards.
  - Added a "#" command for executing System Commands.
  
  Version 1.0
  - Initial release.

=head1 FUTURE PLANS

  - Add a command for long responses so that they can continue on multiple
    lines. For example:
  
       + hello bot
       - Hello there human. This reply is_
         ^ very very long and needs to span_
         ^ across multiple lines.
  
  - Create a Chatbot::Alpha::Sort module for taking your already existing external
    Alpha documents and sorting the triggers, i.e. to make them alphabetic, like
    standard AIML is.

=head1 SEE ALSO

L<Chatbot::Alpha::Sort>

=head1 AUTHOR

Cerone J. Kirsle, cjkirsle "@" aichaos.com

=head1 COPYRIGHT AND LICENSE

    Chatbot::Alpha - A simple chatterbot brain.
    Copyright (C) 2005  Cerone J. Kirsle

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