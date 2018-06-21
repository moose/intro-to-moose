# Your tasks ...
#
# You will go back to the Person class and add several method modifiers.
#
# First, add before and after modifiers to the full_name() method. The
# modifiers will be using for debugging. These modifiers will record debugging
# info by setting a package global, @Person::CALL;
#
# The before modifier should push the string "calling full_name" onto
# @Person::CALL. The after modifier should push "called full_name" onto this
# array.
#
# You do not need to declare this global, but you can if you like.
#
# Finally, create an around modifier for full_name. This modifier should call
# the real full_name method.
#
# However, if the person object's last name is "Wall" (as in Larry Wall), your
# modifier should wrap the full name in asterisks (*), one before the name and
# one after, and then return that new version of the name.
use strict;
use warnings;

use FindBin qw( $Bin );
use lib "$Bin/lib";

use MooseClass::Tests;

MooseClass::Tests::tests04();
