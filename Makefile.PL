
# $Id: Makefile.PL,v 1.4 2008/12/25 23:41:14 Martin Exp $

use inc::Module::Install;

name('WWW-Search-Yahoo-China');
version(1.003);

author('Martin Thurn <mthurn@cpan.org>');
license('perl');

requires( perl => '5.004' );
requires('Data::Dumper');
build_requires('Encode');
build_requires('I18N::Charset');
# Test::More is needed for `make test`:
build_requires('Test::More');
requires('WWW::Search::Yahoo');
build_requires('WWW::Search::Test' => 2.265);

WriteAll;

__END__
