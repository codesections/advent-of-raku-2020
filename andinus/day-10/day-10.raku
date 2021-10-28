#!/usr/bin/env raku

sub MAIN (
    Int $part where * == 1|2 = 1 #= part to run (1 or 2)
) {
    my $solution;

    # Initialize @adapters with charging outlet joltage. @adapters
    # will hold joltages of each adapter.
    my @adapters = 0;
    append @adapters, "input".IO.lines>>.Int.sort;
    push @adapters, @adapters[*-1] + 3; # push the built in joltage.

    if $part == 1 {
        my Int ($diff_1, $diff_3);

        for 0 .. @adapters.end - 1 -> $idx {
            # joltage difference.
            my $diff = @adapters[$idx + 1] - @adapters[$idx];
            $diff_1++ if $diff == 1;
            $diff_3++ if $diff == 3;
        }
        $solution = $diff_1 * $diff_3;
    } elsif $part == 2 {
        my @memoize;
        # complete-chain returns the number of ways to complete the
        # chain given that you're currently at @adapters[$idx]. This
        # is taken from Jonathan Paulson's solution.
        sub complete-chain (
            Int $idx
        ) {
            return 1 if $idx == @adapters.end;
            return @memoize[$idx] if @memoize[$idx];

            my Int $ways;
            for $idx + 1 .. @adapters.end {
                if @adapters[$_] - @adapters[$idx] <= 3 {
                    $ways += complete-chain($_);
                }
            }
            @memoize[$idx] = $ways;
            return $ways;
        }
        $solution = complete-chain(0);
    }

    say "Part $part: ", $solution;
}
