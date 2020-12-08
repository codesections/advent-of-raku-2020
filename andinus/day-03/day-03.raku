#!/usr/bin/env raku

sub MAIN (
    # Part to run.
    Int $part where * == 1|2 = 1
) {
    my @input = "input".IO.lines>>.comb;

    if $part == 1 {
        say "Part 1: ", count-trees(@input, 3, 1);
    } elsif $part == 2 {
        my @trees = [{ right => 1, down => 1 },
	 { right => 3, down => 1 },
	 { right => 5, down => 1 },
	 { right => 7, down => 1 },
	 { right => 1, down => 2 },].map(
            {count-trees(@input, $_<right>, $_<down>)}
        );
        say "Part 2: ", [*] @trees;
    }
}

sub count-trees (
    @input,
    Int $right,
    Int $down
) {
    # Start at top left position.
    my $x = 0;
    my $y = 0;
    my $trees = 0;

    my $x-max = @input[0].elems - 1;
    my $y-max = @input.elems - 1;

    loop {
        $trees++ if @input[$y][$x] eq '#';

        $x += $right;
        $y += $down;

        # Cannot let $x become greater than $x-max because that'll produce
        # error when we try to access @input with those positions. So, we
        # wrap it around because the same map is repeated.
        $x -= $x-max + 1 if $x > $x-max;

        last if $y-max < $y;
    }
    return $trees;
}
