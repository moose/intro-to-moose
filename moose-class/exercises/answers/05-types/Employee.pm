package Employee;

use Moose;
use Moose::Util::TypeConstraints;

extends 'Person';

has '+title' => (
    default => 'Worker',
);

subtype 'Int1To10',
    as    'Int',
    where { $_ >= 1 && $_ <= 10 };

has salary_level => (
    is      => 'rw',
    isa     => 'Int1To10',
    default => 1,
);

subtype 'PosInt',
    as    'Int',
    where { $_ > 0 };

has salary => (
    is       => 'ro',
    isa      => 'PosInt',
    lazy     => 1,
    builder  => '_build_salary',
    init_arg => undef,
);

subtype 'ValidSSN',
    as    'Str',
    where { /^\d\d\d-\d\d\-\d\d\d\d$/};

has ssn => (
    is  => 'ro',
    isa => 'ValidSSN',
);

sub _build_salary {
    my $self = shift;

    return $self->salary_level * 10000;
}

no Moose;
no Moose::Util::TypeConstraints;

__PACKAGE__->meta->make_immutable;

1;
