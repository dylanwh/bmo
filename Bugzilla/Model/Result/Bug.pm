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
    qw( bug_id product_id component_id short_desc)
);
__PACKAGE__->set_primary_key('bug_id');

__PACKAGE__->has_many('flags', 'Bugzilla::Model::Result::Flag', 'bug_id');
__PACKAGE__->has_many(bug_group_map => 'Bugzilla::Model::Result::BugGroupMap', 'bug_id');
__PACKAGE__->many_to_many(groups => 'bug_group_map', 'group_');

1;