#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use TAP::Harness;


### construct a hash of test_filename => answer_libdir
my %test2anslib =
    map {
        my $answer_libdir = $_;
        my ($exercise_num) = $answer_libdir =~ m!/(\d+)-!
            or die "can't parse dir name '$answer_libdir'";

        map {$_ => $answer_libdir}
        glob "$FindBin::RealBin/../t/$exercise_num-*.t";
    }
    # filter to find just answer libdirs
    grep m!/\d+-[\w-]+/$!,
    # list all dirs below this t/ dir
    glob "$FindBin::RealBin/*/"; 



my $harness = TAP::Harness->new({
    failures => 1,
    exec => sub {
        my ($h,$testfile) = @_;
        my $ans_libdir = $test2anslib{$testfile} or die "test file $testfile not found??";
        [$^X, "-I$ans_libdir", $testfile ]
    },
});

chdir "$FindBin::RealBin/../";
$harness->runtests( sort keys %test2anslib );
