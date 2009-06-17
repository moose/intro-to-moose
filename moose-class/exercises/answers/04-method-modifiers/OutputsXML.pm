package OutputsXML;

use Moose::Role;

requires 'as_xml';

around as_xml => sub {
    my $orig = shift;
    my $self = shift;

    return
          qq{<?xml version="1.0" encoding="UTF-8"?>\n} . q{<}
        . ( ref $self ) . q{>} . "\n"
        . ( join "\n", $self->$orig(@_) ) . "\n" . q{</}
        . ( ref $self ) . q{>} . "\n";
};

no Moose::Role;

1;
