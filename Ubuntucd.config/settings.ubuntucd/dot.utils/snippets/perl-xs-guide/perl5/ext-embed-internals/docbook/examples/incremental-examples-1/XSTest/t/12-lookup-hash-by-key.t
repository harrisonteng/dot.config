use strict;
use warnings;

use Test::More tests => 5;

use XSTest;

{
    my $value = XSTest::lookup_value_in_hash(
        { 'key1' => "Success100" }, 
        "key1"
    );

    # TEST
    is ($value, "Success100", "Lookup is OK.")
}

{
    my %hash =
    (
        'first' => "David",
        'last' => "Ben-Yishay",
        'title' => "King",
        'sex' => "M",
        'age' => 25,
        'wife' => "Michal",
    );

    # TEST
    is (XSTest::lookup_value_in_hash(
            \%hash,
            "first"
        ),
        "David",
        "Lookup first",
    );

    # TEST
    is (XSTest::lookup_value_in_hash(
            \%hash,
            "age"
        ),
        25,
        "Lookup age",
    );

    # TEST
    ok (!defined(XSTest::lookup_value_in_hash(
            \%hash,
            "does-not-exist",
        )),
        "Lookup of non-existent key."
    );
}

{
    my $value = XSTest::lookup_value_in_hash(
        { "012\0abc" => "That's OK", }, 
        "012\0abc",
    );

    # TEST
    is ($value, "That's OK", "Lookup of strings containing NUL is OK.")
}
