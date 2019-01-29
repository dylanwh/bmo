# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.
use 5.10.1;
use strict;
use warnings;
use lib qw( . lib local/lib/perl5 );

use Bugzilla::Test::MockDB;
use Bugzilla::Test::MockParams (password_complexity => 'no_constraints');
use Bugzilla;
use Bugzilla::Constants;
BEGIN { Bugzilla->extensions }
use Test2::V0;
use Test2::Tools::Mock qw(mock mock_accessor);
use Test2::Tools::Exception qw(dies lives);
use ok 'Bugzilla::Search::Quicksearch';
use ok 'Bugzilla::Search';

my $CGI = mock 'Bugzilla::CGI' => (add_constructor => [fake_new => 'hash',]);
Bugzilla->usage_mode(USAGE_MODE_MOJO);
Bugzilla->request_cache->{cgi} = Bugzilla::CGI->fake_new();

like(
  dies { quicksearch('') },
  qr/buglist_parameters_required/,
  "Got right exception"
);

test_quicksearch(
  input  => "summary:batman OR summary:robin",
  params => {
    'bug_status' => ['UNCONFIRMED', 'CONFIRMED', 'IN_PROGRESS'],
    'field0-0-0' => 'short_desc',
    'field0-0-1' => 'short_desc',
    'type0-0-0'  => 'substring',
    'type0-0-1'  => 'substring',
    'value0-0-0' => 'batman',
    'value0-0-1' => 'robin',
  },
  sql_like => qr{
    IPOSITION\(bugs\.short_desc, \s+ '(?:batman|robin)'\) \s+ > \s+ 0
    \s+ OR \s+
    IPOSITION\(bugs\.short_desc, \s+ '(?:robin|batman)'\) \s+ > \s+ 0
  }xs
);

#my $search = Bugzilla::Search->new(params => scalar $cgi->Vars);
#diag $search->_sql, "\n";
test_quicksearch(
  input  => "summary:batman AND summary:robin",
  params => {
    'bug_status' => ['UNCONFIRMED', 'CONFIRMED', 'IN_PROGRESS'],
    'field0-0-0' => 'short_desc',
    'field1-0-0' => 'short_desc',
    'type0-0-0'  => 'substring',
    'type1-0-0'  => 'substring',
    'value0-0-0' => 'batman',
    'value1-0-0' => 'robin',
  },
  sql_like => qr{
    IPOSITION\(bugs\.short_desc, \s+ '(?:batman|robin)'\) \s+ > \s+ 0
    \s+ AND \s+
    IPOSITION\(bugs\.short_desc, \s+ '(?:robin|batman)'\) \s+ > \s+ 0
  }xs
);

test_quicksearch(
  input  => "ALL summary:batman AND summary:robin",
  params => {
    'field0-0-0' => 'short_desc',
    'field1-0-0' => 'short_desc',
    'type0-0-0'  => 'substring',
    'type1-0-0'  => 'substring',
    'value0-0-0' => 'batman',
    'value1-0-0' => 'robin',
  },
);

test_quicksearch(
  input  => "ALL+ summary:batman AND summary:robin",
  params => {
    'field0-0-0' => 'short_desc',
    'field1-0-0' => 'short_desc',
    'type0-0-0'  => 'substring',
    'type1-0-0'  => 'substring',
    'value0-0-0' => 'batman',
    'value1-0-0' => 'robin',
    'limit'      => 0,
  },
);

test_quicksearch(
  input       => "FIXED summary:batman AND summary:robin",
  sort_params => ['bug_status'],
  params      => {
    'bug_status' => ['RESOLVED', 'VERIFIED'],
    'resolution' => 'FIXED',
    'field0-0-0' => 'short_desc',
    'field1-0-0' => 'short_desc',
    'type0-0-0'  => 'substring',
    'type1-0-0'  => 'substring',
    'value0-0-0' => 'batman',
    'value1-0-0' => 'robin',
  },
);


done_testing;

sub test_quicksearch {
  my (%opt) = @_;
  my $cgi = Bugzilla->request_cache->{cgi} = Bugzilla::CGI->fake_new;
  quicksearch($opt{input});
  my $vars = $cgi->Vars;
  if ($opt{sort_params}) {
    foreach my $key (@{$opt{sort_params}}) {
      $vars->{$key} = [sort @{$vars->{$key} // []}];
    }
  }

  is($vars, $opt{params}, "test params: $opt{input}");
  if (my $sql = $opt{sql_like}) {
    my $search = Bugzilla::Search->new(params => $vars);
    like($search->_sql, $sql, "sql: $opt{input}");
  }
}

