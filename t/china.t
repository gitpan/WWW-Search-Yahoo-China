
# $Id: china.t,v 1.3 2008/12/25 23:40:46 Martin Exp $

use blib;
use Test::More no_plan;

use WWW::Search::Test;
BEGIN
  {
  use_ok('WWW::Search::Yahoo::China');
  }

tm_new_engine('Yahoo::China');
my $iDebug = 0;
my $iDump = 0;

# goto TEST_NOW;
# goto MULTI_TEST;

# This test returns no results (but we should not get an HTTP error):
diag("Sending 0-page query to cn.yahoo.com...");
$iDebug = 0;
$iDump = 0;
tm_run_test('normal', $WWW::Search::Test::bogus_query, 0, 0, $iDebug, $iDump);
# goto ALL_DONE; # for testing
TEST_NOW:
pass();
$iDebug = 0;
$iDump = 0;
# This query returns 1 page of results:
diag("Sending 1-page query to cn.yahoo.com...");
TODO:
  {
  $TODO = q{I need a Chinese reader to implement the result-count regex};
  tm_run_test('normal',
              # "\xE8\xAF\xB7\xE4\xB9\xA6\xE7\x9A\x84\xE5\x86\x99\xE6\xB3\x95",
              'wiz'.'ardery',
              1, 99, $iDebug, $iDump, {ei => 'UTF-8'});
  $TODO = '';
  } # end of TODO block
my @ao = $WWW::Search::Test::oSearch->results();
cmp_ok(0, '<', scalar(@ao), 'got any results');
foreach my $oResult (@ao)
  {
  like($oResult->url, qr{\Ahttp://},
       'result URL is http');
  cmp_ok($oResult->title, 'ne', '',
         'result Title is not empty');
  cmp_ok($oResult->description, 'ne', '',
         'result description is not empty');
  } # foreach
# goto ALL_DONE;
MULTI_TEST:
pass();
diag("Sending multi-page query to cn.yahoo.com...");
$iDebug = 0;
$iDump = 0;
# This query returns MANY pages of results:
TODO:
  {
  $TODO = q{I need a Chinese reader to implement the result-count regex};
  tm_run_test('normal', "\xCB\xBD", 21, undef, $iDebug, $iDump);
  $TODO = '';
  } # end of TODO block

ALL_DONE:
pass();

__END__

