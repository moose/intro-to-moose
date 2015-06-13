A little bit about these exercises ...

## DIRECTORY CONTENTS

This directory contains exercises for the Intro to Moose class. Here's what's
what ...

* `t/*.t` - each .t file contains instructions on what the exercise is, and runs the tests to check your code.
* `t/lib/MooseClass/Tests.pm` - the actual tests all live in this module. It also shows many examples of how to use Moose's metaclass APIs for introspection.
* `lib` - this will be your working directory for most exercises. You'll be creating various classes and roles in here, and then testing against the test code.
* `answers` - code that passes all the tests for each section. You can look in here if you're stuck, or if you just want to see how someone else did these exercises.

## EXERCISES HOW-TO

The exercises are all (except for one) designed to be done in the form
of writing Perl modules and running tests against them.

You will create these modules in the lib/ directory. You will often
find yourself changing or extending the module you created in a
previous exercise, so don't delete anything from this directory as you
go.

The instructions on each exercise are in the associated .t file.

To run the tests, simply run this command:

    prove -lv t/test-name.t

The test file name will be something like 01-classes.t.

This command will run the tests in verbose mode so you will get clues as to
what exactly failed. Keep iterating on your code until the tests pass.
