#!/usr/bin/env raku
use v6.d;

grammar Baggage {
    rule TOP      { <rule> ** 1..* }
    rule rule     { <color> <.bag-contain> <contents> '.' }
    rule contents { [ <.empty> | <quantity> <color> <.bag> ] ** 1..* % ',' }
    token color       { \w+ \W+ \w+ }
    token bag-contain { 'bags contain' }
    token empty       { 'no other bags' }
    token quantity    { \d+ }
    token bag         { 'bag' 's'? }
}

class BaggageActions {
    has $.inside = {};
    has $.outside = {};
    method rule($/) {
        return  if 'no other bags' eq ~$<contents>;
        my $outer = ~$<color>;
        my $inner = %( $<contents>.<color>.map({~$_}).List Z=> $<contents>.<quantity>.map({+$_}).List );
        $!inside{$outer} = $inner;
        for $inner.pairs {
            $!outside{.key}.push($outer);
        }
    }
}

sub MAIN (
    IO() :$input where *.f     = $?FILE.IO.sibling('input'),
    Int  :$part where * == 1|2 = 1, # Solve Part One or Part Two?
    --> Nil
) {
    my $a = BaggageActions.new();
    Baggage.parse($input.slurp, :actions($a));
    given $part {
        when 1 { can_contain('shiny gold').elems.say }
        when 2 { bags_required('shiny gold').say }
    }

    sub can_contain (Str $color) {
        $a.outside{$color}.map({ $_ ?? ($_, can_contain($_)) !! () }).flat.Slip.unique;
    }

    sub bags_required (Str $color) {
        $a.inside{$color}.pairs.map({ .value + .value * bags_required(.key) }).sum;
    }
}
