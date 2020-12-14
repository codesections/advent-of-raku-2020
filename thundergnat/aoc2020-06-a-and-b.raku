my $now = now;

my @groups = slurp.split(/\n\n+/);

say 'A: ',
(sum @groups.map({ .comb(/\w/).Bag })».keys), (now - $now).fmt("\t(%.2f seconds)");

$now = now;

say 'B: ',
(sum @groups.map: -> $ans { +$ans.comb(/\w/).Bag.grep: {.value == $ans.lines} }),
(now - $now).fmt("\t(%.2f seconds)");
