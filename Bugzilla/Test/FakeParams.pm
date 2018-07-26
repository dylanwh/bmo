# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.
package Bugzilla::Test::FakeParams;
use 5.10.1;
use strict;
use warnings;
use Try::Tiny;
use Capture::Tiny qw(capture_merged);
use Test2::Tools::Mock qw(mock);

use Bugzilla::Test::FakeDB;
use Bugzilla::Config;

our $Params;
our $Mock = mock 'Bugzilla::Config' => (
    override => [
        '_read_file' => sub {
            my ($class) = @_;
            return {} unless $Params;
            my $s = Safe->new;
            $s->reval($Params);
            die "Error evaluating params: $@" if $@;
            return { %{ $s->varglob('param') } };
        },
        '_write_file' => sub {
            my ($class, $str) = @_;
            $Params = $str;
        },
    ],
);

sub import {
    my ($self, %answers) = @_;
    Bugzilla::Test::FakeDB->initialize_database;
    my $Bugzilla = mock 'Bugzilla' => (
        override => [
            installation_answers => sub { \%answers },
        ],
    );
    capture_merged {
        Bugzilla::Config::update_params();
    };
    return;
}


1;