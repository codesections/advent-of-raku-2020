#!/usr/bin/env raku
use v6.d;

sub MAIN (
    IO() :$input where *.f     = $?FILE.IO.sibling('input'),
    Int  :$part where * == 1|2 = 1, # Solve Part One or Part Two?
    --> Nil
) {
    given $part {
        when 1 {
            say $input.lines.map({ seat_id($_) }).max;
        }
        when 2 {
            my @vacant = ( (0..1023) (-) $input.lines.map({ seat_id($_) }) ).keys;
            say @vacant.grep({ !( $_+1 ~~ any @vacant ) and !( $_-1 ~~ any @vacant) })[0];
        }
    }
}

sub seat_id (Str $code --> Int) {
    return +('0b' ~ $code.comb.map({ /<[BR]>/ ?? 1 !! 0 }).join);
}

