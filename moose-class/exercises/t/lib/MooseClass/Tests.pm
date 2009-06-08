package MooseClass::Tests;

use strict;
use warnings;

use Lingua::EN::Inflect qw( A PL_N );
use Test::More 'no_plan';

sub tests01 {
    my %p = (
        person_attr_count   => 2,
        employee_attr_count => 3,
        @_,
    );

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    has_meta('Person');

    check_isa( 'Person', ['Moose::Object'] );

    count_attrs( 'Person', $p{person_attr_count} );

    has_rw_attr( 'Person', $_ ) for qw( first_name last_name );

    has_method( 'Person', 'full_name' );

    no_droppings('Person');
    is_immutable('Person');

    person01();

    has_meta('Employee');

    check_isa( 'Employee', [ 'Person', 'Moose::Object' ] );

    count_attrs( 'Employee', $p{employee_attr_count} );

    has_rw_attr( 'Employee', $_ ) for qw( position salary );
    has_ro_attr( 'Employee', 'ssn' );

    has_overridden_method( 'Employee', 'full_name' );

    employee01();
}

sub tests02 {
    tests01( person_attr_count => 3 );

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    no_droppings($_) for qw( Printable HasAccount );

    does_role( 'Person', $_ ) for qw( Printable HasAccount );
    has_method( 'Person', $_ ) for qw( as_string deposit withdraw );
    has_rw_attr( 'Person', 'balance' );

    does_role( 'Employee', $_ ) for qw( Printable HasAccount );

    person02();
    employee02();
}

sub has_meta {
    my $class = shift;

    ok( $class->can('meta'), "$class has a meta() method" )
        or BAIL_OUT("Cannot run tests against a class without a meta!");
}

sub check_isa {
    my $class   = shift;
    my $parents = shift;

    my @isa = $class->meta->linearized_isa;
    shift @isa;    # returns $class as the first entry

    my $count = scalar @{$parents};
    my $noun = PL_N( 'parent', $count );

    is( scalar @isa, $count, "$class has $count $noun" );

    for ( my $i = 0; $i < @{$parents}; $i++ ) {
        is( $isa[$i], $parents->[$i], "parent[$i] is $parents->[$i]" );
    }
}

sub count_attrs {
    my $class = shift;
    my $count = shift;

    my $noun = PL_N( 'attribute', $count );
    is(
        scalar $class->meta->get_attribute_list, $count,
        "$class defines $count $noun"
    );
}

sub has_rw_attr {
    my $class = shift;
    my $name  = shift;

    my $article = A($name);
    ok( $class->meta->has_attribute($name),
        "$class has $article $name attribute" );

    my $attr = $class->meta->get_attribute($name);

    is(
        $attr->get_read_method, $name,
        "$name attribute has a reader accessor - $name()"
    );
    is(
        $attr->get_write_method, $name,
        "$name attribute has a writer accessor - $name()"
    );
}

sub has_ro_attr {
    my $class = shift;
    my $name  = shift;

    my $article = A($name);
    ok( $class->meta->has_attribute($name),
        "$class has $article $name attribute" );

    my $attr = $class->meta->get_attribute($name);

    is(
        $attr->get_read_method, $name,
        "$name attribute has a reader accessor - $name()"
    );
    is(
        $attr->get_write_method, undef,
        "$name attribute does not have a writer"
    );
}

sub has_method {
    my $class = shift;
    my $name  = shift;

    my $article = A($name);
    ok( $class->meta->has_method($name), "$class has $article $name method" );
}

sub has_overridden_method {
    my $class = shift;
    my $name  = shift;

    my $article = A($name);
    ok( $class->meta->has_method($name), "$class has $article $name method" );

    my $meth = $class->meta->get_method($name);
    isa_ok( $meth, 'Moose::Meta::Method::Overridden' );
}

sub no_droppings {
    my $class = shift;

    ok( !$class->can('has'), "no Moose droppings in $class" );
}

sub is_immutable {
    my $class = shift;

    ok( $class->meta->is_immutable, "$class has been made immutable" );
}

sub does_role {
    my $class = shift;
    my $role  = shift;

    ok( $class->meta->does_role($role), "$class does the $role role" );
}

sub person01 {
    my $person = Person->new(
        first_name => 'Bilbo',
        last_name  => 'Baggins',
    );

    is(
        $person->full_name, 'Bilbo Baggins',
        'full_name() is correctly implemented'
    );
}

sub employee01 {
    my $employee = Employee->new(
        first_name => 'Amanda',
        last_name  => 'Palmer',
        position   => 'Singer',
    );

    is(
        $employee->full_name, 'Amanda Palmer (Singer)',
        'full_name() is properly overriden in Employee'
    );
}

sub person02 {
    my $person = Person->new(
        first_name => 'Bilbo',
        last_name  => 'Baggins',
        balance    => 0,
    );

    is(
        $person->as_string, 'Bilbo Baggins',
        'as-string() is correctly implemented'
    );

    account_tests($person);
}

sub employee02 {
    my $employee = Employee->new(
        first_name => 'Amanda',
        last_name  => 'Palmer',
        position   => 'Singer',
        balance    => 0,
    );

    is(
        $employee->as_string, 'Amanda Palmer (Singer)',
        'as_string() uses overridden full_name method in Employee'
    );

    account_tests($employee);
}

sub account_tests {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $person = shift;

    $person->deposit(50);
    eval { $person->withdraw(75) };
    like(
        $@, qr/\QBalance cannot be negative/,
        'cannot withdraw more than is in our balance'
    );

    $person->withdraw(23);

    is( $person->balance, 27,
        'balance is 25 after deposit of 50 and withdrawal of 23' );
}

1;
