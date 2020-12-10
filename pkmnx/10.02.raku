#!/usr/bin/env raku

# AoC, 2020; #10, pt.2
#
# see usage:
#
#  pk@pkx:~/raku/advent-of-raku-2020/pkmnx$ time ./10.02.raku < input/10.input 
#  15790581481472
#  
#  real    0m0.212s
#  user    0m0.282s
#  sys     0m0.030s

our ( $csh, $nms ) = {}, { 0 => 1 };
$nms{ Int(.chomp) } = 1 for lines();

$nms{$nms.keys.max +3};

path(0).say;

sub path($n) {

  return $csh{$n} if $csh{$n}:exists;

  my $v = 0;
  for ( $n +1 .. $n +3 ) -> $p {
     $v += $csh{$p}:exists ?? $csh{$p}
        !!( $nms{$p}:exists ??( $csh{$p} = path($p) ) !!0 );
  }

  return $csh{$n} = $v > 0 ?? $v !! 1;

}
