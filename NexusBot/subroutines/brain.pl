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
#  Subroutine: brain                            #
# Description: The main brain of the bot.       #
#################################################

sub brain {
	# Get the details from the shift.
	my ($client,$msg,$omsg,$listener,$learn) = @_;
	my $reply = "";

	# Load or create this user's profile.
	&profile_get ($client,$listener);

	# See if this user is telling or asking about himself.
	if ($msg =~ /my name is (.*)/i) {
		$name = $1;
		$name = formal($name);
		&profile_send ($client,$listener,"name",$name);
		$reply = "$name, nice to meet you! :-)";
	}
	elsif ($msg =~ /call me (.*)/i) {
		$name = $1;
		$name = formal($name);
		&profile_send ($client,$listener,"name",$name);
		$reply = "I will call you $name now.";
	}
	elsif ($msg =~ /i am (\d+) years old/i) {
		$age = $1;
		&profile_send ($client,$listener,"age",$age);
		$reply = "What's it like being $age years old?";
	}
	elsif ($msg =~ /i am a (boy|guy|male|man|dude|girl|gurl|grrl|female|chick)/i) {
		$sex = $1;
		&profile_send ($client,$listener,"sex",$sex);
		$reply = "Oh, so you're a $sex.";
	}
	elsif ($msg =~ /i am from (.*)/i) {
		$location = $1;
		$location = formal($location);
		&profile_send ($client,$listener,"location",$location);
		$reply = "I know somebody from $location.";
	}
	elsif ($msg =~ /my (fav|fave|favorite|favourite) color is (.*)/i) {
		$color = $2;
		&profile_send ($client,$listener,"color",$color);
		$reply = "$color is a pretty color.";
	}
	elsif ($msg =~ /my (fav|fave|favorite|favourite) band is (.*)/i) {
		$band = $2;
		$band = formal($band);
		&profile_send ($client,$listener,"band",$band);
		$reply = "Oh, I've never heard of $band.";
	}
	elsif ($msg =~ /my (fav|fave|favorite|favourite) book is (.*)/i) {
		$book = $2;
		$book = formal($book);
		&profile_send ($client,$listener,"book",$book);
		$reply = "I've never read $book.";
	}
	elsif ($msg =~ /i am (gay|homo|lesbian|a dyke)/i) {
		&profile_send ($client,$listener,"sexuality","homosexual");
		$reply = "That's cool.";
	}
	elsif ($msg =~ /i am (bi|bisexual)/i) {
		&profile_send ($client,$listener,"sexuality","bisexual");
		$reply = "That's cool.";
	}
	elsif ($msg =~ /i am (str8|straight)/i) {
		&profile_send ($client,$listener,"sexuality","heterosexual");
		$reply = "That's cool.";
	}
	elsif ($msg =~ /my job is a (.*)/i) {
		$job = $1;
		$job = formal($job);
		&profile_send ($client,$listener,"job",$job);
		$reply = "Oh, I've talked to a $job before.";
	}

	# Are they asking about themselves?
	elsif ($msg =~ /what (is|are) my (rights|permissions|status)/i) {
		$reply = "Your permission status is: $chaos->{users}->{$client}->{permission}.";
	}
	elsif ($msg =~ /how (many messages have i sent|talkative am i)/i) {
		$reply = "You have sent me $chaos->{users}->{$client}->{messages} messages.";
	}
	elsif ($msg =~ /who am i|what is my name/i) {
		$reply = "You told me your name was $chaos->{users}->{$client}->{name}.";
	}
	elsif ($msg =~ /how old am i|what is my age/i) {
		$reply = "You told me you were $chaos->{users}->{$client}->{age} years old.";
	}
	elsif ($msg =~ /what is my sexuality|am i gay|am i straight|am i lesbian|am i bi/i) {
		$reply = "You told me you were $chaos->{users}->{$client}->{sexuality}.";
	}
	elsif ($msg =~ /what am i|what is my (gender|sex)/i) {
		$reply = "You are a $chaos->{users}->{$client}->{sex}.";
	}
	elsif ($msg =~ /where am i|where do i live/i) {
		$reply = "You live in $chaos->{users}->{$client}->{location}.";
	}
	elsif ($msg =~ /what is my (fav|fave|favorite|favourite) color/i) {
		$reply = "You like the color $chaos->{users}->{$client}->{color}.";
	}
	elsif ($msg =~ /what is my (fav|fave|favorite|favourite) band/i) {
		$reply = "Your favorite band is $chaos->{users}->{$client}->{band}.";
	}
	elsif ($msg =~ /what is my (fav|fave|favorite|favourite) book/i) {
		$reply = "The best book you read was $chaos->{users}->{$client}->{book}.";
	}
	elsif ($msg =~ /what is my (job|occupation)|what do i do/i) {
		$reply = "You are a $chaos->{users}->{$client}->{job}.";
	}

	# If we don't yet have a reply, use our learning brain.
	if ($reply eq "") {
		# If Learn Mode is set to 1, use it.
		if ($learn == 1) {
			$reply = respond ($client,$msg,$omsg);
		}
		else {
			$reply = nolearn ($client,$msg,$omsg);
		}
	}

	# Increase their message count.
	$cnt++;
	&profile_send ($client,$listener,"messages",$cnt);

	# Return the reply.
	return $reply;
}
1;