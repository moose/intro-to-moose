package Person;

use BankAccount;
use Moose;

with 'Printable';

has account => (
    is      => 'rw',
    isa     => 'BankAccount',
    default => sub { BankAccount->new },
    handles => [ 'deposit', 'withdraw' ],
);

has title => (
    is        => 'rw',
    predicate => 'has_title',
    clearer   => 'clear_title',
);

has first_name => ( is => 'rw' );

has last_name  => ( is => 'rw' );

sub BUILD {
    my $self = shift;

    $self->account->owner($self);
}

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
