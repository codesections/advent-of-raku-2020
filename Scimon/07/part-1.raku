#!/usr/bin/env raku

use v6;

sub MAIN ( Str $file where "example"|"input"|"example2", Str $type = "shiny", Str $color = "gold" ) {
    my $bag = "$type $color";
    my $rules = parse-file( $file );
    my @to-check = ($bag);
    my %holders;

    while (@to-check) {
        my $check = shift @to-check;
        my @holders = $rules{$check}<contained>.keys;
        for @holders -> $h {
            %holders{$h} = True;
            @to-check.push($h);
        }
    }
    
    say %holders.keys.elems;
    say bag-count( $bag, $rules ) - 1;

}

sub bag-count ( $bag, $rules ) is pure {
    my $count = 1;
    for $rules{$bag}<contains>.kv -> $inner, $number {
        $count += $number * bag-count($inner, $rules);
    }
    
    return $count;
}

#`[
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
]

sub parse-file( $file ) {
    my $rules = {};
    for $file.IO.lines -> $line {
        my $match = $line ~~ m/^$<bag>=(\S+ " " \S+) " bags contain" "s"? " " $<contains>=($<none>=("no other bags")|$<item>=($<count>=(\d+) " " $<bag>=(\S+ " " \S+) " bag" "s"?)+ % ", ")\.$/;
        my $bag = $match<bag>.Str;
        $rules{$bag} //= { "contained" => {}, "contains" => {} };
        next if $match<contains><none>;
        for $match<contains><item> -> $item {
            my $target-bag = $item<bag>.Str;
            my $count = $item<count>.Int;
            $rules{$target-bag} //= { "contained" => {}, "contains" => {} };
            $rules{$bag}<contains>{$target-bag} = $count;
            $rules{$target-bag}<contained>{$bag} = True;
        }
    }
    return $rules;
}
