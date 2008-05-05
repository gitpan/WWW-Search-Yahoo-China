
# $Id: China.pm,v 2.12 2008/05/05 10:31:00 Martin Exp $

=head1 NAME

WWW::Search::Yahoo::China - WWW::Search backend for searching Yahoo! China

=head1 SYNOPSIS

  use WWW::Search;
  my $oSearch = new WWW::Search('Yahoo::China');
  my $sQuery = WWW::Search::escape_query("暴囂勧秤");
  $oSearch->native_query($sQuery);
  while (my $oResult = $oSearch->next_result())
    print $oResult->url, "\n";

=head1 DESCRIPTION

This class is a Yahoo! China specialization of L<WWW::Search>.  It
handles making and interpreting searches on Yahoo! China
F<http://cn.yahoo.com>.

This class exports no public interface; all interaction should
be done through L<WWW::Search> objects.

=head1 NOTES

I have no idea what character encoding(s) are accepted/expected by
Yahoo China's website.  To create/test this backend I just
cut-and-pasted Chinese characters from cn.yahoo.com.

It seems that if your query is in UTF-8, sending option {ei =>
'UTF-8'} makes it do the right thing.

=head1 PRIVATE METHODS

=over

=cut

package WWW::Search::Yahoo::China;

use strict;
use warnings;

use Data::Dumper;  # for debugging only
use WWW::Search::Yahoo 2.372;
use base 'WWW::Search::Yahoo';

our
$VERSION = do { my @r = (q$Revision: 2.12 $ =~ /\d+/g); sprintf "%d."."%03d" x $#r, @r };
our $MAINTAINER = 'Martin Thurn <mthurn@cpan.org>';

sub _native_setup_search
  {
  my ($self, $sQuery, $rh) = @_;
  $self->{'_options'} = {
                         'p' => $sQuery,
                         'scch' => 'on',
                         'stype' => '',
                        };
  $rh->{'search_base_url'} = 'http://cn.search.yahoo.com';
  $rh->{'search_base_path'} = '/search/cn';
  return $self->SUPER::_native_setup_search($sQuery, $rh);
  } # _native_setup_search

sub _where_to_find_count
  {
  my %hash = (
              _tag => 'span',
              class => 'num',
             );
  return \%hash;
  } # _where_to_find_count

sub _string_has_count
  {
  my $self = shift;
  my $s = shift;
  # I NEED A CHINESE READER TO SEND ME THE CORRECT PATTERN.
  return $1 if ($s =~ m!([,0-9]+)[^0-9]*\z!i);
  return -1;
  } # _string_has_count

sub _result_list_tags
  {
  return (
          _tag => 'div',
          class => 'i',
         );
  } # _result_list_tags

sub _result_list_items
  {
  my $self = shift;
  my $oTree = shift || die;
  my $oDIV = $oTree->look_down(
                               _tag => 'div',
                               class => 'rst'
                              );
  return () if ! ref $oDIV;
  my @ao = $oDIV->look_down(_tag => 'li');
  return @ao;
  } # _result_list_items

sub _a_is_next_link
  {
  my $self = shift;
  my $oA = shift;
  return 0 unless (ref $oA);
  # I can not type Chinese, nor even cut-and-paste into Emacs with
  # confidence that the encoding will not get screwed up, so I resort
  # to this ugliness:
  return ($oA->as_HTML =~ m!&Iuml;&Acirc;&Ograve;&raquo;&Ograve;&sup3;!i);
  } # _a_is_next_link

=item parse_details

Given a (portion of an) HTML::TreeBuilder tree
and a L<WWW::SearchResult> object,
parses one result out of the tree and populates the SearchResult.

=cut

sub parse_details
  {
  my $self = shift;
  # Required arg1 = (part of) an HTML parse tree:
  my $oLI = shift;
  # Required arg2 = a WWW::SearchResult object to fill in:
  my $hit = shift;
  # Grab the size & date:
  my $oDIV = $oLI->look_down(_tag => 'span',
                            );
  if (ref $oDIV)
    {
    my $sDIV = $oDIV->as_text;
    $sDIV =~ s!\240! !g;
    print STDERR " DDD Y::C found rel div =$sDIV=\n" if (2 <= $self->{_debug});
    if ($sDIV =~ m! - ([0-9KM]+) - !)
      {
      $hit->size($1);
      } # if
    if ($sDIV =~ m!/ / / ([-0-9/]+)/ / / !)
      {
      $hit->change_date($1);
      } # if
    $oDIV->detach;
    $oDIV->delete;
    } # if
  my $oTR = $oLI->look_down(_tag => 'p',
                           );
  if (ref $oTR)
    {
    $hit->description($oTR->as_text);
    } # if
  } # parse_details

1;

__END__

=back

=head1 SEE ALSO

To make new back-ends, see L<WWW::Search>.

=head1 BUGS

Please tell the maintainer if you find any!

=head1 AUTHOR

Martin Thurn <mthurn@cpan.org>

=head1 LICENSE

This software is released under the same license as Perl itself.

=cut
