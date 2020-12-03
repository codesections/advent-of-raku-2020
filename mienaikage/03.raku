#!/usr/bin/env raku

unit sub MAIN (
  IO() :$file where *.f      = $?FILE.IO.sibling('input/03.txt'), #= Path to input file
  Int  :$part where * == 1|2 = 1, #= Part of the exercise (1 or 2)
  --> Nil
);

my @slope := @($file.lines.map(*.comb.List));

say [*] gather {
  for ( 3,1 ; 1,1 ; 5,1 ; 7,1 ; 1,2 ) -> @xy {
    ( @xy, { @(.[] Z+ @xy) } …^ *.[1] ≥ @slope )
      .grep({ @slope[ .[1] ; .[0] % * ] eq '#' })
      .elems
      .take;
    last if $part == 1;
  }
}
