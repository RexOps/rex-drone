#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Rex::Drone;

use strict;
use warnings;

sub new {
  my $that  = shift;
  my $proto = ref($that) || $that;
  my $self  = {@_};

  bless( $self, $proto );

  open($self->{log}, ">>", "/tmp/drone.log");
  $self->rpc->set_app($self);

  return $self;
}

sub rpc { (shift)->{rpc}; }

sub run {
  my ($self) = @_;


  while ( my $line = <STDIN> ) {
    $self->log->say($line);
    $line =~ s/[\r\n]//gms;
    my $response = $self->rpc->parse($line);
    $self->log->say("Responding: $response");
    STDOUT->say($response);
    STDOUT->flush;
  }
}

sub exit_app {
  my ($self) = @_;
  exit;
}

sub log { (shift)->{log}; }

1;
