#!/usr/bin/perl

#################################################
# Chaos A.I. Technology NexusBot Program        #
#-----------------------------------------------#
# Copyright 2004 Chaos AI Technology            #
#-----------------------------------------------#
$AUTHOR = "Kirsle";  # This program is released #
$VERSION = "1.0.00"; # under the GNU General    #
$COPYRIGHT = "2004"; # Public License v. 2      #
#################################################

# Use the local library.
use lib "./lib";

################################################
# Use all modules we require here.             #
#----------------------------------------------#
use LWP::Simple;              # For text files #
use File::Basename;           # To have a base #
use Net::OSCAR qw(:standard); # For AIM        #
use MSN;                      # For MSN        #
################################################

# Print the startup message.
print <<intro;
     #####    #
    #     #   #
   #       #  #
  #           #            #
  #           ####     #####     ####    ####
  #           #   #   #    #    #    #  #
   #       #  #    #  #    #    #    #   ###
    #     #   #    #  #    #    #    #      #
     #####    #    #   #### ##   ####   ####

         A . I .      T e c h n o l o g y
+------------------------------------------------+
I Chaos AI Technology ShardsBot is starting...   I
I VERSION: $VERSION                 AUTHOR: $AUTHOR I
+------------------------------------------------+

intro

# The PANIC sub.
sub panic {
	my ($message,$fatality) = @_;

	# Sound the alarm.
	print "\a";

	# Show the message to the console.
	print "\tCKS // PANIC: $message\n";

	# If fatality is nonzero, sleep a bit and crash.
	if ($fatality) {
		sleep 500;
		exit;
	}
}

# Make sure all the required directories are in existence.
@required_directories = (
	"bots",
	"commands",
	"commands/master",
	"commands/superadmin",
	"commands/admin",
	"commands/supermoderator",
	"commands/moderator",
	"commands/keeper",
	"commands/gifted",
	"commands/client",
	"clients",
	"data",
	"handlers",
	"lib",
	"logs",
	"subroutines",
);
foreach $folder (@required_directories) {
	if (-e "./$folder" != 1) {
		panic ("You are missing required folder \"$folder\".", 1);
	}
}

# Scan the folders.
print ":: Scanning folders... Done!\n";

# Declare all global hashes.
print ":: Declaring global hashes... ";
%userdata;
%chaos;
print "Done!\n";

# Load up the bots' information.
print ":: Loading bot information... ";
@bot_names;
opendir (BOTS, "./bots");
foreach $file (sort(grep(!/^\./, readdir (BOTS)))) {
	print "./bots/$file\n";
	open (BOT, "./bots/$file");
	@bot_data = <BOT>;
	close (BOT);

	foreach $line (@bot_data) {
		chomp $line;
		$line =~ s/: /:/g;
		($what,$is) = split(/:/, $line);

		$what =~ s/ //g;
		$what = lc($what);

		if ($what eq "screenname") {
			# We have a screenname.
			$screenname = $is;
			push @bot_names, $screenname;
		}
		elsif ($what eq "password") {
			# The bot's password.
			$chaos->{$screenname}->{pw} = $is;
		}
		elsif ($what eq "client") {
			# The messenger.
			$chaos->{$screenname}->{listener} = $is;
		}
		else {
			# Misc Info.
			$chaos->{$screenname}->{$what} = $is;
		}
	}
}
closedir (BOTS);
print "Done!\n";

# Load all the Perl files.
print ":: Appending All Files...\n";
@file_folders = (
	"commands/master",
	"commands/superadmin",
	"commands/admin",
	"commands/supermoderator",
	"commands/moderator",
	"commands/keeper",
	"commands/gifted",
	"commands/client",
	"extensions",
	"handlers/aim",
	"handlers/msn",
	"handlers/http",
	"subroutines",
);
foreach $folder (@file_folders) {
	opendir (PL, "./$folder");
	foreach $file (sort(grep(!/^\./, readdir (PL)))) {
		print "\tLoading $folder/$file... ";
		require "./$folder/$file";
		print "Done!\n";
	}
	closedir (PL);
}
print ":: Done Loading Files!\n";

# Sign on all the bots.
print ":: Signing on all the bots...\n";
foreach $robot (@bot_names) {
	print "$robot\n";

	# AOL Instant Messenger
	if ($chaos->{$robot}->{listener} eq "AIM") {
		print "\tChaosAIM: Signing on $robot to AIM... ";

		# Create a new Net-OSCAR for this bot.
		$chaos->{$robot}->{client} = Net::OSCAR->new();

		# Setup AIM handlers.
		$chaos->{$robot}->{client}->set_callback_admin_error (\&aim_admin_error);
		$chaos->{$robot}->{client}->set_callback_admin_ok (\&aim_admin_ok);
		$chaos->{$robot}->{client}->set_callback_auth_challenge (\&aim_auth_challenge);
		$chaos->{$robot}->{client}->set_callback_buddy_in (\&aim_buddy_in);
		$chaos->{$robot}->{client}->set_callback_buddy_info (\&aim_buddy_info);
		$chaos->{$robot}->{client}->set_callback_buddy_out (\&aim_buddy_out);
		$chaos->{$robot}->{client}->set_callback_buddylist_error (\&aim_buddylist_error);
		$chaos->{$robot}->{client}->set_callback_buddylist_ok (\&aim_buddylist_ok);
		$chaos->{$robot}->{client}->set_callback_chat_buddy_in (\&aim_chat_buddy_in);
		$chaos->{$robot}->{client}->set_callback_chat_buddy_out (\&aim_chat_buddy_out);
		$chaos->{$robot}->{client}->set_callback_chat_closed (\&aim_chat_closed);
		$chaos->{$robot}->{client}->set_callback_chat_im_in (\&aim_chat_im_in);
		$chaos->{$robot}->{client}->set_callback_chat_invite (\&aim_chat_invite);
		$chaos->{$robot}->{client}->set_callback_chat_joined (\&aim_chat_joined);
		$chaos->{$robot}->{client}->set_callback_error (\&aim_error);
		$chaos->{$robot}->{client}->set_callback_evil (\&aim_evil);
		$chaos->{$robot}->{client}->set_callback_im_in (\&aim_im_in);
		$chaos->{$robot}->{client}->set_callback_im_ok (\&aim_im_ok);
		$chaos->{$robot}->{client}->set_callback_rate_alert (\&aim_rate_alert);
		$chaos->{$robot}->{client}->set_callback_signon_done (\&aim_signon_done);

		# Sign on the robot.
		$screenname = $robot;
		$password = $chaos->{$robot}->{pw};

		$chaos->{$robot}->{client}->signon ($screenname,$password) or panic ("Could not sign on!", 0);

		print "Connection recieved!\n\n";
	}
	elsif ($chaos->{$robot}->{listener} eq "MSN") {
		print "\tChaosMSN: Signing on $robot to MSN... ";

		# Sign on the MSN bot.
		$screenname = $robot;
		$password = $chaos->{$robot}->{pw};

		# Create a new MSN instance.
		$chaos->{$robot}->{client} = MSN->new (
			Handle   => $screenname,
			Password => $password,
		);

		# Set handlers.
		$chaos->{$robot}->{client}->set_handler (Connected => \&msn_connected);
		$chaos->{$robot}->{client}->set_handler (Message   => \&msn_im_in);
		$chaos->{$robot}->{client}->set_handler (Answer    => \&msn_answer);
		$chaos->{$robot}->{client}->set_handler (Join      => \&msn_join);

		# Connect.
		$chaos->{$robot}->{client}->connect() or panic ("Could not connect to MSN!", 0);

		print "Connection recieved!\n\n";
	}
	else {
		panic ("Unrecognized client \"$chaos->{$robot}->{client}\".", 0);
	}
}
print ":: Done connecting!\n\n";

# Start looping!
while (1) {
	foreach $active (@bot_names) {
		$chaos->{$active}->{client}->do_one_loop();
	}
}