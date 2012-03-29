#!perl

use 5.008;

use ModPerl::MM ();
use Apache::Test;
use Apache::TestMM qw(test clean);
use Apache::TestRunPerl ();
Apache::TestMM::filter_args();
Apache::TestRunPerl->generate_script();

ModPerl::MM::WriteMakefile(
    'NAME'         => 'Apache::Template',
    'VERSION_FROM' => 'lib/Apache/Template.pm',
    'PMLIBDIRS'    => [ 'lib' ],
    'PREREQ_PM'    => {
        Template             => 2.10,
        Digest::MD5          => 2.09,
        Apache2::Request     => 0,
        mod_perl2            => 0,
    },
);

