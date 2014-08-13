#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

#
# example communication
#
# client / request:
#
#    {"pkg": "Rex::Drone::Exec", "func": "exec", "args": ["arg1", "arg2", ...]}
#
# server / response:
#
#    {"status": 200, "response": { "key": "value", ... }}
#
# on error:
#
#    {"status": 500, "error": "error description"}
#
#
package Rex::Drone::RPC::Protocol::JSON;

use strict;
use warnings;

use Rex::Drone::RPC::Protocol::Base;
use base 'Rex::Drone::RPC::Protocol::Base';
use JSON::PP;

sub new {
  my $that  = shift;
  my $proto = ref($that) || $that;
  my $self  = $proto->SUPER::new(@_);

  bless( $self, $proto );

  $self->{json} = JSON::PP->new;

  return $self;
}

sub parse {
  my ( $self, $req ) = @_;

  my ( $ref, $res );
  eval {
    $ref = $self->json->decode($req);

    my $pkg_to_use   = $ref->{pkg};
    my $func_to_call = $ref->{func};
    my @args         = @{ $ref->{args} };

    eval "use $pkg_to_use";
    die "Error finding package $pkg_to_use." if $@;

    my $pkg      = $pkg_to_use->new(app => $self->app);
    my $res_func = $pkg->$func_to_call(@args);

    $res = {
      status   => 200,
      response => $res_func,
    };

    1;
  } or do {
    $res = { status => 500, error => $@ };
  };

  return $self->json->encode($res);
}

sub json { (shift)->{json} }

1;
