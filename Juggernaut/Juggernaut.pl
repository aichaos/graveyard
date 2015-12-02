#!/usr/bin/perl

# Chaos AI Technology Juggernaut
# Copyright (C) 2004 Cerone Kirsle

# We require Perl 5.8 or higher.
require 5.8.00;

# Declare our bot's body hash.
our $chaos = {};

# Arguments.
$chaos->{_system}->{cmd}->{reslis} = 0; # Not restricting listeners.
if (defined @ARGV) {
	foreach $item (@ARGV) {
		$item = lc($item);

		if ($item eq '/?' || $item eq '-?') {
			print "\n=================================\n"
				. "CKS Juggernaut Command Line Arguments:\n\n"
				. "/?   => Displays help.\n"
				. "/m   => Start up in Maintenance Mode.\n"
				. "/msn => Only sign-on MSN bots.\n"
				. "/aim => Only sign-on AIM bots.\n"
				. "/irc => Only sign-on IRC bots.\n"
				. "Any number of these arguments can be used at once, i.e.\n"
				. "\tperl Juggernaut.pl /m /w\n\n";
			exit;
		}
		elsif ($item eq '/m') {
			# Maintenance mode ON.
			$chaos->{_system}->{maintain}->{msg} = 'The bot is currently under '
				. 'maintenance mode.';
			$chaos->{_system}->{maintain}->{on} = 1;
		}
		elsif ($item =~ /^\/(aim|msn|irc)$/i) {
			# Specifying messengers.
			$item = $1;

			# Restrict messengers.
			$chaos->{_system}->{cmd}->{reslis} = 1;

			# Add this to the allowance.
			$chaos->{_system}->{cmd}->{allowlis}->{$item} = 1;
		}
		else {
			print "\n\nInvalid argument: use /? for list of arguments!\n\n";
		}
	}
}

# Use all modules...
use lib "./lib";               # Use our own local library
use LWP::Simple;               # For text file manipulation
use warnings;                  # Show warnings.
use strict;                    # Proper coding.
#use AIML::Common;             # The Alice bot brain.
use Net::OSCAR qw(:standard);  # To connect to AIM
use Net::IRC;                  # To connect to IRC
use MSN;                       # To connect to MSN

# Using Net-OSCAR 1.11? (1.11 supports buddy icons but has a messed up chat_invite handler)
my $oscar111 = 1; # or 0 for no

$chaos->{_system}->{version} = '4.0';
$chaos->{_system}->{author} = 'Cerone Kirsle';

# Our current version number.
my $VERSION = $chaos->{_system}->{version};

# Declare common variables.
my ($key,@botnames,@new_botnames,$name,$screenname,
	$password,$temp,$what,$is,@data,@perl_files,
	$bot,$line,$file,$lvl,@required_directories,
	$item);

# Print the startup message.
print <<intro;
             ::.                   .:.
              .;;:  ..:::::::.  .,;:
                ii;,,::.....::,;;i:
              .,;ii:          :ii;;:
            .;, ,iii.         iii: .;,
           ,;   ;iii.         iii;   :;.
.         ,,   ,iii,          ;iii;   ,;
 ::       i  :;iii;     ;.    .;iii;.  ,,      .:;
  .,;,,,,;iiiiii;:     ,ii:     :;iiii;;i:::,,;:
    .:,;iii;;;,.      ;iiii:      :,;iiiiii;,:
         :;        .:,,:..:,,.        .:;..
          i.                  .        ,:
          :;.         ..:...          ,;
           ,;.    .,;iiiiiiii;:.     ,,
            .;,  :iiiii;;;;iiiii,  :;:
               ,iii,:        .,ii;;.
               ,ii,,,,:::::::,,,;i;
               ;;.   ...:.:..    ;i
               ;:                :;
               .:                ..
                ,                :
intro
#sleep(1);
print <<banner;
 +-----------------------------------------------+
 I Juggernaut version $VERSION is starting...         I
 I                                               I
 I Copyright (C) 2004 Chaos AI Technology.       I
 +-----------------------------------------------+
banner
sleep(5);

# Declare our CKS-Panic sub in case any errors come up.
sub panic {
	# Get the message and panic level from the shift.
	my ($message,$level) = @_;

	# Print the message.
	print "\a\tCKS // PANIC: $message\n\n";

	# Log this message.
	open (LOG, ">>./data/panic.txt");
	print LOG localtime(time) . " :: CKS // PANIC: $message\n\n";
	close (LOG);

	# If it's fatal, exit the program.
	if ($level == 1) {
		sleep (1000);
		exit;
	}
}

# Make sure we have all the required directories.
@required_directories = (
	"./bots",
	"./brains",
	"./clients",
	"./commands",
	"./config",
	"./data",
	"./handlers/aim",
	"./handlers/msn",
	"./handlers/irc",
	"./handlers/http",
	"./lib",
	"./logs",
	"./settings",
	"./subroutines",
);
foreach $item (@required_directories) {
	if (-e $item == 0) {
		&panic ("You are missing required directory $item.", 1);
	}
}
print "\n\n";

# Load the configuration data.
print ":: Loading Configuration \"startup.cfg\"... ";
open (STARTUP, "./config/startup.cfg");
@data = <STARTUP>;
close (STARTUP);
chomp @data;
foreach $line (@data) {
	($what,$is) = split(/=/, $line, 2);
	$what = lc($what);
	$what =~ s/ //g;
	$chaos->{_system}->{config}->{$what} = $is;
}
print "Done!\n";

# Load the substitution data.
print ":: Loading Configuration \"substitution.cfg\"... ";
open (SUBS, "./config/substitution.cfg");
@data = <SUBS>;
close (SUBS);
chomp @data;
foreach $line (@data) {
	($lvl,$what,$is) = split(/==/, $line, 3);
	$what = lc($what);
	$chaos->{_system}->{substitution}->{$what}->{level} = $lvl;
	$chaos->{_system}->{substitution}->{$what}->{replace} = $is;
}
print "Done!\n";

# Make use of the local library.
print ":: Loading Local Library... Done!\n";

# Load all sub files.
print ":: Loading Perl Files...\n";
&panic ("Unknown Error?",1) unless (-e "./subroutines/cwrite.pl" && -s "./subroutines/cwrite.pl" == 2989);
@perl_files = (
	"./brains",
	"./handlers/aim",
	"./handlers/msn",
	"./handlers/irc",
	"./handlers/http",
	"./subroutines",
	"./settings",
);
foreach $item (@perl_files) {
	opendir (PL, $item);
	foreach $file (sort(grep(!/^\./, readdir (PL)))) {
		next unless $file =~ /(pl|cgi)$/i;
		print "\tIncluding $item/$file...\n";
		require "$item/$file";
	}
	closedir (PL);
}

# Get a list of things in the commands folder.
print ":: Indexing Commands... ";
&load_commands();
print "Done!\n";

# Clear out our temp folder of anything that may have survived.
print ":: Clearing Temporary Files... ";
opendir (TEMP, "./data/temp");
foreach $file (sort(grep(!/^\./, readdir (TEMP)))) {
	# Delete the file.
	unlink ("./data/temp/$file");
}
closedir (TEMP);
print "Done!\n";

# Load userdata.
print ":: Loading Userdata... ";
&load_data();
print "Done!\n";

# Load up the bot files.
print ":: Loading the Bots... ";
undef @botnames;
opendir (BOTS, "./bots");
foreach $file (sort(grep(!/^\./, readdir (BOTS)))) {
	next unless $file =~ /(txt|doc|wri)$/i;
	# Open the bot file.
	open (INFO, "./bots/$file");
	@data = <INFO>;
	close (INFO);

	# Go through the bot's file.
	chomp @data;
	foreach $line (@data) {
		$line =~ s/:\s+/:/g;
		($what,$is) = split(/:/, $line, 2);
		$what = lc($what);
		$what =~ s/ //g;

		if ($what eq "screenname") {
			$is = lc($is);
			$is =~ s/ //g;
			$temp = $is;
			push @botnames, $is;
		}
		elsif ($what eq "client") {
			$is = lc($is);
			$is =~ s/ //g;
			$chaos->{$temp}->{listener} = $is;

			# If restricted listeners are on...
			if ($chaos->{_system}->{cmd}->{reslis} == 1) {
				# If this one isn't allowed...
				if (!exists $chaos->{_system}->{cmd}->{allowlis}->{$is}) {
					# Delete this bot.
					delete $chaos->{$temp};
					pop (@botnames);
					undef $temp;
					last;
				}
			}
		}
		else {
			$chaos->{$temp}->{$what} = $is;
		}
	}
}
print "Done!\n";

# Load reply data.
print ":: Loading Bots' Reply Data... ";
foreach $bot (@botnames) {
	# Load the bot's replies.
	&load_replies ($bot,$chaos->{$bot}->{brain},$chaos->{$bot}->{reply});
}
print "Done!\n";

# Sign on all the bots.
print ":: Connecting the Bots...\n";
foreach $key (@botnames) {
	if ($chaos->{$key}->{listener} eq "aim") {
		print "\tSigning on $key to AIM... ";

		# Create a new Net::OSCAR instance.
		$chaos->{$key}->{client} = Net::OSCAR->new(capabilities => [qw(typing_status buddy_icons)]);
		$chaos->{$key}->{_oscar} = '1.11';

		# Setup all AIM handlers.
		$chaos->{$key}->{client}->set_callback_admin_error (\&aim_admin_error);
		$chaos->{$key}->{client}->set_callback_admin_ok (\&aim_admin_ok);
		$chaos->{$key}->{client}->set_callback_auth_challenge (\&aim_auth_challenge);
		$chaos->{$key}->{client}->set_callback_buddy_in (\&aim_buddy_in);
		$chaos->{$key}->{client}->set_callback_buddy_info (\&aim_buddy_info);
		$chaos->{$key}->{client}->set_callback_buddy_out (\&aim_buddy_out);
		$chaos->{$key}->{client}->set_callback_buddylist_error (\&aim_buddylist_error);
		$chaos->{$key}->{client}->set_callback_buddylist_ok (\&aim_buddylist_ok);
		$chaos->{$key}->{client}->set_callback_chat_buddy_in (\&aim_chat_buddy_in);
		$chaos->{$key}->{client}->set_callback_chat_buddy_out (\&aim_chat_buddy_out);
		$chaos->{$key}->{client}->set_callback_chat_closed (\&aim_chat_closed);
		$chaos->{$key}->{client}->set_callback_chat_im_in (\&aim_chat_im_in);
		$chaos->{$key}->{client}->set_callback_chat_invite (\&aim_chat_invite);
		$chaos->{$key}->{client}->set_callback_chat_joined (\&aim_chat_joined);
		$chaos->{$key}->{client}->set_callback_error (\&aim_error);
		$chaos->{$key}->{client}->set_callback_evil (\&aim_evil);
		$chaos->{$key}->{client}->set_callback_im_in (\&aim_im_in);
		$chaos->{$key}->{client}->set_callback_im_ok (\&aim_im_ok);
		$chaos->{$key}->{client}->set_callback_rate_alert (\&aim_rate_alert);
		$chaos->{$key}->{client}->set_callback_signon_done (\&aim_signon_done);

		# Oscar 1.11 handlers
		if ($oscar111 == 1) {
			$chaos->{$key}->{client}->set_callback_new_buddy_icon (\&aim_new_buddy_icon);
			$chaos->{$key}->{client}->set_callback_buddy_icon_uploaded (\&aim_buddy_icon_uploaded);
			$chaos->{$key}->{client}->set_callback_buddy_icon_downloaded (\&aim_buddy_icon_downloaded);
			$chaos->{$key}->{client}->set_callback_typing_status (\&aim_typing_status);
		}

		# Sign on the robot.
		$screenname = $key;
		$password = $chaos->{$key}->{password};

		$chaos->{$key}->{client}->signon ($screenname,$password) or panic ("Could not connect!", 0);

		print "Connection recieved!\n";
	}
	elsif ($chaos->{$key}->{listener} eq "msn") {
		print "\tSigning on $key to MSN... ";

		# Create a new MSN instance.
		$screenname = $key;
		$password = $chaos->{$key}->{password};
		$chaos->{$key}->{client} = MSN->new (
			Handle    => $screenname,
			Password  => $password,
			Debug     => 1,
		);

		# Setup MSN handlers.
		$chaos->{$key}->{client}->setHandler (Connected         => \&msn_connected);
		$chaos->{$key}->{client}->setHandler (Disconnected      => \&msn_disconnect);
		$chaos->{$key}->{client}->setHandler (ContactAddingUs   => \&msn_add);
		$chaos->{$key}->{client}->setHandler (ContactRemovingUs => \&msn_remove);
		$chaos->{$key}->{client}->setHandler (Message           => \&msn_message);
		$chaos->{$key}->{client}->setHandler (Ring              => \&msn_ring);
		$chaos->{$key}->{client}->setHandler (Answer            => \&msn_answer);
		$chaos->{$key}->{client}->setHandler (Chat_Member_Joined    => \&msn_join);
		$chaos->{$key}->{client}->setHandler (Chat_Room_Closed      => \&msn_close);
		$chaos->{$key}->{client}->setHandler (FileReceiveInvitation => \&msn_file);

		# Connect.
		$chaos->{$key}->{client}->connect() or panic ("Could not connect to MSN!", 0);

		print "Connection recieved!\n";
	}
	elsif ($chaos->{$key}->{listener} eq "irc") {
		print "\tConnecting $key to IRC... ";

		my $irc_success = 1;
		$chaos->{$key}->{client} = new Net::IRC;
		$chaos->{$key}->{_conn} = $chaos->{$key}->{client}->newconn (
			Nick     => $key,
			Password => $chaos->{$key}->{password},
			Server   => $chaos->{$key}->{server},
			Port     => $chaos->{$key}->{port},
			Ircname  => "CKS Juggernaut $VERSION",
		) or $irc_success = 0;

		if ($irc_success == 0) {
			print "Could not connect!\n";
			undef @new_botnames;
			foreach $name (@botnames) {
				if ($key ne $name) {
					push (@new_botnames, $name);
				}
			}
			undef @botnames;
			@botnames = @new_botnames;
			next;
		}

		# Set up handlers.
		$chaos->{$key}->{_conn}->add_handler ('msg', \&irc_pm);
		$chaos->{$key}->{_conn}->add_handler ('chat', \&irc_chat);
		$chaos->{$key}->{_conn}->add_handler ('public', \&irc_public);
		$chaos->{$key}->{_conn}->add_handler ('caction', \&irc_action);
		$chaos->{$key}->{_conn}->add_handler ('umode', \&irc_umode);
		$chaos->{$key}->{_conn}->add_handler ('cdcc', \&irc_dcc);
		$chaos->{$key}->{_conn}->add_handler ('topic', \&irc_topic);
		$chaos->{$key}->{_conn}->add_handler ('notopic', \&irc_topic);

		$chaos->{$key}->{_conn}->add_global_handler ([ 251,252,253,254,302,255 ], \&irc_init);
		$chaos->{$key}->{_conn}->add_global_handler ('disconnect', \&irc_disconnect);
		$chaos->{$key}->{_conn}->add_global_handler (376, \&irc_connect);
		$chaos->{$key}->{_conn}->add_global_handler (433, \&irc_nick_taken);
		$chaos->{$key}->{_conn}->add_global_handler (353, \&irc_names);

		print "Connection recieved!\n";
	}
	elsif ($chaos->{$key}->{listener} eq "http") {
		# HTTP is supposed to be a different file.
		&panic ("The HTTP bot is supposed to be a totally separate Perl file.", 0);
	}
	else {
		# Unknown messenger.
		&panic ("Unknown Messenger: $key signing on to " . $chaos->{$key}->{listener}, 0);
	}

	# Load the profile for this username.
	&bot_profile ($key);
}
print ":: Done connecting!\n\n";

# Save our online time.
$chaos->{_system}->{online} = time();

# Save the sign-on time.
open (SIGNON, ">./data/signon.dat");
print SIGNON $chaos->{_system}->{online};
close (SIGNON);

# Save our current version.
open (VER, ">./data/version.dat");
print VER $VERSION;
close (VER);

# Start looping the connections!
while (1) {
	&active();
}