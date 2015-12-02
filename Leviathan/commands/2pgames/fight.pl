#      .   .               <Leviathan>
#     .:...::     Command Name // !fight
#    .::   ::.     Description // Pick a fight with someone.
# ..:;;. ' .;;:..        Usage // !fight <username>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // AIM,MSN
#     :     :        Copyright // 2005 AiChaos Inc.

sub fight {
	my ($self,$client,$msg) = @_;

	# Monkey-Island style fight game.
	# Written 3-25-2005 by Cerone Kirsle.
	# Please give some credit if you port this
	# to a different bot template!

	# AIM and MSN Only.
	my ($a,$b) = split(/\-/, $client, 2);
	return "This command is for Instant Messengers only." unless $a =~ /^(AIM|MSN|IRC|YAHOO|JABBER)$/i;

	# Comebacks.
	my %out = (
		0 => 'And I\'ve got a little TIP for you, get the POINT?',
		1 => 'First you better stop waiving it like a feather-duster.',
		2 => 'So you got that job as a janitor, after all.',
		3 => 'Even BEFORE they smell your breath?',
		4 => 'He must have taught you everything you know.',
		5 => 'You make me think somebody already did.',
		6 => 'You run THAT fast?',
		7 => 'How appropriate, you fight like a cow.',
		8 => 'I hope now you\'ve learned to stop picking your nose.',
		9 => 'Why, did you want to borrow one?',
		10 => 'Too bad no one\'s ever heard of YOU at all.',
		11 => 'I\'d be in real trouble if you ever used them.',
		12 => 'I wanted to make sure you\'d feel comfortable with me.',
		13 => 'Your hemorrhoids are flaring up again, eh?',
		14 => 'Yes there are. You just never learned them.',
		15 => 'I\'m glad to hear you attented your family reunion.',
		16 => 'With your breath, I\'m sure they all suffocated.',
		17 => 'I look that much like your fiancée?',
		18 => 'Then killing you must be justifiable fungicide.',
		19 => 'If you don\'t count all the ones you\'ve dated!',
		20 => 'When I\'m done with you, you\'ll be a boneless filet.',
		21 => 'With you around, I\'d rather be fumigated.',
		22 => 'Is that your face? I thought it was your backside.',
		23 => 'At least mine can be identified.',
		24 => 'I could, if you would use some breath spray.',
		25 => 'You would have, but you were always running away.',
		26 => 'Oh, that is so cliché.',
		27 => 'Too bad they\'re all fabricated.',
		28 => 'Then perhaps you should switch to decaffeinated.',
		29 => 'Your odor alone makes me aggravated, agitated, and infuriated.',
		30 => 'The only way you\'ll be preserved is in formaldehyde.',
		31 => 'Then be a good dog, Sit! Stay!',
		32 => 'From the size of your gut I\'d guess they were eaten.',
		33 => 'It\'s too bad none of them are in your arms.',
		34 => 'I would if it would stop your WINE-ING.',
		35 => 'Yeah, but we both got better bladder control than you do.',
		36 => 'Why, ya studying to be a nurse?',
		37 => 'I\'m surprised you can count that high!',
		38 => 'Yeah, yeah I know: it\'s a three headed monkey.',
		39 => 'I thought that the bean dip had a strange taste.',
		40 => 'So THAT\'S why you\'re scratching. I\'d go see a vet.',
		41 => 'Sadly, your breath should be equally reckoned.',
		42 => 'I\'m shocked that you\'ve never gazed at your wife.',
		43 => 'An over-the-counter defoliant could help with that problem.',
		44 => 'I\'m sure that spineless creatures everywhere are humbled by your might.',
		45 => 'It\'s laughter that\'s caused by your feathery grip.',
	);

	# The insults and comebacks.
	my %in = (
		# General insults.
		'This is the END for you, you gutter-crawling cur!' => 0,
		'Soon you\'ll be wearing my sword like a shisk kebab!' => 1,
		'My handkerchief will wipe up your blood!' => 2,
		'People fall at my feet when they see me coming.' => 3,
		'I once owned a dog that was smarter than you.' => 4,
		'You make me want to puke.' => 5,
		'Nobody\'s ever drawn blood from me and nobody ever will.' => 6,
		'You fight like a dairy farmer.' => 7,
		'I got this scar on my face during a mighty struggle!' => 8,
		'Have you stopped wearing diapers yet?' => 9,
		'I\'ve heard you were a contemptible sneak.' => 10,
		'You\'re no match for my brains, you poor fool.' => 11,
		'You have the manners of a beggar.' => 12,
		'I\'m not going to take your insolence sitting down!' => 13,
		'There are no words for how disgusting you are.' => 14,
		'I\'ve spoken with apes more polite than you.' => 15,
		'Every enemy I have met, I\'ve annihilated!' => 16,
		'You\'re as repulsive as a monkey in a negligee!' => 17,
		'Killing you would be justifiable homocide!' => 18,
		'You\'re the ugliest monster ever created!' => 19,
		'I\'ll skewer you like a sow at a buffet!' => 20,
		'Would you like to be buried, or cremated?' => 21,
		'Coming face to face with me must leave you petrified!' => 22,
		'When your father first saw you, he must have been mortified.' => 23,
		'You can\'t match my witty repartee!' => 24,
		'I have never seen such clumsy swordplay!' => 25,
		'En Garde! Touché!' => 26,
		'Throughout the Caribbean, my great deeds are celebrated!' => 27,
		'I can\'t rest \'til\' you\'ve been exterminated!' => 28,
		'I\'ll leave you devastated, mutiliated, and perforated!' => 29,
		'Heaven preserve me! You look like something that\'s died!' => 30,
		'I\'ll hound you night and day!' => 31,
		'Today, by myself, twelve people I\'ve beaten.' => 32,
		'I\'ve got muscles in places you\'ve never even heard of.' => 33,
		'Give up now, or I\'ll crush you like a grape!' => 34,
		'My ninety-eight year old grandmother has bigger arms than you!' => 35,
		'I\'m going to put your arm in a sling!' => 36,
		'My stupefying strength will shatter your ulna into a million pieces!' => 37,
		'Hey, look over there!' => 38,
		'Your knuckles I\'ll grind to a splintery paste.' => 39,
		'Your arms are no bigger than fleas I\'ve met!' => 40,
		'People consider my fists lethal weapons!' => 41,
		'Only once have I met such a coward!' => 4,
		'You\'re the ugliest creature I\'ve ever seen in my life.' => 42,
		'My forearms have been mistaken for tree trunks.' => 43,
		'I\'ve out-wrestled octopi with these arms!' => 44,
		'Do I see quivers of agony dance on your lip?' => 45,

		# Special insults (these point to common comebacks but are a bit more tricky).

		# The Sword Master.
		'I\'ve got a long, sharp lesson for you to learn today.' => 0,
		'My tongue is sharper than any sword.' => 1,
		'My name is feared in every dirty corner of this island!' => 2,
		'My wisest enemies run away at the first sight of me!' => 3,
		'Only once have I met such a coward!' => 4,
		'If your brother\'s like you, better to marry a pig.' => 5,
		'No one will ever catch ME fighting as badly as you do.' => 6,
		'I will milk every drop of blood from your body!' => 7,
		'My last fight ended with my hands covered in blood.' => 8,
		'I hope you have a boat ready for a quick escape.' => 9,
		'My sword is famous all over the Caribbean!' => 10,
		'I\'ve got the courage and skill of a master swordsman!' => 11,
		'Every word you say to me is stupid.' => 12,
		'You are a pain in the backside, sir!' => 13,
		'There are no clever moves that can help you now.' => 14,
		'Now I know what filth and stupidity really are.' => 15,
		'I usually see people like you passed-out on tavern floors.' => 3,

		# Captain Rottingham.
		'My attacks have left entire islands depopulated!' => 16,
		'You have the sex appeal of a shar-pei!' => 17,
		'When I\'m done, your body will be rotted and putrefied!' => 18,
		'Your looks would make pigs nauseated!' => 19,
		'Your lips look like they belong on the catch of the day!' => 20,
		'I give you a choice. You can be gutted, or decapitated.' => 21,
		'Never before have I faced someone so sissified!' => 22,
		'You\'re a disgrace to your species, you\'re so undignified!' => 23,
		'Nothing can stop me from blowing you away!' => 24,
		'I have never lost a melee!' => 25,
		'Your mother wears a toupee!' => 26,
		'My skills with a sword are highly venerated!' => 27,
		'Your stench would make an outhouse cleaner irritated!' => 28,
		'I can\'t tell which of my traits have you the most intimidated!' => 29,
		'Nothing on this earth can save your sorry hide!' => 30,
		'You\'ll find I\'m dogged and relentless to my prey!' => 31,
	);

	# Player 1 = the antagonist
	# Player 2 = the victim

	my $sn;
	$sn = $self->screenname() if $a eq 'AIM';
	$sn = $self->{Msn}->{Handle} if $a eq 'MSN';
	$sn = lc($sn);
	$sn =~ s/ //g;

	# Picking a fight?
	if (!exists $chaos->{clients}->{$client}->{_attack}) {
		# See if there's a valid target.
		if (length $msg > 0) {
			# Make a unique Game ID.
			$msg = lc($msg); $msg =~ s/ //g;
			my ($listener,$name) = split(/\-/, $client, 2);
			my $id = join ('-', $client, $msg);
			my $target = join ('-', $listener, $msg);

			# Is this user busy elsewhere?
			if (exists $chaos->{clients}->{$target}->{_attack}) {
				return "$msg is already busy with a duel with somebody else.";
			}

			if ($target eq $client) {
				return "You can't pick a fight with yourself.";
			}

			# Don't allow it with blocked or warners.
			my $blocked = 0;
			$blocked = 1 if &isBlocked($target);
			$blocked = 1 if &isWarner($target);
			if ($blocked) {
				return "That user is blocked; I won't send any messages to them, therefore you "
					. "can't fight them.";
			}

			# Get this user's profile (in case they're a new user).
			&profile_get ($target);

			$chaos->{clients}->{$client}->{host} = $sn;
			$chaos->{clients}->{$target}->{host} = $sn;
			$chaos->{clients}->{$client}->{_attack} = $id;       # Set ID for antagonist.
			$chaos->{clients}->{$client}->{_attkplayer} = 1;     # Antagonist is Player 1.
			$chaos->{clients}->{$client}->{callback} = 'fight'; # Set callback for antagonist.
			$chaos->{clients}->{$client}->{_attktarget} = $target; # Antagonist's target.
			$chaos->{clients}->{$target}->{_attack} = $id;       # Set ID for victim.
			$chaos->{clients}->{$target}->{_attkplayer} = 2;     # Victim is Player 2.
			$chaos->{clients}->{$target}->{callback} = 'fight'; # Set callback for victim.
			$chaos->{clients}->{$target}->{_attktarget} = $client; # Victim's target.
			$chaos->{clients}->{$client}->{_attkturn} = 2;       # It is the victim's turn to fight back.
			$chaos->{clients}->{$target}->{_attkturn} = 2;       # It is the victim's turn to fight back.

			# Create the game.
			$chaos->{games}->create (
				id   => $id,
				name => 'Fight',
			);

			# Add both players.
			$chaos->{games}->addPlayer ($id, name => $client);
			$chaos->{games}->addPlayer ($id, name => $target);

			# Pick a random insult.
			my @insults = keys %in;
			my $rand = $insults [ int(rand(scalar(@insults))) ];

			# Provide a few options.
			my @nums = ();
			push (@nums, $in{$rand}); # The correct response.
			while (scalar(@nums) < 4) {
				# Pick a random number from 0 to 45.
				my $key = int(rand(46));

				my $found = 0;
				foreach my $already (@nums) {
					if ($key == $already) {
						$found = 1;
					}
				}
				push (@nums, $key) unless $found;
			}

			# Shuffle the array.
			for (my $i = 0; $i < scalar(@nums); $i++) {
				my $j = int(rand(scalar(@nums)));
				($nums[$i],$nums[$j]) = ($nums[$j],$nums[$i]);
			}

			# Prepare the message being sent to the victim.
			my $send = "$name has picked a fight with you!\n\n"
				. "He said:\n"
				. "<gt><gt> $rand\n\n"
				. "You shouldn't take this! Fight back!\n"
				. "A. $out{$nums[0]}\n"
				. "B. $out{$nums[1]}\n"
				. "C. $out{$nums[2]}\n"
				. "D. $out{$nums[3]}\n\n"
				. "You can surrender at any time by typing \"quit\".";

			# Save the answers.
			$chaos->{clients}->{$target}->{_attkinsult} = $rand;
			$chaos->{clients}->{$target}->{_attkopts} = {
				a => $nums[0],
				b => $nums[1],
				c => $nums[2],
				d => $nums[3],
			};

			# Send a message to the victim.
			$chaos->{games}->sendMessage (
				to      => $target,
				message => $send,
			);
			return "You have picked a fight with $msg.\n\n"
				. "<gt><gt> $rand\n\n"
				. "Awaiting their response... you can surrender at any time by typing \"quit\".";
		}
		else {
			return "Tell me who to attack when calling this command:\n\n"
				. "i.e.\n"
				. "!fight screenname";
		}
	}
	else {
		# See whose turn it is.
		my $player = $chaos->{clients}->{$client}->{_attkplayer};
		my $turn = $chaos->{clients}->{$client}->{_attkturn};

		if ($msg =~ /^quit$/i) {
			my $target = $chaos->{clients}->{$client}->{_attktarget};

			# Kill the game.
			$chaos->{games}->destroy (
				id      => $chaos->{clients}->{$client}->{_attack},
				force   => 1,
				alert   => 1,
				message => "$client has chickened out! $target won!",
			);

			delete $chaos->{clients}->{$client}->{host};
			delete $chaos->{clients}->{$target}->{host};
			delete $chaos->{clients}->{$client}->{_attack};
			delete $chaos->{clients}->{$client}->{_attkplayer};
			delete $chaos->{clients}->{$client}->{callback};
			delete $chaos->{clients}->{$client}->{_attktarget};
			delete $chaos->{clients}->{$target}->{_attack};
			delete $chaos->{clients}->{$target}->{_attkplayer};
			delete $chaos->{clients}->{$target}->{callback};
			delete $chaos->{clients}->{$target}->{_attktarget};
			delete $chaos->{clients}->{$client}->{_attkturn};

			return "<noreply>";
		}

		# Our turn?
		if ($player == $turn) {
			# See what answer they picked.
			if ($msg =~ /^(a|b|c|d)$/i) {
				$msg = lc($msg);
				my $key = $chaos->{clients}->{$client}->{_attkopts}->{$msg};
				my $correct = $in{$chaos->{clients}->{$client}->{_attkinsult}};
				if ($key == $correct) {
					# They fought back!
					my ($listener,$name) = split(/\-/, $client, 2);

					# Find the victim now.
					my $victim = $chaos->{clients}->{$client}->{_attktarget};
					my $target = $chaos->{clients}->{$client}->{_attktarget};
					my ($l,$n) = split(/\-/, $victim, 2);
					$victim = $n;

					# Change the turn.
					if ($turn == 1) {
						$turn = 2;
					}
					else {
						$turn = 1;
					}
					$chaos->{clients}->{$client}->{_attkturn} = $turn;
					$chaos->{clients}->{$target}->{_attkturn} = $turn;

					# Pick a random insult.
					my @insults = keys %in;
					my $rand = $insults [ int(rand(scalar(@insults))) ];

					# Provide a few options.
					my @nums = ();
					push (@nums, $in{$rand}); # The correct response.
					while (scalar(@nums) < 4) {
						# Pick a random number from 0 to 45.
						my $key = int(rand(46));

						my $found = 0;
						foreach my $already (@nums) {
							if ($key == $already) {
								$found = 1;
							}
						}
						push (@nums, $key) unless $found;
					}

					# Shuffle the array.
					for (my $i = 0; $i < scalar(@nums); $i++) {
						my $j = int(rand(scalar(@nums)));
						($nums[$i],$nums[$j]) = ($nums[$j],$nums[$i]);
					}

					# Prepare the message being sent to the victim.
					my $send = "$name has fought back!\n\n"
						. "They said:\n"
						. "<lt><lt> $out{$key}\n"
						. "<gt><gt> $rand\n\n"
						. "You shouldn't take this! Fight back!\n"
						. "A. $out{$nums[0]}\n"
						. "B. $out{$nums[1]}\n"
						. "C. $out{$nums[2]}\n"
						. "D. $out{$nums[3]}\n\n"
						. "You can surrender at any time by typing \"quit\".";

					# Save the answers.
					$chaos->{clients}->{$target}->{_attkinsult} = $rand;
					$chaos->{clients}->{$target}->{_attkopts} = {
						a => $nums[0],
						b => $nums[1],
						c => $nums[2],
						d => $nums[3],
					};

					# Send a message to the victim.
					$chaos->{games}->sendMessage (
						to      => $target,
						message => $send,
					);

					# Refresh the victim's callback.
					$chaos->{clients}->{$target}->{callback} = 'fight';

					return "You have fought back against $victim.\n\n"
						. "<lt><lt> $out{$key}\n"
						. "<gt><gt> $rand\n\n"
						. "Awaiting their response... you can surrender at any time by typing \"quit\".";
				}
				else {
					# WRONG!

					# Find the victim now.
					my ($listener,$name) = split(/\-/, $client, 2);
					my $victim = $chaos->{clients}->{$client}->{_attktarget};
					my $target = $chaos->{clients}->{$client}->{_attktarget};
					my ($l,$n) = split(/\-/, $victim, 2);
					$victim = $n;

					my $send = "$name has fought back!\n\n"
						. "They said:\n"
						. "<lt><lt> $out{$key}\n\n"
						. "You have won this battle!";

					$chaos->{games}->sendMessage (
						to      => $target,
						message => $send,
					);

					# Delete the data.
					my $id = $chaos->{clients}->{$client}->{_attack};
					delete $chaos->{clients}->{$client}->{_attack};
					delete $chaos->{clients}->{$client}->{_attkplayer};
					delete $chaos->{clients}->{$client}->{callback};
					delete $chaos->{clients}->{$client}->{_attktarget};
					delete $chaos->{clients}->{$target}->{_attack};
					delete $chaos->{clients}->{$target}->{_attkplayer};
					delete $chaos->{clients}->{$target}->{callback};
					delete $chaos->{clients}->{$target}->{_attktarget};
					delete $chaos->{clients}->{$client}->{_attkturn};

					# Destroy the game.
					$chaos->{games}->dropPlayer ($id,$client);
					$chaos->{games}->dropPlayer ($id,$target);
					$chaos->{games}->destroy (
						id    => $id,
						force => 1,
						alert => 0,
					);

					return "You have fought back against $victim.\n\n"
						. "<lt><lt> $out{$key}\n\n"
						. "You picked the wrong comeback! You have lost!";
				}
			}
			else {
				return "Invalid option: must be A through D.";
			}
		}
		else {
			return "It's not your turn! Wait for your victim to go! (or type \"quit\" to surrender)";
		}
	}
}
{
	Category    => 'Multiplayer Games',
	Description => 'Pick a fight with someone.',
	Usage       => '!fight <username>',
	Listener    => 'AIM,MSN',
};