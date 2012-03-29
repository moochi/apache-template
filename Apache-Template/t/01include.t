use strict;
use warnings FATAL => 'all';

use Apache::Test;
use Apache::TestRequest;
use Apache::TestUtil qw(t_cmp t_write_file);
use Apache2::Const -compile => qw(HTTP_OK);

use File::Spec::Functions qw(catfile);

plan tests => 2, need_module('mod_perl.c', 'mod_apreq2.c');

my $serverroot = Apache::Test::vars('serverroot');

t_write_file(catfile($serverroot, qw(htdocs include.txt)), <DATA>);
t_write_file(catfile($serverroot, qw(templates plain)), <DATA>);

{
  my $url = '/tt2/include.txt';

  my $response = GET $url;
  ok t_cmp($response->code, Apache2::Const::HTTP_OK, "$url status");

  chomp(my $received = $response->content);
  chomp(my $expected = <<EOF);
plain
EOF

  ok t_cmp($received, $expected, "$url content");
}

__END__
[% INSERT plain %]
plain
