#!/usr/bin/env raku

unit sub MAIN (
  IO() :$file where *.f      = $?FILE.IO.sibling('input/06.txt'), #= Path to input file
  Int  :$part where * == 1|2 = 1, #= Part of the exercise (1 or 2)
  --> Nil
);

say do given $part {
  when 1 {
    result { .comb(/\w/).unique.elems }
  }
  when 2 {
    result { .lines.map( *.comb(/\w/).Set ).reduce(&infix:<∩>).elems }
  }
};

sub result ( &block --> Int ) {
  $file.slurp.split("\n" x 2, :skip-empty).map(&block).sum;
}
