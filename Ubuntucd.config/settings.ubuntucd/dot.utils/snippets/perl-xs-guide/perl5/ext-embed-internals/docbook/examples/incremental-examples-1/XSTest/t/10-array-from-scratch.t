use strict;
use warnings;

use Test::More tests => 7;

use XSTest;

{
    my @array1 = (0, 1, 200, 33);
    my @array2 = (4004, 50);

    my $combined = XSTest::concat_two_array_refs(\@array1, \@array2);
    # TEST
    is_deeply(
        $combined,
        [0, 1, 200, 33, 4004, 50],
        "concat_two_array_refs - 1"
    );
}

{
    my $combined;

    {
        my @array1 = ("Hon", "Ton", "Gorgon");
        my @array2 = ("Look", "Mook", "Crook");

        $combined = XSTest::concat_two_array_refs(\@array1, \@array2);
    }

    # TEST
    is_deeply(
        $combined,
        [qw(Hon Ton Gorgon Look Mook Crook)],
        "concat_two_array_refs - original go out of scope"
    );
}

package MyTestDestroyed;

use vars (qw(@log));

sub new
{
    my $class = shift;
    my $self = {};
    
    bless $self, $class;

    $self->{'id'} = shift;

    return $self;
}

sub DESTROY
{
    my $self = shift;

    push @log, "$self->{id} was Destroyed";
}

package main;

{
    {
        my $combined;

        {
            my @array1 = ("One", MyTestDestroyed->new("CamelCase"));
            my @array2 = (20,30,40);

            $combined = XSTest::concat_two_array_refs(\@array1, \@array2);
            # $combined = [@array1, @array2];
        }

        # TEST
        is ($combined->[0], "One", 
            "concat_two_arrays - Garbage Collection - elem 0"
        );

        # TEST
        is ($combined->[1]->{'id'}, "CamelCase", 
            "concat_two_arrays - Garbage Collection - elem 1/id"
        );

    }

    # TEST
    is_deeply(
        \@MyTestDestroyed::log,
        ["CamelCase was Destroyed"],
        "concat_two_arrays - Garbage Collection - object was destroyed.",
    );

    @MyTestDestroyed::log = ();
}

{
    my @array1 = (0, 1, 200, 33);
    my @array2 = (4004, 50);

    my $combined = XSTest::concat_two_array_refs(\@array1, \@array2);

    $array1[0] .= "Hello";

    # TEST
    is_deeply(
        $combined,
        [0, 1, 200, 33, 4004, 50],
        "concat_two_array_refs - 1"
    );

    $combined->[1] .= "suffix";

    # TEST
    is_deeply(
        \@array1,
        ["0Hello", 1, 200, 33],
    );
}

