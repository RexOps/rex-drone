#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:
   
package Rex::Drone::RPC::Protocol::Base;
   
use strict;
use warnings;

sub new {
  my $that = shift;
  my $proto = ref($that) || $that;
  my $self = { @_ };

  bless($self, $proto);

  return $self;
}

sub set_app {
  my ($self, $app) = @_;
  $self->{app} = $app;
}

sub app { (shift)->{app}; };

1;
