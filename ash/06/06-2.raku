#!/usr/bin/env raku

my @groups = 'input.txt'.IO.slurp.split("\n\n").map: *.lines;

say [+] gather for @groups -> $group {
    my $n = $group.elems;
    take $group.join.comb.Bag.grep(*.value == $n).elems;    
}

# 3398
