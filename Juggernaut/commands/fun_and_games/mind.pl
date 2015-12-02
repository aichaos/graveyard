#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !mind
#    .::   ::.     Description // I Can Read Your Mind!
# ..:;;. ' .;;:..        Usage // !mind
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub mind {
	my ($self,$client,$msg,$listener) = @_;	

	# The Perl version of the classic mind reader game.

	# If they're in the callback...
	if ($chaos->{_users}->{$client}->{callback} eq "mind") {
		# If they have a number...
		if (exists $chaos->{_users}->{$client}->{_mind}->{number}) {
			# Array of questions.
			my @steps = (
				'1. Think of a number between 1 and 10.',
				'2. Multiple the number by 9.',
				'3. Add the digits of your result.',
				'4. Subtract 5 from your new number.',
				'5. Find the letter that corresponds to your number (1=A, 2=B, 3=C, etc.)',
				'6. Think of a country that begins with your letter.',
				'7. Write down the name of that country.',
				'8. Think of an animal beginning with the second letter of your country.',
				'9. Think of the color of that animal.',
				'10. Write down the animal and its color.',
				'11. Think of an animal that begins with the last letter of your country.',
				'12. Think of a fruit that begins with the last letter of this second animal.',
				'13. Write down the fruit and the animal.',
				'Sadly, Denmark is an unlikely place to find gray elephants '
					. 'and orange kangaroos!',
			);

			# Show them their step.
			my $num = $chaos->{_users}->{$client}->{_mind}->{number} || 0;
			my $reply = $steps[$num];

			# Add and save a new step.
			if ($num < 13) {
				$num++;
				$chaos->{_users}->{$client}->{_mind}->{number} = $num;
			}
			else {
				delete $chaos->{_users}->{$client}->{_mind};
				delete $chaos->{_users}->{$client}->{callback};
			}

			# Return the reply.
			return $reply;
		}
		else {
			delete $chaos->{_users}->{$client}->{callback};
			return "Unknown error.";
		}
	}
	else {
		# Set the callback and step number.
		$chaos->{_users}->{$client}->{callback} = "mind";
		$chaos->{_users}->{$client}->{_mind}->{number} = 0;

		return "I am going to give you 13 steps to follow. Do not answer any of the questions "
			. "directly, simply give me an \"ok\" to continue (just say anything to get me "
			. "to give you the next step). And I'll be able to read your mind in the end!\n\n"
			. "Ready? Type \"ok\" to get your first step!";
	}
}

{
	Category => 'Fun & Games',
	Description => 'Mind Reader Game',
	Usage => '!mind',
	Listener => 'All',
};