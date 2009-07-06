package Person;

use Moose;

with 'Printable', 'HasAccount';

has title => (
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_title',
    clearer   => 'clear_title',
);

has first_name => (
    is  => 'rw',
    isa => 'Str',
);

has last_name => (
    is  => 'rw',
    isa => 'Str',
);

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
