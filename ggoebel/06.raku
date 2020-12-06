#!/usr/bin/env raku
use v6.d;
sub rv (&code) { 'input'.IO.slurp.split("\n\n", :skip-empty).map(&code).sum }
say "One: " ~ rv { .comb(/\S/).Set.elems };
say "Two: " ~ rv { .lines.map({ .comb(/\S/).Set }).reduce(&infix:<∩>).elems };


