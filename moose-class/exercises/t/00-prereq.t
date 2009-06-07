use strict;
use warnings;

my %prereqs = (
    'Test::More' => '0',
    'Moose'      => '0.80',
    'Class::MOP' => '0.85',
);

my @missing;
for my $mod ( keys %prereqs ) {
    eval "require $mod";

    if ($@) {
        push @missing, "$mod is not installed";
        next;
    }

    if ( $mod->VERSION < $prereqs{$mod} ) {
        push @missing, "$mod must be version $prereqs{$mod} or greater";
    }
}

if (@missing) {
    warn "\n# ***********************************************************\n";
    warn "#\n";
    warn "# Found the following prereq problems ...\n";
    warn "#   $_\n" for @missing;
    warn "#\n";
    warn "# ***********************************************************\n";

    exit 255;
}

Test::More->import;

plan( tests => 1 );
ok( 'Looks like you have all the prereqs' );

