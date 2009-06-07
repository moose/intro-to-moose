package Person;

use Moose;

has first_name => ( is => 'rw' );
has last_name  => ( is => 'rw' );

sub full_name {
    my $self = shift;

    return join q{ }, $self->first_name, $self->last_name;
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;
