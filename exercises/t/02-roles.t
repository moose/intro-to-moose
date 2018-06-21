# Your tasks ...
#
# Create a Printable role. This role should simply require that the
# consuming class implement an "as_string" method.
#
# Make the Person class from the last set of exercises consume this
# role. Use full_name as the output for the as_string method. The
# Employee subclass should still override this output.
#
# Implement a role HasAccount. This should provide a read-write "balance"
# attribute. It should also implement "deposit" and "withdraw" methods. These
# methods will be passed a single argument, a positive number. Increment or
# decrement the balance by this amount. Attempting to reduce the cash balance
# below 0 via "withdraw" should die with an error that includes the string:
#
#   Balance cannot be negative
#
# Make the Person class consume this role as well.
#
# Make sure all roles are free of Moose droppings.

use strict;
use warnings;

use FindBin qw( $Bin );
use lib "$Bin/lib";

use MooseClass::Tests;

MooseClass::Tests::tests02();
