#!/usr/bin/raku

sub MAIN() {
    my $joltage = 0;
    my @sorted = [] xx 3;
    my @adapters = "input/day10.input".IO.lines.map({ $_.Int; });

    for 0 ..^ @adapters.elems {
        for 1 .. 3 -> $i {
            if ($joltage + $i) ∈ @adapters {
                $joltage += $i;
                @sorted[$i - 1].push($joltage);
                last;
            }
        }
    }

    @sorted[2].push($joltage + 3);

    say @sorted[0].elems * @sorted[2].elems;
}
