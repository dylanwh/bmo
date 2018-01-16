package Bugzilla::Model::Result::Flag;
use 5.10.1;
use strict;
use warnings;

use base qw/DBIx::Class::Core/;

use Bugzilla::Flag;

__PACKAGE__->table(Bugzilla::Flag->DB_TABLE);
__PACKAGE__->add_columns(
    qw(
        id
        type_id
        bug_id
        attach_id
        requestee_id
        setter_id
        status
        creation_date
        modification_date
    ),
 );

__PACKAGE__->set_primary_key(Bugzilla::Flag->ID_FIELD);

__PACKAGE__->belongs_to(requestee => 'Bugzilla::Model::Result::User', 'requestee_id');
__PACKAGE__->belongs_to(requester => 'Bugzilla::Model::Result::User', 'setter_id');
__PACKAGE__->belongs_to(bug => 'Bugzilla::Model::Result::Bug', 'bug_id');
__PACKAGE__->has_one(type => 'Bugzilla::Model::Result::FlagType', 'id');

__PACKAGE__->has_many('bug_group_map' => 'Bugzilla::Model::Result::BugGroupMap', 'bug_id');
__PACKAGE__->belongs_to('attachment'  => 'Bugzilla::Model::Result::Attachment', 'attach_id', { join_type => 'left' });


1;