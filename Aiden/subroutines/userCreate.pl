# userCreate.pl - create a new userfile

sub userCreate {
	my $client = shift;

	return 0 if -e "./clients/$client\.usr";

	open (USR, ">./clients/$client\.usr");
	print USR "name=$client\n"
		. "blocked=0\n"
		. "expires=0\n"
		. "blocks=0\n"
		. "stars=0\n"
		. "points=0";
	close (USR);

	&userGet ($client);
}
1;