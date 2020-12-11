#!/usr/bin/env raku

sub MAIN() {

  my @d = lines().map({$_.comb()});
  my @dirs = (-1 .. 1 X -1 .. 1).grep(-> ($a,$b){ !($a == 0 && $b == 0) });
  my ( $emp, $oc, $flr ) = ( 'L', '#', '.' );

  my @stack = ();
  @stack.push(@d.clone);

  while (@stack) {

     my $d2 = @stack.shift;
     my $d3 = [][];
     my $chngCnt = 0;
     my $occCnt = 0;

     for ( ^@d.elems X ^@d[0].elems ) -> ($y,$x) { if ( $d2[$y][$x]:exists) {

        my $cnt = 0;
        my $v = $d2[$y][$x];
        my ($ty, $tx) = ($y,$x);

        $d3[$y][$x] = $v;

        if ($v !~~ $flr) {
           for (@dirs) -> ($dy,$dx) {
              ( $ty, $tx ) = ( $y + $dy, $x + $dx );
              my $ok = True;
              while ( $ok and $ty > -1 and $tx > -1 and @d[$ty][$tx]:exists) { 
                 my $vv = $d2[$ty][$tx];
                 $ok = False if $vv !~~ $flr;
                 $cnt++      if $vv  ~~ $oc;
                 $ty += $dy;
                 $tx += $dx;
              }
           }
           if ( $v ~~ $emp ) {
              $d3[$y][$x] = $oc if $cnt == 0;
           }
           else {
              $d3[$y][$x] = $emp if $cnt >= 5;
           }
        }

        $chngCnt++  if $d3[$y][$x] !~~ $d2[$y][$x];
        $occCnt++   if $d3[$y][$x]  ~~ $oc;

     }}

     @stack.push($d3) if $chngCnt > 0;

     "$chngCnt".say;
     "$occCnt".say;
#     $d3.map({.join()}).join("\n").say;
     print "\n";

  }

}
