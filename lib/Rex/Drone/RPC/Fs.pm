#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:
   
package Rex::Drone::RPC::Fs;
   
use strict;
use warnings;
   
sub new {
  my $that = shift;
  my $proto = ref($that) || $that;
  my $self = { @_ };

  bless($self, $proto);

  return $self;
}

sub rename {
  my ($self, $old, $new) = @_;
  my $ret = {rename => CORE::rename($old, $new) };
  return $ret;
}

sub is_file {
  my ($self, $file) = @_;
  my $ret = {is_file => (-f $file) };
  return $ret;
}

sub is_dir {
  my ($self, $dir) = @_;
  my $ret = {is_dir => (-d $dir) };
  return $ret;
}

sub unlink {
  my ($self, $file) = @_;
  my $ret = { unlink => CORE::unlink($file) };
  return $ret;
}

sub stat {
  my ($self, $file) = @_;

  if (
    my (
      $dev,  $ino,   $mode,  $nlink, $uid,     $gid, $rdev,
      $size, $atime, $mtime, $ctime, $blksize, $blocks
    )
    = CORE::stat($file)
    )
  {

    my %ret;

    $ret{'mode'}  = sprintf( "%04o", $mode & 07777 );
    $ret{'size'}  = $size;
    $ret{'uid'}   = $uid;
    $ret{'gid'}   = $gid;
    $ret{'atime'} = $atime;
    $ret{'mtime'} = $mtime;

    return { stat => \%ret };
  }

  return { stat => {} };
}

   
1;
