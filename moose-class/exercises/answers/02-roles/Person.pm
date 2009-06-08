package Person;

use Moose;

with 'Printable', 'HasAccount';

has first_name => ( is => 'rw' );
has last_name  => ( is => 'rw' );

sub full_name {
    my $self = shift;

    return join q{ }, $self->first_name, $self->last_name;
}

sub as_string { $_[0]->full_name }

no Moose;

__PACKAGE__->meta->make_immutable;

1;
