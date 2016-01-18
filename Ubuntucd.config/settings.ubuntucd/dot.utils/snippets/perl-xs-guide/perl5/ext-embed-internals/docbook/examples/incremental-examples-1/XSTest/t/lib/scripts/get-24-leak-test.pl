#!/usr/bin/perl

use strict;
use warnings;

use blib;

use XSTest;

while (1)
{
    my $i = XSTest::get_24();
    $i++;
}
