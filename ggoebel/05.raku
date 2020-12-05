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
    my ($row, $col) = (0,0);
    for $code.substr(0..6).comb -> $r {
        $row = $row +< 1;
        $row += 1  if $r eq 'B';
    };
    for $code.substr(7..9).comb -> $c {
        $col = $col +< 1;
        $col +=1  if $c eq 'R';
    }
    return $row * 8 + $col;
}
