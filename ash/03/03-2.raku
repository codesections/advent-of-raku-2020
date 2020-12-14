#!/usr/bin/env raku

my @trees = 'forest.txt'.IO.lines.map: *.comb.Array;

my $height = @trees.elems;
my $width = @trees[0].elems;

my $prod = 1;
for [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]] -> @step {
    my ($x, $y) = 0, 0;

    my $trees = 0;
    while $y < $height {
        $trees++ if @trees[$y][$x % $width] eq '#';

        $x += @step[0];
        $y += @step[1];
    }

    # say $trees;
    $prod *= $trees;
}

say $prod;
