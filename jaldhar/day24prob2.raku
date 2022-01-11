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

sub flip(%hexes) {
    my @neighbors = ( [1, -1], [1,  0], [0,  1], [-1, 1], [-1, 0], [0, -1] );

    for %hexes.kv -> $k, $v {
        my ($row, $col) = $k.split(q{ });

        for @neighbors -> @neighbor {
            my $pos = ($row + @neighbor[0]) ~ ' ' ~ ($col + @neighbor[1]);

            if %hexes{$pos}:!exists {
                %hexes{$pos} = True;
            }
        }
    }

    my %newhexes;
    my %colors;
    for %hexes.kv -> $k, $v {
        my ($row, $col) = $k.split(q{ });
        %colors{False} = 0;
        %colors{True} = 0;

        for @neighbors -> @neighbor {
            my $pos = ($row + @neighbor[0]) ~ ' ' ~ ($col + @neighbor[1]);

            if %hexes{$pos}:exists {
                %colors{%hexes{$pos}}++;
            }
        }

        if !$v && (%colors{False} == 0 || %colors{False} > 2) {
            %newhexes{$k} = True;
        } elsif $v && %colors{False} == 2 {
            %newhexes{$k} = False;
        } else {
            %newhexes{$k} = $v;
        }
    }

    %hexes = %newhexes;
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
            %hexes{$position} = !%hexes{$position};
        } else {
            %hexes{$position} = False;
        }
    }

    for 1 .. 100 {
        flip(%hexes);
    }

    say %hexes.values.grep({ !$_; }).elems;
}