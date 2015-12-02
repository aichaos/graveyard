package Event::Handler;

# Create Instance of Event::Handler
sub new {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = {};
        my $args = shift;

        bless ($self, $class);
        
        return $self;
}

# Add a handler for an Event
sub add_handler
{
    my $self = shift;
    my $Event = shift;
    my $Handler = shift || undef;
    if (ref($Event) eq "ARRAY")
    {
        foreach my $E (@$Event)
        {
            $self->{events}->{$E} = $Handler;
        }
    }
    else
    {
        $self->{events}->{$Event} = $Handler;
    }
}

sub set_default
{
    my $self = shift;    
    my $Handler = shift || undef;
    $self->{default} = $Handler;    
}

sub get_events
{
    my $self = shift;
    return sort keys %{$self->{events}};
}

# Call Event, Pass it the array of arguments.
sub call_event
{
    my $self = shift;
    my $Event = shift;
    my $function = $self->{events}->{$Event};
    return &$function(@_) if (defined $function);
    $function = $self->{default};
    return &$function(@_) if (defined $function);
    return undef;
}

1;