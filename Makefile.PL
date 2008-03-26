
# $Id: Makefile.PL,v 1.2 2008/03/26 03:21:28 Martin Exp $

use inc::Module::Install;

name('WWW-Search-Yahoo-China');
version(1.001);

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
