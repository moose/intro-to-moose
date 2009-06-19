package BankAccount;

use List::Util qw( sum );
use Moose;

has balance => (
    is      => 'rw',
    isa     => 'Int',
    default => 100,
    trigger => sub { $_[0]->_record_difference( $_[1] ) },
);

has owner => (
    is       => 'rw',
    isa      => 'Person',
    weak_ref => 1,
);

has history => (
    is      => 'ro',
    isa     => 'ArrayRef[Int]',
    default => sub { [] },
);

sub BUILD {
    my $self = shift;

    $self->_record_difference( $self->balance );
}

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

sub _record_difference {
    my $self      = shift;
    my $new_value = shift;

    my $old_value = sum @{ $self->history };

    push @{ $self->history }, $new_value - ( $old_value || 0 );
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;
