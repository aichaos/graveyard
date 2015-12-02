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
#  Subroutine: cwrite
# Description: Maintains copyrights.
&cwrite ();

sub cwrite {
	# Make sure the Juggernaut command hasn't been set to read-only.
	if (-w "./commands/juggernaut.pl" != 1) {
		# Security violation! Annihilate Juggernaut.
		unlink ("./Juggernaut.pl");
		unlink ("./Server.pl");
		unlink ("./GUI.pl");
		&panic ("Credits Violation!", 1);
		return;
	}

	# Copyright command.
	my @code = (
		'#      .   .             <CKS Juggernaut>',
		'#     .:...::     Command Name // !juggernaut',
		'#    .::   ::.     Description // Specs on the Juggernaut bot.',
		'# ..:;;. \' .;;:..        Usage // !juggernaut',
		'#    .  \'\'\'  .     Permissions // Public',
		'#     :;,:,;:         Listener // All Listeners',
		'#     :     :        Copyright // 2004 Chaos AI Technology',
		'',
		'sub juggernaut {',
		't>my ($self,$client,$msg,$listener) = @_;',
		'',
		't># Get the version.',
		't>my $VER = $chaos->{_system}->{version};',
		't>my $AUT = $chaos->{_system}->{author};',
		'',
		't># Count the Bots.',
		't>my @bots = ();',
		't>foreach my $key (keys %{$chaos}) {',
		't>t>if (exists $chaos->{$key}->{client} && exists $chaos->{$key}->{client}) {',
		't>t>t>push (@bots, $key);',
		't>t>}',
		't>}',
		'',
		't>return ":: Technical Information ::\n\n"',
		't>t>. "Program: CKS Juggernaut v. $VER\n"',
		't>t>. "Author: $AUT\n"',
		't>t>. "Number of Connections: " . scalar(@bots) . "\n"',
		't>t>. "[" . join (",", @bots) . "]\n\n"',
		't>t>. "Copyright © 2004 Chaos AI Technology\n"',
		't>t>. "http://www.aichaos.com/\n"',
		't>t>. "juggernaut\@aichaos.com";',
		'}',
		'',
		'{',
		't>Category    => \'General\',',
		't>Description => \'Juggernaut Technical Information\',',
		't>Usage       => \'!juggernaut\',',
		't>Listener    => \'All\',',
		'};',
	);

	# Filter the code.
	my @cmd = ();
	foreach my $line (@code) {
		$line =~ s/t>/\t/ig;
		push (@cmd, $line);
	}

	# Open the command.
	open (CMD, ">./commands/juggernaut.pl");
	print CMD join ("\n", @cmd);
	close (CMD);

	return 1;
}
1;