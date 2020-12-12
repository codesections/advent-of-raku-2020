my @moves = lines;

{
    my %position = :0E, :0N, :0W, :0S;
    my $heading  = 0;
    my @compass  = <E N W S>;

    for @moves {
        my ($do, $what) = .substr(0,1), .substr(1);
        given $do {
            when 'R' { ($heading -= $what / 90 + 4) %= 4 }
            when 'L' { ($heading += $what / 90 + 4) %= 4 }
            when 'F' { %position{@compass[$heading]} += $what }
            default  { %position{$do}                += $what }
        }
    }

    say 'A: ',  abs(%position<E> - %position<W>) + abs(%position<N> - %position<S>);
}

{
    my %ship     =  :0x, :0y;
    my %waypoint = :10x, :1y;

    for @moves {
        my ($do, $what) = .substr(0,1), .substr(1);
        given $do {
            when 'R' { rotate (-$what / 90 + 4) % 4 }
            when 'L' { rotate ( $what / 90 + 4) % 4 }
            when 'F' { %ship »+=» %waypoint for ^$what }
            when 'N' { %waypoint<y> += $what }
            when 'S' { %waypoint<y> -= $what }
            when 'E' { %waypoint<x> += $what }
            when 'W' { %waypoint<x> -= $what }
        }
    }

    sub rotate ($n) {
        given $n {
            when 1  { (%waypoint<x>, %waypoint<y>) = -%waypoint<y>, %waypoint<x> }
            when 2  { (%waypoint<x>, %waypoint<y>) = -%waypoint<x>,-%waypoint<y> }
            when 3  { (%waypoint<x>, %waypoint<y>) =  %waypoint<y>,-%waypoint<x> }
        }
    }

    say 'B: ', %ship<x>.abs + %ship<y>.abs;
}
