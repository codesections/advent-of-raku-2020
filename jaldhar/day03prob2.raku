#!/usr/bin/raku

sub traverse(@forest, $height, $width, $right, $down) {
    my $row = 0;
    my $col = 0;
    my $trees = 0;

    while ($row != $height - 1) {
        $row = $row + $down;
        $col = ($col + $right) % $width;
        if @forest[$row][$col] eq '#' {
            $trees++;
        }
    }

    return $trees;
}

sub MAIN() {
    my $count = 0;
    my @forest;

    for "input/day03.input".IO.lines -> $line {
        @forest.push($line.comb);
    }

    my $height = @forest.elems;
    my $width = @forest[0].elems;

    say [*]
        traverse(@forest, $height, $width, 1, 1),
        traverse(@forest, $height, $width, 3, 1),
        traverse(@forest, $height, $width, 5, 1),
        traverse(@forest, $height, $width, 7, 1),
        traverse(@forest, $height, $width, 1, 2)
    ;
}
