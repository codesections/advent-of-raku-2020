my @groups = slurp.split(/\n\n+/);

say 'A: ',
sum @groups.map({ .subst(/\s/,'',:g).comb.Bag })».keys;

say 'B: ',
sum @groups.map: -> $ans { +$ans.subst(/\s/,'',:g).comb.Bag.grep: {.value == $ans.lines} };
