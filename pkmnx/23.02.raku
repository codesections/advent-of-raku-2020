#!/usr/bin/env raku

# see usage:
#
#  pk@pkx:~/Downloads/raku/advent-of-raku-2020/pkmnx$ time ./23.02.raku 
#  processing input.
#  100000 ...
#  
#  875050
#  792708
#  693659135400
#  
#  real    12m15.635s
#  user    12m13.314s
#  sys     0m1.369s
#

sub MAIN() {

   my $input = "389125467";
   $input = "198753462";

   my $MAXINPUT = 1000000;

   my ( $head, $tail, $objs, $min, $max ) = setup($input, $MAXINPUT);

#   my $LIM = 1000000;
#   my $LIM = 100;

   my $LIM = 10000000;

   my $mv = 1;
   my $proc = True;
   while ( $proc ) {

if ( $mv %% 100000 ) {
      "\n\n-- Move: $mv --".say;
      $head.say;
}
#      $objs.say;

      my $pickup = [];
      $pickup.push( $objs{$head{"n"}} );
      $pickup.push( $objs{$pickup.tail{"n"}} ) for (^3);
      $pickup.tail{"h"} = $head{"i"};
      $head{"n"} = $pickup.tail{"i"};
      $pickup.pop;

      my $pVals = {};
      $pickup.map(-> $pku { $pVals{ $pku{"i"} }++ });

      ## find num to place
      my $finding = True;
      my $srch = $head{"i"} -1;

      while ($finding) {
         if ( $srch < $min ) { 
            $srch = $max;
         }
         if ( $pVals{$srch}:exists ) {
            $srch--;
         } else {
            $finding = False;
         }
      }

      if ( $objs{$srch}:exists ) {
         my $s = $objs{$srch};
         $objs{$s{"n"}}{"h"} = $pickup.head{"i"};
         $pickup.tail{"n"} = $s{"n"};
         $s{"n"} = $pickup.head{"i"};
         $pickup.head{"h"} = $s{"i"};
         $objs{$srch} = $s;
      }

      $head = $objs{$head{"n"}};
      $mv++;
      $proc = False if $mv > $LIM;
   }


   my $out = 1;
   my $disp = $objs{1};
#   my $cntdown = $objs.keys.elems -1;
   my $cntdown = 2;
   while ( $cntdown-- > 0 ) {
      $disp = $objs{ $disp{"n"} };
      $disp{"i"}.say;
      $out = $out * $disp{"i"};
   }

   $out.say;

}  

sub setup ( $input, $MAXINPUT ) {

   my $min = Inf;
   my $max = -Inf;

   my $tail;
   my $head;
   my $objs = {};

   my @inp = $input.comb();

"processing input.".say;

   for ( 1 .. $MAXINPUT ) -> $i {

      my $indx = $i;
      if ( @inp[$indx -1]:exists ) {
         $indx = @inp[$indx -1] +0;
      }

say "$indx" if $indx %% 100000;

      $min = $indx if $min > $indx;
      $max = $indx if $max < $indx;

      my $obj = { i => $indx, h => $tail{"i"} };
      $objs{$indx} = $obj;

      if ($tail) {
         $tail{"n"} = $obj{"i"};
         $obj{"n"} = $tail{"i"};
      }

      $tail = $obj;
      $head = $obj if $i == 1;
 
   }

"finished processing input.".say;

   $head{"h"} = $tail{"i"};
   $tail{"n"} = $head{"i"};

   return [ $head, $tail, $objs, $min, $max ];
}
