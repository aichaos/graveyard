#================================================
package ContactTools;
#================================================


sub purgeAllowList
{
	my $msn = shift;
	my $filename = shift || './al_list.txt';

	# get the AL list and RL hash
	my @al_list = $msn->getContactList( 'AL' );
	my %rl_hash = map { $_, 1 } $msn->getContactList( 'RL' );

	# backup our AL list
	open( FILE, ">$filename" ) || print( "Could not open backup file '$filename'" ) && return 0;
	print( FILE "$_\n" ) foreach (sort @al_list);
	close( FILE );

	my $removed = 0;

	# do the removals and count
	foreach my $contact (@al_list)
	{
		if( !defined $rl_hash{$contact} )
		{
			$msn->disallowContact( $contact );
			$removed++;
		}

		# do only 10 at a time so we don't upset the server
		last if( $removed >= 10 );
	}

	return $removed;
}

sub syncAllowList
{
	my $msn = shift;

	# get the RL list and AL hash
	my @rl_list = $msn->getContactList( 'RL' );
	my %al_hash = map { $_, 1 } $msn->getContactList( 'AL' );

	my $allowed = 0;

	# do the allows and count
	foreach my $contact (@rl_list)
	{
		if( !defined $al_hash{$contact} )
		{
			$msn->allowContact( $contact );
			$allowed++;
		}

		# do only 10 at a time so we don't upset the server
		last if( $allowed >= 10 );
	}

	return $allowed;
}

sub exportContactLists
{
	my $msn = shift;
	my $filename = shift || './contact_lists.txt';

	# get the lists
	my @fl_list = $msn->getContactList( 'FL' );
	my @bl_list = $msn->getContactList( 'BL' );
	my @al_list = $msn->getContactList( 'AL' );
	my @rl_list = $msn->getContactList( 'RL' );

	# backup our AL list
	open( FILE, ">$filename" ) || print( "Could not open backup file '$filename'" ) && return 0;
	print( FILE "# Forward List (list of contacts)\n\n" );
	print( FILE "$_\n" ) foreach (sort @fl_list);
	print( FILE "\n\n# Block List (list of blocked contacts)\n\n" );
	print( FILE "$_\n" ) foreach (sort @bl_list);
	print( FILE "\n\n# Allow List (list of contacts you allow to see you)\n\n" );
	print( FILE "$_\n" ) foreach (sort @al_list);
	print( FILE "\n\n# Reverse List (list of contacts that put you on their contact list)\n\n" );
	print( FILE "$_\n" ) foreach (sort @rl_list);
	close( FILE );

	return 1;
}


1;
