package Bugzilla::Model::Result::CCList;
use 5.10.1;
use strict;
use warnings;

use base qw/DBIx::Class::Core/;

use Bugzilla::Flag;

__PACKAGE__->table('cc');
__PACKAGE__->add_columns( qw( bug_id who ));

__PACKAGE__->set_primary_key(qw[bug_id who]);

__PACKAGE__->belongs_to( user => 'Bugzilla::Model::Result::User', 'who' );
__PACKAGE__->belongs_to( bug => 'Bugzilla::Model::Result::Bug', 'bug_id' );

1;