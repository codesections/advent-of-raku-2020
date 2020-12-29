#!/usr/bin/env raku

unit sub MAIN (
  #| Path to input file
  IO() :$file where *.f = ( .sibling('input/' ~ .extension('txt').basename) with $?FILE.IO ),
  #| Part of the exercise (1 or 2)
  Int  :$part where * == 1|2 = 1,
  --> Nil
);

say do given $file.lines.map(+*) -> @lines {
  given @lines.rotor(26 => -25).first({
    .[0..*-2].combinations(2).map(*.sum) ∌ .[*-1]
  }).[*-1], $part -> ( Int $invalid, $_ ) {

    when 1 { $invalid }

    when 2 {
      (2..@lines.end).map({
        @lines.rotor($_ => -$_+1).Slip
      }).first(*.sum == $invalid).sort.[0,*-1].sum
    }

  }
};
