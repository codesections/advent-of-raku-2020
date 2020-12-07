my @groups = slurp.split(/\n\n+/);

say 'A: ',
sum @groups.map({ .comb(/\w/).Bag })».keys;

say 'B: ',
sum @groups.map: -> $ans { +$ans.comb(/\w/).Bag.grep: {.value == $ans.lines} };
