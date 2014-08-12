#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:
   
package Rex::Drone::FileManager;
   
use strict;
use warnings;

use IO::File;
   
sub new {
  my $that = shift;
  my $proto = ref($that) || $that;
  my $self = { @_ };

  $self->{__file_handle__} = {};

  bless($self, $proto);

  return $self;
}

sub open {
  my ($self, $file, $mode) = @_;

  my $key = "__file_handle__";

  $self->{$key}->{$file} = IO::File->new($file, $mode);
  $self->{$key}->{$file}->binmode;

  return "$key-$file";
}

sub write {
  my ($self, $file, $buf) = @_;

  my $key = "__file_handle__";

  if(! exists $self->{$key}->{$file}) {
    die "Error writing to $file. Filehandle not open.";
  }

  $self->{$key}->{$file}->print($buf);
}

sub read {
  my ($self, $file, $len) = @_;

  my $key = "__file_handle__";

  if(! exists $self->{$key}->{$file}) {
    die "Error reading from $file. Filehandle not open.";
  }

  my $buf;
  $self->{$key}->{$file}->read($buf, $len);
  return $buf;
}

sub seek {
  my ($self, $file, $pos) = @_;

  my $key = "__file_handle__";

  if(! exists $self->{$key}->{$file}) {
    die "Error seeking in $file. Filehandle not open.";
  }

  $self->{$key}->{$file}->seek($pos, 0);
}

sub close {
  my ($self, $file) = @_;

  my $key = "__file_handle__";

  if(! exists $self->{$key}->{$file}) {
    die "Error closing $file. Filehandle not open.";
  }

  $self->{$key}->{$file}->close;
}
   
1;
