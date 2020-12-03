#!/usr/bin/env raku

my @inputs;
@inputs = "input".IO.lines>>.Int;

while pop @inputs -> $num_1 {
    my Int $diff = 2020 - $num_1;
    for @inputs -> $num_2 {
        say "Part 1: ", $num_2 * $num_1 if $diff == $num_2;
    }
}

@inputs = "input".IO.lines>>.Int;
for @inputs -> $num_1 {
    for @inputs -> $num_2 {
        for @inputs -> $num_3 {
            if 2020 == $num_1 + $num_2 + $num_3 {
                say "Part 2: ", ($num_1 * $num_2 * $num_3);
                exit;
            }
        }
    }
}
