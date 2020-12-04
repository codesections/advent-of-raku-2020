my @mountain = lines;

say 'A: ', toboggan 3;
say 'B: ', toboggan < 1 3 5 7 1/2 >;

sub toboggan (*@slopes) {
    [*] @slopes».Rat.map: -> $slope {
        @mountain[1 .. *].batch($slope.denominator).map( {
            state $path = 0;
            $path = ($path + $slope.numerator) % .tail.chars;
            .tail.comb[$path];
        } ).Bag<#>
    }
}
