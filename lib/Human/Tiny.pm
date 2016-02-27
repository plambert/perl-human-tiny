package Human::Tiny;

use 5.014;

use strict;
use warnings;

BEGIN { 
  #$Human::Tiny::AUTHORITY   = 'cpan:TOBYINK'; # i have no cpan id (yet)
  $Human::Tiny::VERSION     = '1.000005';
}

use Exporter qw(import);
our @ISA=qw(Exporter);
our @EXPORT=();
our @EXPORT_OK=qw(human_bytes);
our %EXPORT_TAGS=(
  "all" => [ qw(human_bytes) ],
);

our $BASE=1024;
our @LABELS=( "", "K", "M", "G", "T", "P", );

sub human_bytes {
  my $bytes=shift;
  my $opt={decimals => 3, width => 8};
  my $factor=0;
  my $format;
  if (@_ == 1 and defined $_[0] and !ref $_[0]) {
    $opt->{decimals}=shift @_;
  }
  elsif (@_ > 1 and 0 == scalar(@_) % 2) {
    %$opt=@_;
  }
  my @labels=$opt->{labels} ? @{$opt->{labels}} : @LABELS;
  while($bytes >= $BASE) {
    $factor += 1;
    $bytes /= $BASE;
    last if ($factor == $#labels);
  }
  my $label=$labels[$factor];
  if ($factor == 0) {
    $format=sprintf "%%%dd%%s", $opt->{width}-length($label);
  }
  else {
    $format=sprintf "%%%d.%df%%s", $opt->{width}-length($label), $opt->{decimals};
  }
  return sprintf $format, $bytes, $label;
}

