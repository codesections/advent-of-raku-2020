my $now = now;

my @mountain = lines;

say 'A: ', (toboggan 3), (now - $now).fmt("\t(%.2f seconds)");

$now = now;

say 'B: ', (toboggan < 1 3 5 7 1/2 >), (now - $now).fmt("\t(%.2f seconds)");

sub toboggan (*@slopes) {
    [*] @slopes».Rat.map: -> $slope {
        @mountain[1 .. *].batch($slope.denominator).map( {
            state $path = 0;
            $path = ($path + $slope.numerator) % .tail.chars;
            .tail.comb[$path];
        } ).Bag<#>
    }
}
