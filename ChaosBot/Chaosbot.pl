#!/usr/bin/perl

# Chaos AI Technology's Chatterbot Program

# Use the local library.
use lib "./lib";

# Use LWP::Simple for retrieval of text files.
use LWP::Simple;

# Use Net::OSCAR for connection to AIM.
use Net::OSCAR qw(:standard);
#use Net::AIM;

# Use the MSN Module.
use MSN;

%config;

# Load the configuration data.
open (CONFIG, "config/startup.cfg");
my @config = <CONFIG>;
close (CONFIG);
foreach $line (@config) {
	chomp $line;
	($what,$is) = split(/=/, $line);
	$config{$what} = $is;
}

# Print the startup message.
print ("     \#\#\#\#\#    \#\n"
	. "    \#     \#   \#\n"
	. "   \#       \#  \#\n"
	. "  \#           \#            \#\n"
	. "  \#           \#\#\#\#     \#\#\#\#\#     \#\#\#\#    \#\#\#\#\n"
	. "  \#           \#   \#   \#    \#    \#    \#  \#\n"
	. "   \#       \#  \#    \#  \#    \#    \#    \#   \#\#\#\n"
	. "    \#     \#   \#    \#  \#    \#    \#    \#      \#\n"
	. "     \#\#\#\#\#    \#    \#   \#\#\#\# \#\#   \#\#\#\#   \#\#\#\#\n\n"
	. "         A . I .      T e c h n o l o g y\n"
	. "+------------------------------------------------+\n"
	. "I Chaos AI Technology ChaosBot is starting...    I\n"
	. "I VERSION: 1.0.00          AUTHOR: Cerone Kirsle I\n"
	. "+------------------------------------------------+\n"
	. "$config{'ad_txt'}\n\n");

# The PANIC sub.
sub panic {
	my ($message,$fatality) = @_;

	# Show the message to the console.
	print "\tCKS \/\/ PANIC: $message\n";

	# If FATALITY is non-zero, sleep 500 seconds and crash.
	if ($fatality) {
		sleep(500);
		exit;
	}
}

# Make sure we have use in all the directories.
my @required_directories = (
	"commands",
	"config",
	"data",
	"lib",
	"logs",
	"handlers",
);
foreach $folder (@required_directories) {
	if (-e "./$folder" != 1) {
		panic ("You are missing required folder \"$folder\".\n"
			. "\tPlease see \"docs/folders.html\" for more information.",1);
	}
}

# Use the local library.
print ":: Loading local libraries... ";
print "Done.\n";

# Clear old temp files.
print ":: Clearing temporary files... ";
opendir(TMP, "./temp");
foreach $file (sort(grep(!/^\./, readdir(TMP)))) {
	unlink ("./temp/$file");
}
closedir(TMP);
print "Done.\n";

# Begin loading up the bots.
print ":: Loading bot files... ";

%bots;
@bot_names;

opendir(DIR, "./bots");
foreach $file (sort(grep(!/^\./, readdir(DIR)))) {
	#$file =~ s/\.(.*)//g;

	open (BOT, "./bots/$file");
	my @bot_data = <BOT>;
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
			# Time to set the password.
			$bots{$screenname}->{"pw"} = $is;
		}
		elsif ($what eq "client") {
			# The client it connects to.
			$bots{$screenname}->{"listener"} = $is;
		}
		else {
			$bots{$screenname}->{$what} = $is;
		}
	}
}
closedir(DIR);
print "Done.\n";

# Load all commands and other necessary files.
print ":: Loading all Perl files...\n";
my @file_folders = (
	"commands",
	"handlers/aim",
	"handlers/msn",
	"subroutines",
);
foreach $folder (@file_folders) {
	opendir (PL, "./$folder");
	foreach $file (sort(grep(!/^\./, readdir(PL)))) {
		print "\tLoading $folder/$file... ";
		require "./$folder/$file";
		print "Done!\n";
	}
	closedir (PL);
}
print ":: Done loading files.\n";

# Begin connecting the bots to their messengers.
print ":: Signing on all the bots... ";
foreach $robot (@bot_names) {

	if ($bots{$robot}->{"listener"} eq "AIM") {

		print "\nSigning on $robot to AIM.\n";

		# Create a new Net::OSCAR instance for this bot.
		$bots{$robot}->{"client"} = Net::OSCAR->new();

		print "Created a Net-OSCAR.\n";

		# Setup the handlers for AIM.
		#$bots{$robot}->{"client"}->set_callback_admin_error (\&aim_admin_error);
		#$bots{$robot}->{"client"}->set_callback_admin_ok (\&aim_admin_ok);
		#$bots{$robot}->{"client"}->set_callback_buddy_in (\&aim_buddy_in);
		#$bots{$robot}->{"client"}->set_callback_buddy_out (\&aim_buddy_out);
		#$bots{$robot}->{"client"}->set_callback_buddylist_error (\&aim_buddylist_error);
		#$bots{$robot}->{"client"}->set_callback_buddylist_ok (\&aim_buddylist_ok);
		#$bots{$robot}->{"client"}->set_callback_chat_buddy_in (\&aim_chat_buddy_in);
		#$bots{$robot}->{"client"}->set_callback_chat_buddy_out (\&aim_chat_buddy_out);
		#$bots{$robot}->{"client"}->set_callback_chat_closed (\&aim_chat_closed);
		#$bots{$robot}->{"client"}->set_callback_chat_im_in (\&aim_chat_im_in);
		$bots{$robot}->{"client"}->set_callback_chat_invite (\&aim_chat_invite);
		$bots{$robot}->{"client"}->set_callback_chat_joined (\&aim_chat_joined);
		$bots{$robot}->{"client"}->set_callback_error (\&aim_error);
		$bots{$robot}->{"client"}->set_callback_evil (\&aim_evil);
		$bots{$robot}->{"client"}->set_callback_im_in (\&aim_im_in);
		#$bots{$robot}->{"client"}->set_callback_rate_alert (\&aim_rate_alert);
		$bots{$robot}->{"client"}->set_callback_signon_done (\&aim_signon_done);

		$screenname = $robot;
		$password = $bots{$robot}->{"pw"};

		print "Defined screenname and password.\n";

		$bots{$robot}->{"client"}->signon ($screenname,$password);

		print "Signed on.\n";
	}
	elsif ($bots{$robot}->{"listener"} eq "MSN") {

		print "\nSigning on $robot to MSN.\n";

		$screenname = $robot;
		$password = $bots{$robot}->{"pw"};

		$bots{$robot}->{"client"} = MSN->new(Handle => $screenname, Password => $password);

		$bots{$robot}->{"client"}->set_handler (Connected => \&Connected);
		$bots{$robot}->{"client"}->set_handler (Message   => \&Message);
		$bots{$robot}->{"client"}->set_handler (Answer    => \&Answer);
		$bots{$robot}->{"client"}->set_handler (Join      => \&Join);

		$bots{$robot}->{"client"}->connect();
	}
}
print "Done.\n";

# Get the loop count. We'll reset at 500K.
$loop_count = 0;
while (1) {
	foreach $active (@bot_names) {
		$bots{$active}->{"client"}->do_one_loop();
	}

	if ($loop_count == 500000) {
		print "CKS // Your bot has reached 500,000 loops.\n\n";
	}
	$loop_count++;
}

# Some MSN subs.
sub Connected {
	print "ChaosMSN: Sub CONNECTED called.\n";
	$self = shift;
	$self->set_status ('NLN');
}
sub Message {
	&msn_im (@_);
}
sub Join {
}
sub Answer {
}