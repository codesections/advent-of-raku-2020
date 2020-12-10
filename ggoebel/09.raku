#!/usr/bin/env raku
use v6.d;

unit sub MAIN (
    IO() :$input where *.f     = $?FILE.IO.sibling('input'),
    Int  :$part where * == 1|2 = 1, # Solve Part One or Part Two?
    --> Nil
);

given $part {
    my @xmas = $input.lines.map({ +$_ });
    when 1 { say find_invalid(@xmas, 25) }
    when 2 { say weakness(@xmas, find_invalid(@xmas, 25)) }
}

sub find_invalid (@xmas, Int $psize --> Int ){
    my $idx = 0;
    repeat {
        my @p   = @xmas[$idx..$idx+$psize-1];
        my @sum = @p.combinations(2).map({.sum}).unique;
        last  if Nil === @sum.first(@xmas[$idx+$psize]);
        $idx++;
    } while $idx + $psize < @xmas.end;
    return +@xmas[$idx+$psize];
}

sub weakness(@xmas, $invalid) {
    my @contig;
    OUTSIDE: loop (my Int $i = 0; $i < @xmas.elems; $i++) {
        my $j = $i;
        INSIDE: while (@contig.sum < $invalid) {
            @contig.push(@xmas[$j++]);
            if @contig.sum == $invalid {
                last OUTSIDE;
            }
        }
        @contig = ();
    }
    my $min = @contig.list.min;
    my $max = @contig.list.max;
    my $r = @contig.min + @contig.max;
    return $r;
}

# Tests (run with `raku -MTest --doc -c [THIS_FILE_NAME]`)
DOC CHECK { multi is(|) { callsame }
my $input = q:to/§/;
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    §

    my @xmas = $input.lines.map({ +$_ });
    my $invalid = find_invalid(@xmas, 5);
    say "Part One: $invalid";
    say "Part Two: {weakness(@xmas, $invalid)}";
}