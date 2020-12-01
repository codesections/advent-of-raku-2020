#!/usr/bin/env raku

unit sub MAIN (
  Int  :$n = 2, #= Number of entries
  IO() :$file where * ~~ :f = $?FILE.IO.sibling('input/01.txt'), #= Path to input file
  --> Nil
);

$file.slurp
  .lines
  .combinations($n)
  .first(*.sum == 2020)
  .reduce(* × *)
  .say
;
