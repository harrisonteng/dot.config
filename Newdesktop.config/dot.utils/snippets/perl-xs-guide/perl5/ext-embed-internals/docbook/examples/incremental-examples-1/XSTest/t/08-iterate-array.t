use strict;
use warnings;

use Test::More tests => 4;

use XSTest;

# TEST
is (XSTest::sum([]), 0, "sum of an empty array is 0.");

# TEST
is (XSTest::sum([5,6]), 11, "sum of two numbers");

# TEST
is (XSTest::sum([100.54]), 100.54, "summing one (real) number");

{
    my @array = (-5, 6, 120);
    # TEST
    is (XSTest::sum(\@array), 121, "summing array with negative indices");
}

