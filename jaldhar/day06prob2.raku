#!/usr/bin/raku

sub MAIN() {
    my $count = 0;

    for "input/day06.input".IO.split("\n\n") -> $group {
        my @people = $group.split("\n").map({ $_.comb;  });
        $count += ([∩] @people).elems;
    }

    say $count;
}
