#!/usr/bin/raku

sub copy(@arr) {
    my @copy;

    for 0 ..^ @arr.elems -> $row {
        for 0 ..^ @arr[$row].elems -> $col {
            @copy[$row;$col] = @arr[$row;$col];
        }
    }

    return @copy;
}

sub count(@arr) {
    my $total;

    for 0 ..^ @arr.elems -> $row {
        for 0 ..^ @arr[$row].elems -> $col {
            if @arr[$row;$col] eq '#' {
                $total++;
            }
        }
    }

    return $total;
}

sub MAIN() {
    my @seats = "input/day11.input".IO.lines.map({ [ $_.comb; ] });
    my @dirs= ( [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1]);

    loop {
        my $change = 0;
        my @next = copy(@seats);

        for 0 ..^ @seats.elems -> $row {
            for 0 ..^ @seats[$row].elems -> $seat {
                given @seats[$row;$seat] {
                    when 'L' {
                        my $adjacent = 0;
                        for @dirs -> [$r, $c] {
                            if (@seats[$row + $r;$seat + $c] // q{.}) eq '#' {
                                $adjacent++;
                                last;
                            }
                        }

                        unless $adjacent {
                            @next[$row;$seat] = '#';
                            $change++;
                        }
                    }

                    when '#' {
                        my $adjacent = 0;
                        for @dirs -> [$r, $c] {
                            if (@seats[$row + $r;$seat + $c] // q{.}) eq '#' {
                                $adjacent++;
                                if ($adjacent > 3) {
                                    last;
                                }
                            }
                        }

                        if $adjacent > 3 {
                            @next[$row;$seat] = 'L';
                            $change++;
                        }
                    }

                    default {
                    }
                }
            }
        }

        if ($change == 0) {
            say count(@next);
            last;
        }

        @seats = copy(@next);
    }

}
