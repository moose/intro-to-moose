#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use TAP::Harness;

my $harness = TAP::Harness->new(
    {
        failures => 1,
        exec     => sub {
            my ( undef, $testfile ) = @_;

            my ($number) = $testfile =~ m{^t/(\d+)};

            return [ $^X, $testfile ] if $number eq '00';

            my ($libdir) = glob "answers/$number-*"
                or die "Cannot find an answer dir for $testfile";

            [ $^X, "-I$libdir", $testfile ];
        },
    }
);

chdir "$FindBin::RealBin/../";
$harness->runtests( sort glob 't/*.t' );
