#      .   .               <Leviathan>
#     .:...::     Command Name // !google
#    .::   ::.     Description // Google Search.
# ..:;;. ' .;;:..        Usage // !google <query>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub google {
	my ($self,$client,$msg) = @_;

	# They need a search query.
	return "You must provide a query to search for.\n\n"
		. "!google <lt>search string<gt>" unless length $msg > 0;

	my $key = $chaos->{config}->{google};
	if (length $key == 0) {
		# A valid key is required for this command.
		if (&isMaster($client)) {
			return "This command requires you to obtain a Google Search Key. You "
				. "can get one at http://www.google.com/apis/ . Install the "
				. "Google key by opening settings.cfg in a text editor and "
				. "setting the variable \"googlekey\" and insert the new "
				. "key as its value.";
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
	Category => 'Utilities',
	Description => 'Google Search.',
	Usage => '!google <query>',
	Listener => 'All',
};