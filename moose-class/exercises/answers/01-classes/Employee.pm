package Employee;

use Moose;

extends 'Person';

has position => ( is => 'rw' );
has salary   => ( is => 'rw' );
has ssn      => ( is => 'ro' );

override full_name => sub {
    my $self = shift;

    return super() . q[ (] . $self->position . q[)];
};

no Moose;

__PACKAGE__->meta->make_immutable;

1;
