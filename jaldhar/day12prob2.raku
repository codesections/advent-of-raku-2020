#!/usr/bin/raku

sub MAIN() {

    my $y = 0;
    my $x = 0;
    my $waypointY = -1;
    my $waypointX = 10;

    my @commands;

    for "input/day12.input".IO.lines -> $line {
        my ($action, $value) = $line.match(/ (<[A .. Z]>) (\d+) / ).list;
        @commands.push([ $action, $value ]);
    }

    for @commands -> [ $action, $value ] {
        given $action {
            when 'N' {
                $waypointY -= $value;
            }
            when 'S' {
                $waypointY += $value;
            }
            when 'E' {
                $waypointX += $value;
            }
            when 'W' {
                $waypointX -= $value;
            }
            when 'L' {
                given $value / 90 {
                    when 1 {
                        my $temp = $waypointX;
                        $waypointX = $waypointY;
                        $waypointY = -$temp;
                    }

                    when 2 {
                        $waypointX = -$waypointX;
                        $waypointY = -$waypointY; 
                    }

                    when 3 {
                        my $temp = $waypointX;
                        $waypointX = -$waypointY;
                        $waypointY = $temp;
                    }

                    default {
                    }
                }
            }
            when 'R' {
                given $value / 90 {
                    when 1 {
                        my $temp = $waypointX;
                        $waypointX = -$waypointY;
                        $waypointY = $temp;
                    }

                    when 2 {
                        $waypointX = -$waypointX;
                        $waypointY = -$waypointY; 
                    }

                    when 3 {
                        my $temp = $waypointX;
                        $waypointX = $waypointY;
                        $waypointY = -$temp;
                    }

                    default {
                    }
                }
            }
            when 'F' {
                for 1 .. $value {
                    $y += $waypointY;
                    $x += $waypointX;
                }
            }

            default {
            }
        }
    }

    say $y.abs + $x.abs;
}
