#!/usr/bin/raku

sub MAIN() {
    my $count = 0;
    my @forest;

    for "input/day03.input".IO.lines -> $line {
        @forest.push($line.comb);
    }

    my $height = @forest.elems;
    my $width = @forest[0].elems;
    my $row = 0;
    my $col = 0;
    my $trees = 0;
    my $right = 3;
    my $down = 1;

    while ($row != $height - 1) {
        $row = $row + $down;
        $col = ($col + $right) % $width;
        if @forest[$row][$col] eq '#' {
            $trees++;
        }
    }

    say $trees;
}
