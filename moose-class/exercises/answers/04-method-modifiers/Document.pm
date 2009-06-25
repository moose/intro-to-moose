package Document;

use Moose;

has [ qw( title author ) ] => ( is => 'ro' );

sub output {
    my $self = shift;

    my $t = $self->title;
    my $a = $self->author;

    my $content = inner();

    return <<"EOF";
$t

$content

Written by $a
EOF
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;
