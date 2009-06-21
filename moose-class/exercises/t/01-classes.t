# Your tasks ...
#
# Create a Person class in lib/Person.pm
#
# A Person has the following attributes:
#
# * first_name - read-write
# * last_name - read-write
#
# This class should also have a method named "full_name". This
# method should return the first and last name separated by a string
# ("Jon Smith").
#
# Write a BUILDARGS method for this class which allows the caller to
# pass a two argument array reference. These should be assigned to the
# first and last name respectively.
#
#   Person->new( [ 'Lisa', 'Smith' ] );
#
# Create an Employee class in lib/Employee.pm
#
# The Employee class is a subclass of Person
#
# An Employee has the following read-write attributes:
#
# * title - read-write
# * salary - read-write
# * ssn - read-only
#
# The Employee class should override the "full_name" method to
# append the employee's title in parentheses ("Jon Smith
# (Programmer)"). Use override() and super() for this.
#
# Finally, both classes should be free of Moose droppings, and should be
# immutable.

use strict;
use warnings;

use lib 't/lib';

use MooseClass::Tests;

use Person;
use Employee;

MooseClass::Tests::tests01();
