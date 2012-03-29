use strict;
use warnings FATAL => 'all';

use Apache::Test;
use Apache::TestRequest;
use Apache::TestUtil qw(t_cmp t_write_file);
use Apache2::Const -compile => qw(HTTP_OK);

use File::Spec::Functions qw(catfile);

# skip test 2 - it will pass when run by itself
# but will fail under make test, since merging is completely
# borked in this module

plan tests => 2, todo => [2],
              need_module('mod_perl.c', 'mod_apreq2');

my $serverroot = Apache::Test::vars('serverroot');
my $servername = Apache::Test::vars('servername');

t_write_file(catfile($serverroot, qw(htdocs params.txt)), <DATA>);

{
  my $url = '/params/params.txt?foo=bar';

  my $response = GET $url;
  ok t_cmp($response->code, Apache2::Const::HTTP_OK, "$url status");

  chomp(my $received = $response->content);
  chomp(my $expected = <<EOF);
The URI is /params/params.txt

Server name is $servername

CGI params are:
<table>
<tr>
<td>foo</td>  <td>bar</td>
</tr>
EOF

  ok t_cmp($received, $expected, "$url content");
}

__END__
The URI is [% uri %]

Server name is [% env.SERVER_NAME %]

CGI params are:
<table>[% FOREACH key = params.keys %]
<tr>
<td>[% key %]</td>  <td>[% params.$key %]</td>
</tr>
[% END %]
