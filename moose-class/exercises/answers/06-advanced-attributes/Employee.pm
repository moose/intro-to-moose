package Employee;

use Moose;

extends 'Person';

has '+title' => (
    default => 'Worker',
);

has salary_level => (
    is      => 'rw',
    default => 1,
);

has salary => (
    is       => 'ro',
    lazy     => 1,
    builder  => '_build_salary',
    init_arg => undef,
);

has ssn    => ( is => 'ro' );

sub _build_salary {
    my $self = shift;

    return $self->salary_level * 10000;
}

augment as_xml => sub {
    my $self = shift;

    return
        ( map { "<$_>" . ( $self->$_ || q{} ) . "</$_>" } qw( salary salary_level ssn ) ),
        inner();
};

no Moose;

__PACKAGE__->meta->make_immutable;

1;
