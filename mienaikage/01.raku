#!/usr/bin/env raku

unit sub MAIN (
  #| Path to input file
  IO() :$file where *.f = ( .sibling('input/' ~ .extension('txt').basename) with $?FILE.IO ),
  #| Part of the exercise (1 or 2)
  Int  :$part where * == 1|2 = 1,
  Bool :$race,
  --> Nil
);

$file.slurp\
  .lines\
  .combinations($part + 1)\
  .&({ $race ?? .race !! $_ })
  .first(*.sum == 2020)
  .reduce(* × *)
  .say
;
