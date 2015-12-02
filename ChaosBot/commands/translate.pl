##########################################
#  ChaosBot Program A - www.chaosbot.tk  #
#     Copyright 2003 Cerone Kirsle.      #
#          <kirsle@hotmail.com>          #
##########################################

sub translate {
	my ($client,$msg) = (shift,shift);
	#Remove /translate from the message
	$msg =~ s/\!translate //;
	($lang,$text) = split(/:/,$msg);

	#Change spaces
	$text =~ s/ /~/ig;

	#Split the letters apart
	@chars = split("",$text);

	#Lower-case the language
	$lang = lc($lang);

	################### AZULIAN ########################################
	if ($lang eq "azulian" || $lang eq "azu") {
		foreach $character (@chars) {
			#Make the characters lower-cased
			$character = lc($character);
			if ($character eq "a") {
				$character = "e";
			}
			elsif ($character eq "b") {
				$character = "r";
			}
			elsif ($character eq "c") {
				$character = "s";
			}
			elsif ($character eq "d") {
				$character = "t";
			}
			elsif ($character eq "e") {
				$character = "o";
			}
			elsif ($character eq "f") {
				$character = "v";
			}
			elsif ($character eq "g") {
				$character = "w";
			}
			elsif ($character eq "h") {
				$character = "x";
			}
			elsif ($character eq "i") {
				$character = "a";
			}
			elsif ($character eq "j") {
				$character = "y";
			}
			elsif ($character eq "k") {
				$character = "z";
			}
			elsif ($character eq "l") {
				$character = "b";
			}
			elsif ($character eq "m") {
				$character = "c";
			}
			elsif ($character eq "n") {
				$character = "d";
			}
			elsif ($character eq "o") {
				$character = "u";
			}
			elsif ($character eq "p") {
				$character = "f";
			}
			elsif ($character eq "q") {
				$character = "g";
			}
			elsif ($character eq "r") {
				$character = "h";
			}
			elsif ($character eq "s") {
				$character = "j";
			}
			elsif ($character eq "t") {
				$character = "k";
			}
			elsif ($character eq "u") {
				$character = "i";
			}
			elsif ($character eq "v") {
				$character = "l";
			}
			elsif ($character eq "w") {
				$character = "m";
			}
			elsif ($character eq "x") {
				$character = "n";
			}
			elsif ($character eq "y") {
				$character = "p";
			}
			elsif ($character eq "z") {
				$character = "q";
			}
			elsif ($character eq "\~") {
				$character = "tilde";
			}
			else {
				$character = $character;
			}
		}
	}
	################### ENGLISH ########################################
	if ($lang eq "english" || $lang eq "eng") {
		foreach $character (@chars) {
			#Make the characters lower-cased
			$character = lc($character);
			if ($character eq "a") {
				$character = "i";
			}
			elsif ($character eq "b") {
				$character = "l";
			}
			elsif ($character eq "c") {
				$character = "m";
			}
			elsif ($character eq "d") {
				$character = "n";
			}
			elsif ($character eq "e") {
				$character = "a";
			}
			elsif ($character eq "f") {
				$character = "p";
			}
			elsif ($character eq "g") {
				$character = "q";
			}
			elsif ($character eq "h") {
				$character = "r";
			}
			elsif ($character eq "i") {
				$character = "u";
			}
			elsif ($character eq "j") {
				$character = "s";
			}
			elsif ($character eq "k") {
				$character = "t";
			}
			elsif ($character eq "l") {
				$character = "v";
			}
			elsif ($character eq "m") {
				$character = "w";
			}
			elsif ($character eq "n") {
				$character = "x";
			}
			elsif ($character eq "o") {
				$character = "e";
			}
			elsif ($character eq "p") {
				$character = "y";
			}
			elsif ($character eq "q") {
				$character = "z";
			}
			elsif ($character eq "r") {
				$character = "b";
			}
			elsif ($character eq "s") {
				$character = "c";
			}
			elsif ($character eq "t") {
				$character = "d";
			}
			elsif ($character eq "u") {
				$character = "o";
			}
			elsif ($character eq "v") {
				$character = "f";
			}
			elsif ($character eq "w") {
				$character = "g";
			}
			elsif ($character eq "x") {
				$character = "h";
			}
			elsif ($character eq "y") {
				$character = "j";
			}
			elsif ($character eq "z") {
				$character = "k";
			}
			elsif ($character eq "\~") {
				$character = "tilde";
			}
			else {
				$character = $character;
			}
		}
	}
	#Format the results and turn tildes back into spaces
	$result = "@chars";
	$result =~ s/ //ig;
	$result =~ s/tilde/ /ig;
	$reply = "Translation: $result";
	return $reply;
}
1;