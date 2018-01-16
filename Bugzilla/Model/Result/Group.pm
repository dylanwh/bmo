package Bugzilla::Model::Result::Group;
use 5.10.1;
use strict;
use warnings;

use base qw/DBIx::Class::Core/;

use Bugzilla::Group;

__PACKAGE__->table(Bugzilla::Group->DB_TABLE);
__PACKAGE__->add_columns(
    qw(
        id
        name
        description
        isbuggroup
        userregexp
        isactive
        icon_url
        owner_user_id
        idle_member_removal
    )
 );

__PACKAGE__->set_primary_key(Bugzilla::Group->ID_FIELD);

1;