#!/usr/bin/env raku
use v6.d;
#use Grammar::Tracer;

my $input = 'input'.IO.slurp;

my %node;
grammar Baggage {
    token TOP { <rule>  ** 1..* %% "\n"}
    token rule {
        <color> <.bag-contain> <contents> '.'
        { %node{~$<color>} = [ $<contents>.<color>.map({~$_}).List Z=> $<contents>.<quantity>.map({+$_}).List ]  }
    }
    token color { \w+ <.ws> \w+ }
    token bag-contain { <.ws> 'bags contain' <.ws> }
    token contents { [ <.empty> | <quantity> <.ws> <color> <.ws> <.bag> ] ** 1..* % ', ' }
    token empty { 'no other bags' }
    token quantity { \d+ }
    token bag { 'bag' 's'? }
}

my $match = Baggage.parse($input);
say "Part One: " ~ containers_of('shiny gold').flat.unique.elems;
say "Part Two: " ~ bags_required_by('shiny gold');

sub containers_of (Str $match) {
    %node.pairs
        .grep({ 0 != .value.grep({ .key eq $match }) })
        .map({ ~.key, containers_of(.key) })
}

sub bags_required_by (Str $match --> Int) {
    %node{$match}.List.map({ .value + .value * bags_required_by(.key) }).sum;
}
