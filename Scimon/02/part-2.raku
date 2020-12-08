#!/usr/bin/env raku

my $count = 0;
for "input".IO.lines -> $line {
    my $match = $line ~~ m/^ $<pos1>=(\d+) "-" $<pos2>=(\d+) " " $<character>=(.) ": " $<password>=(.+) $/;
    $count++ if one( $match<password>.comb[$match<pos1>-1,$match<pos2>-1] ) ~~ $match<character>.Str;
}
say $count;

