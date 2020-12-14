#!/usr/bin/env raku

multi sub MAIN() {
    my $file = "input";
    my $busses = $file.IO.lines[1];
    say find-ts( $busses );
}

multi sub MAIN("test") {
    use Test;
#    is( find-ts( "3,5,7" ), 23);
    is( find-ts( "17,x,13,19" ), 3417 );
    is( find-ts( "7,13,x,x,59,x,31,19" ), 1068781 );
    is( find-ts( "67,7,59,61"), 754018 );
    is( find-ts( "67,x,7,59,61"), 779210 );
    is( find-ts( "67,7,x,59,61"), 1261476 );
    is( find-ts( "1789,37,47,1889" ), 1202161486 );
}

sub find-ts( $busses, $min = 0 ) {
    my @times;
    my @deltas;   
    my $idx = 0;
    my $max = 0;
    my $max-idx = 0;
    for $busses.split(",") -> $bus {
        $idx++;
        next if $bus ~~ "x";
        @times.push($bus.Int);
        @deltas.push($bus.Int - $idx);
    }   
    note "{@times.gist},{@deltas.gist}"; 

    
    return 1+chinese-remainder(@times)(@deltas);
}

# Nicked from rosetta code
sub mul-inv($a is copy, $b is copy) {
    return 1 if $b == 1;
    my ($b0, @x) = $b, 0, 1;
    ($a, $b, @x) = (
	$b,
	$a % $b,
	@x[1] - ($a div $b)*@x[0],
	@x[0]
    ) while $a > 1;
    @x[1] += $b0 if @x[1] < 0;
    return @x[1];
}
 
sub chinese-remainder(*@n) {
    my \N = [*] @n;
    -> *@a {
	N R% [+] map {
	    my \p = N div @n[$_];
	    @a[$_] * mul-inv(p, @n[$_]) * p
	}, ^@n
    }
}
