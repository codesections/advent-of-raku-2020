#!/usr/bin/env raku

my $pos = 0;
my $count = 0;

for "input".IO.lines.skip(1).map( *.comb ) -> @row {
    $pos += 3;
    $count++ if @row[$pos % @row.elems] ~~ '#';
}

say $count;
