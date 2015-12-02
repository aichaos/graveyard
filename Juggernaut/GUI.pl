#!/usr/bin/perl

# CKS Juggernaut Graphical User Interface
#
# This code was written entirely by Cerone Kirsle. Do NOT copy and paste
# this into a different bot template without giving me proper credits. I
# spent the greater part of 24 hours working on this file, so show a little
# respect and credit me if you want to convert this to a different template.
#
# By doing so, I expect you to keep the copyright notice (below)
# completely intact.

#    CKS Juggernaut Graphical User Interface
#    Copyright (C) 2004 Cerone Kirsle
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

# And yes, even if you do use it in a different template, you have to keep
# the "CKS Juggernaut Graphical User Interface" in the credit. Even though
# the third party template is not called CKS Juggernaut, the graphical user
# interface used was original taken from Juggernaut and would therefore have
# to be included in the credits.
# The entire GPL message in the block above has to be in this file at all times,
# so if you use this code on a different template the message must stay there
# completely intact and unedited.
# ~Cerone Kirsle <kirsle@chaos.kirsle.net>

# Requires Perl 5.8 or higher.
require 5.8.00;

$bots_running = 0;

$VERSION = "3.6";

# All the Tk modules.
use Tk;
use Tk::DialogBox;
use Tk::Entry;
use Tk::Label;
use Tk::Scrollbar;
use Tk::Text;
use Tk::Notebook;
use Tk::LabEntry;
use Tk::ROText;
use Tk::Menu;
use Tk::Frame;
use Tk::DialogBox;
use Tk::Menubutton;
use Tk::Button;
use Tk::Radiobutton;
use Tk::BrowseEntry;
use File::Glob;
use File::Find;
use FileHandle;
use LWP::Simple;

# Declare our CKS-Panic sub in case any errors come up.
sub panic {
	# Get the message and panic level from the shift.
	my ($message,$level) = @_;

	# Print the message.
	print "\tCKS // PANIC: $message\n\n";

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

# Load the GUI config file.
open (CFG, "./config/gui.cfg");
@data = <CFG>;
close (CFG);
chomp @data;
foreach $line (@data) {
	($what,$is) = split(/=/, $line, 2);
	$what = lc($what);
	$what =~ s/ //g;

	$gui->{$what} = $is;
}

$main = MainWindow->new (
	-title => 'CKS Juggernaut',
	-takefocus => 1,
);
$main->geometry ("640x480");

$icon = $main->Photo (-file => "icon.bmp");
$main->Icon (-image => $icon);

# The menu bar frame.
$menubar = $main->Frame()->pack (
	-side => "top",
	-fill => "x",
);

# Dialog Boxes
$about = $main->DialogBox (-title => "About CKS Juggernaut", -buttons => ["OK", "Website"]);
$about_left = $about->Frame()->pack (
	-side => "left",
	-fill => "y",
);
$about_logo = $about_left->Scrolled (
	ROText,
	-width => '16',
	-height => '7',
	-scrollbars => '',
	-background => '#000000',
	-foreground => '#00FF00',
	-wrap => 'none',
	-font => [
		-family => 'Courier New',
		-size => '10',
	],
	)->pack (-fill => 'both', -expand => 1);
$about_logo->delete ('1.0', 'end');
$about_logo->insert ('end', "      .   .\n");
$about_logo->insert ('end', "     .:...::\n");
$about_logo->insert ('end', "    .::   ::.\n");
$about_logo->insert ('end', " ..:;;. ' .;;:..\n");
$about_logo->insert ('end', "    .  '''  .\n");
$about_logo->insert ('end', "     :;,:,;:\n");
$about_logo->insert ('end', "     :     :\n\n");
$about_logo->insert ('end', " CKS Juggernaut");
$about_a = $about->add ("Label", -text => "CKS Juggernaut: Intelligent Chatterbot Entity",
	-font => [
		-family => 'Arial',
		-size => '12',
		-weight => 'bold',
	],
	-foreground => '#FF0000',
)->pack;
$about_b = $about->add ("Label", -text => "Copyright (C) 2004 Cerone Kirsle",
	-font => [
		-family => 'Verdana',
		-size => '9',
		-weight => 'bold',
	],
	-foreground => '#0000FF',
)->pack;
$about_c = $about->add ("Label",
	-text => "This program is free software; you may redistribute it and/or modify\n"
		. "it under the terms of the GNU General Public License as published by\n"
		. "the Free Software Foundation; either version 2 of the License, or\n"
		. "(at your option) any later version.\n\n"
		. "This program is distributed in the hope that it will be useful,\n"
		. "but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
		. "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\n"
		. "GNU General Public License for more details.\n\n"
		. "You should have received a copy of the GNU General Public License\n"
		. "along with this program; if not, write to the Free Software\n"
		. "Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA",
	-font => [
		-family => 'Verdana',
		-size => '9',
	],
)->pack;
$runerr = $main->DialogBox (-title => "ERROR", -buttons => ["OK"]);
$runerr_a = $runerr->add ("Label", -text => "There is already an instance of CKS Juggernaut running.\n\n"
	. "If you wish to restart the bot, send it a command\n"
	. "such as !shutdown or !perl exit;")->pack;
$killerr = $main->DialogBox (-title => "ERROR", -buttons => ["OK"]);
$killerr_a = $killerr->add ("Label", -text => "You cannot shut the bots down, because they are not currently running.\n\n"
	. "Select \"Start CKS Juggernaut\" from the FILE menu to start the bots.")->pack;

# Global menu font.
$gfont = " -family => 'Arial', -size => '6' ";

# Build the menu.
$filemenu = $menubar->Menubutton (
	-text => 'File',
	-underline => 0,
	-tearoff => 0,
	)->pack (-side => 'left');

	$filemenu->command (-label => 'Start CKS Juggernaut', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		if ($bots_running == 0) {
			$bots_running = 1;
			&run_bots();
		}
		else {
			$runerr->Show;
		}
	});

	$filemenu->command (-label => 'Kill Bots', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		if ($bots_running == 1) {
			# Kill the bots.
			print "Killing the bots!\n";
			foreach $bot (@botnames) {
				$chaos->{$bot}->{client} = undef;
			}

			@botnames = undef;

			$bot_loops = 0;

			$bots_running = 0;

			$status->delete ('1.0', 'end');
			$status->insert ('end', "Bot Processes Terminated :: "
				. "Copyright © 2004 Chaos AI Technology");
		}
		else {
			$killerr->Show;
		}
	});

	$filemenu->separator;

	$filemenu->command (-label => 'Clear Logs', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		$text->delete ('1.0', 'end');
	});

	$filemenu->command (-label => 'Delete Logs', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		opendir (LOGS, "./logs");
		foreach $file (sort(grep(!/^\./, readdir (LOGS)))) {
			if ($file =~ /\.txt$/i) {
				unlink ("./logs/$file");
			}
		}
		closedir (LOGS);
	});

	$filemenu->command (-label => 'Save Logs As...', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		$types = [['Text Files', '*.txt', ]];
		$save = $main->getSaveFile (-filetypes => $types);
		$data = $text->get ('1.0','end');
		open (FILE, ">$save");
		print FILE $data;
		close (FILE);
		$open = $save;
	});

	$filemenu->separator;

	$filemenu->command (-label => 'Exit', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		exit (0);
	});
$editmenu = $menubar->Menubutton (
	-text => 'Edit',
	-underline => 0,
	-tearoff => 0,
	)->pack (-side=>'left');

	$editmenu->command (-label => 'Copy', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		my ($w) = @_;
		$text->Column_Copy_or_Cut(0);
	});

	$editmenu->command (-label => 'Select All', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		$text->selectAll();
	});

	$editmenu->command (-label => 'Unselect All', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		$text->unselectAll();
	});

	$editmenu->separator;

	$editmenu->command (-label => 'Goto Line', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		$text->GotoLineNumberPopUp();
	});
$searchmenu = $menubar->Menubutton (
	-text => 'Search',
	-underline => 0,
	-tearoff => 0,
	)->pack (-side => 'left');

	$searchmenu->command (-label => 'Find', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		$text->findandreplacepopup(1);
	});
$wizmenu = $menubar->Menubutton (
	-text => 'Wizards',
	-underline => 0,
	-tearoff => 0,
	)->pack (-side => 'left');

	$wizmenu->command (-label => 'Bot Data...', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		$bd = $main->DialogBox (-title => "Bot Data", -buttons => ["OK", "Add Bot", "Remove", "Cancel"]);
		$bd->geometry ("500x480");
		$bd_tab = $bd->NoteBook ()->pack (-expand => 1, -fill => 'both');

		my %tabs;
		my %rowz;

		# Open bots folder.
		opendir (BOTS, "./bots");
		foreach $file (sort(grep(!/^\./, readdir(BOTS)))) {
			if ($file =~ /\.txt$/i) {
				$bd_x_a = 0;
				$bd_x_b = 150;
				$bd_y_a = 0;
				$bd_y_b = 0;

				$file =~ s/\.txt$//ig;

				$rowz{$file} = $main->Frame()->pack (-side => 'top',-fill => 'x');

				# Create a new tab.
				$tabs{$file} = $bd_tab->add ($file, -label => "$file");

				open (FILE, "./bots/$file\.txt");
				@data = <FILE>;
				close (FILE);
				chomp @data;

				my @botlines;

				foreach $line (@data) {
					next if $line =~ /^\#/;
					next if length $line == 0;
					$line =~ s/:\s+/:/g;
					($what,$is) = split(/:/, $line, 2);

					$bd_bots->{$file}->{$what} = $is;
					push (@botlines, $what);
				}

				$bdlines->{$file} = join ("\n", @botlines);

				foreach $key (@botlines) {
					$tobelabel = ucfirst($key);
					$tabs{$file}->Label (
						-text => "$tobelabel",
						-width => 25,
						-font => [
							-family => 'Verdana',
							-size => '8',
						],
					)->place (-x => $bd_x_a, -y => $bd_y_a);
					$tabs{$file}->LabEntry (
						-width => '30',
						-relief => 'sunken',
						-background => '#FFFFFF',
						-foreground => '#000000',
						-font => [
							-family => 'Verdana',
							-size => '8',
						],
						-textvariable => \$bd_bots->{$file}->{$key},
					)->place (-x => $bd_x_b, -y => $bd_y_b);

					$bd_y_a += 25;
					$bd_y_b += 25;
				}
			}
		}

		# Show the dialog.
		$result = $bd->Show();
		if ($result =~ /ok/i) {
			# Save the data.
			foreach $file (keys %tabs) {
				@tosend = split (/\n/, $bdlines->{$file});
				my @in;
				foreach $send (@tosend) {
					push (@in,"$send: $bd_bots->{$file}->{$send}");
				}
				open (FILE, ">./bots/$file\.txt");
				print FILE join ("\n", @in);
				close (FILE);
			}
		}
		elsif ($result =~ /remove/i) {
			# Remove a Bot.
			$bd->destroy();
			$rembot = $main->DialogBox (-title => 'Remove Bot?', -buttons => ["OK", "Cancel"]);
			$rembot->geometry ("450x90");
			$rembot_a = $rembot->Label (
				-text => "Enter the file name of the bot to delete:",
				-font => [
					-family => 'Verdana',
					-size => '8',
				],
			)->pack;
			$rembot_b = $rembot->LabEntry (
				-width => 30,
				-relief => 'sunken',
				-background => '#FFFFFF',
				-foreground => '#000000',
				-font => [
					-family => 'Verdana',
					-size => '8',
				],
				-textvariable => \$rembot_file,
			)->pack;

			$remresult = $rembot->Show();
			if ($remresult =~ /ok/i) {
				$rembot_file .= '.txt' unless $rembot_file =~ /\.txt$/i;
				unlink ("./bots/$rembot_file");
			}
		}
		elsif ($result =~ /add/i) {
			# Add New Bot.
			$bd->destroy();
			$addbot = $main->DialogBox (-title => 'Add New Bot', -buttons => ["AIM", "MSN", "IRC", "Cancel"]);
			$addbot->geometry ("450x90");
			$addbot_a = $addbot->Label (
				-text => "File Name:",
				-width => 25,
				-font => [
					-family => 'Verdana',
					-size => '8',
				],
			)->place (-x => 0, -y => 0);
			$addbot_file = 'New Bot.txt';
			$addbot_b = $addbot->LabEntry (
				-width => 30,
				-relief => 'sunken',
				-background => '#FFFFFF',
				-foreground => '#000000',
				-font => [
					-family => 'Verdana',
					-size => '8',
				],
				-textvariable => \$addbot_file,
			)->place (-x => 150, -y => 0);
			$addbot_c = $addbot->Label (
				-text => "Click the button below for the\nmessenger you want to create a bot for.",
				-width => '50',
				-font => [
					-family => 'Verdana',
					-size => '8',
				],
			)->place (-x => 25, -y => 25);

			$addresult = $addbot->Show();
			if ($addresult =~ /aim/i) {
				$addbot->destroy();

				$addbot_file .= '.txt' unless $addbot_file =~ /\.txt$/i;

				$addnew = $main->DialogBox (-title => 'Add an AIM Bot', -buttons => ["OK"]);
				if (-e "./bots/$addbot_file") {
					$addnew_a = $addnew->Label (
						-text => "ERROR: A bot with that file name already exists!",
						-foreground => '#FF0000',
						-font => [
							-family => 'Verdana',
							-size => '8',
							-weight => 'bold',
						],
					)->pack;
				}
				else {
					# Create new bot file.
					open (NEW, ">./bots/$addbot_file");
					print NEW "ScreenName: SampleAIM\n"
						. "Password: bigsecret\n"
						. "Auto Reconnect: 1\n"
						. "Client: AIM\n"
						. "Brain: ChaosML\n"
						. "Reply: ./replies/cml/standard\n"
						. "Data: ./data/profiles/Juggernaut.txt\n"
						. "Format: SampleAIM\n"
						. "Profile: ./data/aim/profiles/Juggernaut.html\n"
						. "Icon: ./data/aim/icons/vortex.jpg\n"
						. "Buddies: ./data/aim/buddies/Juggernaut.txt\n"
						. "Chats: ./data/aim/chats/Juggernaut.txt\n"
						. "Chat Triggers: ./data/aim/triggers/Juggernaut.txt\n"
						. "Font: ./data/aim/fonts/Juggernaut.txt";
					close (NEW);

					$addnew_a = $addnew->Label (
						-text => "Your AIM bot has been generated.\n\n"
							. "Reselect \"Bot Data\" from the Wizards menu\n"
							. "to set up your new bot.",
						-font => [
							-family => 'Verdana',
							-size => '8',
						],
					)->pack;
				}
			}
			elsif ($addresult =~ /msn/i) {
				$addbot->destroy();

				$addbot_file .= '.txt' unless $addbot_file =~ /\.txt$/i;

				$addnew = $main->DialogBox (-title => 'Add an MSN Bot', -buttons => ["OK"]);
				if (-e "./bots/$addbot_file") {
					$addnew_a = $addnew->Label (
						-text => "ERROR: A bot with that file name already exists!",
						-foreground => '#FF0000',
						-font => [
							-family => 'Verdana',
							-size => '8',
							-weight => 'bold',
						],
					)->pack;
				}
				else {
					# Create new bot file.
					open (NEW, ">./bots/$addbot_file");
					print NEW "ScreenName: sample\@msn.com\n"
						. "Password: bigsecret\n"
						. "Client: MSN\n"
						. "Brain: ChaosML\n"
						. "Reply: ./replies/cml/standard\n"
						. "Nick: Juggernaut\n"
						. "WelcomeMsg: ./data/msn/welcome/Juggernaut.txt\n"
						. "DisplayPic: ./data/msn/dp/Juggernaut.png\n"
						. "Emoticons: ./data/msn/emo/Juggernaut.txt\n"
						. "Data: ./data/profiles/Juggernaut.txt\n"
						. "Font: ./data/msn/fonts/Juggernaut.txt";
					close (NEW);

					$addnew_a = $addnew->Label (
						-text => "Your MSN bot has been generated.\n\n"
							. "Reselect \"Bot Data\" from the Wizards menu\n"
							. "to set up your new bot.",
						-font => [
							-family => 'Verdana',
							-size => '8',
						],
					)->pack;
				}
			}
			elsif ($addresult =~ /irc/i) {
				$addbot->destroy();

				$addbot_file .= '.txt' unless $addbot_file =~ /\.txt$/i;

				$addnew = $main->DialogBox (-title => 'Add an IRC Bot', -buttons => ["OK"]);
				if (-e "./bots/$addbot_file") {
					$addnew_a = $addnew->Label (
						-text => "ERROR: A bot with that file name already exists!",
						-foreground => '#FF0000',
						-font => [
							-family => 'Verdana',
							-size => '8',
							-weight => 'bold',
						],
					)->pack;
				}
				else {
					# Create new bot file.
					open (NEW, ">./bots/$addbot_file");
					print NEW "ScreenName: Juggernaut\n"
						. "Password: optional\n"
						. "Client: IRC\n"
						. "Server: irc.domain.com\n"
						. "Port: 6667\n"
						. "Channel: #lobby\n"
						. "Brain: ChaosML\n"
						. "Reply: ./replies/cml/standard\n"
						. "Data: ./data/profiles/Juggernaut.txt";
					close (NEW);

					$addnew_a = $addnew->Label (
						-text => "Your IRC bot has been generated.\n\n"
							. "Reselect \"Bot Data\" from the Wizards menu\n"
							. "to set up your new bot.",
						-font => [
							-family => 'Verdana',
							-size => '8',
						],
					)->pack;
				}
			}
		}
	});

	$wizmenu->command (-label => 'GUI Colors...', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		$colors = $main->DialogBox (-title => "Setup GUI Colors", -buttons => ["Cancel"]);
		$colors_a = $colors->add ("Label",
			-text => "General Colors",
			-foreground => '#0000FF',
			-font => [-weight => 'bold', -family => 'Arial', -size => '12'],
		)->pack;

		$colors_b = $colors->add ("Label", -text => "Main Background")->pack;
		$colors_1 = $colors->LabEntry (
			-width => '20',
			-relief => 'sunken',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-textvariable => \$gui->{background},
		)->pack;

		$colors_c = $colors->add ("Label", -text => "Main Font")->pack;
		$colors_2 = $colors->LabEntry (
			-width => '20',
			-relief => 'sunken',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-textvariable => \$gui->{fontface},
		)->pack;

		$colors_d = $colors->add ("Label", -text => "Main Color")->pack;
		$colors_3 = $colors->LabEntry (
			-width => '20',
			-relief => 'sunken',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-textvariable => \$gui->{fontcolor},
		)->pack;

		$colors_e = $colors->add ("Label",
			-text => "Status Bar Colors",
			-foreground => '#0000FF',
			-font => [-weight => 'bold', -family => 'Arial', -size => '12'],
		)->pack;

		$colors_f = $colors->add ("Label", -text => "Status Background")->pack;
		$colors_4 = $colors->LabEntry (
			-width => '20',
			-relief => 'sunken',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-textvariable => \$gui->{statusbg},
		)->pack;

		$colors_g = $colors->add ("Label", -text => "Status Font")->pack;
		$colors_5 = $colors->LabEntry (
			-width => '20',
			-relief => 'sunken',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-textvariable => \$gui->{statusfont},
		)->pack;

		$colors_h = $colors->add ("Label", -text => "Status Color")->pack;
		$colors_6 = $colors->LabEntry (
			-width => '20',
			-relief => 'sunken',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-textvariable => \$gui->{statuscolor},
		)->pack;

		$colors_i = $colors->Button (
			-text => "Save Changes",
			-relief => 'raised',
			-command => sub {
				open (NEW, ">./config/gui.cfg");
				print NEW "Background=$gui->{background}\n"
					. "Font Face=$gui->{fontface}\n"
					. "Font Color=$gui->{fontcolor}\n"
					. "Status BG=$gui->{statusbg}\n"
					. "Status Font=$gui->{statusfont}\n"
					. "Status Color=$gui->{statuscolor}";
				close (NEW);

				$text->configure (
					-background => $gui->{background},
					-foreground => $gui->{fontcolor},
					-font => [
						-face => $gui->{fontface},
						-size => '10',
					],
				);
				$status->configure (
					-background => $gui->{statusbg},
					-foreground => $gui->{statuscolor},
					-font => [
						-face => $gui->{statusfont},
						-size => '10',
					],
				);

				$colors->destroy();
			},
		)->pack;

		$colors->Show;
	});

	$wizmenu->separator;

	$wizmenu->command (-label => 'Startup Config', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		# Open the config file.
		open (CFG, "./config/startup.cfg");
		@data = <CFG>;
		close (CFG);

		chomp @data;

		foreach $line (@data) {
			($what,$is) = split(/=/, $line, 2);
			$what = lc($what);
			$what =~ s/ //g;

			$startup->{$what} = $is;
		}

		$startcfg = $main->DialogBox (-title => 'Startup Config Data', -buttons => ["OK", "Cancel"]);

		$start_t = $startcfg->add ("Label",
			-text => "These are the configuration data loaded when your bot first connects, "
				. "and (under\n" . "normal circumstances) are not reloaded later, hence "
				. "the name \"startup.cfg\".\n\n")->pack;

		$start_a = $startcfg->LabEntry (
			-label => 'Command Character:',
			-width => 1,
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-background => '#FFFFFF',
			-foreground => '#000000',
			-textvariable => \$startup->{commandchar},
		)->pack;

		$start_g = $startcfg->LabEntry (
			-label => 'Google API Key:',
			-width => 30,
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-background => '#FFFFFF',
			-foreground => '#000000',
			-textvariable => \$startup->{googlekey},
		)->pack;

		$start_b = $startcfg->LabEntry (
			-label => 'E-Mail Server:',
			-width => 30,
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-background => '#FFFFFF',
			-foreground => '#000000',
			-textvariable => \$startup->{emailserver},
		)->pack;

		$start_c = $startcfg->LabEntry (
			-label => 'E-Mail From: Name:',
			-width => 30,
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-background => '#FFFFFF',
			-foreground => '#000000',
			-textvariable => \$startup->{emailfrom},
		)->pack;

		$start_d = $startcfg->LabEntry (
			-label => 'E-Mail Subject:',
			-width => 30,
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-background => '#FFFFFF',
			-foreground => '#000000',
			-textvariable => \$startup->{emailsubject},
		)->pack;

		$start_e = $startcfg->LabEntry (
			-label => 'E-Mail Bot Name:',
			-width => 30,
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-background => '#FFFFFF',
			-foreground => '#000000',
			-textvariable => \$startup->{emailname},
		)->pack;

		$start_f = $startcfg->Checkbutton (
			-text => 'MSN Chat Allowed?',
			-variable => \$startup->{msnchatallowed},
		)->pack;

		$result = $startcfg->Show;
		if ($result =~ /ok/i) {
			open (NEW, ">./config/startup.cfg");
			print NEW "Command Char=$startup->{commandchar}\n"
				. "Google Key=$startup->{googlekey}\n"
				. "Email Server=$startup->{emailserver}\n"
				. "Email From=$startup->{emailfrom}\n"
				. "Email Subject=$startup->{emailsubject}\n"
				. "Email Name=$startup->{emailname}\n"
				. "MSN Chat Allowed=$startup->{msnchatallowed}";
			close (NEW);
		}
	});

	$wizmenu->command (-label => 'Substitutions', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		open (SUBS, "./config/substitution.cfg");
		@data = <SUBS>;
		close (SUBS);

		chomp @data;

		$sublist = "";
		foreach $line (@data) {
			$sublist .= "$line\n";
		}

		$subs = $main->DialogBox (-title => "Substitutions", -buttons => ["Close"]);

		$subs_t = $subs->add ("Label",
			-text => "This is your bot's substitution data. The format is:",
		)->pack;
		$subs_t1 = $subs->add ("Label",
			-text => "level==before==after",
			-font => [ -family => 'Verdana', -size => '10', -weight => 'bold' ],
		)->pack;
		$subs_t2 = $subs->add ("Label",
			-text => "If LEVEL is 1, the word will only be substituted if it is alone in a\n"
				. "message. If 0, it will be substituted regardless of where it is.\n",
		)->pack;

		$subs_1 = $subs->Scrolled (
			Text,
			-width => 20,
			-height => 10,
			-scrollbars => 'se',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-font => [
				-family => 'Verdana',
				-size => '10',
			],
		)->pack (-side => 'top', -fill => 'both', -expand => 1);

		$subs_1->delete ('1.0', 'end');
		$subs_1->insert ('end', $sublist);

		$subs_a = $subs->Button (
			-text => "Save Changes",
			-relief => 'raised',
			-command => sub {

				open (NEW, ">./config/substitution.cfg");
				print NEW $subs_1->get ('1.0', 'end');
				close (NEW);

				$subs->destroy();
			},
		)->pack;

		$subs->Show;
	});
$toolsmenu = $menubar->Menubutton (
	-text => 'Tools',
	-underline => 0,
	-tearoff => 0,
	)->pack (-side => 'left');

	$toolsmenu->command (-label => 'Send IM', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		# Bots must be running.
		if ($bots_running == 1) {
			undef @sendim_bots;
			foreach $key (keys %{$chaos}) {
				if (exists $chaos->{$key}->{listener} && exists $chaos->{$key}->{client}) {
					push (@sendim_bots, $key);
				}
			}
			$sendim = $main->DialogBox (-title => "Send IM", -buttons => ["Send", "Close"]);
			$sendim->geometry ("320x100");
			$sendim_a = $sendim->Label (
				-text => "From:",
				-font => [
					-family => 'Verdana',
					-size   => '8',
					-weight => 'bold',
				],
			)->place (-x => 0, -y => 0);
			$sendim_b = $sendim->BrowseEntry (
				-width => 28,
				-variable => \$sendim_from,
				-choices  => \@sendim_bots,
				-state    => 'readonly',
				-font => [
					-family => 'Verdana',
					-size => 8,
				],
				-background => '#FFFFFF',
				-foreground => '#000000',
			)->place (-x => 100, -y => 0);
			$sendim_c = $sendim->Label (
				-text => "To:",
				-font => [
					-family => 'Verdana',
					-size   => '8',
					-weight => 'bold',
				],
			)->place (-x => 0, -y => 25);
			$sendim_d = $sendim->LabEntry (
				-width => 30,
				-relief => 'sunken',
				-background => '#FFFFFF',
				-foreground => '#000000',
				-font => [
					-family => 'Verdana',
					-size => 8,
				],
				-textvariable => \$sendim_to,
			)->place (-x => 100, -y => 25);
			$sendim_mess = $sendim->LabEntry (
				-width => 44,
				-relief => 'sunken',
				-background => '#FFFFFF',
				-foreground => '#000000',
				-font => [
					-family => 'Verdana',
					-size => 8,
				],
				-textvariable => \$sendim_msg,
			)->place (-x => 0, -y => 50);

			$result = $sendim->Show;

			# Sending?
			if ($result =~ /send/i) {
				$sendim->destroy();

				# See if the bot exists.
				if (exists $chaos->{$sendim_from}->{listener}) {
					# Send the message.
					if ($chaos->{$sendim_from}->{listener} eq 'aim') {
						# Get the font.
						$sendim_font = get_font ($sendim_from,'AIM');

						# Send the message.
						$chaos->{$sendim_from}->{client}->send_im ($sendim_to,
							$sendim_font . $sendim_msg);

						# Show success dialog.
						$sendim = $main->DialogBox (-title => 'Send IM Success!', -buttons => ["OK"]);
						$sendim->geometry ("300x50");
						$sendim_a = $sendim->add ("Label",
							-text => "The message was sent successfully.",
							-font => [
								-family => 'Verdana',
								-size => 8,
								-weight => 'bold',
							],
						)->pack;
						$sendim->Show;
					}
					elsif ($chaos->{$sendim_from}->{listener} eq 'msn') {
						# Send the message.
						$chaos->{$sendim_from}->{client}->call ($sendim_to, $sendim_msg);

						# Show success dialog.
						$sendim = $main->DialogBox (-title => 'Send IM Success!', -buttons => ["OK"]);
						$sendim->geometry ("300x50");
						$sendim_a = $sendim->add ("Label",
							-text => "The message was sent successfully.",
							-font => [
								-family => 'Verdana',
								-size => 8,
								-weight => 'bold',
							],
						)->pack;
						$sendim->Show;
					}
					else {
						# Show error dialog.
						$sendim = $main->DialogBox (-title => 'ERROR!', -buttons => ["OK"]);
						$sendim->geometry ("300x50");
						$sendim_a = $sendim->add ("Label",
							-text => "That listener doesnt support Sending IM's!",
							-foreground => '#FF0000',
							-font => [
								-family => 'Verdana',
								-size => 8,
								-weight => 'bold',
							],
						)->pack;
						$sendim->Show;
					}

					# Clear variables.
					$sendim_to = '';
					$sendim_msg = '';
				}
				else {
					# Show error dialog.
					$sendim = $main->DialogBox (-title => 'ERROR!', -buttons => ["OK"]);
					$sendim->geometry ("300x50");
					$sendim_a = $sendim->add ("Label",
						-text => "The bot could not be found!",
						-foreground => '#FF0000',
						-font => [
							-family => 'Verdana',
							-size => 8,
							-weight => 'bold',
						],
					)->pack;
					$sendim->Show;
				}
			}
		}
		else {
			# Show error dialog.
			$sendim = $main->DialogBox (-title => 'ERROR!', -buttons => ["OK"]);
			$sendim->geometry ("300x50");
			$sendim_a = $sendim->add ("Label",
				-text => "Your bots are not currently running.",
				-foreground => '#FF0000',
				-font => [
					-family => 'Verdana',
					-size => 8,
					-weight => 'bold',
				],
			)->pack;
			$sendim->Show;
		}
	});
$infomenu = $menubar->Menubutton (
	-text => 'Data',
	-underline => 0,
	-tearoff => 0,
	)->pack (-side => 'left');

	$infomenu->command (-label => 'Client Data', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		# Open the clients folder.
		$client_data = undef;
		$this = 10;
		@headers = ("Listener", "Username");
		opendir (CLIENTS, "./clients");
		foreach $file (sort(grep(!/^\./, readdir (CLIENTS)))) {
			open (FILE, "./clients/$file");
			@usrdata = <FILE>;
			close (FILE);

			chomp @usrdata;

			($lis,$nick) = split(/\-/, $file, 2);
			($nick,$void) = split(/\./, $nick, 2);

			# If the length is greater than 10...
			if (length $lis > 10) {
				@chars = split(//, $lis);
				$lis = $chars[0] . $chars[1] . $chars[2] . $chars[3] .
					$chars[4] . $chars[5] . $chars[6] . $chars[7];
				$lis .= "..";
			}
			else {
				while (length $lis < 10) {
					$lis .= " ";
				}
			}
			if (length $nick > 10) {
				@chars = split(//, $nick);
				$nick = $chars[0] . $chars[1] . $chars[2] . $chars[3] .
					$chars[4] . $chars[5] . $chars[6] . $chars[7];
				$nick .= "..";
			}
			else {
				while (length $nick < 10) {
					$nick .= " ";
				}
			}

			$client_data .= "$lis $nick";

			foreach $line (@usrdata) {
				($what,$is) = split(/=/, $line, 2);
				$what = lc($what);
				$what =~ s/ //g;

				#$cdat_a->insert ('end', "What: $what, Is: $is\n");

				# If the length is greater than 10...
				if (length $is > 10) {
					@chars = split(//, $is);
					$is = $chars[0] . $chars[1] . $chars[2] . $chars[3] .
						$chars[4] . $chars[5] . $chars[6] . $chars[7];
					$is .= "..";
				}
				else {
					while (length $is < 10) {
						$is .= " ";
					}
				}

				$client_data .= " $is";

				# If this is a new header...
				$new = 1;
				foreach $head (@headers) {
					if ($head eq $what) {
						$new = 0;
						last;
					}
				}
				if ($new == 1) {
					push (@headers, $what);
				}
			}

			$client_data .= "\n";
		}

		$cdat = $main->DialogBox (-title => "Client Data", -buttons => ["OK"]);

		$cdat_b = $cdat->add ("Label", -text => "This is all the data of your bot's users.\n"
			. "This data cannot be edited via this form.")->pack (-side => 'top');

		$cdat_table = $cdat->Frame()->pack (
			-side => 'top',
			-fill => 'both',
		);

		$cdat_a = $cdat_table->Scrolled (
			ROText,
			-width => 70,
			-height => 12,
			-scrollbars => 'se',
			-background => '#CCCCCC',
			-foreground => '#000000',
			-font => [
				-family => 'Courier New',
				-size => '10',
			],
			-wrap => 'none',
		)->pack (-fill => 'both', -expand => 1);

		$cdat_a->delete ('1.0', 'end');

		foreach $head (@headers) {
			if (length $head > 10) {
				@chars = split(//, $head);
				$head = $chars[0] . $chars[1] . $chars[2] . $chars[3] .
					$chars[4] . $chars[5] . $chars[6] . $chars[7];
				$head .= "..";
			}
			else {
				while (length $head < 10) {
					$head .= " ";
				}
			}

			$cdat_a->insert ('end', "$head ");
		}
		$cdat_a->insert ('end', "\n");
		foreach $head (@headers) {
			$cdat_a->insert ('end', "---------- ");
		}
		$cdat_a->insert ('end', "\n");

		$cdat_a->insert ('end', $client_data);

		$cdat->Show;
	});
	$infomenu->command (-label => 'Warners List', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		open (WARNERS, "./data/warners.txt");
		@data = <WARNERS>;
		close (WARNERS);

		chomp @data;

		$warnlist = "";
		foreach $line (@data) {
			$warnlist .= "$line\n";
		}

		$warners = $main->DialogBox (-title => "Warners List", -buttons => ["Close"]);

		$warners_1 = $warners->Scrolled (
			Text,
			-width => 20,
			-height => 10,
			-scrollbars => 'se',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-font => [
				-family => 'Verdana',
				-size => '10',
			],
		)->pack (-side => 'top', -fill => 'both', -expand => 1);

		$warners_1->delete ('1.0', 'end');
		$warners_1->insert ('end', $warnlist);

		$warners_a = $warners->Button (
			-text => "Save Changes",
			-relief => 'raised',
			-command => sub {

				open (NEW, ">./data/warners.txt");
				print NEW $warners_1->get ('1.0', 'end');
				close (NEW);

				$warners->destroy();
			},
		)->pack;

		$warners->Show;
	});

	$infomenu->command (-label => 'Blacklist', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		open (BLACK, "./data/blacklist.txt");
		@data = <BLACK>;
		close (BLACK);

		chomp @data;

		$blacklist = "";
		foreach $line (@data) {
			$blacklist .= "$line\n";
		}

		$black = $main->DialogBox (-title => "Blacklist", -buttons => ["Close"]);

		$black_1 = $black->Scrolled (
			Text,
			-width => 20,
			-height => 10,
			-scrollbars => 'se',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-font => [
				-family => 'Verdana',
				-size => '10',
			],
		)->pack (-side => 'top', -fill => 'both', -expand => 1);

		$black_1->delete ('1.0', 'end');
		$black_1->insert ('end', $blacklist);

		$black_a = $black->Button (
			-text => "Save Changes",
			-relief => 'raised',
			-command => sub {

				open (NEW, ">./data/blacklist.txt");
				print NEW $black_1->get ('1.0', 'end');
				close (NEW);

				$black->destroy();
			},
		)->pack;

		$black->Show;
	});

	$infomenu->separator;

	$infomenu->command (-label => 'Guest Book', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		open (GB, "./data/gb.txt");
		@data = <GB>;
		close (GB);

		chomp @data;

		$gb = "";
		foreach $line (@data) {
			$gb .= "$line\n";
		}

		$guest = $main->DialogBox (-title => "Guestbook Entries", -buttons => ["Close"]);

		$guest_1 = $guest->Scrolled (
			Text,
			-width => 30,
			-height => 10,
			-wrap => 'none',
			-scrollbars => 'se',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-font => [
				-family => 'Verdana',
				-size => '10',
			],
		)->pack (-side => 'top', -fill => 'both', -expand => 1);

		$guest_1->delete ('1.0', 'end');
		$guest_1->insert ('end', $gb);

		$guest_a = $guest->Button (
			-text => "Save Changes",
			-relief => 'raised',
			-command => sub {

				open (NEW, ">./data/gb.txt");
				print NEW $guest_1->get ('1.0', 'end');
				close (NEW);

				$guest->destroy();
			},
		)->pack;

		$guest->Show;
	});

	$infomenu->command (-label => 'Applications', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		open (APP, "./data/applications.txt");
		@data = <APP>;
		close (APP);

		chomp @data;

		$app = "";
		foreach $line (@data) {
			$app .= "$line\n";
		}

		$apply = $main->DialogBox (-title => "Applications", -buttons => ["Close"]);

		$apply_t = $apply->add ("Label", -text => "The screennames listed below have applied for Admin controls\n"
			. "on your bot.")->pack (-side => 'top');

		$apply_1 = $apply->Scrolled (
			Text,
			-width => 20,
			-height => 10,
			-wrap => 'none',
			-scrollbars => 'se',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-font => [
				-family => 'Verdana',
				-size => '10',
			],
		)->pack (-side => 'top', -fill => 'both', -expand => 1);

		$apply_1->delete ('1.0', 'end');
		$apply_1->insert ('end', $app);

		$apply_a = $apply->Button (
			-text => "Save Changes",
			-relief => 'raised',
			-command => sub {

				open (NEW, ">./data/applications.txt");
				print NEW $apply_1->get ('1.0', 'end');
				close (NEW);

				$apply->destroy();
			},
		)->pack;

		$apply->Show;
	});

	$infomenu->separator;

	$infomenu->command (-label => 'Moderators', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		open (MOD, "./data/authority/moderator.txt");
		@data = <MOD>;
		close (MOD);

		chomp @data;

		$modlist = join ("\n", @data);

		$mods = $main->DialogBox (-title => "Moderators", -buttons => ["Close"]);

		$mods_b = $mods->add ("Label",
			-text => "Format:    LISTENER-username",
		)->pack;

		$mods_1 = $mods->Scrolled (
			Text,
			-width => 20,
			-height => 10,
			-scrollbars => 'se',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-wrap => 'none',
			-font => [
				-family => 'Verdana',
				-size => '10',
			],
		)->pack (-side => 'top', -fill => 'both', -expand => 1);

		$mods_1->delete ('1.0', 'end');
		$mods_1->insert ('end', $modlist);

		$mods_a = $mods->Button (
			-text => "Save Changes",
			-relief => 'raised',
			-command => sub {
				open (NEW, ">./data/authority/moderator.txt");
				print NEW $mods_1->get ('1.0', 'end');
				close (NEW);

				$mods->destroy();
			},
		)->pack;

		$mods->Show;
	});

	$infomenu->command (-label => 'Administrators', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		open (ADMIN, "./data/authority/admin.txt");
		@data = <ADMIN>;
		close (ADMIN);

		chomp @data;

		$adminlist = join ("\n", @data);

		$admins = $main->DialogBox (-title => "Administrators", -buttons => ["Close"]);

		$admins_b = $admins->add ("Label",
			-text => "Format:    LISTENER-username",
		)->pack;

		$admins_1 = $admins->Scrolled (
			Text,
			-width => 20,
			-height => 10,
			-scrollbars => 'se',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-wrap => 'none',
			-font => [
				-family => 'Verdana',
				-size => '10',
			],
		)->pack (-side => 'top', -fill => 'both', -expand => 1);

		$admins_1->delete ('1.0', 'end');
		$admins_1->insert ('end', $adminlist);

		$admins_a = $admins->Button (
			-text => "Save Changes",
			-relief => 'raised',
			-command => sub {
				open (NEW, ">./data/authority/admin.txt");
				print NEW $admins_1->get ('1.0', 'end');
				close (NEW);

				$admins->destroy();
			},
		)->pack;

		$admins->Show;
	});

	$infomenu->command (-label => 'Botmasters', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		open (MASTER, "./data/authority/master.txt");
		@data = <MASTER>;
		close (MASTER);

		chomp @data;

		$masterlist = join ("\n", @data);

		$masters = $main->DialogBox (-title => "Botmasters", -buttons => ["Close"]);

		$masters_c = $masters->add ("Label",
			-text => "WARNING: Only make YOUR usernames be the masters,\n"
				. "Masters have access to commands that could potentially\n"
				. "destroy your computer. Do not give Master access\n"
				. "to ANYBODY else!!!",
			-font => [
				-family => 'Verdana',
				-size => '8',
				-weight => 'bold',
			],
			-foreground => '#FF0000',
		)->pack;

		$masters_b = $masters->add ("Label",
			-text => "Format:    LISTENER-username",
		)->pack;

		$masters_1 = $masters->Scrolled (
			Text,
			-width => 20,
			-height => 10,
			-scrollbars => 'se',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-wrap => 'none',
			-font => [
				-family => 'Verdana',
				-size => '10',
			],
		)->pack (-side => 'top', -fill => 'both', -expand => 1);

		$masters_1->delete ('1.0', 'end');
		$masters_1->insert ('end', $masterlist);

		$masters_a = $masters->Button (
			-text => "Save Changes",
			-relief => 'raised',
			-command => sub {
				open (NEW, ">./data/authority/master.txt");
				print NEW $masters_1->get ('1.0', 'end');
				close (NEW);

				$masters->destroy();
			},
		)->pack;

		$masters->Show;
	});
$helpmenu = $menubar->Menubutton (
	-text => 'Help',
	-underline => 0,
	-tearoff => 0,
	)->pack (-side => 'left');

	$helpmenu->command (-label => 'About CKS Juggernaut', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		$result = $about->Show;

		if ($result =~ /website/i) {
			# Launch the website.
			system ("start ./server/link.html");
		}
	});

	$helpmenu->separator;

	$helpmenu->command (-label => 'ReadMe File', -font => [ -family => 'Arial', -size => '8' ], -command => sub {
		# Launch "readme.html"
		system ("start readme.html");
	});

	$helpmenu->command (-label => 'Report a Bug', -font => [ -family => 'Arial', -size => '8', ], -command => sub {
		$bug = $main->DialogBox (-title => 'Report a Bug', -buttons => ["Send", "Cancel"]);

		$bug_a = $bug->add ("Label",
			-text => "Before reporting a bug: Make sure the bug is not already known, look in the \"bugs\"\n"
				. "section of the README file for a list of known bugs.")->pack;

		$bug_b = $bug->add ("Label",
			-text => "Send Type:",
			-font => [
				-family => 'Verdana',
				-size => '8',
				-weight => 'bold',
			],
		)->pack;

		$bug->Radiobutton (
			-text => "My Bot's Email Server",
			-value => 1,
			-variable => \$bug_1,
		)->pack (-anchor => 'w');
		$bug->Radiobutton (
			-text => "Direct Send to CKS Server",
			-value => 2,
			-variable => \$bug_1,
		)->pack (-anchor => 'w');

		$bug_c = $bug->add ("Label",
			-text => "Please describe the steps required to recreate this bug or error.",
		)->pack;

		$bug_2 = $bug->Scrolled (
			Text,
			-scrollbars => 'e',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-wrap => 'word',
			-font => [
				-family => 'Verdana',
				-size => '10',
			],
			-width => 20,
			-height => 4,
		)->pack;

		$bug_d = $bug->add ("Label",
			-text => "Describe the bug or error experienced in the field below.",
		)->pack;

		$bug_3 = $bug->Scrolled (
			Text,
			-scrollbars => 'e',
			-background => '#FFFFFF',
			-foreground => '#000000',
			-wrap => 'word',
			-font => [
				-family => 'Verdana',
				-size => '10',
			],
			-width => 20,
			-height => 4,
		)->pack;

		$result = $bug->Show;
		if ($result =~ /send/i) {
			# See what method they chose.
			if ($bug_1 == 1) {
				# Sending E-Mail.
				use lib "./lib";
				use Mail::Sendmail;

				open (CFG, "./config/startup.cfg");
				@data = <CFG>;
				close (CFG);
				chomp @data;
				foreach $line (@data) {
					($what,$is) = split(/=/, $line, 2);
					$what = lc($what);
					$what =~ s/ //g;

					$startdata{$what} = $is;
				}

				%mail = undef;
				$mail{Smtp} = $startdata{emailserver};
				$mail{To} = 'kirsle@yahoo.com';
				$mail{From} = 'CKS Juggernaut <juggernaut@cks.kirsle.net>';
				$mail{Subject} = 'Bug Report';
				$mail{Message} = "Bug Report from CKS Juggernaut concerning the User Interface:\n\n"
					. ":: How To Re-enact the Bug\n"
					. $bug_2->get ('1.0', 'end') . "\n\n"
					. ":: The Bug Report\n"
					. $bug_3->get ('1.0', 'end') . "\n\n";

				$safe = $main->DialogBox (-title => 'Send E-Mail', -buttons => ["OK"]);

				if (Mail::Sendmail::sendmail (%mail)) {
					$safe_a = $safe->add ("Label", -text => "The e-mail was sent successfully.")->pack;
				}
				else {
					$safe_a = $safe->add ("Label", -text => "The e-mail could not be sent!\n\n"
						. "$Mail::Sendmail::error")->pack;
				}

				$safe->Show;
			}
			elsif ($bug_1 == 2) {
				# Get the URL.
				$bug1 = $bug_2->get ('1.0', 'end');
				$bug2 = $bug_3->get ('1.0', 'end');

				$bug1 =~ s/\n/ <break> /ig;
				$bug2 =~ s/\n/ <break> /ig;

				$void = LWP::Simple::get ("http://chaos.kirsle.net/bug.pl?redo=$bug1&report=$bug2");

				if (length $void > 0) {
					$succ = $main->DialogBox (-title => 'Bug Report', -buttons => ["OK"]);

					$succ_a = $succ->add ("Label",
						-text => "The report was sent successfully.")->pack;

					$succ->Show;
				}
				else {
					$noserver = $main->DialogBox (-title => 'ERROR', -buttons => ["OK"]);

					$noserver_a = $noserver->add ("Label",
						-text => "The server could not be reached!")->pack;

					$noserver->Show;
				}
			}
			else {
				$errmsg = $main->DialogBox (-title => 'ERROR', -buttons => ["OK"]);

				$errmsg_a = $errmsg->add ("Label", -text => "You did not specify a method of sending the "
					. "bug report!")->pack;

				$errmsg->Show;
			}
		}
	});

# The main text field.
$text = $main->Scrolled (
	Text,
	-scrollbars => 'e',
	-background => $gui->{background},
	-foreground => $gui->{fontcolor},
	-wrap => 'word',
	-font => [
		-family => $gui->{fontface},
		-size => '10',
	],
	)->pack (-fill => 'both', -expand => 1);
$realtext = $text->Subwidget ('text');

# Tie STDOUT to a widget.
tie *STDOUT, ref $realtext, $realtext;

# The status bar.
$status = $main->ROText (
	-relief => 'sunken',
	-height => 1,
	-background => $gui->{statusbg},
	-foreground => $gui->{statuscolor},
	-font => [
		-family => $gui->{statusfont},
		-size => '10',
	],
)->pack (-side => 'bottom', -fill => 'x', -padx => 2, -pady => 2);

$status->insert ('end', "CKS Juggernaut version $VERSION ~ Copyright © 2004 Chaos AI Technology");

$text->delete ('1.0', 'end');
$text->insert ('end', "             ::.                   .:.\n");
$text->insert ('end', "              .;;:  ..:::::::.  .,;:\n");
$text->insert ('end', "                ii;,,::.....::,;;i:\n");
$text->insert ('end', "              .,;ii:          :ii;;:\n");
$text->insert ('end', "            .;, ,iii.         iii: .;,\n");
$text->insert ('end', "           ,;   ;iii.         iii;   :;.\n");
$text->insert ('end', ".         ,,   ,iii,          ;iii;   ,;\n");
$text->insert ('end', " ::       i  :;iii;     ;.    .;iii;.  ,,      .:;\n");
$text->insert ('end', "  .,;,,,,;iiiiii;:     ,ii:     :;iiii;;i:::,,;:\n");
$text->insert ('end', "    .:,;iii;;;,.      ;iiii:      :,;iiiiii;,:\n");
$text->insert ('end', "         :;        .:,,:..:,,.        .:;..\n");
$text->insert ('end', "          i.                  .        ,:\n");
$text->insert ('end', "          :;.         ..:...          ,;\n");
$text->insert ('end', "           ,;.    .,;iiiiiiii;:.     ,,\n");
$text->insert ('end', "            .;,  :iiiii;;;;iiiii,  :;:\n");
$text->insert ('end', "               ,iii,:        .,ii;;.\n");
$text->insert ('end', "               ,ii,,,,:::::::,,,;i;\n");
$text->insert ('end', "               ;;.   ...:.:..    ;i\n");
$text->insert ('end', "               ;:                :;\n");
$text->insert ('end', "               .:                ..\n");
$text->insert ('end', "                ,                :\n");

MainLoop;

sub run_bots {
	# Use our local library.
	use lib "./lib";

	# The main modules.
	use Net::OSCAR qw(:standard);  # To connect to AIM
	use Net::IRC;                  # To connect to IRC
	use MSN;                       # To connect to MSN

	# Using Net-OSCAR 1.11? (1.11 supports buddy icons but has a messed up chat_invite handler)
	my $oscar111 = 1; # or 0 for no

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
	$text->insert ('1.0', ":: Loading Perl Files...\n");
	@perl_files = (
		"./brains",
		"./handlers/aim",
		"./handlers/msn",
		"./handlers/http",
		"./settings",
		"./subroutines",
	);
	foreach $item (@perl_files) {
		opendir (PL, $item);
		foreach $file (sort(grep(!/^\./, readdir (PL)))) {
			$text->insert ('1.0', "\tIncluding $item/$file...\n");
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
	@botnames;
	opendir (BOTS, "./bots");
	foreach $file (sort(grep(!/^\./, readdir (BOTS)))) {
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
			if ($oscar111 == 1) {
				$chaos->{$key}->{client} = Net::OSCAR->new(capabilities => [qw(typing_status buddy_icons)]);
				$chaos->{$key}->{_oscar} = '1.11';
			}
			else {
				$chaos->{$key}->{client} = Net::OSCAR->new ();
				$chaos->{$key}->{_oscar} = '1.0';
			}

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
				my @new_botnames;
				foreach my $name (@botnames) {
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

	$small_loop = 5;

	&loop_bots ();
}
$bot_loops = 0;
sub loop_bots {
	if ($bots_running == 1) {
		&active();

		$bot_loops++;

		$status->delete ('1.0', 'end');
		$status->insert ('end', "Bot Loop \#$bot_loops :: " . scalar(@botnames) . " Bots Connected :: "
			. "Copyright © 2004 Chaos AI Technology");

		#$main->after (200, \&loop_bots);
		$main->update ();
		&loop_bots;
	}
}