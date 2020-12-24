my $now = now;

my $input = '583976241';

my int @cups = $input.comb».Int;

my $max = 9;

my $current;
for ^100 {
    $current = $_ % $max;
    #say "\nmove {$_ + 1}: ", @cups;

    my $pos = @cups[$current];
    my $dest = $pos - 1;
    $dest = $max if $dest < 1;
    my @pick-up = ($current + 1) % $max, ($current + 2) % $max, ($current + 3) % $max;
    my @picked-up = @cups[|@pick-up];
    @cups.splice($_,1) for @pick-up.sort: -*;
    while $dest ∈ @picked-up {
        $dest -= 1;
        $dest = $max if $dest < 1;
    }
    my $destination = @cups.first: * == $dest, :k;
    @cups.splice(1 + $destination, 0, @picked-up);
    if $destination < $current {
        my $offset = (@cups.first: * == $pos, :k) - $current;
        @cups.=rotate($offset);
    }
}

@cups.=rotate until @cups.tail == 1;

say "A: ", (@cups[^8].join), (now - $now).fmt("\t(%.2f seconds)");
