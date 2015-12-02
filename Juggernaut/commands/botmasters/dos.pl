#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !dos
#    .::   ::.     Description // Toggles the visibility of the DOS window.
# ..:;;. ' .;;:..        Usage // !dos <on|off|visible|hidden|show|hide>
#    .  '''  .     Permissions // Botmaster
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub dos {
	my ($self,$client,$msg,$listener) = @_;

	# Credits:
	#     Cerone Kirsle- Programmer
	#     Keenie- Once told me basicly how to do it
	#     darkmonkey- Knew exactly how to do it. ;)

	# Botmaster Only.
	return "This command may only be used by the Botmaster." if !isMaster($client,$listener);

	# Requires Windows.
	if ($^O ne 'MSWin32') {
		return "This command only works on Windows systems, your operating system is $^O.";
	}

	# See if there's a message.
	if (length $msg > 0) {
		# Conversions.
		$msg = "show" if $msg =~ /^(on|visible|show)$/i;
		$msg = "hide" if $msg =~ /^(off|hidden|hide)$/i;

		# Requires Win32::GUI.
		use Win32::GUI;

		# Get the Perl window.
		my $dos = GUI::GetPerlWindow();

		# Commands.
		if ($msg eq "show") {
			GUI::Show ($dos);

			return "DOS Window Now Visible.";
		}
		elsif ($msg eq "hide") {
			GUI::Hide ($dos);

			return "DOS Window Now Hidden.";
		}
		else {
			return "Valid arguments are show or hide (or the aliases on, off, visible, and hidden).\n\n"
				. "!dos show\n"
				. "!dos hide";
		}
	}
	else {
		return "You must provide an argument:\n\n"
			. "!dos <lt>show|hide<gt>";
	}
}

{
	Restrict => 'Botmaster',
	Category => 'Botmaster Commands',
	Description => 'Show/Hide the DOS Window',
	Usage => '!dos <show|hide>',
	Listener => 'All',
};