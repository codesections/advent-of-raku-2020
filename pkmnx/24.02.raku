#!/usr/bin/env raku

#
# 'tis slow & could use some pruning of the search space, but ... whatever ...
#

our $SZ = 250;

sub MAIN() {

   my $board = [][];
   for ( ^$SZ X ^$SZ ) -> ($y, $x) {
      $board[$y][$x] = False;
   }

   my $moves = [ 'se', 'sw', 'ne', 'nw', 'e', 'w' ];

   my $pos = { 
      'se' => (-1,  1),
      'sw' => (-1, -1),
      'ne' => ( 1,  1),
      'nw' => ( 1, -1),
       'e' => ( 0,  2),
       'w' => ( 0, -2)
   };

   my $mh = {};
   my $nmh = {};
   my $mcnt = 0;
   $moves.map( -> $m {
      $mh{$m} = $mcnt;
      $nmh{$mcnt++} = $m;
   });

   my $path = [];
   my $olines = [];
   for lines() -> $l {

      my $nl = $l;
      $olines.push($nl);

      for ( $mh.keys.sort({ $mh{$^a} <=> $mh{$^b} }) ) -> $k {
         $nl ~~ s:g/$k/$mh{$k}/;
      }
      my $ar = [];
      $nl.comb().map({ $ar.push($moves[$_]) });
      $path.push($ar);
   }

   for (^$olines.elems) -> $i {
      my $pth = $path[$i];
      my ($y, $x) = ( $SZ / 2, $SZ / 2 );

      for ( ^$pth.elems ) -> $si {
         my $stp = $pth[$si];
         my ($dy, $dx) = $pos{$stp};
        
         $y += $dy;
         $x += $dx;

      }
      $board[$y][$x] = ! $board[$y][$x];
   }

   display($board);

   my $days = 1;
   while ( $days <= 100 ) {
      "\nDay $days".say;
      my $nb = [][];
      for ( ^$SZ X ^$SZ ) -> ($y, $x) {

         my $tc = 0;

         $pos.keys.map( -> $k {
            my ($dy, $dx) = $pos{$k};
            my ($diffy, $diffx) = ( $y + $dy, $x + $dx);

            if ( $diffy > -1 and $diffx > -1 and $diffy <= $SZ and $diffx <= $SZ ) {
               if ( $board[$diffy][$diffx] ) {
                  $tc++;
               }
            }
         });

         $nb[$y][$x] = $board[$y][$x];

         if ( $board[$y][$x]         and $tc == 0 ) {
            $nb[$y][$x] = False;
         } 
         elsif ( $board[$y][$x]      and $tc > 2 ) {
            $nb[$y][$x] = False;
         }
         elsif ( (!$board[$y][$x])   and $tc == 2 ) {
            $nb[$y][$x] = True;
         }
      }

      display($nb);
      $board = $nb;
      $days++;
   }

}
 
sub display($nb) {
   my $cnt = 0;
   for ( ^$SZ X ^$SZ ) -> ($y, $x) {
      if ( $nb[$y][$x] ) { 
         $cnt++;
      }
   }
   $cnt.say;
}
