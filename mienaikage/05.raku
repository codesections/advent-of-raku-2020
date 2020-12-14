#!/usr/bin/env raku

unit sub MAIN (
  #| Path to input file
  IO() :$file where *.f = ( .sibling('input/' ~ .extension('txt').basename) with $?FILE.IO ),
  #| Part of the exercise (1 or 2)
  Int  :$part where * == 1|2 = 1,
  --> Nil
);

say do given $file.lines.map({
  .trans(<F L> => '0', <B R> => '1')
  .parse-base(2)
}), $part -> ( @seats, $_ ) {
  when 1 { @seats.max }
  when 2 { @seats.minmax ∖ @seats }
};
