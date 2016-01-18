#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'XSTest' );
}

diag( "Testing XSTest $XSTest::VERSION, Perl $], $^X" );
