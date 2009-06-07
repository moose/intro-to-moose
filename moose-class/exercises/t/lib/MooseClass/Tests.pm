package MooseClass::Tests;

use strict;
use warnings;

use Lingua::EN::Inflect qw( PL_N );
use Test::More 'no_plan';

sub tests01 {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    has_meta('Person');

    check_isa( 'Person', ['Moose::Object'] );

    count_attrs( 'Person', 2 );

    has_rw_attr( 'Person', $_ ) for qw( first_name last_name );

    has_method( 'Person', 'full_name' );

    no_droppings('Person');
    is_immutable('Person');

    person01();

    has_meta('Employee');

    check_isa( 'Employee', [ 'Person', 'Moose::Object' ] );

    count_attrs( 'Employee', 3 );

    has_rw_attr( 'Employee', $_ ) for qw( position salary );
    has_ro_attr( 'Employee', 'ssn' );

    has_overridden_method( 'Employee', 'full_name' );

    employee01();
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
    is( scalar $class->meta->get_attribute_list, $count,
        "$class defines $count $noun" );
}

sub has_rw_attr {
    my $class = shift;
    my $name  = shift;

    ok( $class->meta->has_attribute($name), "$class has attribute - $name" );

    my $attr = $class->meta->get_attribute($name);

    is( $attr->get_read_method, $name,
        "$name attribute has a reader accessor - $name()" );
    is( $attr->get_write_method, $name,
        "$name attribute has a writer accessor - $name()" );
}

sub has_ro_attr {
    my $class = shift;
    my $name  = shift;

    ok( $class->meta->has_attribute($name), "$class has attribute - $name" );

    my $attr = $class->meta->get_attribute($name);

    is( $attr->get_read_method, $name,
        "$name attribute has a reader accessor - $name()" );
    is( $attr->get_write_method, undef,
        "$name attribute does not have a writer" );
}

sub has_method {
    my $class = shift;
    my $name  = shift;

    ok( $class->meta->has_method($name), "$class has a $name method" );
}

sub has_overridden_method {
    my $class = shift;
    my $name  = shift;

    ok( $class->meta->has_method($name), "$class has a $name method" );

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

sub person01 {
    my $person = Person->new(
        first_name => 'Bilbo',
        last_name  => 'Baggins',
    );

    is( $person->full_name, 'Bilbo Baggins',
        'full_name() is correctly implemented' );
}

sub employee01 {
    my $employee = Employee->new(
        first_name => 'Amanda',
        last_name  => 'Palmer',
        position   => 'Singer',
    );

    is( $employee->full_name, 'Amanda Palmer (Singer)',
        'full_name() is properly overriden in Employee' );
}


1;
