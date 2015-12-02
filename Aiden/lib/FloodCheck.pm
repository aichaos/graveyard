#==============================================================================
#
#  This module is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Library General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Library General Public License for more details.
#
#  FloodCheck
#  Copyright (C) 2003-2004 Deep Gorge Technologies
#
#==============================================================================

#================================================
package FloodCheck;
#================================================

use strict;

my $VERSION = 'FloodCheck .2 (2004.03.29)';
my $DATAVERSION = 'FloodCheck Data .1';

local $SIG{__WARN__} = sub {};

my $CODESTRING = { -1 => 'ERROR', 0 => 'None', 1 => 'Huge message', 2 => 'Multiple large messages', 3 => 'Repeating', 4 => 'Repeating over range', 5 => 'Over rate limit' };


#================================================
# Constructor
#================================================

sub new
{
	my $class = shift;
	my %options = @_;

	print( $VERSION . "\n" );

	my $this =
	{
		'debug'					=> $options{'debug'} || 0,
		'message_total'		=> $options{'message_total'} || 10,
		'huge_size'				=> $options{'huge_size'} || 250,
		'large_size'			=> $options{'large_size'} || 100,
		'repeat_size'			=> $options{'repeat_size'} || 3,
		'range_size'			=> $options{'range_size'} || 4,
		'rate_size'				=> $options{'rate_size'} || 3,
		'rate_time'				=> $options{'rate_time'} || 10,
		'auto_purge'			=> $options{'auto_purge'} || 0,
		'purge_interval'		=> $options{'purge_interval'} || 600,
		'purge_min'				=> $options{'purge_min'} || 1200,
		'last_purge'			=> time,
		'users'					=> {}
	};
	bless $this, $class;

	return $this;
}

#================================================
# Destructor
#================================================

sub DESTROY
{
	my $this = shift;

}

#================================================
# Get the version of this module
#================================================

sub getVersion
{
	my $this = shift;
	return $VERSION;
}

#================================================
# AUTOLOAD method to handle all unknown method calls
#================================================

sub AUTOLOAD
{
	my $this = shift;

	print( "method $FloodCheck::AUTOLOAD not defined\n" );
}

sub debug
{
	my $this = shift;
	my $string = shift;

	print( "$string\n" ) if( $this->{'debug'} );
}

#================================================
# Set method
#================================================

sub set
{
	my $this = shift;
	my %options = shift;

	$this->{'debug'} = $options{'debug'} || $this->{'debug'};
	$this->{'message_total'} = $options{'message_total'} || $this->{'message_total'};
	$this->{'huge_size'} = $options{'huge_size'} || $this->{'huge_size'};
	$this->{'large_size'} = $options{'large_size'} || $this->{'large_size'};
	$this->{'repeat_size'} = $options{'repeat_size'} || $this->{'repeat_size'};
	$this->{'range_size'} = $options{'range_size'} || $this->{'range_size'};
	$this->{'rate_size'} = $options{'rate_size'} || $this->{'rate_size'};
	$this->{'rate_time'} = $options{'rate_time'} || $this->{'rate_time'};
	$this->{'auto_purge'} = $options{'auto_purge'} || $this->{'auto_purge'};
	$this->{'purge_interval'} = $options{'purge_interval'} || $this->{'purge_interval'};
	$this->{'purge_min'} = $options{'purge_min'} || $this->{'purge_min'};
}

#================================================
# Check if a user is flooding
#================================================

sub check
{
	my $this = shift;
	my $username = shift;
	my $message = shift;

	# purge if auto purge is on and if enough time has past since last purge
	$this->purge() if( $this->{'auto_purge'} && time - $this->{'last_purge'} >= $this->{'purge_interval'} );

	# fail on bad username or message
	return -1 if( !defined $username || $username eq '' || !defined $message || $message eq '' );

	# remove excess whitespace and forget case
	$message =~ s/^\s+//g;
	$message =~ s/\s+$//g;
	$message =~ s/\s+/ /g;
	$message = lc $message;

	# create an entry for this user if we don't have one
	$this->{'users'}->{$username} ||= { 'message' => [], 'time' => [] };

	# add the message and time
	unshift( @{$this->{'users'}->{$username}->{'message'}}, $message );
	unshift( @{$this->{'users'}->{$username}->{'time'}}, time );

	# if we have more than our max messages, pop off the last one
	if( scalar @{$this->{'users'}->{$username}->{'message'}} > $this->{'message_total'} )
	{
		pop @{$this->{'users'}->{$username}->{'message'}};
		pop @{$this->{'users'}->{$username}->{'time'}};
	}

	# get easier to use variables
	my $messages = $this->{'users'}->{$username}->{'message'};
	my $times = $this->{'users'}->{$username}->{'time'};
	my $message_count = scalar @$messages;

	# huge message detected
	return 1 if( length $messages->[0] >= $this->{'huge_size'} );

	# back to back large messages
	return 2 if( $message_count >= 2 && length $messages->[0] >= $this->{'large_size'} && length $messages->[1] >= $this->{'large_size'} );

	# multiple large messages over range
	my $count = 0;
	map { $count++ if( length $_ >= $this->{'large_size'} ); } @$messages;
	return 2 if( $count >= $this->{'range_size'} );

	# repeated messages
	$count = 0;
	for( my $i=0; $i<$this->{'repeat_size'}; $i++ ) { $count++ if( exists $messages->[$i] && $messages->[$i] eq $messages->[0] ); }
	return 3 if( $count == $this->{'repeat_size'} );

	# repeating over range
	$count = 0;
	map { $count++ if( $_ eq $messages->[0] ); } @$messages;
	return 4 if( $count >= $this->{'range_size'} );

	# message rate exceeded
	return 5 if( $message_count >= $this->{'rate_size'} && $times->[0] - $times->[$this->{'rate_size'} - 1] <= $this->{'rate_time'} );

	# no flooding
	return 0;
}

#================================================
# Purge old users from the list
#================================================

sub purge
{
	my $this = shift;

	foreach my $key (keys %{$this->{'users'}})
	{
		delete $this->{'users'}->{$key} if( time - $this->{'users'}->{$key}->{'time'}->[0] >= $this->{'purge_min'} );
	}

	$this->{'last_purge'} = time;
}

#================================================
# Get messages for a specific username
#================================================

sub get
{
	my $this = shift;
	my $username = shift;

	return $this->{'users'}->{$username}->{'message'};
}

#================================================
# Clear messages from a specific username
#================================================

sub clear
{
	my $this = shift;
	my $username = shift;

	delete $this->{'users'}->{$username};
}

#================================================
# Convert the flooding code to a message
#================================================

sub codeToString
{
	my $this = shift;
	my $code = shift || 0;

	return 'unknown' if( $code < -1 || $code > 5 );

	return $CODESTRING->{$code};
}


1;
