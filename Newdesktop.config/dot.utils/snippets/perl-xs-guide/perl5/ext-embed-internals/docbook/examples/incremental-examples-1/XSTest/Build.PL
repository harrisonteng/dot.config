use strict;
use warnings;
use File::Spec;
use lib File::Spec->catdir(File::Spec->curdir(), "inc");

use Test::Run::Builder;


my $builder = Test::Run::Builder->new(
    module_name         => 'XSTest',
    license             => 'perl',
    dist_author         => 'Shlomi Fish <shlomif@iglu.org.il>',
    dist_version_from   => 'lib/XSTest.pm',
    include_dirs        => ['.'],
    requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'XSTest-*' ],
);

$builder->create_build_script();
