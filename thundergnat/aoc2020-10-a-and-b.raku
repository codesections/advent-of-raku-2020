my @adapters = flat 0, lines».Int.sort;

@adapters.push: @adapters.tail + 3;

# Joltage difference between adapters. Could only 1 or 3 jolts.
my @diffs;

for @adapters.rotor( 2 => -1 ) { @diffs[ .[1] - .[0] ]++ };

say 'A: ', [*] @diffs[1,3];

# Runs of single jolt step adapters. Those are the only ones
# that could possibly be removed to change the arrangement.
my @runs = 0;

@adapters[$_] - @adapters[$_-1] == 1 ?? @runs.[*-1]++ !! @runs.push(0) for 1 ..^ @adapters;

# Experimentation shows no more than 6 one jolt adapters in a row.
# Use list of values up to 7 adjacent one jolt step adapters.
say 'B: ', [*] @runs.map: { (1,1,2,4,7,10,21)[$_] };
