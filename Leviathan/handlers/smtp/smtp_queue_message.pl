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
# SMTP Handler: smtp_queue_message
#  Description: Queues the message.

sub smtp_queue_message {
	my ($smtp,$session,$data) = @_;

	# Get some data.
	my $sender = $session->get_sender();
	my @recipients = $session->get_recipients();

	unless (@recipients) {
		print "ChaosSMTP: 554 Error: no valid recipients.\n";
		return (0, 554, 'Error: no valid recipients');
	}

	# Add the queue.
	my $msgid = &smtp_add_queue ($smtp,$sender,\@recipients,$data) or return(0);

	print "ChaosSMTP: 250 Message queued $msgid.\n";
	return (1, 250, "Message queued $msgid.");
}
{
	Type        => 'handler',
	Name        => 'smtp_queue_message',
	Description => 'Queue the message.',
	Author      => 'Cerone Kirsle',
	Created     => '7:18 AM 2/14/2005',
	Updated     => '7:18 AM 2/14/2005',
	Version     => '1.0',
};