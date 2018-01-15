package Bugzilla::Model::Result::User;
use 5.10.1;
use strict;
use warnings;

use base qw/DBIx::Class::Core/;

use Bugzilla::User;

__PACKAGE__->table(Bugzilla::User->DB_TABLE);
__PACKAGE__->add_columns(
    qw(
        userid login_name realname mybugslink disabledtext disable_mail
        extern_id is_enabled last_seen_date password_change_required
        password_change_reason mfa mfa_required_date
    )
);

__PACKAGE__->set_primary_key(Bugzilla::User->ID_FIELD);

__PACKAGE__->has_many(incoming_flags => 'Bugzilla::Model::Result::Flag', 'requestee_id');
__PACKAGE__->has_many(outgoing_flags => 'Bugzilla::Model::Result::Flag', 'setter_id');

1;