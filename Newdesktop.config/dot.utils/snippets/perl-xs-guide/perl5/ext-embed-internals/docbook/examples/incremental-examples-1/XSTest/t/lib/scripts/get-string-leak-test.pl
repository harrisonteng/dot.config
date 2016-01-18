#!/usr/bin/perl

use strict;
use warnings;

use blib;

use XSTest;

my $count;
while (1)
{
    if (++$count % 1000 == 0)
    {
        print "$count\n";
    }
    my $s = XSTest::get_xs_string();
    $s .= "Hello";
}
