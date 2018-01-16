package Bugzilla::Model::Result::Attachment;
use 5.10.1;
use strict;
use warnings;

use base qw/DBIx::Class::Core/;

use Bugzilla::Attachment;

__PACKAGE__->table(Bugzilla::Attachment->DB_TABLE);
__PACKAGE__->add_columns(Bugzilla::Attachment->DB_COLUMNS);
__PACKAGE__->set_primary_key(Bugzilla::Attachment->ID_FIELD);

__PACKAGE__->has_many('flags', 'Bugzilla::Model::Result::Flag', 'attach_id');


1;