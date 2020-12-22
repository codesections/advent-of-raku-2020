#!/usr/bin/env raku

# see usage:
#
#  pk@pkx:~/Downloads/raku/advent-of-raku-2020/pkmnx$ time ./22.02.raku < input/22.input 
#  2
#  [1 6 49 29 30 18 32 25 35 20 21 3 46 43 45 8 16 7 42 24 39 19 48 47 5 4 44 15 22 2 38 31 34 28 41 17 37 12 27 14 26 10 50 23 36 11 40 13 33 9]
#  32528
#  
#  real    1m34.624s
#  user    1m34.579s
#  sys     0m0.352s
#

sub MAIN() {

   my $h = {};
   my $p = "";
   my $totalCards = 0;

   for lines() -> $l {
      if ( $l ~~ /layer.*?(\d+)/ ) {
         $p = $0 + 0;
      }
      if ( $p.chars > 0 and  $l ~~ /^\d+/ ) {
        $h{$p}.push($l +0);
        $totalCards++;
      }
   }

   my $che = {};
   my $rounds = [];
   my $cnt = 0;
   my $vl =  fn($h, $che, $rounds, $cnt, $totalCards );

   my $val = 0;
   my $ar = $h{$vl};
   my $t = $ar.elems;
   $ar.map( -> $c {
      $val += $c * $t;
      $t--;
   });
   $vl.say;
   $h{$vl}.say;
   $val.say;
 
}

sub fn( $h, $ch, $rnds, $cnt, $tc ) {

   for ($h.keys) -> $p {
      my $dig = $h{$p}.join("|");
      if ( $ch{$p}{$dig}:exists ) {
         return 1;
      }
   }

   for ($h.keys) -> $p {
      my $dig = $h{$p}.join("|");
      $ch{$p}{$dig}++;
   }

   my @stack = ();
   my $scnt = 0;
   for ($h.keys) -> $p {
      @stack.push({
         id => $scnt++,
         p => $p,
         c => $h{$p}.shift,
         e => $h{$p}.elems
      });
   }

   my $max;
   my $ok = @stack.grep({ $_{"c"} <= $_{"e"}}).elems;
   if ( $ok == $h.keys.elems) {

      my $ncnt = 0;
      my $nrnds = [];
      my $nch = {};
      my $nh = {};

      for @stack -> $s {
         $nh{ $s{"p"} } = [];
         for ( ^$s{"c"} ) {
            $nh{ $s{"p"} }[$_] = $h{$s{"p"}}[$_];
         }
      }

      my $vl = fn( $nh, $nch, $nrnds, $ncnt, $tc );

      for @stack -> $s {
         $max = $s  if $vl == $s{ "p" };
      }

   } else {
      $max = @stack.max({$_{"c"}});
   }

   if ( $max{"id"} == 0 ) {
       while ( @stack ) {
          my $cd = @stack.shift;
          $h{ $max{"p"} }.push( $cd{"c"} );
       }
   } else {
       while ( @stack ) {
          my $cd = @stack.pop;
          $h{ $max{"p"} }.push( $cd{"c"} );
       }
   }

   $rnds[$cnt] = $max{"p"};

   for ($h.keys) -> $p {
      my $elems = $h{$p}.elems;
      return $max{"p"} if $elems == 0;
   }

   fn( $h, $ch, $rnds, ($cnt +1), $tc );

}
