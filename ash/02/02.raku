#!/usr/bin/env raku

my $good = 0;
for 'input.txt'.IO.lines() -> $line {
    $line ~~ / (\d+) '-' (\d+) ' ' (\w) ': ' (\w+) /;

    my %chars = $/[3].comb.Bag;
    $good++ if $/[0] <= (%chars{$/[2]} // 0) <= $/[1];
}

say $good; # 454
