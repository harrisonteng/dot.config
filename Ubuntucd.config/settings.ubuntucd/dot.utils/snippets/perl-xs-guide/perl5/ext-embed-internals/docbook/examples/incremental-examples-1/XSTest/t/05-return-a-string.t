use strict;
use warnings;

use Test::More tests => 4;

use XSTest;

# TEST
is (XSTest::get_xs_string(), "Hello", "XS String returns Hello - 1st try");

# TEST
is (XSTest::get_xs_string(), "Hello", "XS String returns Hello - 2nd try");

my $var = XSTest::get_xs_string();

# TEST
is ($var, "Hello", "Assignment works.");

$var = "Aloha";

# TEST
is ($var, "Aloha", 
    "Assigning a different value to the XS returned variable works."
);

