#!/usr/bin/env raku

unit sub MAIN (
  #| Path to input file
  IO() :$file where *.f = ( .sibling('input/' ~ .extension('txt').basename) with $?FILE.IO ),
  #| Part of the exercise (1 or 2)
  Int  :$part where * == 1|2 = 1,
  --> Nil
);

say do given { $file.slurp.split("\n" x 2).map(&^a).sum }, $part -> ( &summer, $_ ) {
  when 1 {
    &summer( *.comb(/\w/).unique.elems );
  }
  when 2 {
    &summer( *.lines.map( *.comb(/\w/).Set ).reduce(&infix:<∩>).elems );
  }
};
