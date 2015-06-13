# Your tasks ...
#
# In this set of exercises, you will return to your Person and
# Employee classes, and add appropriate types for every one of their
# attributes.
#
# In Person, the title, first_name, and last_name attributes should
# all be strings.
#
# In Employee, you will create several custom subtypes.
#
# The salary_level attribute should be an integer subtype that only
# allows for values from 1-10.
#
# The salary attribute should be a positive integer.
#
# Finally, the ssn attribute should be a string subtype that validates
# against a regular expression of /^\d\d\d-\d\d-\d\d\d\d$/

use strict;
use warnings;

use lib 't/lib';

use MooseClass::Tests;

MooseClass::Tests::tests05();
