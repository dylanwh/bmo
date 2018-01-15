package Bugzilla::Model::Result::FlagType;
use 5.10.1;
use strict;
use warnings;

use base qw/DBIx::Class::Core/;

use Bugzilla::Flag;

__PACKAGE__->table(Bugzilla::FlagType->DB_TABLE);
__PACKAGE__->add_columns(Bugzilla::FlagType->DB_COLUMNS);
__PACKAGE__->set_primary_key(Bugzilla::Flag->ID_FIELD);

__PACKAGE__->has_many('flags', 'Bugzilla::Model::Result::Flag', 'type_id');

1;