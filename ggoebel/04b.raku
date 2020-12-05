#!/usr/bin/env raku
use v6.d;
#use Grammar::Tracer;

my @fields = <byr cid ecl eyr hcl hgt iyr pid>;

grammar Passport1 {
    token TOP { [ <field> ':' \S+ ] ** 0..* % \s+ }
    token field { @fields }
}

grammar Passport2 {
    token TOP { <field> ** 0..* % \s+ }
    token fs { ':' }
    token year4d { <.digit> ** 4 }
    token byr { 'byr' <.fs> (<.year4d>) <?{ 1920 <= $/[0].Int <= 2002 }> }
    token cid { 'cid' <.fs> \S+ }
    token ecl { 'ecl' <.fs> [ amb || blu || brn || gry || grn || hzl || oth ] }
    token eyr { 'eyr' <.fs> (<.year4d>) <?{ 2020 <= $/[0].Int <= 2030 }> }
    token hcl { 'hcl' <.fs> '#' <.xdigit> ** 6 }
    token hgt { 'hgt' <.fs> [  ( <.digit> ** 3 ) <?{ 150 <= $/[0].Int <= 193 }> 'cm'
                            || ( <.digit> ** 2 ) <?{ 59 <= $/[0].Int <= 76 }>   'in' ] }
    token iyr { 'iyr' <.fs> (<.year4d>) <?{ 2010 <= $/[0].Int <= 2020 }> }
    token pid { 'pid' <.fs> <digit> ** 9 }
    token field { ( <byr> || <cid> || <ecl> || <eyr> || <hcl> || <hgt> || <iyr> || <pid> )
    }
}

sub MAIN (
        IO() :$input where *.f     = $?FILE.IO.sibling('input'),
        Int  :$part where * == 1|2 = 1, # Solve Part One or Part Two?
        --> Nil
) {
    my @batch = $input.slurp.split("\n\n", :skip-empty);
    if $part == 1 {
        @batch.grep({ Passport1.parse(.trim)<field>>>.Str ⊇ @fields ∖ <cid> }).elems.say;
    } else {
        @batch.grep({Passport2.parse(.trim)<field>
                              .grep({.defined})
                              .map({.subst(/\:.*/)}) ⊇ @fields ∖ <cid> }).elems.say;
    }
}

