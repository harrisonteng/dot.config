use strict;
use warnings;

use Test::More tests => 2;

use XSTest;

# TEST
is (XSTest::get_24(), 24, "Test get_24 once");

# TEST
is (XSTest::get_24(), 24, "Test get_24 again");

