package TPSReport;

use Moose;

extends 'Report';

has [ qw( t p s ) ] => ( is => 'ro' );

augment output => sub {
    my $self = shift;

    return join q{}, map { "$_: " . $self->$_ . "\n" } qw( t p s );
};

no Moose;

__PACKAGE__->meta->make_immutable;

1;
