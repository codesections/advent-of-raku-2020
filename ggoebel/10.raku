#!/usr/bin/env raku
use v6.d;

unit sub MAIN (
        IO() :$input where *.f     = $?FILE.IO.sibling('input'),
        Int  :$part where * == 1|2 = 1, # Solve Part One or Part Two?
        --> Nil
);

# valid permutations (p) per length of consecutive (c) numbers
# ( no more than 4 consecutive numbers found in input )
my @p = (1,1,2,4,7);

given $part {
    when 1 {
        say $input.lines».Int.sort.&{((|@$_,.tail+3) Z-(0,|@$_)).Bag.&{.{1}*.{3}}}
    }
    when 2 {
        my @c = 0;
        say $input.lines».Int.sort.&{ 0, |@$_, .tail+3 }.&{
            .rotor(2 => -1)
            .map({ .[1]-.[0]==1 ?? @c[*-1]++ !! @c.push(0) });
            @c;
        }.map({ @p[$_] }).reduce(&infix:<*>);
    }
}



