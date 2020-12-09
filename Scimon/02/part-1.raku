#!/usr/bin/env raku

my $count = 0;
for "input".IO.lines -> $line {
    my $match = $line ~~ m/^ $<range-start>=(\d+) "-" $<range-end>=(\d+) " " $<character>=(.) ": " $<password>=(.+) $/;
    $count++ if $match<password>.comb.grep( * ~~ $match<character>.Str).elems ~~ ( $match<range-start>..$match<range-end> );
}
say $count;

