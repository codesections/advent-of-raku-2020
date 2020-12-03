#!/usr/bin/env raku

sub MAIN (
  IO() :$file where *.f      = $?FILE.IO.sibling('input/03.txt'), #= Path to input file
  Int  :$part where * == 1|2 = 1, #= Part of the exercise (1 or 2)
  --> Nil
) {
  my @slope := @($file.lines.map(*.comb.List));

  say [*] gather {
    for ( 1,3 ; 1,1 ; 1,5 ; 1,7 ; 2,1 ) -> @xy {
      take [+] gather {
        for @xy, { @(.[] Z+ @xy) } …^ *.[0] ≥ @slope {
          take @slope[ .[0] ; .[1] % * ] eq '#';
        }
      }
      last if $part == 1;
    }
  }
}
