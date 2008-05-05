
# $Id: Makefile.PL,v 1.3 2008/05/05 10:26:16 Martin Exp $

use inc::Module::Install;

name('WWW-Search-Yahoo-China');
version(1.002);

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
