package Report;

use Moose;

extends 'Document';

has 'summary' => ( is => 'ro' );

augment output => sub {
    my $self = shift;

    my $content = inner();

    my $s = $self->summary;

    return <<"EOF";
$s

$content
EOF
};

no Moose;

__PACKAGE__->meta->make_immutable;

1;
