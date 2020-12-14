#!/usr/bin/env raku

my @trees = 'forest.txt'.IO.lines.map: *.comb.Array;

my $height = @trees.elems;
my $width = @trees[0].elems;

my ($x, $y) = 0, 0;

my $trees = 0;
while $y < $height {
    $trees++ if @trees[$y][$x % $width] eq '#';

    $x += 3;
    $y++;
}

say $trees; # 159
