#!/usr/bin/raku

sub MAIN() {
    my @entries = "input/day01.input".IO.lines;

    for @entries.combinations(3) -> @combo {
        if (([+] @combo) == 2020) {
            say @combo.join(q{ }), ': ', [*] @combo;
            last;
        }
    }
}
