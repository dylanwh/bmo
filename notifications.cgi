#!/usr/bin/perl -T
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

use 5.10.1;
use strict;
use warnings;

use lib qw(. lib local/lib/perl5);

#http://bmo-web.vm/request.cgi?action=queue&requestee=dylan%40mozilla.com&group=requestee&ctype=json
use Bugzilla;
use Bugzilla::Util;
use Bugzilla::Error;
use Bugzilla::Flag;
use Bugzilla::FlagType;
use Bugzilla::User;
use Bugzilla::Product;
use Bugzilla::Component;

# Make sure the user is logged in.
my $user = Bugzilla->login();
my $cgi = Bugzilla->cgi;
# Force the script to run against the shadow DB. We already validated credentials.
Bugzilla->switch_to_shadow_db;

my $dbh = Bugzilla->dbh;
my $userid = $user->id;

# This results in just one sql SELECT
my $groups = $user->groups_as_string;
my $rs = Bugzilla->model->resultset('Flag')->search_rs(
    {
        status             => '?',
        'requestee.userid' => $userid,
        -or                => [
            { 'bug_security.group_id' => undef },
            {
                'cc_security.who'       => { '!=' => undef },
                'bug.cclist_accessible' => 1,
            },
            {
                'bug.reporter' => $userid,
                'bug.reporter_accessible' => 1,
            },
            { 'bug.assigned_to' => $userid },
            { 'bug.qa_contact'  => $userid },
        ],
    },
    {
        rows     => 20,
        join => [
            'requestee',
            'requester',
            'type',
            'attachment',
            { 'bug' => [ 'bug_security', 'cc_security', 'bug_group_map' ] }
        ],
        order_by => 'me.modification_date',
        group_by => 'me.id',
        columns => {
            requester      => 'requester.login_name',
            requestee      => 'requestee.login_name',
            type           => 'type.name',
            status         => 'me.status',
            bug_id         => 'me.bug_id',
            bug_summary    => 'bug.short_desc',
            created        => 'me.modification_date',
            attach_id      => 'me.attach_id',
            ispatch        => 'attachment.ispatch'
            attach_summary => 'attachment.description'
            restricted     => { count => 'bug_group_map.group_id' },
        },
        result_class => 'DBIx::Class::ResultClass::HashRefInflator',
    }
);

print $cgi->header('application/json');
print json_response([ $rs->all ]);

sub json_response {
    my ($requests) = @_;
    my @display_columns = (
        "requester", "requestee",      "type",    "status",  "bug_id", "bug_summary",
        "attach_id", "attach_summary", "ispatch", "created", "category", "restricted"
    );
    my @results;
    foreach my $request (@$requests) {
        my %item = ();
        foreach my $column (@display_columns) {
            my $val;
            if ( $column eq 'created' ) {
                $val = format_time( $request->{$column}, '%Y-%m-%dT%H:%M:%SZ', 'UTC');
            }
            elsif ( $column =~ /^requeste/ ) {
                $val = email_filter( $request->{$column} );
            }
            elsif ( $column =~ /_id$/ ) {
                $val = $request->{$column} ? 0 + $request->{$column} : undef;
            }
            elsif ( $column =~ /^is/ or $column eq 'restricted' ) {
                $val = $request->{$column} ? \1 : \0;
            }
            else {
                $val = $request->{$column};
            }
            $item{$column} = $val;
        }
        push @results, \%item;
    }
    state $json = JSON::XS->new->utf8->ascii->pretty;
    return $json->encode( \@results );
}
