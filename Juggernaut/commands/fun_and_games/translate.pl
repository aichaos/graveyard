#      .   .             <CKS Juggernaut>
#     .:...::     Command Name // !translate
#    .::   ::.     Description // English/Azulian Translator.
# ..:;;. ' .;;:..        Usage // !translate <eng|azu>-><message>
#    .  '''  .     Permissions // Public
#     :;,:,;:         Listener // All Listeners
#     :     :        Copyright // 2004 Chaos AI Technology

sub translate {
	my ($self,$client,$msg,$listener) = @_;

	# Our translation hashes.
	my %to_azu = (
		A => "E",
		B => "P",
		C => "W",
		D => "Q",
		E => "O",
		F => "T",
		G => "V",
		H => "Y",
		I => "A",
		J => "X",
		K => "Z",
		L => "B",
		M => "D",
		N => "F",
		O => "U",
		P => "G",
		Q => "J",
		R => "C",
		S => "H",
		T => "K",
		U => "I",
		V => "L",
		W => "R",
		X => "M",
		Y => "S",
		Z => "N",
	);
	my %to_eng = (
		A => "I",
		B => "L",
		C => "R",
		D => "M",
		E => "A",
		F => "N",
		G => "P",
		H => "S",
		I => "U",
		J => "Q",
		K => "T",
		L => "V",
		M => "X",
		N => "Z",
		O => "E",
		P => "B",
		Q => "D",
		R => "W",
		S => "Y",
		T => "F",
		U => "O",
		V => "G",
		W => "C",
		X => "J",
		Y => "H",
		Z => "K",
	);

	# See if they have a message.
	if (length $msg > 1) {
		# Format the message...
		$msg =~ s/\&gt\;/>/ig;
		$msg =~ s/\&lt\;/</ig;

		# Split the language from the message.
		my ($lang,$str) = split(/\-\>/, $msg, 2);
		$lang = lc($lang);

		# Split the string into an array.
		my @string = split(//, $str);

		# See if they have a valid language.
		$lang = "a" if $lang eq "azulian";
		$lang = "a" if $lang eq "azu";
		$lang = "e" if $lang eq "english";
		$lang = "e" if $lang eq "eng";

		my $char;
		my $final;
		my $type;

		if ($lang eq "a") {
			$type = "Azulian";
			# Translating into Azulian.
			foreach $char (@string) {
				if ($char eq " ") {
					$final .= " ";
				}
				else {
					if (!exists $to_azu{uc($char)}) {
						$final .= $char;
						next;
					}
					$char = uc($char);
					$char =~ s/$char/$to_azu{$char}/ig;
					$char = lc($char);
					$final .= $char;
				}
			}
		}
		elsif ($lang eq "e") {
			$type = "English";
			# Translating into English.
			foreach $char (@string) {
				if ($char eq " ") {
					$final .= " ";
				}
				else {
					if (!exists $to_eng{uc($char)}) {
						$final .= $char;
						next;
					}
					$char = uc($char);
					$char =~ s/$char/$to_eng{$char}/ig;
					$char = lc($char);
					$final .= $char;
				}
			}
		}
		else {
			return "Invalid use of the command:\n\n"
				. "!translate azulian->hello world!";
		}

		# Return their reply.
		return "Translation ($type): $final";
	}
	else {
		return "To use the translator:\n\n"
			. "!translate azulian->hello world!";
	}
}

{
	Category => 'Fun & Games',
	Description => 'Azulian/English Translator',
	Usage => '!translate <azulian|english>-><string>',
	Listener => 'All',
};