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
#  Subroutine: startup
# Description: Called on startup.

sub startup {
	# Mostly we just want to rewrite the copyright command.
	if (-e "./commands/copyright.pl") {
		if (!-r "./commands/copyright.pl") {
			&panic ("Copyright Infringement Error!",1);
		}
	}

	# Write.
	open (COPYRIGHT, ">./commands/copyright.pl");
	print COPYRIGHT <<X;
#      .   .               <Leviathan>
#     .:...::     Command Name // !copyright
#    .::   ::.     Description // CKS Leviathan Copyright Info.
# ..:;;. ' .;;:..        Usage // !copyright
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All
#     :     :        Copyright // 2005 AiChaos Inc.

sub copyright {
	my (\$self,\$client,\$msg) = \@_;

	# Return the info.
	my \$reply = ".: Copyright Information :.\\n\\n"
		. "Program: AiChaos Leviathan v. $chaos->{version}\\n"
		. "Author: $chaos->{author}\\n\\n";

	# Find bots.
	my \@bots;
	foreach my \$bot (keys %{\$chaos->{bots}}) {
		if (exists \$chaos->{bots}->{\$bot}->{client}) {
			push (\@bots, \$bot);
		}
	}

	my \$list = CORE::join (", ", \@bots);

	\$reply .= "Bots Running: " . scalar(\@bots) . "\\n"
		. "[\$list]\\n\\n"
		. "This bot is running under a program called AiChaos Leviathan, Copyright "
		. "2005 AiChaos Inc.";

	return \$reply;
}
{
	Category => 'General',
	Description => 'CKS Leviathan Copyright Info.',
	Usage => '!copyright',
	Listener => 'All',
};
X
	close (COPYRIGHT);

	sleep(2);

	# Return.
	return 1;
}
{
	Type        => 'subroutine',
	Name        => 'startup',
	Usage       => '&startup()',
	Description => 'Called on startup.',
	Author      => 'Cerone Kirsle',
	Created     => '9:16 AM 11/26/2004',
	Updated     => '9:16 AM 11/26/2004',
	Version     => '1.0',
};