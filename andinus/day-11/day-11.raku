#!/usr/bin/env raku

unit sub MAIN (
    Int $part where * == 1|2 = 1 #= part to run (1 or 2)
);

my @seats = "input".IO.lines.map(*.comb.cache.Array);
my Int ($x-max, $y-max) = (@seats[0].end, @seats.end);

my Num $visibility = 1e0;
my Int $tolerance = 4;

# Infinite visibility & increased tolerance for part 2.
($visibility, $tolerance) = (Inf, 5) if $part == 2;

my List @directions[8] = (
    # $y, $x
    ( +1, +0 ), # bottom
    ( +1, +1 ), # bottom-right
    ( +1, -1 ), # bottom-left
    ( -1, +0 ), # top
    ( -1, +1 ), # top-right
    ( -1, -1 ), # top-left
    ( +0, +1 ), # right
    ( +0, -1 ), # left
);

my Int $round = 0;
loop {
    $round++;
    print "Round $round.\r";

    my Int ($x, $y) = (-1, 0);
    my @changed;
    INNER: loop {
        if $x == $x-max {
            $x = 0;
            # goto next row if not in the last row.
            last INNER if $y == $y-max;
            $y += 1;
        } else {
            $x += 1;
        }

        @changed[$y][$x] = @seats[$y][$x];
        given @seats[$y][$x] {
            when '.' { next INNER; }
            when 'L' {
                unless adjacent-occupied(@seats, $x, $y, $visibility, True) {
                    @changed[$y][$x] = '#';
                }
            }
            when '#' {
                if adjacent-occupied(@seats, $x, $y,
                                     $visibility, False) >= $tolerance {
                    @changed[$y][$x] = 'L';
                }
            }
        }
    }
    # If seats didn't change then exit the loop.
    last if @seats eqv @changed;

    for 0 .. @changed.end -> $y {
        for 0.. @changed[0].end -> $x {
            @seats[$y][$x] = @changed[$y][$x];
        }
    }
}

say "Part $part: ", @seats.join.comb('#').elems;

# adjacent-occupied returns the number of adjacent cells that have
# been occupied by others.
#
# $visibility should be 1 if only directly adjacent seats are to be
# counted. Make it Inf for infinite visibility. It ignores floors
# ('.').
#
# If $only-bool is set then a Bool will be returned which will
# indicate whether any adjacent seat it occupied or not.
subset Occupied where Int|Bool;
sub adjacent-occupied (
    @seats, Int $x, Int $y, Num $visibility, Bool $only-bool = False
                                                  --> Occupied
) {
    my Int $occupied = 0;
    for neighbors(@seats, $x, $y, $visibility).List -> $neighbor {
        if @seats[$neighbor[0]][$neighbor[1]] eq '#' {
            return True if $only-bool;
            $occupied++ ;
        }
    }
    return $occupied;
}

# neighbors returns the neighbors of given index. It doesn't account
# for $visibility when caching the results. So, if $visibility changes
# & it has a cached result then the return value might be wrong. So,
# you can't solve both part 1 & 2 at once because $visibility changes
# between the two. This can be solved easily by just accounting for
# $visibility when caching the neighbors.
sub neighbors (
    @seats, Int $x, Int $y, Num $visibility --> List
) {
    state Array @neighbors;

    unless @neighbors[$y][$x] {
        my Int $pos-x;
        my Int $pos-y;

        DIRECTION: for @directions -> $direction {
            $pos-x = $x;
            $pos-y = $y;
            SEAT: for 1 .. $visibility {
                $pos-y += $direction[0];
                $pos-x += $direction[1];

                next DIRECTION unless @seats[$pos-y][$pos-x];
                given @seats[$pos-y][$pos-x] {
                    # Don't care about floors, no need to check those.
                    when '.' { next SEAT; }
                    when 'L'|'#' {
                        push @neighbors[$y][$x], [$pos-y, $pos-x];
                        next DIRECTION;
                    }
                }
            }
        }
    }

    return @neighbors[$y][$x];
}
