#!/usr/bin/env raku

my @lines = "input.txt".IO.lines>>.comb;

sub trees($xd, $yd) {
    my ($x, $y, $t) = 0, 0, 0;
    while $y < @lines.elems {
        $t++ if  @lines[$y][$x] eq '#';
        ($x, $y) <<+=>> ($xd, $yd);
        $x %= @lines[0].elems;
    }
    $t;
}

say "Part 1: ", trees(3, 1);
say "Part 2: ", [*] ((1, 1), (3, 1), (5, 1), (7, 1), (1, 2)).map({trees(|$_)});
