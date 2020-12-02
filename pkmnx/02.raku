#!/usr/bin/env raku

sub MAIN( Str $pt2 ) {

   my $mats = 0;

   for lines() -> $l {
      if ( $l ~~ /(\d+) \- (\d+) \s+ (\w+) \: \s+ (.*)/ ) -> ($a,$b,$c,$d) {

         if ($pt2 ~~ '2' ) {
            my $dd = $d.comb;
            next    if ( $dd[$a -1] eqv "$c" && $dd[$b -1] eqv "$c" );
            $mats++ if ( $dd[$a -1] eqv "$c" || $dd[$b -1] eqv "$c" );
         } else {
            my $dl = $d.comb.grep(/<$c>/).join("").chars;
            $mats++ if ( $dl >= $a && $dl <= $b );
         }

      }
   }

   $mats.say;
}
