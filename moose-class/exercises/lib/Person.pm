package Person;

use Moose;

use namespace::clean -except => "meta";

has [qw(first_name last_name)] => (
    is => "rw",
    required => 1,
);

sub full_name {
    my $self = shift;
    $self->first_name . " " . $self->last_name;
}

override BUILDARGS => sub {
    my ( $self, @args ) = @_;

    if ( @args == 1 and ref $args[0] eq 'ARRAY' ) {
        my %p; @p{qw(first_name last_name)} = @{ $args[0] };
        return \%p;
    } else {
        return super;
    }
};

__PACKAGE__->meta->make_immutable;

1;
