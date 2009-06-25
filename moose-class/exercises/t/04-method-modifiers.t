# Your tasks ...
#
# First, we will create a set of three new classes to make use of the
# augment method modifier. The class hierarchy will look like this:
#
#   Document
#      |
#   Report
#      |
#   TPSReport
#
# The Document class should have two read-only attributes: "title" and
# "author".
#
# The Report class should have one read-only attributes: "summary".
#
# Finally, the TPSReport class should have three read-only attributes:
# "t", "p", and "s".
#
# The goal is to produce a report that looks this:
#
# $title
#
# $summary
#
# t: $t
# p: $p
# s: $s
#
# Written by $author
#
# This report will be a string returned by the Document->output
# method.
#
# Don't worry too much about how many newlines separate each item (as
# long as it's at least one). The test does a little massaging to make
# this more forgiving.
#
# Use augment method modifiers in Report and TPSReport to "inject" the
# relevant content, while Document will output the $title and $author.

use strict;
use warnings;

use lib 't/lib';

use MooseClass::Tests;

use TPSReport;

MooseClass::Tests::tests04();
