#================================================
package MSN;
#================================================

=head1 MSN v2.0PR

=cut

use strict;
use warnings;

# IO
use IO::Select;

use MSN::Notification;
use MSN::SwitchBoard;

use constant CVER10 => '0x0409 winnt 5.0 i386 MSNMSGR 6.1.0203 MSMSGS ';
use constant VER => 'MSNP10 MSNP9 CVR0';

my $REVISION = '$Rev: 69 $';
$REVISION =~ s/\$//g;
my $VER = 'MSNP10 MSNP9 CVR0';

# print out the version and checksum
my $strVERSION = "MSN 2.0PR (09/17/2004)";
sub checksum { my $o = tell(DATA); seek DATA,0,0; local $/; my $t = unpack("%32C*",<DATA>) % 65535;seek DATA,$o,0; return $t;};
print $strVERSION . " - Checksum: " . checksum() .
							"-NS" . MSN::Notification::checksum() .
							"-SB" . MSN::SwitchBoard::checksum() .
			  " $REVISION\n\n";



=head2 Methods

=item
new

Used to create your instance of the MSN object used to communicate with MSN Servers.

=cut

sub new
{
	my $class = shift;

	my $self  =
	{
		Host  => 'messenger.hotmail.com',
		Port  => 1863,
		Handle => '',
		Password => '',
		Debug => 1,
		ShowTX => 0,
		ShowRX => 0,
		AutoloadError => 0,
		Select => new IO::Select(),
		Notification => undef,
		Connections => {},
		Connected => 0,
		Status => 'NLN',
		AutoReconnect => 0,
		@_
	};
	bless( $self, $class );

	return $self;
}

sub DESTROY
{
	my $self = shift;

	# placeholder for possible destructor code
}

sub AUTOLOAD
{
	my $self = shift;

	$self->error( "method $MSN::AUTOLOAD not defined" ) if( $self->{AutoloadError} );
}

sub debug
{
	my $self = shift;
	my $message = shift || '';

	if( defined $self->{handler}->{Debug} )
	{
		$self->call_event( $self, 'Debug', $message );
	}
	else
	{
		print( "$message\n" ) if( $self->{Debug} );
	}

	return 1;
}

sub error
{
	my $self = shift;
	my $message = shift || '';

	if( defined $self->{Msn}->{handler}->{Error} )
	{
		$self->{Msn}->call_event( $self, 'Error', $message );
	}
	else
	{
		print( "ERROR: $message\nCaller trace:\n" );

		for( my $i=0; $i<20; $i++ )
		{
			my ($package, $filename, $line, $subroutine, @more ) = caller($i);
			last if( !defined $package );
			$filename =~ s/.*MSN/MSN/gi;
			print( "  $i: $subroutine ($filename, line $line)\n" );
		}
	}

	return 0;
}

sub serverError
{
	my $self = shift;
	my $message = shift || '';

	if( defined $self->{handler}->{ServerError} )
	{
		$self->call_event( $self, 'ServerError', $message );
	}
	else
	{
		print( "SERVER ERROR: $message\n" );
	}

	return 0;
}


=item
connect

Call this when your object is created, your event handlers are set, and you are ready to connect.

=cut

sub connect
{
	my $self = shift;

	$self->debug( "Connecting to $self->{Host}:$self->{Port} as $self->{Handle}/$self->{Password}" );

	$self->{Notification} = new MSN::Notification( $self, $self->{Host}, $self->{Port}, $self->{Handle}, $self->{Password} );
	$self->{Notification}->connect();

	$self->{Connected} = time;
}

=item
disconnect

Name realy says it all.

=cut

sub disconnect
{
	my $self = shift;

	foreach my $convo (values %{$self->getConvoList()})
	{
		$convo->leave();
	}

	return $self->{Notification}->disconnect();

	$self->{Connected} = 0;
}

sub uptime
{
	my $self = shift;

	return ($self->{Connected}) ? (time - $self->{Connected}) : 0;
}

#================================================
# Passthroughs
#================================================

=item
setName

Sets the display name.

=cut

sub setName
{
	my $self = shift;

	return $self->{Notification}->setName( @_ );
}

=item
setName

Sets the status.

=cut

sub setStatus
{
	my $self = shift;

	return $self->{Notification}->setStatus( @_ );
}

=item
setDisplayPicture($file)

Sets the display picture. This must be passed a png file and resets your status to NLN so that your Display picture gets sent out.

=cut

sub setDisplayPicture
{
	my $self = shift;

	return $self->{Notification}->setDisplayPicture( @_ );
}

=item
addEmoticon($shortcut, $filename)

Adds an emoticon to your connection.  This loads the file and prepares it. Anytime you use the text form $shortcut in an outgoing message it will be replaced with the appropriate emoticon. You can only use 5 different emoticons per message.

=cut

sub addEmoticon
{
	my $self = shift;
	return return $self->{Notification}->addEmoticon( @_ );
}

=item
blockContact($email)

Puts $email on your block list.

=cut

sub blockContact
{
	my $self = shift;

	return $self->{Notification}->blockContact( @_ );
}

=item
unblockContact($email)

Removes $email on your block list.

=cut

sub unblockContact
{
	my $self = shift;

	return $self->{Notification}->unblockContact( @_ );
}

=item
addContact($email)

Puts $email on your FL list. This allows you to recieve status messages about this individual.

=cut


sub addContact
{
	my $self = shift;

	return $self->{Notification}->addContact( @_ );
}

=item
remContact($email)

Removes $email from your contact list.

=cut


sub remContact
{
	my $self = shift;

	return $self->{Notification}->remContact( @_ );
}

=item
allowContact($email)

Puts $email on your allow list. This is generaly automatic but there might be some cases where it is useful.
If you do not want to automatically allow contacts to see you online, you can set a handler for the "ContactAddingUs"
event and return 0.

=cut

sub allowContact
{
	my $self = shift;

	return $self->{Notification}->allowContact( @_ );
}

=item
disallowContact($email)

You guessed it, it takes the contact off your allow list.  They will no longer be able to see you or talk to you.

=cut

sub disallowContact
{
	my $self = shift;

	return $self->{Notification}->disallowContact( @_ );
}

=item
getContactList($list)

Expects $list to be FL, RL, AL, or BL.  Returns the email address on said list.

=cut

sub getContactList
{
	my $self = shift;

	return $self->{Notification}->getContactList( @_ );
}

=item
getContactName($email)

Returns the friendly name used by this contact, if they are on your FL list. 

=cut

sub getContactName
{
	my $self = shift;

	return $self->{Notification}->getContactName( @_ );
}

=item
getContactStatus($email)

Returns the status of this contact, if they are on your FL list. 

=cut

sub getContactStatus
{
	my $self = shift;

	return $self->{Notification}->getContactName( @_ );
}

=item
findMember($email)

Looks for a member in an active SwitchBoard and returns the SB or undef, if not found

=cut

sub findMember
{
	my $self = shift;
	my $email = shift || '';

	foreach my $convo (values %{$self->getConvoList()})
	{
		my $members = $convo->getMembers();

		return $convo if( defined $members->{$email} );
	}

	return undef;
}

=item
broadcast($msg)

Broadcasts the message to all open conversations

=cut

sub broadcast
{
	my $self = shift;
	my $msg = shift || '';

	foreach my $convo (values %{$self->getConvoList()})
	{
		$convo->sendmsg( $1 );
	}
}

=item
call($email,$msg)

Calls the contact, starting a conversation with them.

=cut

sub call
{
	my $self = shift;

	$self->{Notification}->call( @_ );
}

=item
do_one_loop()

Process a single cycle's worth of incoming and outgoing messages.  This should be done at a regular intervals, prefereably under a second.

=cut

sub do_one_loop
{
	my $self = shift;

	return if( !$self->{Connected} );

	$self->{Notification}->ping( );

	foreach my $convo (values %{$self->getConvoList()})
	{
		$convo->p2pSendOne() if $convo->p2pWaiting;
	}

	my @ready = $self->{Select}->can_read(.1);
	foreach my $fh ( @ready )
	{
		# get filenumber associated with this socket's filehandle
		my $fn = $fh->fileno;

		# get the object assocatied with this socket
		my $connection = $self->{Connections}->{$fn};

		# DO WE NEED THIS CODE? if the connection is really dead, will it even be showing up in the list of filehandles that can be read from??
		# if the connection is dead, remove it from the select, delete it from the Connections list and output a warn
		if( !$connection->{Socket}->connected() )
		{
			$self->{Select}->remove( $fn );
			delete( $self->{Connections}->{fn} );
			warn "Killing dead socket";
			next;
		}

		sysread( $fh, $connection->{buf}, 2048, length( $connection->{buf} || '' ) );	 

		while( $connection->{buf} =~ s/^(.*?\n)// )
		{
			$connection->{line}= $1;
			my $incomingdata = $connection->{line};
			$incomingdata =~ s/[\r\n]//g;

			print( "($fn $connection->{Type}) RX: $incomingdata\n" ) if( $self->{ShowRX} );

			my $result = $connection->dispatch( $incomingdata );
			last if( $result && $result eq "wait" );
		}
	}
}


=item
setHandler($event, $handler)

$event should be an event listed in the events section.  These are called based on information sent by MSN,
receiving a message is an event, status changes are events, getting a call is an event, etc.

	 my $msn = new MSN;
	 $msn->setHandler( Connected => \&connected );
	 
	 sub connected {
		 my $self = shift;
		 print "Yay we connected";
	 }

=cut

sub setHandler
{
	my $self = shift;
	my ($event, $handler) = @_;

	$self->{handler}->{$event} = $handler;
}

=item
setHandlers( $event1 => $handler1, $event2 => $handler2)

Expects a list of events and handlers.

	  my $msn = new MSN;
	  $msn->setHandlers( Connected	  => \&connected,
								 Disconnected => \&disconnected );

=cut

sub setHandlers
{
	my $self = shift;
	my $handlers = { @_ };
	for my $event (keys %$handlers)
	{
		$self->setHandler( $event, $handlers->{$event} );
	}
}

sub call_event
{
	my $self = shift;
	my $receiver = shift;
	my $event = shift;

	# get and run the handler if it is defined
	my $function = $self->{handler}->{$event};
	return &$function( $receiver, @_ ) if( defined $function );

	# get and run the default handler if it is defined
	$function = $self->{handler}->{Default};
	return &$function( $receiver, $event, @_ ) if( defined $function );

	return undef;
}

=item
getNotification

Returns the MSN::Notification object if you have a need to interact with it directly.

=cut

sub getNotification
{
	my $self = shift;

	return $self->{Notification};
}

=item
getConvoList

Returns a hash of conversations (MSN::SwitchBoard objects) keyed by file number of the socket they are on.

=cut

sub getConvoList
{
	my $self = shift;

	my $convos = {};

	foreach my $fn (keys %{$self->{Connections}} )
	{
		if( $self->{Connections}->{$fn}->{Type} eq 'SB' )
		{
			$convos->{$fn} = $self->{Connections}->{$fn};
		}
	}

	return $convos;
}

=item
getConvo

Returns a conversation (MSN::SwitchBoard object) found by socket number.

=cut

sub getConvo
{
	my $self = shift;
	my $key = shift;

	if( defined $self->{Connections}->{$key} && $self->{Connections}->{$key}->{Type} eq 'SB' )
	{
		return $self->{Connections}->{$key};
	}

	return undef;
}


return 1;
__DATA__