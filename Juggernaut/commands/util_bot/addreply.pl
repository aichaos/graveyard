#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !addreply
#    .::   ::.     Description // Add a reply (for Juggernaut and ChaosML brains)
# ..:;;. ' .;;:..        Usage // !addreply [input]::[new reply]
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub addreply {
	my ($self,$client,$msg,$listener) = @_;

	# Format the message.
	$msg =~ s/\&lt\;/</g;
	$msg =~ s/\&gt\;/>/g;
	$msg =~ s/\&amp\;/&/g;
	$msg =~ s/\&quot\;/"/g;
	$msg =~ s/\&amp\;/'/g;

	# Get the Handle.
	my $sn;
	$sn = $self->{Msn}->{Handle} if $listener eq "MSN";
	$sn = $self->screenname() if $listener eq "AIM";
	$sn = $self->nick() if $listener eq "IRC";
	$sn = '_http' if $listener eq "HTTP";

	$sn = lc($sn);
	$sn =~ s/ //g;

	# Get the brain.
	my $brain = $chaos->{$sn}->{brain};

	$brain = lc($brain);
	$brain =~ s/ //g;

	# Juggernaut or ChaosML brains ONLY.
	if ($brain eq "juggernaut" || $brain eq "chaosml") {
		# Get the message data.
		my ($input,$output) = split(/::/, $msg, 2);
		$input = uc($input);
		$input =~ s/[^A-Za-z0-9 \*]//ig;

		return "Bad syntax: valid usage is:\n\n"
			. "!addreply input::output"
			unless (length $input > 0 && length $output > 0);

		# No System Tags Allowed!
		if ($output =~ /<system>/i) {
			return "Access denied: Use of the <lt>system<gt> tag is "
				. "not allowed!";
		}

		# Open a file for writing.
		if (-e "$chaos->{$sn}->{reply}/addreply.cml") {
			open (FILE, "$chaos->{$sn}->{reply}/addreply.cml");
			my @cml = <FILE>;
			close (FILE);

			chomp @cml;

			# Go through the file.
			my @out;
			foreach my $line (@cml) {
				if ($line =~ /^<cml (.*?)>/i) {
					# Add to this part.
					$line .= "\n\n";

					# Juggernaut type reply.
					if ($brain eq "juggernaut") {
						$line .= "<category>\n"
							. "Input: $input\n"
							. "Reply: $output\n"
							. "</category>\n\n";
					}
					else {
						$line .= "<category>\n"
							. "\t<pattern>$input</pattern>\n"
							. "\t<template>$output</template>\n"
							. "</category>\n\n";
					}
				}

				push (@out, $line);
			}

			open (NEW, ">$chaos->{$sn}->{reply}/addreply.cml");
			print NEW join ("\n", @out);
			close (NEW);
		}
		else {
			# Create a new file.
			open (FIRST, ">$chaos->{$sn}->{reply}/addreply.cml");

			# Juggernaut.
			if ($brain eq "juggernaut") {
				print FIRST "<cml version=\"1.0\">\n\n"
					. "<category>\n"
					. "Input: $input\n"
					. "Reply: $output\n"
					. "</category>\n\n"
					. "</cml>";
			}
			else {
				print FIRST "<cml version=\"2.0\">\n\n"
					. "<category>\n"
					. "\t<pattern>$input</pattern>\n"
					. "\t<template>$output</template>\n"
					. "</category>\n\n"
					. "</cml>";
			}
			close (FIRST);
		}

		# Reload the replies.
		&chaosml_load ($sn,$brain,$chaos->{$sn}->{reply}) if $brain eq "chaosml";
		&juggernaut_load ($sn,$brain,$chaos->{$sn}->{reply}) if $brain eq "juggernaut";

		return "The reply has been added.";
	}
	else {
		return "My current bot brain ($brain) doesn't support adding replies.";
	}
}

{
	Category => 'Bot Utilities',
	Description => 'Add a Reply',
	Usage => '!addreply [input]::[new reply]',
	Listener => 'All',
};