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
#       Brain: ChaosML
#    Sub-Type: LOAD
# Description: Creates and loads a CML brain.

sub chaosml_load {
	# Incoming data for the brain.
	my ($bot,$brain,$dir) = @_;

	use CML;

	$chaos->{$bot}->{_data}->{brain} = new CML ();

	# Load the folder.
	my ($load,@files) = $chaos->{$bot}->{_data}->{brain}->load_folder ($dir);

	# Errors?
	if ($load == 1) {
		if (scalar (@files) > 0) {
			&panic ("CML Brain: Bad or Corrupted Files:\n"
				. "\t" . join ("\n\t", @files), 0);
		}
	}
	elsif ($load == 2) {
		&panic ("CML Brain: Error 2 Folder Did Not Exist", 1);
	}
	elsif ($load == 3) {
		&panic ("CML Brain: No CML Files Found!", 1);
	}

	# All done!
	return 1;
}
1;