package CML;

my $VERSION = "2.0";

=head1 NAME

Chaos AI Technology CML Reply System

=head1 DESCRIPTION

A module for use with reading and parsing CML files.

=head1 USAGE

	use CML;
	my $cml = new CML (debug => 1);

	$cml->load_folder ('./cml');

	my ($reply,$that) = $cml->get_reply ($message,
		topic => $topic,
		that => $that,
	);

=cut

# For debugging.
use Data::Dumper;

=head1 METHODS

=head2 new

To create a new CML object. If you are going to use multiple
instances of CML (i.e. different bots), each CML object has
to be its own instance of CML (unless they're going to share
the same reply data).

This can also take the flag DEBUG if you are a developer:

	my $cml = new CML (debug => 1);

=cut

sub new {
	my $proto = shift;

	my $class = ref($proto) || $proto;

	my $self = {
		debug => 0,
		@_
	};

	bless ($self, $class);

	return $self;
}

=head2 version

Returns the version of the module (could be used if you want
to require a specific version)

	$cml->version();

=cut

sub version {
	my $self = shift;

	return $VERSION;
}

=head2 debug

Prints a debug message, usually only called by the module itself.

	$cml->debug ('Debug Message');

=cut

sub debug {
	my ($self,$msg) = @_;

	# Only show if debug mode is on.
	if ($self->{debug} == 1) {
		print "CML::Debug // $msg\n";
	}

	return 1;
}

=head2 load_folder

Opens a folder and loads all of its contents into a replies hash.
The arguments are the folder path (relative or exact), and (optional)
a specific file extension to look for (defaults to .CML)

	$cml->load_folder ('./replies');
	$cml->load_folder ('./replies', 'cml');

Will return a number and (possibly) an array of filenames that were
not formatted correctly.
	1 = Everything went okay.
	2 = Reply folder did not exist.
	3 = No files of the extension were found.

=cut

sub load_folder {
	my $self = shift;
	my $dir = shift;
	my $ext = shift || 'cml';

	# Extension must be alphanumeric.
	$ext =~ s/[^A-Za-z0-9]//ig;

	# Make sure the reply directory exists.
	return 2 if -e "$dir" == 0;

	# Set some globals.
	my %in = (
		cml => 0,
		category => 0,
		pattern => 0,
		template => 0,
		that => 0,
		topic => 0,
	);

	# Temporary data.
	my %temp = (
		pattern => undef,
		template => undef,
	);

	# Array of bad files (if needed).
	my @wrong;

	# Open the directory.
	my $found_file = 0;
	my $id = 0;
	opendir (DIR, "$dir");
	foreach my $file (sort(grep(!/^\./, readdir (DIR)))) {
		if ($file =~ /$ext$/i && $found_file == 0) {
			$found_file = 1;
		}

		# Open the file.
		open (FILE, "$dir/$file");
		my @data = <FILE>;
		close (FILE);
		chomp @data;

		# Go through each line.
		foreach my $line (@data) {
			$line =~ s/^\t//ig;
			$line =~ s/^\s//ig;
			# Already in the file?
			if ($in{cml} == 1) {
				# Already in a category?
				if ($in{category} == 1) {
					if ($line =~ /<pattern>(.*?)<\/pattern>/i) {
						$line =~ s/<pattern>//ig;
						$line =~ s/<\/pattern>//ig;
						$line =~ s/\*/(.*)/g;
						$self->{$id}->{pattern} = $line;
					}
					if ($line =~ /<template>(.*?)<\/template>/i) {
						$line =~ s/<template>//ig;
						$line =~ s/<\/template>//ig;
						$self->{$id}->{template} = $line;
					}

					# That's and Topic's
					if ($line =~ /<that>(.*)<\/that>/i) {
						$line =~ s/<that>//ig;
						$line =~ s/<\/that>//ig;
						$self->{$id}->{that} = $line;
						$self->{$id}->{that} = uc($self->{$id}->{that});
						$self->{$id}->{that} =~ s/[^A-Z0-9 ]//ig;
					}
					if ($line =~ /<topic>(.*)<\/topic>/i) {
						$self->{$id}->{topic} = $line;
					}
				}

				if ($line =~ /<category>/i) {
					$id++;
					$in{category} = 1;
				}
				if ($line =~ /<\/category>/i) {
					# Delete the past.
					$temp{pattern} = "";
					$temp{template} = "";

					$in{category} = 0;
				}
			}
			if ($line =~ /<cml version=(.*?)>/i) {
				# Version must match our version or lower.
				my $v = $1;
				$v =~ s/\"//ig;

				if ($v eq $self->version) {
					# Acceptible.
					$in{cml} = 1;
				}
				push (@wrong, $file);
			}
			if ($line =~ /<\/cml>/i) {
				# Ending the CML.
				$in{cml} = 0;

				# Return this as a bad file if anything else
				# was left open.
				foreach my $key (keys %in) {
					if ($in{$key} == 1) {
						push (@wrong, $file);
					}
				}
			}
		}
	}

	# Save this max ID thing.
	$self->{maxid} = $id;

	if ($self->{debug} == 1) {
		foreach $id (keys %{$self}) {
			print "\n\$self->{$id}->{pattern} = $self->{$id}->{pattern}\n" if exists $self->{$id}->{pattern};
			print "\n\$self->{$id}->{template} = $self->{$id}->{template}\n" if exists $self->{$id}->{template};
			print "\n\$self->{$id}->{that} = $self->{$id}->{that}\n" if exists $self->{$id}->{that};
		}
	}

	# Return a notification.
	if ($found_file == 0) {
		return 3;
	}

	return 1;
}

=head2 cml_response

Gets a reply, and only a reply. This includes all the in-reply tags such
<get>, <set>, <bot>, <nextreply>, etc. These tags must be filtered out
and handled by the software running the module. However, tags such as
<star1>-<star9> will be filtered in correctly here.

	($reply,$that) = $cml->cml_response ($input,
		topic => $topic,
		that => $that,
	);

Returns $reply (the response to the message), and $that (a simplified
response, all caps and no puncutation, for use with the <that> tags in
more advanced reply matching.

It takes (optionally) $topic and $that. These values have to be
determined by the software running the module.

=cut

sub cml_response {
	my $self = shift;
	my $msg = shift;
	my %indata = @_;

	my %args = (
		topic => $indata{topic} || '',
		that  => $indata{that} || '',
	);

	$self->debug ("\$args{topic} = $args{topic}");
	$self->debug ("\$args{that} = $args{that}");

	my $reply;

	# A test . . .
	if ($self->{debug} == 2) {
		foreach $item (keys %{$self}) {
			print "\$self->{$item} = $self->{$item}\n";
			foreach $two (keys %{$self->{$item}}) {
				print "\$self->{$item}->{$two} = $self->{$item}->{$two}\n";
			}
		}
	}

	#return "All your base.";

	$self->debug ("Msg: $msg");

	my $found;
	my @stars;

	# See if there's a reply.
	foreach my $key (keys %{$self}) {
		# Make sure this is a reply key.
		next unless exists $self->{$key}->{pattern};
		next unless exists $self->{$key}->{template};

		# Skip past the wildcard.
		if ($self->{$key}->{pattern} eq '(.*)' && length $self->{$key}->{that} == 0 && length $self->{$key}->{topic} == 0) {
			next;
		}

		# Match topics.
		$self->debug ("Scanning Replies... Key: $key");
		$self->debug ("\$self->{$key}->{pattern} = $self->{$key}->{pattern}") if exists $self->{$key}->{pattern};
		$self->debug ("\$self->{$key}->{template} = $self->{$key}->{template}") if exists $self->{$key}->{template};
		$self->debug ("\$self->{$key}->{that} = $self->{$key}->{that}") if exists $self->{$key}->{that};
		$self->debug ("\$self->{$key}->{topic} = $self->{$key}->{topic}") if exists $self->{$key}->{topic};

		if (length $args{topic} > 0 && $args{topic} eq $self->{$key}->{topic} && $msg =~ /^$self->{$key}->{pattern}$/i) {
			@stars = ('',$1,$2,$3,$4,$5,$6,$7,$8,$9);
			$self->debug ("Topic test matched.");
			$found = 1;
			$reply = $self->{$key}->{template};
			goto end;
		}
		elsif (length $args{topic} == 0 && length $args{that} > 0 && $self->{$key}->{that} eq $args{that} && $msg =~ /^$self->{$key}->{pattern}$/i) {
			@stars = ('',$1,$2,$3,$4,$5,$6,$7,$8,$9);
			$self->debug ("<THAT> test matched.");
			$found = 1;
			$reply = $self->{$key}->{template};
			goto end;
		}
		elsif (length $self->{$key}->{that} == 0 && length $self->{$key}->{topic} == 0 && $msg =~ /^$self->{$key}->{pattern}$/i) {
		#else {
			@stars = ('',$1,$2,$3,$4,$5,$6,$7,$8,$9);
			$self->debug ("Normal test matched...");
			# It's a match.
			$found = 1;
			$reply = $self->{$key}->{template};
			goto end;
		}
	}
	end:

	# Choose a random reply.
	if ($reply =~ /\|/) {
		my @replies = split(/\|/, $reply);
		$reply = $replies [ int(rand(scalar(@replies))) ];
	}

	# Set the <that>.
	my $that = uc($reply);
	$that =~ s/[^A-Z0-9 ]//ig;
	#$self->debug ("Set <that> = $that");

	# Lowercase wildcards.
	my $i;
	for ($i = 1; $i <= 9; $i++) {
		$stars[$i] = lc($stars[$i]);
	}

	# Filter wildcards in.
	$reply =~ s/<star1>/$stars[1]/ig;
	$reply =~ s/<star2>/$stars[2]/ig;
	$reply =~ s/<star3>/$stars[3]/ig;
	$reply =~ s/<star4>/$stars[4]/ig;
	$reply =~ s/<star5>/$stars[5]/ig;
	$reply =~ s/<star6>/$stars[6]/ig;
	$reply =~ s/<star7>/$stars[7]/ig;
	$reply =~ s/<star8>/$stars[8]/ig;
	$reply =~ s/<star9>/$stars[9]/ig;
	#$self->debug ('Filtered Wildcards In');

	if (length $reply == 0) {
		# Call the wildcard.
		$self->debug ('Searching for * Reply');
		foreach $key (keys %{$self}) {
			if ($self->{$key}->{pattern} eq '(.*)' && !exists $self->{$key}->{that} && !exists $self->{$key}->{topic}) {
				$self->debug ('Found * Reply');
				$reply = $self->{$key}->{template};
				goto end;
			}
		}
		if (length $reply == 0) {
			$self->debug ('Did Not Find * Reply');
			$reply = "Cannot reply to that.";
		}
	}

	if ($self->{debug} == 1) {
		print "Reply: $reply\n"
			. "That: $that\n";
	}

	# Return the data.
	$self->debug ('Returning $reply and $that.');
	return ($reply,$that);
}

=head1 BUGS

No known bugs at this time.

=cut

1;