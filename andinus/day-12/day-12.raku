#!/usr/bin/env raku

unit sub MAIN (
    Int $part where * == 1|2 = 1 #= part to run (1 or 2)
);

my @instructions = "input".IO.lines;

# east/west, north/south. east/north are positive.
my Int @ship[2] = 0, 0;

my token Instruction { (N|S|E|W|L|R|F) (\d+) };
if $part == 1 {
    my Str @directions[4] = <E S W N>;
    my Int $facing = 0;

    for @instructions -> $instruction {
        if $instruction ~~ &Instruction -> $match {
            given $match[0] {
                when 'N' { @ship[1] += $match[1]; }
                when 'S' { @ship[1] -= $match[1]; }
                when 'E' { @ship[0] += $match[1]; }
                when 'W' { @ship[0] -= $match[1]; }
                when 'L' {
                    for 1..($match[1] / 90).Int {
                        if $facing == 0 {
                            $facing = 3;
                        } else {
                            $facing -= 1;
                        }
                    }
                }
                when 'R' {
                    for 1..($match[1] / 90).Int {
                        if $facing == 3 {
                            $facing = 0;
                        } else {
                            $facing += 1;
                        }
                    }
                }
                when 'F' {
                    given @directions[$facing] {
                        when 'N' { @ship[1] += $match[1]; }
                        when 'S' { @ship[1] -= $match[1]; }
                        when 'E' { @ship[0] += $match[1]; }
                        when 'W' { @ship[0] -= $match[1]; }
                    }
                }
            }
        }
    }
} elsif $part == 2 {
    # east/west, north/south. east/north are positive.
    my Int @waypoint[2] = 10, 1;

    for @instructions -> $instruction {
        if $instruction ~~ &Instruction -> $match {
            given $match[0] {
                when 'N' { @waypoint[1] += $match[1]; }
                when 'S' { @waypoint[1] -= $match[1]; }
                when 'E' { @waypoint[0] += $match[1]; }
                when 'W' { @waypoint[0] -= $match[1]; }
                when 'L' {
                    for 1..($match[1] / 90).Int {
                        @waypoint = -@waypoint[1], @waypoint[0];
                    }
                }
                when 'R' {
                    for 1..($match[1] / 90).Int {
                        @waypoint = @waypoint[1], -@waypoint[0];
                    }
                }
                when 'F' {
                    @ship[0] += @waypoint[0] * $match[1];
                    @ship[1] += @waypoint[1] * $match[1];
                }
            }
        }
    }
}

say "Part $part: ", [+] @ship.map(*.abs);
