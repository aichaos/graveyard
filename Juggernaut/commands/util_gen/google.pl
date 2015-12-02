#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !google
#    .::   ::.     Description // A better Google search.
# ..:;;. ' .;;:..        Usage // !google <query>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub google {
	my ($self,$client,$msg,$listener) = @_;

	# They need a search query.
	if (length $msg == 0) {
		return "You must provide a query to search for.\n\n"
			. "!google <lt>search string<gt>";
	}

	my $key = $chaos->{_system}->{config}->{googlekey};
	if (length $key == 0) {
		# A valid key is required for this command.
		if (isMaster($client,$listener)) {
			return "This command requires you to obtain a Google Search Key. You "
				. "can get one at http://www.google.com/apis/ . Install the "
				. "Google key by opening startup.cfg and adding the variable "
				. "\"Google Key\" and insert the new key as its value, i.e.\n\n"
				. "Google Key=your new google key";
		}
		else {
			return "My botmaster has not obtained a Google key, and this command "
				. "cannot be used without a valid key.";
		}
	}

	use SOAP::Lite;
	my $google = SOAP::Lite->service ('file:./lib/GoogleSearch.wsdl');
	my $query = $msg;
	my $result = $google->doGoogleSearch($key, $query, 0, 5, 'false', '', 'false', '', 'latin1', 'latin1');

	my $reply;
	foreach my $element (@{$result->{resultElements}}) {
		$reply .= "$element->{title}\n"
			. "$element->{URL}\n\n";
	}

	return "Google Search Results\n\n" . $reply;

}

{
	Category => 'General Utilities',
	Description => 'Google Search',
	Usage => '!google <search string>',
	Listener => 'All',
};