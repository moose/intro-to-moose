use strict;
use warnings;

use lib 't/lib';

use Test::More tests => 1;

my %prereqs = (
    'Moose'      => '2.1800',
);

my @missing;
for my $mod ( keys %prereqs ) {
    eval "require $mod";

    if ($@) {
        push @missing, "$mod is not installed";
        next;
    }

    if ( $mod->VERSION < $prereqs{$mod} ) {
        push @missing, "$mod must be version $prereqs{$mod} or greater (you have " . $mod->VERSION . ")";
    }
}

if (@missing) {
    diag "\n***********************************************************\n";
    diag "\n";
    diag " Found the following prereq problems ...\n";
    diag "   $_\n" for @missing;
    diag "\n";
    diag " ***********************************************************\n";
}

ok( ! @missing, 'Checking for prereqs' );
