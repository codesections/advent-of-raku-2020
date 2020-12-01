#!/usr/bin/env raku

my @inputs = "input.txt".IO.lines>>.Int;

say "Part 1";
for @inputs.combinations: 2 { say [*] @_ if @_.sum == 2020; }

say "Part 2";
for @inputs.combinations: 3 { say [*] @_ if @_.sum == 2020; }
