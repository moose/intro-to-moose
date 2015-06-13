package Person;

use Moose;

with 'Printable', 'HasAccount';

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

sub full_name {
    my $self = shift;

    my $title = join q{ }, $self->first_name, $self->last_name;
    $title .= q[ (] . $self->title . q[)]
        if $self->has_title;

    return $title;
}

sub as_string { $_[0]->full_name }

no Moose;

__PACKAGE__->meta->make_immutable;

1;
