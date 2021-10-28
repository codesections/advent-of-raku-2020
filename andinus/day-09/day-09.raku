#!/usr/bin/env raku

sub MAIN (
    Int $part where * == 1|2 = 1 #= part to run (1 or 2)
) {
    my @numbers = "input".IO.lines>>.Int;
    my Int $solution;

    my Int $preamble_length = 25;
    my Int %invalid;

    MAIN: for @numbers.kv -> $idx, $num {
        next if $idx < $preamble_length;

        my @preamble = @numbers[$idx - $preamble_length..$idx - 1].sort;

        my Bool $valid;
        while pop @preamble -> $num_1 {
            my $diff = $num - $num_1;
            for @preamble -> $num_2 {
                if $num_2 == $diff {
                    $valid = True;
                    next MAIN;
                }
            }
        }

        unless $valid {
            %invalid<num> = $num;
            %invalid<idx> = $idx;
            $solution = %invalid<num> if $part == 1;
            last MAIN;
        }
    }

    if $part == 2 {
        my @set = @numbers[0..%invalid<idx> - $preamble_length - 1];

        PART2: for @set.elems - 1 ... 0 -> $idx_1 {
            for @set.elems - 1 ... 0 -> $idx_2 {
                my $sum = [+] @set[$idx_1..$idx_2];
                if $sum == %invalid<num> {
                    my @tmp = @set[$idx_1..$idx_2].sort;
                    $solution = @tmp[0] + @tmp[*-1];
                    last PART2;
                }
            }
        }
    }

    say "Part $part: ", $solution;
}
