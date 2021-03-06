use strict;
use warnings;
use utf8;
use Test::More;
use t::Util;
use File::Temp qw(tempdir);
use File::pushd;

use Minilla::Util qw(spew);
use Minilla::FileGatherer;
use Minilla::Git;

can_ok('Minilla::FileGatherer', 'new');

my $guard = pushd(tempdir());

mkdir 'local';
mkpath 'extlib/lib';
spew('local/foo', '...');
spew('extlib/lib/Foo.pm', '...');
spew('README', 'rrr');
spew('META.json', 'mmm');

git_init();
git_add('.');
git_commit('-m', 'foo');

my @files = Minilla::FileGatherer->new(
    exclude_match => ['^local/'],
)->gather_files('.');

is(join(',', sort @files), 'META.json,README');

done_testing;

