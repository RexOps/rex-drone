#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:
   
package Rex::Drone::RPC::File;
   
use strict;
use warnings;

use Rex::Drone::RPC::Base;
use base qw(Rex::Drone::RPC::Base);

use Rex::Drone::Base64;
   
sub new {
  my $that = shift;
  my $proto = ref($that) || $that;
  my $self = $proto->SUPER::new(@_);

  bless($self, $proto);

  return $self;
}
   
sub open {
  my ($self, $file, $mode) = @_;
  my $ret = { open => $self->app->filemanager->open($file, $mode) };
  return $ret;
}

sub close {
  my ($self, $file) = @_;
  my $ret = { close => $self->app->filemanager->close($file) };
  return $ret;
}

sub read {
  my ($self, $file, $len) = @_;
  my $ret = { read => $self->app->filemanager->read($file, $len) };
  return $ret;
}

sub write {
  my ($self, $file, $buf) = @_;
  my $ret = { write => $self->app->filemanager->write($file, decode_base64($buf)) };
  return $ret;
}

sub seek {
  my ($self, $file, $pos) = @_;
  my $ret = { write => $self->app->filemanager->seek($file, $pos) };
  return $ret;
}

1;
