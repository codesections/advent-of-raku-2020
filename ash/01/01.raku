#!/usr/bin/env raku

my @data = 'data.txt'.IO.lines;

say [*] @data.combinations(2).first(*.sum == 2020); # 870331
say [*] @data.combinations(3).first(*.sum == 2020); # 283025088
