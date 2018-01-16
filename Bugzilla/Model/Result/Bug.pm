package Bugzilla::Model::Result::Bug;
use 5.10.1;
use strict;
use warnings;

use base qw/DBIx::Class::Core/;

use Bugzilla::Bug;

# At the moment we don't really do much with this table,
# as contains a huge amount of business logic.
# But we need it to exist for other things to work
__PACKAGE__->table(Bugzilla::Bug->DB_TABLE);
__PACKAGE__->add_columns(
    qw(
        bug_id product_id component_id short_desc
        assigned_to reporter qa_contact
        cclist_accessible reporter_accessible
    )
);
__PACKAGE__->set_primary_key(Bugzilla::Bug->ID_FIELD);

__PACKAGE__->has_many(flags => 'Bugzilla::Model::Result::Flag', 'bug_id');

__PACKAGE__->has_many(
    bug_group_map => 'Bugzilla::Model::Result::BugGroupMap', 'bug_id'
);

__PACKAGE__->has_many(
    cc_security => 'Bugzilla::Model::Result::CCList',
    sub {
        my ($args) = @_;
        my $userid = Bugzilla->user->id;
        return {
            "$args->{foreign_alias}.bug_id" => { -ident => "$args->{self_alias}.bug_id" },
            $userid ? ( "$args->{foreign_alias}.who" => { '=', $userid } ) : (),
        },
    },
);

__PACKAGE__->has_many(
    bug_security => 'Bugzilla::Model::Result::BugGroupMap',
    sub {
        my ($args) = @_;
        my $groups = Bugzilla->user->groups_as_string;
        return {
            "$args->{foreign_alias}.bug_id" => {-ident => "$args->{self_alias}.bug_id" },
            "$args->{foreign_alias}.group_id" => { -not_in => \"($groups)" },
        }
    },
 );


1;