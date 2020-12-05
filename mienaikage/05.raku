#!/usr/bin/env raku

unit sub MAIN (
  IO() :$file where *.f      = $?FILE.IO.sibling('input/05.txt'), #= Path to input file
  Int  :$part where * == 1|2 = 1, #= Part of the exercise (1 or 2)
  --> Nil
);

say do given $file.lines.map({
  .trans(<F L> => '0', <B R> => '1')
  .parse-base(2)
}).List {
  when $part == 1 { .max         }
  when $part == 2 { .minmax ∖ $_ }
}
