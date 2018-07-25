# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

package Bugzilla::Report::SecurityRisk;

use 5.10.1;
use Moo;
use MooX::StrictConstructor;
use Types::Standard qw(Bool Str HashRef ArrayRef Object);
use Type::Utils;

my $DateTime = class_type { class => 'DateTime' };
my $Component = class_type { class => 'Bugzilla::Component' };

has 'current_date' => (
    is => 'ro',
    required => 1,
    isa => $DateTime,
);

has 'previous_date' => (
    is       => 'ro',
    required => 1,
    isa      => $DateTime,
);

has 'component' => (
    is       => 'ro',
    required => 1,
    isa      => $Component,
);

has 'results' => (
    is => 'lazy',
);

has 'current_bugs' => (
    is  => 'lazy',
    isa => ArrayRef[Object],
);

has 'events' => (
    is  => 'lazy',
    isa => ArrayRef[HashRef],
);

has 'previous_bugs' => (
    is => 'lazy',
    isa => ArrayRef[Object],
);

# probably Bugzilla::Bug->match({...})
# but the nice thing is for testing you can just pass in mocked data.
sub _build_current_bugs {
    my ($self) = @_;

    return [];
}


# probably a complex query from the bugs_activities table.
# Use $self->current_date and $self->previous_date.
# Likewise, for testing, pass in mocked data.
sub _build_events {
    my ($self) = @_;

    return [];
}

# Using the current bugs and the events list,
# re-wind the changes of the current bugs into a list of previous bugs.
# Note that the 'bug' objects hight might not be Bugzilla::Bug, but something that is duck-typed
# like one.
sub _build_previous_bugs {
    my ($self) = @_;

    return [];
}


# In the test I supposed this to be an object, but I think a hash would do.
# Basically you'd use List::Utils count { } over the current and previous bug lists based on the criteria
# (which I think is just the security keyword/flag?)
sub _build_results {
    my ($self) = @_;


    return undef;
}


1;
