use strict;
use warnings FATAL => 'all';

use Apache::Test;

# skip all tests unless mod_perl and mod_apreq are available
plan tests => 1, need_module('mod_perl.c', 'mod_apreq2.c');

ok 1;
