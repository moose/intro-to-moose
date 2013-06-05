# Your tasks ...
#
# First, you must make the account associated with a Person a proper
# class of its own. Call it BankAccount.
#
# This class should have two attributes, "balance", an Int that
# defaults to 100, and "owner", a Person object.
#
# The owner attribute should be a weak reference to prevent cycles.
#
# Copy the deposit and withdraw methods from the HasAccount role.
#
# Finally, add a read-only history attribute. This will be an ArrayRef of
# Int's. This should default to an empty array reference. Use a Native
# delegation method to push values onto this attribute.
#
# Use a trigger to record the _old value_ of the balance each time it
# changes. This means your trigger should not do anything if it is not passed
# an old value (this will be the case when the attribute is set for the first
# time). You can check for the presence of an old value by looking at the
# number of elements passed to the trigger in the @_ array.
#
# Now you can delete the HasAccount role entirely. Instead, add an "account"
# attribute to Person directly.
#
# This new account attribute should default to a new BankAccount object. Use
# delegation so that when the code calls Person->deposit and Person->withdraw,
# it calls those methods on the person's BankAccount object.
#
# Add a BUILD method to the Person class to set the owner of the
# Person's bank account to $self.

use strict;
use warnings;

use lib 't/lib';

use MooseClass::Tests;

MooseClass::Tests::tests06();
