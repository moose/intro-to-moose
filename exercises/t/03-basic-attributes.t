# Your tasks ...
#
# Go back to your Person class and make the first_name and last_name
# attributes required.
#
# Move the title attribute from the Employee class to the Person
# class.
#
# Add a predicate (has_title) and clearer (clear_title) to the title
# attribute as well.
#
# Adjust full_name in the Person class so it includes the title, which is
# optional and has no default. If a person has no title, the full_name method
# should simply return the first and last name. Use the title's predicate
# method in the new full_name method.
#
# Go back to the Employee class.
#
# In the employee class, make default value for the title attribute the string
# 'Worker' (do not use a builder for this). You can now inherit full_name from
# the Person class rather than re-implementing it.
#
# Add a read-write salary_level attribute. This will be a number from
# 1-10 (but you will deal with enforcing this later). This attribute
# should default to 1.
#
# Make the salary attribute read-only. Also make it lazy. The default
# should be calculated as salary_level * 10000. Use a builder method
# to set the default. Name the builder "_build_salary". This attribute
# should not be settable via the constructor.
#
# Go back to the HasAccount role and make the balance default to 100.

use strict;
use warnings;

use FindBin qw( $Bin );
use lib "$Bin/lib";

use MooseClass::Tests;

MooseClass::Tests::tests03();
