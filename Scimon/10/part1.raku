#!/usr/bin/env raku

use v6;

sub MAIN ( $file where "example1"|"example2"|"input" ) {
    my @jolts = $file.IO.lines.map(*.Int).sort;
    @jolts = [ 0, |@jolts, @jolts[*-1]+3 ];
    my $bag = @jolts.rotor(2 => -1).map( -> ($a, $b) { $b - $a } ).Bag;

    say $bag;
    say $bag{1} * $bag{3};
}
