# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

package Bugzilla::Report::Ping::Simple;
use 5.10.1;
use Moo;

use JSON::Validator qw(joi);

our $VERSION = '1';

with 'Bugzilla::Report::Ping';

sub _build_validator {
  my ($self) = @_;

  # For prototyping we use joi, but after protyping
  # $schema should be set to the file path or url of a json schema file.
  my $schema = joi->object->strict->props({
    bug_id     => joi->integer->required->min(1),
    product    => joi->string->required,
    component  => joi->string->required,
    bug_status => joi->string->required,
    keywords   => joi->array->required->items(joi->string)->required,
    groups     => joi->array->required->items(joi->string)->required,
    flags      => joi->array->required->items(joi->object->strict->props({
      name      => joi->string->required,
      status    => joi->string->enum([qw[? + -]])->required,
      setter_id    => joi->integer->required,
      requestee_id => joi->type([qw[null integer]])->required,
    })),
    priority     => joi->string->required,
    bug_severity => joi->string->required,
    resolution   => joi->string,
  });


  return JSON::Validator->new(schema => Mojo::JSON::Pointer->new($schema->compile));
}

sub _build_resultset {
  my ($self)  = @_;
  my $bugs    = $self->model->resultset('Bug');
  my $query   = {};
  my $options = {
    order_by => 'me.bug_id',
  };
  return $bugs->search($query, $options);
}

sub prepare {
  my ($self, $bug) = @_;
  my $doc = {
    bug_id       => 0 + $bug->id,
    product      => $bug->product->name,
    component    => $bug->component->name,
    bug_status   => $bug->bug_status,
    priority     => $bug->priority,
    resolution   => $bug->resolution,
    bug_severity => $bug->bug_severity,
    keywords     => [map { $_->name } $bug->keywords->all],
    groups       => [map { $_->name } $bug->groups->all],
    flags        => [
      map { $self->_prepare_flag($_) } $bug->flags->all
    ],
  };

  return ($bug->id, $doc);
}

sub _prepare_flag {
  my ($self, $flag) = @_;

  return {
    name         => $flag->type->name,
    status       => $flag->status,
    requestee_id => $flag->requestee_id,
    setter_id    => $flag->setter_id,
  };
}

1;
