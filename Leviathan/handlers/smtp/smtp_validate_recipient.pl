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
# SMTP Handler: validate_recipient
#  Description: Makes sure the recipient is one of our own bots.

sub smtp_validate_recipient {
	my ($smtp,$session,$recipient) = @_;

	print "ChaosSMTP: Validating recipient...\n";

	# See if there's a domain.
	my $domain;
	if ($recipient =~ /\@(.*?)$/) {
		$domain = $1;
	}

	my $to = $recipient;
	$to =~ s/<//g;
	$to =~ s/>//g;
	$to = lc($to);

	if (not defined $domain) {
		print "ChaosSMTP: 513 Syntax Error: No domain defined!\n";
		return (0, 513, 'Synax Error: No domain defined!');
	}

	# See if this is one of our own.
	my @bots = split(/ /, $chaos->{bots}->{$smtp}->{addresses});
	my $local = 0;
	foreach my $bot (@bots) {
		if ($to eq $bot) {
			$local = 1;
		}
	}

	if ($local != 1) {
		print "ChaosSMTP: 554 Address Rejected: Relay Access Denied!\n";
		return (0, 554, "$recipient: Recipient address rejected: Relay access denied.");
	}

	# Return true.
	return (1);
}
{
	Type        => 'handler',
	Name        => 'smtp_validate_recipient',
	Description => 'Makes sure the recipient is one of our own bots.',
	Author      => 'Cerone Kirsle',
	Created     => '7:15 AM 2/14/2005',
	Updated     => '7:15 AM 2/14/2005',
	Version     => '1.0',
};