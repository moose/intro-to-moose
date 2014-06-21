package Person;

use Moose;

has title => (
    is        => 'rw',
    predicate => 'has_title',
    clearer   => 'clear_title',
);

has first_name => (
    is       => 'rw',
    required => 1,
);

has last_name => (
    is       => 'rw',
    required => 1,
);

sub BUILDARGS {
    my $class = shift;

    if ( @_ == 1 && 'ARRAY' eq ref $_[0] ) {
        return {
            first_name => $_[0]->[0],
            last_name  => $_[0]->[1],
        };
    }
    else {
        return $class->SUPER::BUILDARGS(@_);
    }
}

our @CALL;

before full_name => sub {
    push @CALL, 'calling full_name';
};

after full_name => sub {
    push @CALL, 'called full_name';
};

sub full_name {
    my $self = shift;

    my $title = join q{ }, $self->first_name, $self->last_name;
    $title .= q[ (] . $self->title . q[)]
        if $self->has_title;

    return $title;
}

around full_name => sub {
    my $orig = shift;
    my $self = shift;

    return $self->$orig unless $self->last_name eq 'Wall';

    return q{*} . $self->$orig . q{*};
};

sub as_string { $_[0]->full_name }

no Moose;

__PACKAGE__->meta->make_immutable;

1;
