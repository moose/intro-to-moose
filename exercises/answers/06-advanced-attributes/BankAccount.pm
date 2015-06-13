package BankAccount;

use List::Util qw( sum );
use Moose;

has balance => (
    is      => 'rw',
    isa     => 'Int',
    default => 100,
    trigger => sub { shift->_record_balance(@_) },
);

has owner => (
    is       => 'rw',
    isa      => 'Person',
    weak_ref => 1,
);

has history => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRef[Int]',
    default => sub { [] },
    handles => { add_history => 'push' },
);

sub deposit {
    my $self   = shift;
    my $amount = shift;

    $self->balance( $self->balance + $amount );
}

sub withdraw {
    my $self   = shift;
    my $amount = shift;

    die "Balance cannot be negative"
        if $self->balance < $amount;

    $self->balance( $self->balance - $amount );
}

sub _record_balance {
    my $self = shift;
    shift;

    return unless @_;

    my $old_value = shift;

    $self->add_history($old_value);
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;
