#!/usr/bin/raku

sub chains(%cache, %adapters, $n) {

    if %cache{$n}:exists {
        return %cache{$n};
    }

    my $total = 0;
    for 1 .. 3 -> $i {
        if %cache{$n + $i}:exists {
            $total += %cache{$n + $i};
        } elsif %adapters{$n + $i}:exists {
            %cache{$n + $i} = chains(%cache, %adapters, $n + $i);
            $total += %cache{$n + $i};
        }
    }

    %cache{$n} = $total;

    return $total > 0 ?? $total !! 1;
}

sub MAIN() {
    my %cache;
    my %adapters = "input/day10.input".IO.lines.map({ {$_.Int => 1}; });

    chains(%cache, %adapters, 0).say;
}
