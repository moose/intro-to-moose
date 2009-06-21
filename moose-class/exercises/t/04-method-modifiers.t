# Your tasks ...
#
# You are going to make our Person and Employee classes capable of
# outputting an XML document describing the object.
#
# The document will contain a tag and value for each attribute.
#
# You will use method modifiers and roles to achieve this.
#
# Start by creating a new role, OutputsXML.
#
# This role should require an "as_xml" method in the classes which
# consume it.
#
# This role should also use an around modifier on the as_xml method in
# order to make sure the document is well-formed XML.
#
# This document will look something like this:
#
# <?xml version="1.0" encoding="UTF-8"?>
# <Person>
# <first_name>Joe</first_name>
# <last_name>Smith</last_name>
# </Person>
#
# Use the role to create the xml declaration (the first line) and the
# container tags (<person> or <employee>)
#
# The classes should return a list strings. Each string should be a
# tagged value for an attribute. For consistency, return the
# attributes in sorted order.
#
# ( '<first_name>Joe</first_name>', '<last_name>Smith</last_name>' )
#
# If an attribute is empty, just output an empty tag (<foo></foo>).
#
# Use an augment modifier in the Person and Employee classes to allow
# Employee to return just its own attributes.

use strict;
use warnings;

use lib 't/lib';

use MooseClass::Tests;

use Person;
use Employee;

MooseClass::Tests::tests04();
