#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !uri
#    .::   ::.     Description // URI-Encode or Decode a Message!
# ..:;;. ' .;;:..        Usage // !uri <encode|decode> <message>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub uri {
	my ($self,$client,$msg,$listener) = @_;

	# Use the URI::Escape module.
	use URI::Escape;

	# Get their message parts.
	my ($type,$string) = split(/ /, $msg, 2);
	$type = "decode" if $type eq "out";
	$type = "decode" if $type eq "d";
	$type = "encode" if $type eq "in";
	$type = "encode" if $type eq "e";

	if ($type eq "encode") {
		# Encode the string.
		$string = uri_escape ($string);
	}
	elsif ($type eq "decode") {
		# Decode the string.
		$string = uri_unescape ($string);
	}
	else {
		return "Invalid usage:\n\n"
			. "!uri <lt>encode|decode<gt> <lt>string<gt>";
	}

	return "Result: $string";
}

{
	Category => 'General Utilities',
	Description => 'Uri Encoding/Decoding',
	Usage => '!uri <encode|decode> <message>',
	Listener => 'All',
};