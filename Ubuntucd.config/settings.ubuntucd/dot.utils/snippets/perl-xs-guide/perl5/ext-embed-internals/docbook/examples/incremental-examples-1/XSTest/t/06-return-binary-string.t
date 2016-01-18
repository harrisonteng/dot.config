use strict;
use warnings;

use Test::More tests => 4;

use XSTest;

# TEST
is (XSTest::get_xs_binary_string(), 
    join("\0", qw(a b c)),
    "get_xs_binray_string() returns the correct result"
);

# TEST
is (XSTest::get_xs_binary_string(), 
    join("\0", qw(a b c)),
    "XS String returns Hello - 2nd try"
);

my $var = XSTest::get_xs_binary_string();

# TEST
is ($var, join("\0", qw(a b c)), "Assignment works.");

$var = "Aloha";

# TEST
is ($var, "Aloha", 
    "Assigning a different value to the XS returned variable works."
);

