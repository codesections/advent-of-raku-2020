#!/usr/bin/env raku

unit sub MAIN (
  IO() :$file where *.f      = $?FILE.IO.sibling('input/06.txt'), #= Path to input file
  Int  :$part where * == 1|2 = 1, #= Part of the exercise (1 or 2)
  --> Nil
);

say do given { $file.slurp.split("\n" x 2).map(&^a).sum } {
  when $part == 1 {
    .( *.comb(/\w/).unique.elems );
  }
  when $part == 2 {
    .( *.lines.map( *.comb(/\w/).Set ).reduce(&infix:<∩>).elems );
  }
};
