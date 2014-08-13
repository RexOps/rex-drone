#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Rex::Drone;

use strict;
use warnings;

use Rex::Drone::FileManager;

sub new {
  my $that  = shift;
  my $proto = ref($that) || $that;
  my $self  = {@_};

  bless( $self, $proto );

  $self->rpc->set_app($self);
  $self->{__file_manager__} = Rex::Drone::FileManager->new;

  return $self;
}

sub rpc { (shift)->{rpc}; }
sub filemanager { (shift)->{__file_manager__}; }

sub run {
  my ($self) = @_;


  while ( my $line = <STDIN> ) {
    $line =~ s/[\r\n]//gms;
    my $response = $self->rpc->parse($line);
    STDOUT->say($response);
    STDOUT->flush;
  }
}

sub exit_app {
  my ($self) = @_;
  exit;
}

1;
