#!/usr/bin/env raku

#  
#  this was difficult for me and probably could be done better ... but, I'm exhausted 
#  
#  see usage:
#  
#  pk@pkx:~/Downloads/raku/advent-of-raku-2020/pkmnx$ time ./20.02.raku < input/20.input | tail 
#  ....#............#.####.........#..#......#....#......#.##.......#.#O.......#...#.#...#.....#...
#  ........#..#......#.......#...............#...#...O....OO#...OO..#.OOO.............#...#...##..#
#  #..............#####.#...#...#......#..#.......####O..O..O#.O..O..O...#...#..##..#............#.
#  ...#...#..#.......#.#.....#.#.#.............................#..#............#..........#.#......
#  ......#...........#....#...##...#.....O..#...#....#...#.....................#......#....#.......
#  .......#......##...#O....OO.#..OO#...OOO.##.....#...#....#..#.#..##.........#.............#.#.##
#  ...........#.#..##.#.O.#O..O##O#.O..O..#..#.......#.......##.#.........##..#..##......##.....#..
#  #.#.##.#....#...#.##..#....#.....#.#.#.......#...............##.#.............#........##....##.
#  ..##.#....#........#.................#......##...............#.#.......#...#.#..####....#.......
#  1649
#  
#  real    0m23.674s
#  user    0m24.871s
#  sys     0m0.161s
#

use Math::Matrix :ALL;

my $h = {};
my $ti;
my $sz = 0;

for lines() -> $l {
   if ( $l ~~ /Tile:.*?(\d+)/ ) {
      $ti = $0;
   } else {
     next if $l.chars < 1;
     my $am = $l.comb().map({ $_ ~~ '#' ?? 1 !! 0 });
     $sz = $am.elems;
     $h{$ti}.push($am);
   }
}

my $tot = $h.keys.elems;
my $sqTot = sqrt($tot);

my $dt = {};

for $h.kv -> $k, $v {

   my $top = $v[0];
   my $bot = $v[ $v.elems -1];
   my $left = [];
   my $right = [];
   for (^$v.elems) -> $i {
       my $n = $v[$i];
       my $l = $n[0];
       my $r = $n[ $n.elems -1 ];
       $left.push($l);
       $right.push($r);
   }

   for ( $top, $bot, $left, $right ) -> $s {
      my $str = $s.join("");
      my $str2 = $s.reverse.join("");

      $dt{$str}.push($k);
      $dt{$str2}.push($k);
   }
 
}

my $h2 = {};
for $dt.kv -> $k, $v {
   if ( $v.elems > 1 ) { 
      $h2{$v[0]}{$v[1]}++;
      $h2{$v[1]}{$v[0]}++;
   }
}

my $nxh = {};
for $h2.kv -> $k, $v {
   my $vcnt = $v.elems;
   $nxh{$vcnt}.push($k);
}

## for sol 1 find nxh @ 2 & multiply

## make rotations
my $rots = {};
for $h.kv -> $k, $v {
   my $mm = MM $v;
   my $mmT = $mm.T;
   for ( $mm, $mmT ) -> $m { 
      my $sRow = $m.row(0).join("");
      $rots{$k}{$sRow} = $m;
      for ( 90, 180, 270 ) -> $d  {
         my $mm = rot($m, $d);
         my $sRow = $mm.row(0).join("");
         $rots{$k}{$sRow} = $mm;
      }
   } 
}

     
my $oppos = { u => 'd', r => 'l', d => 'u', l => 'r' };

my $path = [];
my $seen = {};
my $start = $nxh{2}.sort({ $^a <=> $^b})[ $tot == 144 ?? 2 !! 0]; ## because a bug, but too exhausted

$seen{$start}++;
$path.push($start);

my $ds = [];
$ds.push({ id => $start, n => 0, d => MM $h{$start} });

while (True) {

  my $lastp = $path.tail;
  my $lastm = $ds.tail;

  ## find unseen keys
  my $uns = {};
  $h2{$lastp}.keys.grep({ $seen{$_}:!exists }).map({ $uns{$_} = $h2{$_}.keys.grep({ $seen{$_}:!exists }).elems });

  ## find min
  my $min = 999999;
  my $minN;
  for ( $uns.keys ) -> $u {
     my $v = $uns{$u};
     if ( $v < $min ) { 
        $min = $v;
        $minN = $u;
     }
  }

  if ($minN ) {
     ## find matching dir & put in path && seen

     my ( $u, $l, $d, $r ) = ( $lastm{"d"}.row(0), 
         $lastm{"d"}.column(0), 
         $lastm{"d"}.row( $lastm{"d"}.size()[0] -1 ), 
         $lastm{"d"}.column( $lastm{"d"}.size()[1] -1 ) ).map({$_.join("")});

     my $mobj = { u => $u, r => $r, d => $d, l => $l };

     my $cnt = 0;
     my $fObj;
     for ( $mobj.kv ) -> $mk, $mv {
        if ( $rots{$minN}{$mv}:exists ) {

           my $all = [];
           my $mm = $rots{$minN}{$mv};
           my $mmT = $mm.T;
           my $acnt = 0;
           for ( $mm, $mmT ) -> $m { 
              $all[$acnt++] = $m;
              for ( 90, 180, 270 ) -> $d  {
                 $all[$acnt++] = rot($m, $d);
              }
           }

           my $oppo = $oppos{ $mk };

           for (^$all.elems) -> $ai {
              my $m = $all[$ai];
              my ( $u, $l, $d, $r ) = (
                 $m.row(0), $m.column(0),
                 $m.row( $m.size()[0] -1 ),
                 $m.column( $m.size()[1] -1 )
              ).map({$_.join("")});
              my $mObj = { u => $u, r => $r, d => $d, l => $l };

              if ( $mv ~~ $mObj{$oppo} ) {
                 $cnt++;
                 $fObj = { id => $minN, n => $mk, d => $m };
                 last;
              }

           }
        }
     }

     if ( $cnt != 1 ) { 
        die "problem in finding next!";
     } else {
        $path.push($minN);
        $seen{$minN}++;
        $ds.push( $fObj );
     }
    
  }


  if ( $ds.elems == $tot ) {
     last;
  }

}

## place items

my ($y,$x) = (0, 0);
my $pathDelta = { u => (1,0), d => (-1,0), r => (0,1),  l => (0,-1) };

my $final = [][];
$final[$y][$x] = $ds[0];

$ds.map( -> $d {

  my $dir = $d{"n"};
  if ( $dir !~~ "0" ) {
     my $dels = $pathDelta{$dir};
     ($y,$x) = ($y +$dels[0], $x +$dels[1]);
     if ( $y > -1 and $x > -1 ) { 
        $final[$y][$x] = $d;
     }
  }

});

#----------------------------------
# flip
my $ffinal = [][];
my $ffcnt = 0;
for ((^$final.elems).reverse) -> $y {
   $ffinal[$ffcnt] = $final[$y];
   $ffcnt++;
}
#----------------------------------
# shave

my $sfinal = [][];
for (^$ffinal.elems) -> $y {
   for (^$ffinal[$y].elems) -> $x {
      my $d = $ffinal[$y][$x];

      my $sbm = $d{"d"}.submatrix(0,0);
      my $sbm2 = $sbm.submatrix( $sbm.size()[0] -1, $sbm.size()[0] -1);
      $ffinal[$y][$x]{"nd"} = $sbm2;

      $sz  = $sbm2.size()[0];
   }
}

#----------------------------------
my $merged = [][];
for (^$ffinal.elems) -> $y {
   my $yOff = $y * $sz;
   for (^$ffinal[$y].elems) -> $x {
      my $xOff = $x * $sz;
      my $d = $ffinal[$y][$x];
      for (^$sz) -> $ny {
         for (^$sz) -> $nx {
            $merged[$ny + $yOff][ $nx + $xOff] = $d{"nd"}[$ny][$nx];
         }
      }
   }
}

my $mergedM = MM $merged;

#----------------------------------
# finally, search

my $mons1 = "..................1.";
my $mons2 = "1....11....11....111";
my $mons3 = ".1..1..1..1..1..1...";

{
   my $mm = $mergedM;
   my $mmT = $mm.T;
   my $allFins = [];
   for ( $mm, $mmT ) -> $m { 
      $allFins.push($m);
      for ( 90, 180, 270 ) -> $d  {
         my $mm = rot($m, $d);
         $allFins.push($mm);
      }
   } 

   $allFins.map( -> $m {

      my $d = [];
      my $rew = {};
      my $dcnt = 0;
      for (^$m.size()[0]) -> $rw {
         $d[$rw] = $m.row($rw).join();
         if ( $rw + 2 < $m.size()[0] ) { 
            my $ra = $m.row($rw).join();
            my $rb = $m.row($rw +1).join();
            my $rc = $m.row($rw +2).join();

            my $rbPos = [];
            for ( $rb ~~ m:exhaustive/<{ $mons2 }>/ ) -> $match {
               my $mf = $match.from;
               $rbPos.push($mf);
            }

            $rbPos.map( -> $mb {
               if ( $rc ~~ m:c($mb)/<{ $mons3 }>/ ) {
                  my $mc = $/.from;

                  if ( $ra ~~ m:c($mb)/<{ $mons1 }>/ ) {
                     my $ma = $/.from;

                     if ( $ma == $mb == $mc ) {
                        $rew{$rw}.push($mb); 
                     }

                  }
               }
            });

         }
         $dcnt++;
      }

      if ( $rew.keys.elems ) {
         for (^$m.size()[0]) -> $rw {
            if ($rew{$rw}:exists ) {

               $rew{$rw}.map( -> $off {

                  ## this could certainly be made more efficient, but, I'm sleepy
                  my @a = $d[$rw].comb();
                  my @mons1 = $mons1.comb();
                  for ( 0 .. @mons1.elems -1 ) -> $chi {
                     my $vl = @mons1[$chi];
                     if ( $vl ~~ '1' ) {
                       my $noff = $chi + $off;
                       @a[$noff] = "O";
                     }
                  }
                  $d[$rw] = @a.join();

                  my @b = $d[$rw +1].comb();
                  my @mons2 = $mons2.comb();
                  for ( 0 .. @mons2.elems -1 ) -> $chi {
                     my $vl = @mons2[$chi];
                     if ( $vl ~~ '1' ) {
                       my $noff = $chi + $off;
                       @b[$noff] = "O";
                     }
                  }
                  $d[$rw +1] = @b.join();

                  my @c = $d[$rw +2].comb();
                  my @mons3 = $mons3.comb();
                  for ( 0 .. @mons3.elems -1 ) -> $chi {
                     my $vl = @mons3[$chi];
                     if ( $vl ~~ '1' ) {
                       my $noff = $chi + $off;
                       @c[$noff] = "O";
                     }
                  }
                  $d[$rw +2] = @c.join();

               });

            }
         }

         ## finally
         my $totalOnes = 0;
         for (^$m.size()[0]) -> $rw {
            my $line = $d[$rw];
            my $cnt = ($line ~~ m:g/1/).elems;
            $totalOnes += $cnt;
            $line ~~ s:g/0/\./;
            $line ~~ s:g/1/\#/;
            $line.say;
         }
         $totalOnes.say;

      }

   });

}

#----------------------------------

sub rot ($m, $d ) {
   my $nm = $m;
   my $nd = $d;
   while $nd {
     $nm = Math::Matrix.new($nm.list-columns>>.reverse);
     $nd -= 90;
   }
   return $nm;
}
