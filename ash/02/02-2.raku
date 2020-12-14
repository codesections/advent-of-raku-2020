#!/usr/bin/env raku

my $good = 0;
for 'input.txt'.IO.lines() -> $line {
    $line ~~ / (\d+) '-' (\d+) ' ' (\w) ': ' (\w+) /;

    my @chars = $/[3].comb;
    $good++ if one(@chars[$/[0] - 1], @chars[$/[1] - 1]) eq $/[2];
}

say $good; # 649
