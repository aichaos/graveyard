#!/usr/bin/perl

# ChaosBot Setup File

# Use LWP::Simple for text files.
use LWP::Simple;

%config;

main:

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
	. "I Chaos AI Technology                            I\n"
	. "I                          AUTHOR: Cerone Kirsle I\n"
	. "+------------------------------------------------+\n\n");
print "== CONFIGURATION OPTIONS\n";
print "\t[1]    server = $config{'server'}\n";
print "\t\tThe CKS server URL.\n";
print "\t[2]    backup = $config{'backup'}\n";
print "\t\tThe backup server.\n";
print "\t[3]        ad = $config{'ad'}\n";
print "\t\tThe advertisement code.\n";
print "\t[4]  sendlist = $config{'sendlist'}\n";
print "\t\tOption is to update the buddy list with OSCAR (AIM).\n\n";
print "\t[5]  Exit this program.\n";
print "CKS> ";
$command = <STDIN>;
chomp $command;

if ($command == 1) {
	print "\n\n";
	print "Enter the new server URL or leave blank to cancel.\n";
	print "Server> ";
	$command = <STDIN>;
	chomp $command;

	print "\n\n";

	if ($command eq "") {
		goto main;
	}
	else {
		saveIt("server",$command);
	}
}
elsif ($command == 2) {
	print "\n\n";
	print "Enter the new backup server or leave blank to cancel.\n";
	print "Backup Server> ";
	$command = <STDIN>;
	chomp $command;

	print "\n\n";

	if ($command eq "") {
		goto main;
	}
	else {
		saveIt("backup",$command);
	}
}
elsif ($command == 3) {
	print "\n\n";
	print "Enter the number of the advertisement you want:\n\n";
	print "\t[1] Built using [Chaos AI Technology] bot software.\n";
	print "\t[2] Please visit [Chaos AI Technology]!\n";
	print "\t[3] Check out [http://chaos.kirsle.net/]!\n";
	print "\t[4] Get your own [ChaosBot]!\n";
	print "\t[6] (no advertisement)\n";
	print "Note: Text in brackets will be a hyperlink.\n";
	print "Ad Code (blank to cancel)> ";
	$command = <STDIN>;
	chomp $command;

	print "\n\n";

	if ($command eq "") {
		goto main;
	}
	elsif ($command == 1) {
		saveIt("ad","20569510");
	}
	elsif ($command == 2) {
		saveIt("ad","83289525");
	}
	elsif ($command == 3) {
		saveIt("ad","75265854");
	}
	elsif ($command == 4) {
		saveIt("ad","24885320");
	}
	elsif ($command == 5) {
		print "\n\n";
		print "For more information about this feature, please\n";
		print "visit http://programs.chaos.kirsle.net/\n\n";
		sleep(10);
		goto main;
	}
	else {
		goto main;
	}
}
elsif ($command == 4) {
	print "\n\n";
	print "This option enables you to send your bot's buddy list to the \n";
	print "OSCAR server to be kept permanent. Possible values are 0 or 1.\n";
	print "Leave blank to cancel.\n";
	print "Sendlist> ";
	$command = <STDIN>;
	chomp $command;

	print "\n\n";

	if ($command eq "") {
		goto main;
	}
	elsif ($command == 1) {
		saveIt("sendlist","1");
	}
	elsif ($command == 0) {
		saveIt("sendlist","0");
	}
	else {
		goto main;
	}
}
elsif ($command == 5) {
	exit;
}
else {
	goto main;
}

sub saveIt {
	my ($var,$value) = @_;

	my %config;

	# Load the configuration data.
	open (CONFIG, "config/startup.cfg");
	my @config = <CONFIG>;
	close (CONFIG);
	foreach $line (@config) {
		chomp $line;
		($what,$is) = split(/=/, $line);
		$config{$what} = $is;
	}

	$config{$var} = $value;

	# Save over the file.
	open (NEW, ">config/startup.cfg");
	print NEW ("\# Chaos AI Technology Configuration\n"
		. "server=$config{'server'}\n"
		. "backup=$config{'backup'}\n"
		. "ad=$config{'ad'}\n"
		. "sendlist=$config{'sendlist'}");
	close (NEW);

	goto main;
}