#!/usr/bin/env raku

unit sub MAIN (
  #| Path to input file
  IO() :$file where *.f = ( .sibling('input/' ~ .extension('txt').basename) with $?FILE.IO ),
  #| Part of the exercise (1 or 2)
  Int  :$part where * == 1|2 = 1,
  --> Nil
);

say do given $file.lines.map(*.comb.List) -> @slope {
  [*] gather {
    for ( 3,1 ; 1,1 ; 5,1 ; 7,1 ; 1,2 ) -> @xy {
      ( @xy, { @(.[] Z+ @xy) } …^ *.[1] ≥ @slope )
        .grep({ @slope[ .[1] ; .[0] % * ] eq '#' })
        .elems
        .take;
      last if $part == 1;
    }
  }
};
