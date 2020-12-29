#!/usr/bin/env raku

say [+] 'input.txt'.IO.slurp.split("\n\n").map: *.lines.join.comb.unique.elems;

# 6947
