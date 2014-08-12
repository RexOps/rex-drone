#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:
   
package Rex::Drone::RPC::Exec;
   
use strict;
use warnings;

use Rex::Drone::RPC::Base;
use base qw(Rex::Drone::RPC::Base);
   
sub new {
  my $that = shift;
  my $proto = ref($that) || $that;
  my $self = $proto->SUPER::new(@_);

  bless($self, $proto);

  return $self;
}

sub exec {
  my ($self, $command) = @_;

  $self->app->log->say("Executing: <$command>");

  my @output = qx{$command};
  chomp @output;

  $self->app->log->say("Got in return: @output");

  return \@output;
}


1;