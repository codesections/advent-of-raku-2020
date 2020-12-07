#!/usr/bin/env raku
use v6.d;
#use Grammar::Tracer;

my $input = 'input'.IO.slurp;
my $txt = q:to/END/;
$input = 'light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.';
END

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

my $actions = BaggageActions.new();
Baggage.parse($input, :actions($actions));
say "One: " ~ can_contain('shiny gold').elems;
say "Two: " ~ bags_required('shiny gold');

sub can_contain (Str $color) {
    $actions.outside{$color}.map({ $_ ?? ($_, can_contain($_)) !! () }).flat.Slip.unique;
}

sub bags_required (Str $color) {
    $actions.inside{$color}.pairs.map({ .value + .value * bags_required(.key) }).sum;
}
