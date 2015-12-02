#################################################
#                                               #
#     #####    #                                #
#    #     #   #                                #
#   #       #  #                                #
#  #           #            #                   #
#  #           ####     #####     ####    ####  #
#  #           #   #   #    #    #    #  #      #
#   #       #  #    #  #    #    #    #   ###   #
#    #     #   #    #  #    #    #    #      #  #
#     #####    #    #   #### ##   ####   ####   #
#                                               #
#         A . I .      T e c h n o l o g y      #
#-----------------------------------------------#
#  Subroutine: commands                         #
# Description: Checks if the message is command #
#################################################

sub commands {
	# Get variables sent to this sub.
	my ($self,$client,$msg,$listener) = @_;

	# Load their command starter symbol.
	my $sym = get_comm_code();

	# Initially they're not using a command.
	my $is_command = 0;
	my $reply = "";

	# Get the client's permissions.
	&profile_get ($client,$listener);

	# Assign the permission level to a number.
	my $level = 0;
	$level = 0 if $chaos->{users}->{$client}->{permission} eq "Client";
	$level = 1 if $chaos->{users}->{$client}->{permission} eq "Gifted";
	$level = 2 if $chaos->{users}->{$client}->{permission} eq "Keeper";
	$level = 3 if $chaos->{users}->{$client}->{permission} eq "Moderator";
	$level = 4 if $chaos->{users}->{$client}->{permission} eq "Super Moderator";
	$level = 5 if $chaos->{users}->{$client}->{permission} eq "Admin";
	$level = 6 if $chaos->{users}->{$client}->{permission} eq "Super Admin";
	$level = 7 if $chaos->{users}->{$client}->{permission} eq "Master";

	# Make a hash of folder names.
	my %folders = (
		0 => "./commands/client",
		1 => "./commands/gifted",
		2 => "./commands/keeper",
		3 => "./commands/moderator",
		4 => "./commands/supermoderator",
		5 => "./commands/admin",
		6 => "./commands/superadmin",
		7 => "./commands/master",
	);

	# Make a hash of levels.
	my %levels = (
		"0" => "Client",
		"1" => "Gifted",
		"2" => "Keeper",
		"3" => "Moderator",
		"4" => "Super Moderator",
		"5" => "Admin",
		"6" => "Super Admin",
		"7" => "Master",
	);
	my $currlvl = 7;
	while ($currlvl >= 0) {
		if ($level >= $currlvl) {
			opendir (LVL, "$folders{$currlvl}") or panic ("Command folder error",0);
			foreach $file (sort(grep(!/^\./, readdir (LVL)))) {
				($file,$bad) = split(/\./, $file);

				if ($is_command == 0 && $msg =~ /^$sym$file/i) {
					# Cut the command off.
					$msg =~ s/$sym$file //ig;
					$msg =~ s/$sym$file//ig;

					# Call this command.
					$is_command = 1;
					$reply = &{$file} ($self,$client,$msg,$listener);
				}
			}
			closedir (LVL);
		}

		$currlvl--;
	}

	# If we don't have a command...
	if ($reply eq "") {
		$reply = "notcommand";
	}
	if ($is_command == 0) {
		if ($msg =~ /^$sym/i || $msg =~ /^(\/|\!|\#|\\|\@)/i) {
			$is_command = 1;
		}
	}

	# Return the command and the reply.
	return ($is_command, $reply);
}
1;