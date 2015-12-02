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
#  Subroutine: msn_sync
# Description: Synchronizes your MSN bot's contact lists.

sub msn_sync {
	# Code borrowed from ContactTools by Mojave.

	# Get the MSN object.
	my $msn = shift;

	# Get the AllowList and ReverseList hash.
	my @al_list = $msn->getContactList ('AL');
	my @rl_list = $msn->getContactList ('RL');
	my %al_hash = map { $_, 1 } $msn->getContactList ('AL');
	my %rl_hash = map { $_, 1 } $msn->getContactList ('RL');

	# Back up the AL list.
	open (BACKUP, ">./logs/allowlistbackup.txt");
	print BACKUP "$_\n" foreach (sort @al_list);
	close (BACKUP);

	# Number of contacts added and removed.
	my $added = 0;
	my $removed = 0;

	# Remove contacts who have removed us.
	foreach my $contact (@al_list) {
		if (!defined $rl_hash{$contact}) {
			$msn->disallowContact ($contact);
			$removed++;
		}

		# Do 10 at a time so we don't upset the server.
		last if $removed >= 10;
	}

	# Allow contacts whom we haven't allowed.
	foreach my $contact (@rl_list) {
		if (!defined $al_hash{$contact}) {
			$msn->allowContact ($contact);
			$added++;
		}

		# Do 10 at a time.
		last if $added >= 10;
	}

	return ($added,$removed);
}
{
	Type        => 'subroutine',
	Name        => 'msn_sync',
	Usage       => '($added,$removed) = &msn_sync($msn)',
	Description => 'Synchronize your bot\'s contact lists.',
	Author      => 'Cerone Kirsle',
	Created     => '3:16 PM 2/1/2005',
	Updated     => '3:16 PM 2/1/2005',
	Version     => '1.0',
};