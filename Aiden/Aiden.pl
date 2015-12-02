#!/usr/bin/perl -w

# Configure your bot by editing the files in the config folder.

use lib "./lib";
use lib "./libtwo";
use strict;
use warnings;
use Data::Dumper;
use Time::Format;
use RiveScript;
use FloodCheck;

# Body hashref.
our $aiden = {
	version => '1.0',
	author  => 'Cerone Kirsle',
	debug   => 0,
};

$| = 1; # Streaming.

if (@ARGV) {
	if ($ARGV[0] eq '--debug') {
		$aiden->{debug} = 1;
	}
}

print qq~
+-----------------------------+
| Aiden v. $aiden->{version} is starting... |
+-----------------------------+
Running Chatbot::Alpha $Chatbot::Alpha::VERSION
~;

print ":: Loading local libraries... Done!\n";

print ":: Loading flood checker... ";
$aiden->{system}->{flood} = new FloodCheck(
	message_total => 25,
	repeat_size   => 15,
	range_size    => 15,
	rate_size     => 15,
	purge_min     => 1200,
);
print "Done!\n";

print ":: Loading configuration files... ";
$aiden->{root} = require "./config/Connections.cfg";
require "./config/Settings.cfg";
require "./config/Substitutions.cfg";
print "Done!\n";

print ":: Loading listener definitions...\n";
opendir (DIR, "./listeners");
foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
	next if -d $file;
	next unless $file =~ /\.pl$/i;

	my $name = $file;
	$name =~ s/\.pl//g;
	next unless -d "./listeners/$name";

	print "\tLoading $name... ";
	$aiden->{listeners}->{$name} = require "./listeners/$file";
	print "Done!\n";

	opendir (LIS, "./listeners/$name");
	foreach my $file (sort(grep(!/^\./, readdir(LIS)))) {
		next unless $file =~ /\.pl$/i;
		require "./listeners/$name/$file";
	}
	closedir (LIS);
}
closedir (DIR);

print ":: Loading handlers and subroutines...\n";
my @dirs = qw(subroutines handlers);
foreach my $dir (@dirs) {
	opendir (DIR, "./$dir");
	foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
		next unless $file =~ /\.pl$/i;
		print "\tIncluding $dir/$file... ";
		require "./$dir/$file";
		print "Done!\n";
	}
	closedir(DIR);
}

print ":: Loading user data... ";
&loadUsers();
print "Done!\n";

print ":: Loading bot reply data... ";
&loadBrains();
print "Done!\n";

print ":: Loading commands... ";
opendir (DIR, "./commands");
foreach my $file (sort(grep(!/^\./, readdir(DIR)))) {
	next unless $file =~ /\.pl$/i;
	print "\tIncluding commands/$file... ";
	require "./commands/$file";
	print "Done!\n";
}
closedir(DIR);

print ":: Connecting the bots...\n";
foreach my $lis (keys %{$aiden->{root}->{listeners}}) {
	next unless exists $aiden->{listeners}->{$lis};
	next unless $aiden->{root}->{listeners}->{$lis}->{active} == 1;
	my $sn = $aiden->{root}->{listeners}->{$lis}->{screenname};
	$sn = lc($sn);
	$sn =~ s/ //g;

	$aiden->{bots}->{$sn} = $aiden->{root}->{listeners}->{$lis};
	$aiden->{bots}->{$sn}->{listener} = $lis;

	# Mirrors.
	foreach my $mirror (keys %{$aiden->{root}->{listeners}->{$lis}->{mirrors}}) {
		my $msn = &normalize($mirror);
		my $mpw = $aiden->{root}->{listeners}->{$lis}->{mirrors}->{$mirror};

		# Copy keys over.
		foreach my $key (keys %{$aiden->{root}->{listeners}->{$lis}}) {
			if (ref($aiden->{root}->{listeners}->{$lis}->{$key}) =~ /HASH/i) {
				foreach my $sub (keys %{$aiden->{root}->{listeners}->{$lis}->{$key}}) {
					$aiden->{bots}->{$msn}->{$key}->{$sub} = $aiden->{root}->{listeners}->{$lis}->{$key}->{$sub};
				}
			}
			else {
				$aiden->{bots}->{$msn}->{$key} = $aiden->{root}->{listeners}->{$lis}->{$key};
			}
		}

		$aiden->{bots}->{$msn}->{listener} = $lis;
		$aiden->{bots}->{$msn}->{password} = $mpw;
	}
}
foreach my $sn (keys %{$aiden->{bots}}) {
	my $lis = $aiden->{bots}->{$sn}->{listener};
	my $pw  = $aiden->{bots}->{$sn}->{password};
	print "\tConnecting $sn to $lis... ";

	my $eval = "$aiden->{listeners}->{$lis}->{init}\n";

	foreach my $cb (keys %{$aiden->{listeners}->{$lis}->{callbacks}}) {
		my $sub = $aiden->{listeners}->{$lis}->{callbacks}->{$cb};
		my $handler = $aiden->{listeners}->{$lis}->{handlers};
		$handler =~ s/\%CB\%/$cb/g;
		$handler =~ s/\%SUB\%/\\&$sub/g;

		$eval .= "$handler\n";
	}

	$eval .= "\n$aiden->{listeners}->{$lis}->{signon}";

	my $result = eval ($eval) || $@;

	print "Connection received!\n";
}
print "\n\n"
	. "Aiden started up in " . (time() - $^T) . " seconds.\n\n";

open (DEBUG, ">./debug.txt");
print DEBUG Dumper($aiden);
close (DEBUG);

while (1) {
	&active();
}