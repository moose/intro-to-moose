# Your tasks ...
#
# First, we want to make the account associated with a Person a proper
# class. Call it BankAccount.
#
# This class should have two attributes, "balance", an Int that
# defaults to 100, and "owner", a Person object.
#
# The owner attribute should be a weak reference to prevent cycles.
#
# Copy the deposit and withdraw methods from the HasAccount role.
#
# Finally, add a read-only history attribute. This will be an ArrayRef
# of Int's. This should default to an empty array reference.
#
# Use a trigger to record the _difference_ after each change to the
# balance. The previous balance is the sum of all the previous
# changes. You can use List::Util's sum function to calculate this. To
# avoid warnings the first time history is recorded, default to 0 if
# history is empty.
#
# Use a BUILD method in BankAccount to record the original balance in
# the history.
#
# We will now delete the HasAccount role entirely. Instead, add an
# "account" attribute to Person directly.
#
# This new account attribute should default to a new BankAccount
# object. Use delegation so that we can call Person->deposit and
# Person->withdraw and have it call those methods on the person's
# BankAccount object.
#
# Add a BUILD method to the Person class to set the owner of the
# Person's bank account to $self.

use strict;
use warnings;

use lib 't/lib';

use MooseClass::Tests;

use Person;
use Employee;

MooseClass::Tests::tests06();
