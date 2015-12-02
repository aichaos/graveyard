#!/usr/bin/perl -w

use lib "../../lib";
use Chatbot::Alpha::Sort;

print "Sorting...\n\n";

my $cody = new Chatbot::Alpha::Sort();
print "Sorting Cody\n";
$cody->start (
	dir   => './old/cody',
	out   => './cody',
	files => 'intact',
	ext   => 'cba',
);
print "Sorting Casey\n";
my $casey = new Chatbot::Alpha::Sort();
$casey->start (
	dir   => './old/casey',
	out   => './casey',
	files => 'intact',
	ext   => 'cba',
);
print "Sorting Chaos\n";
my $chaos = new Chatbot::Alpha::Sort();
$chaos->start (
	dir   => './old/chaos',
	out   => './chaos',
	files => 'intact',
	ext   => 'cba',
);