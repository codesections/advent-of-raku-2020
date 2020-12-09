#!/usr/bin/env raku

grammar Password {
  token TOP      { <number> '-' <number> ' ' <letter> ': ' <password> }
  token number   { <[0..9]>+ }
  token letter   { <[a..z]> }
  token password { <.letter>+ }
}

sub MAIN (
  #| Path to input file
  IO() :$file where *.f = ( .sibling('input/' ~ .extension('txt').basename) with $?FILE.IO ),
  #| Part of the exercise (1 or 2)
  Int  :$part where * == 1|2 = 1,
  --> Nil
) {
  $file.lines
    .grep({
      given parse Password: $_ {
        when $part == 1 {
          .<number>[0] ≤ .<password>.comb(.<letter>) ≤ .<number>[1]
        }
        when $part == 2 {
          .<password>.comb[.<number>.map(* - 1)].one eq .<letter>
        }
      }
    })
    .elems
    .say;
}
