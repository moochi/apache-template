use strict;
use warnings FATAL => 'all';

use Apache::Test;
use Apache::TestRequest;
use Apache::TestUtil qw(t_cmp t_write_file t_debug);
use Apache2::Const -compile => qw(HTTP_OK);

use File::Spec::Functions qw(catfile);

# skip test 2 - it will pass when run by itself
# but will fail under make test, since merging is completely
# borked in this module

plan tests => 2, todo => [2],
              need_module('mod_perl.c', 'mod_apreq2');

my $serverroot = Apache::Test::vars('serverroot');

t_write_file(catfile($serverroot, qw(htdocs ct.txt)), <DATA>);

{
  my $url = '/ct/ct.txt';

  my $response = GET $url;

  ok t_cmp($response->code, Apache2::Const::HTTP_OK, "$url status");

  ok t_cmp($response->content_type,
           'text/xml',
           "$url has Content-Type 'text/xml'");
}

__END__
[% PERL %] print 'perl'; [% END %]
