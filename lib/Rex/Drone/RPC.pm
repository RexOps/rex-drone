#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:
   
package Rex::Drone::RPC;
   
use strict;
use warnings;

sub create {
  my ($class, $type) = @_;

  eval "use $type";
  if($@) {
    die("Error loading RPC module ($type)");
  }

  my $c = $type->new;
  return $c;
}

1;
