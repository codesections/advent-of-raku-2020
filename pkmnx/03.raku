#!/usr/bin/env raku

sub MAIN( Str $pt2 ) {

   my @d;
   for lines() -> $l {
      my @am = $l.comb(/./).grep({/\.|\#/});
      my @an = ();
      for ( 0 .. 200 ) { 	## arbitrary
         @an.append(@am);
      }
      @d.push(@an);
   }

   my @deltas = ();
   @deltas.push( (1, 3) );

   if ( $pt2 == 2 ) {
      @deltas.push( (1, 1) );
      @deltas.push( (1, 5) );
      @deltas.push( (1, 7) );
      @deltas.push( (2, 1) );
   }

   my $total = 1;

   for ( @deltas ) -> ($dy, $dx) { 
      my $mats = 0;
      my ( $y, $x ) = (0, 0);
      while ($y < @d.elems) { 

        my $n = @d[$y][$x];
        $mats++ if ( $n eqv '#' );

        $y += $dy;
        $x += $dx;
      }
      $total *= $mats;
   }

   $total.say; 

}
