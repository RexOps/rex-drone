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

sub ls {
  my ($self, $path) = @_;

  my @ret;

  eval {
    opendir( my $dh, $path ) or die("$path is not a directory");
    while ( my $entry = readdir($dh) ) {
      next if ( $entry =~ /^\.\.?$/ );
      push @ret, $entry;
    }
    closedir($dh);
  };

  # failed open directory, return undef
  if ($@) { return undef; }

  # return directory content
  return { ls => \@ret };
}

sub mkdir {
  my ( $self, $dir ) = @_;
  return { mkdir => CORE::mkdir($dir) };
}

sub glob {
  my ( $self, $glob ) = @_;
  my @ret = CORE::glob($glob);
  return { glob => \@ret };
}

sub readlink {
  my ( $self, $file ) = @_;
  return { readlink => CORE::readlink($file) };
}

sub is_readable {
  my ($self, $file) = @_;
  if ( -r $file ) { 
    return { is_readable => 1, };
  }

  return { is_readable => 0, };
}

sub is_writable {
  my ($self, $file) = @_;
  if ( -r $file ) { 
    return { is_writable => 1, };
  }

  return { is_writable => 0, };
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
