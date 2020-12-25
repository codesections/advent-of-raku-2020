#!/usr/bin/raku

sub navigate(@directions) {
    my $row = 0;
    my $col = 0;
    my %moves = (
        'ne' => [1, -1],
        'e'  => [1,  0],
        'se' => [0,  1],
        'sw' => [-1, 1],
        'w'  => [-1, 0],
        'nw' => [0, -1],
    );

    for @directions -> $direction {
        $row += %moves{$direction}[0];
        $col += %moves{$direction}[1];
    }

    return "$row $col";
}

sub MAIN() {
    my %hexes;
    for "input/day24.input".IO.lines -> $line {
        my @directions =
            $line.match(/ <("ne"? | "se"? | "e"? | "nw"? | "sw"? | "w"?)> /, :g)
            .list
            .grep({ $_ ne q{} });

        my $position = navigate(@directions);

        if %hexes{$position}:exists {
            if %hexes{$position} eq 'white' {
                %hexes{$position} = 'black';
            } else {
                %hexes{$position} = 'white';
            }
        } else {
            %hexes{$position} = 'black';
        }
    }

    say %hexes.values.grep({ $_ eq 'black'; }).elems;
}