use Test::More tests => 5;

BEGIN {
use_ok( 'XSTest' );
}

my $obj = XSTest->new(1);
ok( $obj->increment );
ok( $obj->{value} == 2);

$obj = XSTest->new(value => 3);
ok( $obj->{value} == 3 );
ok( $obj->increment == 4 );
