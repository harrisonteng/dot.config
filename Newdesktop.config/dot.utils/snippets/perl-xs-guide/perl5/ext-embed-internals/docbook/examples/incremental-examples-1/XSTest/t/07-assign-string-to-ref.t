use strict;
use warnings;

use Test::More tests => 1;

use XSTest;

my $var;
XSTest::assign_string_to_ref(\$var);

# TEST
is ($var, "XSTest was here.", "assign_string_to_ref() works");


