use strict;
use warnings;

use Test::More tests => 1;

use XSTest;

{
    my @array = (0,1,2,3,40,5,6);
    XSTest::assign_to_array(\@array, 4, 400);
    # TEST
    is_deeply(
        \@array,
        [0,1,2,3,400,5,6],
        "assign_to_array test - 1"
    );
}
