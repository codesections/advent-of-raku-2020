#!/usr/bin/raku

sub MAIN() {

    my %directions = ( 'E' => 0, 'S' => 1, 'W' => 2, 'N' => 3 );
    my %headings = %directions.antipairs;
    my $heading = 'E';
    my $y = 0;
    my $x = 0;
    my @commands;

    for "input/day12.input".IO.lines -> $line {
        my ($action, $value) = $line.match(/ (<[A .. Z]>) (\d+) / ).list;
        @commands.push([ $action, $value ]);
    }

    for @commands -> [ $action, $value ] {
        given $action {
            when 'N' {
                $y -= $value;
            }
            when 'S' {
                $y += $value;
            }
            when 'E' {
                $x += $value;
            }
            when 'W' {
                $x -= $value;
            }
            when 'L' {
                $heading = %headings{(%directions{$heading} - ($value / 90)) % 4};
            }
            when 'R' {
                $heading = %headings{(%directions{$heading} + ($value / 90)) % 4};
            }
            when 'F' {
                given $heading {
                    when 'N' {
                        $y -= $value;
                    }
                    when 'S' {
                        $y += $value;
                    }
                    when 'E' {
                        $x += $value;
                    }
                    when 'W' {
                        $x -= $value;
                    }
                }
            }
            default {
            }
        }
    }

    say $y.abs + $x.abs;
}
