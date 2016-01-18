use strict;
use warnings;

use Test::More tests => 1;
use File::Spec;

open my $hello_output_fh, "-|", $^X, 
    File::Spec->catfile("t", "lib", "scripts", "hello.pl");

my $ret = do { local $/; <$hello_output_fh> };

close ($hello_output_fh);

# TEST
is ($ret, "Hello World!\n",
    "The hello XS function returned the correct output."
);

