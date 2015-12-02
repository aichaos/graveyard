#      .   .               <Leviathan>
#     .:...::     Command Name // !mod
#    .::   ::.     Description // Modify points or stars.
# ..:;;. ' .;;:..        Usage // !mod <points|stars> <username> <+|-|=> <value>
#    .  '''  .     Permissions // Administrator Only.
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub mod {
	my ($self,$client,$msg) = @_;

	# Must be an admin.
	return "This command may only be used by Administrators and higher!" unless &isAdmin($client);

	# Get data.
	my ($type,$user,$dir,$value) = split(/\s+/, $msg, 4);
	my ($l,$nick) = split(/\-/, $user, 2);
	$l = uc($l);
	$nick = lc($nick);
	$user = join ('-', $l, $nick);

	# All defined?
	unless (length $type > 0 && length $user > 0 && length $dir > 0 && length $value > 0) {
		return "Proper usage:\n\n"
			. "!mod <lt>points|stars<gt> <lt>username<gt> <lt>+|-|=<gt> <lt>value<gt>";
	}

	return "Invalid TYPE: Must be \"points\" or \"stars\"." unless $type =~ /^(points|stars)$/i;
	return "Improper DIRECTION: Must be +, -, or =" unless $dir =~ /^(\+|\-|=)$/i;
	return "VALUE must be numerical!" if $value =~ /[^0-9]/;

	if ($type eq 'points') {
		&modPoints ($user,$dir,$value);
		return "The points have been modified.";
	}
	elsif ($type eq 'stars') {
		&modStars ($user,$dir,$value);
		return "The stars have been modified.";
	}

	return "500";
}
{
	Restrict    => 'Administrators',
	Category    => 'Administrator Commands',
	Description => 'Modify points or stars.',
	Usage       => '!mod <points|stars> <username> <+|-|=> <value>',
	Listener    => 'All',
};