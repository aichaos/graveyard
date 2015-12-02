#              ::.                   .:.
#               .;;:  ..:::::::.  .,;:
#                 ii;,,::.....::,;;i:
#               .,;ii:          :ii;;:
#             .;, ,iii.         iii: .;,
#            ,;   ;iii.         iii;   :;.
# .         ,,   ,iii,          ;iii;   ,;
#  ::       i  :;iii;     ;.    .;iii;.  ,,      .:;
#   .,;,,,,;iiiiii;:     ,ii:     :;iiii;;i:::,,;:
#     .:,;iii;;;,.      ;iiii:      :,;iiiiii;,:
#          :;        .:,,:..:,,.        .:;..
#           i.                  .        ,:
#           :;.         ..:...          ,;
#            ,;.    .,;iiiiiiii;:.     ,,
#             .;,  :iiiii;;;;iiiii,  :;:
#                ,iii,:        .,ii;;.
#                ,ii,,,,:::::::,,,;i;
#                ;;.   ...:.:..    ;i
#                ;:                :;
#                .:                ..
#                 ,                :
# SMTP Handler: smtp_add_queue
#  Description: Add a message.

sub smtp_add_queue {
	my ($smtp,$sender,$recipients,$data) = @_;

	print "ChaosSMTP: Processing message...\n";

	# Get easier to use data.
	my @to = @{$recipients};
	my $msg = ${$data};

	# Main recipient.
	my $user = $to[0];
	$user =~ s/<//g;
	$user =~ s/>//g;

	# Go through the data.
	my $stay = 1;
	my @keep = ();
	my $subject = '';
	my @info = split(/\n/, $msg);
	print "Debug // Going through SMTP E-Mail Data!\n" if $chaos->{debug} == 1;
	foreach my $line (@info) {
		print "Debug // Line: $line\n" if $chaos->{debug} == 1;
		# Lines to ignore.
		if ($line =~ /^Subject: (.*?)$/i) {
			$subject = $1;
			next;
		}
		next if length $line == 0;
		next if $line =~ /^Message\-ID/i;
		next if $line =~ /^Mime\-Version/i;
		next if $line =~ /^Content\-Transfer/i;
		next if $line =~ /^Date/i;
		next if $line =~ /^From/i;
		next if $line =~ /^Received/i;
		next if $line =~ /^DomainKey/i;
		next if $line =~ /^To/i;
		$stay = 0 if $line =~ /^Content-Type: text\/html/i;
		$stay = 0 if $line =~ /^=+$/i;
		$stay = 0 if $line =~ /^\-+$/i;
		$stay = 0 if $line =~ /^(=3D)+$/i;
		next if $line =~ /^Content-Type/i;
		next if $line =~ /^\-\-/i;

		# This is the message.
		push (@keep, $line);
	}
	$msg = CORE::join (" ", @keep);
	$msg =~ s/(\n|\r)//g;

	# Are we set to chat or just autorespond?
	use Mail::Sendmail;
	my %mail = ();
	$mail{Smtp}    = $chaos->{config}->{email}->{smtp} || 'localhost';
	$mail{From}    = $user || 'AiChaos Leviathan <leviathan@aichaos.com>';
	my $stamp = &get_timestamp();
	if (-e $chaos->{bots}->{$smtp}->{autoreply}) {
		print "Debug // SMTP AutoReply: 1\n" if $chaos->{debug} == 1;
		# Autorespond.
		open (AUTO, "$chaos->{bots}->{$smtp}->{autoreply}");
		my @reply = <AUTO>;
		close (AUTO);
		chomp @reply;

		my $from = $sender;
		$from =~ s/^<(.*?)>$/$1/ig;

		# E-Mail the response.
		$mail{To}      = $sender;
		$mail{Subject} = 'Autoreply from AiChaos Leviathan';
		$mail{Message} = CORE::join ("\n", @reply);
		$mail{Message} =~ s/\$sender/$from/ig;
		$mail{Message} =~ s/\$recipient/$user/ig;
		$mail{Message} =~ s/\$version/$chaos->{version}/ig;

		# Send the mail.
		if (Mail::Sendmail::sendmail(%mail)) {
			print "$stamp\n"
				. "ChaosSMTP: Sent autoreply message to $sender.\n\n";
		}
		else {
			print "$stamp\n"
				. "ChaosSMTP: Failed to send autoreply to $sender:\n"
				. $Mail::Sendmail::error . "\n\n";
		}
	}
	else {
		&panic ("SMTP Autoreply File Not Found!");
	}
}
{
	Type        => 'handler',
	Name        => 'smtp_add_queue',
	Description => 'Add a queue.',
	Author      => 'Cerone Kirsle',
	Created     => '7:30 AM 2/14/2005',
	Updated     => '2:42 PM 2/14/2005',
	Version     => '1.0',
};