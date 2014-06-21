package Employee;

use Moose;

extends 'Person';

has title  => ( is => 'rw' );
has salary => ( is => 'rw' );
has ssn    => ( is => 'ro' );

override full_name => sub {
    my $self = shift;

    return super() . q[ (] . $self->title . q[)];
};

no Moose;

__PACKAGE__->meta->make_immutable;

1;
