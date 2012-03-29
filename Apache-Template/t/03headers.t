use strict;
use warnings FATAL => 'all';

use Apache::Test;
use Apache::TestRequest;
use Apache::TestUtil qw(t_cmp t_write_file t_debug);
use Apache2::Const -compile => qw(HTTP_OK);

use File::Spec::Functions qw(catfile);

# skip tests 5 and 6 - they will pass when run by themselves
# but will fail under make test, since merging is completely
# borked in this module

plan tests => 6, todo => [5,6],
              need_module('mod_perl.c', 'mod_apreq2');

my $serverroot = Apache::Test::vars('serverroot');

t_write_file(catfile($serverroot, qw(htdocs headers.txt)), <DATA>);

{
  my $url = '/tt2/headers.txt';

  my $response = GET $url;
  ok t_cmp($response->code, Apache2::Const::HTTP_OK, "$url status");

  t_debug("$url has no ETag header");
  ok(! $response->header('ETag'));

  t_debug("$url has no Last-Modified header");
  ok(! $response->header('Last-Modified'));
}

{
  my $url = '/headers/headers.txt';

  my $response = GET $url;
  ok t_cmp($response->code, Apache2::Const::HTTP_OK, "$url status");

  t_debug("$url has an ETag header");
  ok($response->header('ETag'));

  t_debug("$url has a Last-Modified header");
  ok($response->header('Last-Modified'));
}

__END__
[% PERL %] print 'perl'; [% END %]
