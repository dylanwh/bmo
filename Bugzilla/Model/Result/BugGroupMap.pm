package Bugzilla::Model::Result::BugGroupMap;
use 5.10.1;
use strict;
use warnings;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('bug_group_map');
__PACKAGE__->add_columns(qw( bug_id group_id ));

__PACKAGE__->set_primary_key(qw( bug_id group_id));

__PACKAGE__->belongs_to( 'bug'   => 'Bugzilla::Model::Result::Bug', 'bug_id');
__PACKAGE__->belongs_to( 'group_' => 'Bugzilla::Model::Result::Group', 'group_id' );

1;