package HasAccount;

use Moose::Role;

has balance => (
    is => 'rw',
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

no Moose::Role;

1;
