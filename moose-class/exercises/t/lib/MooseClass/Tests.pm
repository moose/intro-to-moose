package MooseClass::Tests;

use strict;
use warnings;

use Lingua::EN::Inflect qw( A PL_N );
use Test::More 'no_plan';

sub tests01 {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    has_meta('Person');

    check_isa( 'Person', ['Moose::Object'] );

    has_rw_attr( 'Person', $_ ) for qw( first_name last_name );

    has_method( 'Person', 'full_name' );

    no_droppings('Person');
    is_immutable('Person');

    person01();

    has_meta('Employee');

    check_isa( 'Employee', [ 'Person', 'Moose::Object' ] );

    has_rw_attr( 'Employee', $_ ) for qw( title salary );
    has_ro_attr( 'Employee', 'ssn' );

    has_overridden_method( 'Employee', 'full_name' );

    employee01();
}

sub tests02 {
    tests01();

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    no_droppings($_) for qw( Printable HasAccount );

    does_role( 'Person', $_ ) for qw( Printable HasAccount );
    has_method( 'Person', $_ ) for qw( as_string deposit withdraw );
    has_rw_attr( 'Person', 'balance' );

    does_role( 'Employee', $_ ) for qw( Printable HasAccount );

    person02();
    employee02();
}

sub tests03 {
    {
        local $Test::Builder::Level = $Test::Builder::Level + 1;

        has_meta('Person');
        has_meta('Employee');

        has_rw_attr( 'Person', 'title' );

        has_rw_attr( 'Employee', 'title', 'overridden' );
        has_rw_attr( 'Employee', 'salary_level' );
        has_ro_attr( 'Employee', 'salary' );

        has_method( 'Employee', '_build_salary' );
    }

    ok( ! Employee->meta->has_method('full_name'),
        'Employee no longer implements a full_name method' );

    my $person_title_attr = Person->meta->get_attribute('title');
    ok( !$person_title_attr->is_required, 'title is not required in Person' );
    is( $person_title_attr->predicate, 'has_title',
        'Person title attr has a has_title predicate' );
    is( $person_title_attr->clearer, 'clear_title',
        'Person title attr has a clear_title clearer' );

    my $balance_attr = Person->meta->get_attribute('balance');
    is( $balance_attr->default, 100, 'balance defaults to 100' );

    my $employee_title_attr = Employee->meta->get_attribute('title');
    is( $employee_title_attr->default, 'Worker',
        'title defaults to Worker in Employee' );

    my $salary_level_attr = Employee->meta->get_attribute('salary_level');
    is( $salary_level_attr->default, 1, 'salary_level defaults to 1' );

    my $salary_attr = Employee->meta->get_attribute('salary');
    ok( !$salary_attr->init_arg,   'no init_arg for salary attribute' );
    ok( $salary_attr->has_builder, 'salary attr has a builder' );

    person03();
    employee03();
}

sub tests04 {
    {
        local $Test::Builder::Level = $Test::Builder::Level + 1;

        has_meta('Document');
        has_meta('Report');
        has_meta('TPSReport');

        no_droppings('Document');
        no_droppings('Report');
        no_droppings('TPSReport');

        has_ro_attr( 'Document',  $_ ) for qw( title author );
        has_ro_attr( 'Report',    'summary' );
        has_ro_attr( 'TPSReport', $_ ) for qw( t p s );

        has_method( 'Document', 'output' );
        has_augmented_method( 'Report', 'output' );
        has_augmented_method( 'TPSReport', 'output' );
    }

    my $tps = TPSReport->new(
        title   => 'That TPS Report',
        author  => 'Peter Gibbons (for Bill Lumberg)',
        summary => 'I celebrate his whole collection!',
        t       => 'PC Load Letter',
        p       => 'Swingline',
        s       => 'flair!',
    );

    my $output = $tps->output;
    $output =~ s/\n\n+/\n/g;

    is( $output, <<'EOF', 'output returns expected report' );
That TPS Report
I celebrate his whole collection!
t: PC Load Letter
p: Swingline
s: flair!
Written by Peter Gibbons (for Bill Lumberg)
EOF
}

sub tests05 {
    {
        local $Test::Builder::Level = $Test::Builder::Level + 1;

        has_meta('Person');
        has_meta('Employee');
        no_droppings('Employee');
    }

    for my $attr_name ( qw( first_name last_name title ) ) {
        my $attr = Person->meta->get_attribute($attr_name);

        ok( $attr->has_type_constraint,
            "Person $attr_name has a type constraint" );
        is( $attr->type_constraint->name, 'Str',
            "Person $attr_name type is Str" );
    }

    {
        my $salary_level_attr = Employee->meta->get_attribute('salary_level');
        ok( $salary_level_attr->has_type_constraint,
            'Employee salary_level has a type constraint' );

        my $tc = $salary_level_attr->type_constraint;

        for my $invalid ( 0, 11, -14, 'foo', undef ) {
            my $str = defined $invalid ? $invalid : 'undef';
            ok( ! $tc->check($invalid),
                "salary_level type rejects invalid value - $str" );
        }

        for my $valid ( 1..10 ) {
            ok( $tc->check($valid),
                "salary_level type accepts valid value - $valid" );
        }
    }

    {
        my $salary_attr = Employee->meta->get_attribute('salary');

        ok( $salary_attr->has_type_constraint,
            'Employee salary has a type constraint' );

        my $tc = $salary_attr->type_constraint;

        for my $invalid ( 0, -14, 'foo', undef ) {
            my $str = defined $invalid ? $invalid : 'undef';
            ok( ! $tc->check($invalid),
                "salary type rejects invalid value - $str" );
        }

        for my $valid ( 1, 100_000, 10**10 ) {
            ok( $tc->check($valid),
                "salary type accepts valid value - $valid" );
        }
    }

    {
        my $ssn_attr = Employee->meta->get_attribute('ssn');

        ok( $ssn_attr->has_type_constraint,
            'Employee ssn has a type constraint' );

        my $tc = $ssn_attr->type_constraint;

        for my $invalid ( 0, -14, 'foo', undef, '123-ab-1241', '123456789' ) {
            my $str = defined $invalid ? $invalid : 'undef';
            ok( ! $tc->check($invalid),
                "ssn type rejects invalid value - $str" );
        }

        for my $valid ( '041-12-1251', '123-45-6789', '926-41-5820' ) {
            ok( $tc->check($valid),
                "ssn type accepts valid value - $valid" );
        }
    }
}

sub tests06 {
    {
        local $Test::Builder::Level = $Test::Builder::Level + 1;

        has_meta('BankAccount');
        no_droppings('BankAccount');

        has_rw_attr( 'BankAccount', 'balance' );
        has_rw_attr( 'BankAccount', 'owner' );
        has_ro_attr( 'BankAccount', 'history' );
    }

    my $ba_meta = BankAccount->meta;
    ok( $ba_meta->has_attribute('balance'),
        'BankAccount class has a balance attribute' );

    my $history_attr = $ba_meta->get_attribute('history');

    ok(
        $history_attr->meta()
            ->does_role('Moose::Meta::Attribute::Native::Trait::Array'),
        'BankAccount history attribute uses native delegation to an array ref'
    );

    ok( $ba_meta->get_attribute('balance')->has_trigger,
        'BankAccount balance attribute has a trigger' );

    my $person_meta = Person->meta;
    ok( ! $person_meta->has_attribute('balance'),
        'Person class does not have a balance attribute' );

    my $deposit_meth = $person_meta->get_method('deposit');
    isa_ok( $deposit_meth, 'Moose::Meta::Method::Delegation' );

    my $withdraw_meth = $person_meta->get_method('withdraw');
    isa_ok( $withdraw_meth, 'Moose::Meta::Method::Delegation' );

    ok( $ba_meta->get_attribute('owner')->is_weak_ref,
        'owner attribute is a weak ref' );

    person06();
}


sub has_meta {
    my $class = shift;

    ok( $class->can('meta'), "$class has a meta() method" )
        or BAIL_OUT("$class does not have a meta() method (did you forget to 'use Moose'?)");
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

sub has_rw_attr {
    my $class      = shift;
    my $name       = shift;
    my $overridden = shift;

    my $articled = $overridden ? "an overridden $name" : A($name);
    ok( $class->meta->has_attribute($name),
        "$class has $articled attribute" );

    my $attr = $class->meta->get_attribute($name);

    is( $attr->get_read_method, $name,
        "$name attribute has a reader accessor - $name()" );
    is( $attr->get_write_method, $name,
        "$name attribute has a writer accessor - $name()" );
}

sub has_ro_attr {
    my $class = shift;
    my $name  = shift;

    my $articled = A($name);
    ok( $class->meta->has_attribute($name),
        "$class has $articled attribute" );

    my $attr = $class->meta->get_attribute($name);

    is( $attr->get_read_method, $name,
        "$name attribute has a reader accessor - $name()" );
    is( $attr->get_write_method, undef,
        "$name attribute does not have a writer" );
}

sub has_method {
    my $class = shift;
    my $name  = shift;

    my $articled = A($name);
    ok( $class->meta->has_method($name), "$class has $articled method" );
}

sub has_overridden_method {
    my $class = shift;
    my $name  = shift;

    my $articled = A($name);
    ok( $class->meta->has_method($name), "$class has $articled method" );

    my $meth = $class->meta->get_method($name);
    isa_ok( $meth, 'Moose::Meta::Method::Overridden' );
}

sub has_augmented_method {
    my $class = shift;
    my $name  = shift;

    my $articled = A($name);
    ok( $class->meta->has_method($name), "$class has $articled method" );

    my $meth = $class->meta->get_method($name);
    isa_ok( $meth, 'Moose::Meta::Method::Augmented' );
}

sub no_droppings {
    my $class = shift;

    ok( !$class->can('has'), "no Moose droppings in $class" );
    ok( !$class->can('subtype'), "no Moose::Util::TypeConstraints droppings in $class" );
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

    is( $person->full_name, 'Bilbo Baggins',
        'full_name() is correctly implemented' );

    $person = Person->new( [ qw( Lisa Smith ) ] );
    is( $person->first_name, 'Lisa', 'set first_name from two-arg arrayref' );
    is( $person->last_name, 'Smith', 'set last_name from two-arg arrayref' );

    eval { Person->new( sub { 'foo' } ) };
    like( $@, qr/\QSingle parameters to new() must be a HASH ref/,
          'Person constructor still rejects bad parameters' );
}

sub employee01 {
    my $employee = Employee->new(
        first_name => 'Amanda',
        last_name  => 'Palmer',
        title      => 'Singer',
    );

    my $called = 0;
    my $orig_super = \&Employee::super;
    no warnings 'redefine';
    local *Employee::super = sub { $called++; goto &$orig_super };

    is( $employee->full_name, 'Amanda Palmer (Singer)',
        'full_name() is properly overriden in Employee' );
    ok( $called, 'Employee->full_name calls super()' );
}

sub person02 {
    my $person = Person->new(
        first_name => 'Bilbo',
        last_name  => 'Baggins',
        balance    => 0,
    );

    is( $person->as_string, 'Bilbo Baggins',
        'as_string() is correctly implemented' );

    account_tests($person);
}

sub employee02 {
    my $employee = Employee->new(
        first_name => 'Amanda',
        last_name  => 'Palmer',
        title      => 'Singer',
        balance    => 0,
    );

    is( $employee->as_string, 'Amanda Palmer (Singer)',
        'as_string() uses overridden full_name method in Employee' );

    account_tests($employee);
}

sub person03 {
    my $person = Person->new(
        first_name => 'Bilbo',
        last_name  => 'Baggins',
    );

    is( $person->full_name, 'Bilbo Baggins',
        'full_name() is correctly implemented for a Person without a title' );
    ok( !$person->has_title,
        'Person has_title predicate is working correctly (returns false)' );

    $person->title('Ringbearer');
    ok( $person->has_title, 'Person has_title predicate is working correctly (returns true)' );

    my $called = 0;
    my $orig_pred = \&Person::has_title;
    no warnings 'redefine';
    local *Person::has_title = sub { $called++; goto &$orig_pred };

    is( $person->full_name, 'Bilbo Baggins (Ringbearer)',
        'full_name() is correctly implemented for a Person with a title' );
    ok( $called, 'full_name in person uses the predicate for the title attribute' );

    $person->clear_title;
    ok( !$person->has_title, 'Person clear_title method cleared the title' );

    account_tests( $person, 100 );
}

sub employee03 {
    my $employee = Employee->new(
        first_name   => 'Jimmy',
        last_name    => 'Foo',
        salary_level => 3,
        salary       => 42,
    );

    is( $employee->salary, 30000,
        'salary is calculated from salary_level, and salary passed to constructor is ignored' );
}

sub person06 {
    my $person = Person->new(
        first_name => 'Bilbo',
        last_name  => 'Baggins',
    );

    isa_ok( $person->account, 'BankAccount' );
    is( $person->account->owner, $person,
        'owner of bank account is person that created account' );

    $person->deposit(10);
    is_deeply( $person->account->history, [ 100 ],
               'deposit was recorded in account history' );

    $person->withdraw(15);
    is_deeply( $person->account->history, [ 100, 110 ],
               'withdrawal was recorded in account history' );

    $person->withdraw(45);
    is_deeply( $person->account->history, [ 100, 110, 95 ],
               'withdrawal was recorded in account history' );
}

sub account_tests {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $person = shift;
    my $base_amount = shift || 0;

    $person->deposit(50);
    eval { $person->withdraw( 75 + $base_amount ) };
    like( $@, qr/\QBalance cannot be negative/,
          'cannot withdraw more than is in our balance' );

    $person->withdraw( 23 );

    is( $person->balance, 27 + $base_amount,
        'balance is 27 (+ starting balance) after deposit of 50 and withdrawal of 23' );
}

1;
