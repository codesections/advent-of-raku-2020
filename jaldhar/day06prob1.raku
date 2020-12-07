#!/usr/bin/raku

sub MAIN() {
    my $count = 0;

    for "input/day06.input".IO.split("\n\n") -> $group {
        my %questions;
        for $group.subst("\n", q{}, :g).comb -> $c {
            %questions{$c}++;
        }
        $count += %questions.keys;
    }

    say $count;
}
