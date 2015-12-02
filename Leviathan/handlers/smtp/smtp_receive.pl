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
# SMTP Handler: receive
#  Description: Checks for requests on the SMTP daemon.

sub smtp_receive {
	my ($smtp) = @_;

	# Get the daemon reference.
	my $d = $chaos->{bots}->{$smtp}->{client};

	# Check for requests.
	my $c = $d->accept || return;

	my $time = &get_timestamp();
	print "$time\n"
		. "ChaosSMTP: Receiving new connection...\n";

	# Create an SMTP session.
	my $server = new Net::Server::Mail::SMTP (socket => $c);

	# Set callbacks.
	$server->set_callback (RCPT => sub { &smtp_validate_recipient($smtp,@_); });
	$server->set_callback (DATA => sub { &smtp_queue_message($smtp,@_); });

	# Process it.
	print "ChaosSMTP: Processing the connection...\n";
	$server->process;
	print "\n";
}
{
	Type        => 'handler',
	Name        => 'smtp_receive',
	Description => 'Receives SMTP requests.',
	Author      => 'Cerone Kirsle',
	Created     => '7:09 AM 2/14/2005',
	Updated     => '7:09 AM 2/14/2005',
	Version     => '1.0',
};