#!/usr/bin/perl -w
#

use strict;

sub process{
    local $_ = join '', map { s/^\s+//; s/\s+$//; $_ } @_;
    s/<\?.*?\?>//; s/(?<=[^>])<\/\w+>/",/g;
    s/<\/\w+>/},/g; s/></",{"/g; s/>/","/g;
    s/</"/g; s/.*?{/{/; eval;
}

my %data = %{ process<STDIN> };

my $key = $ARGV[0];
print "$key=$data{$key}\n";

exit;
