my $now = now;

use MONKEY;

my @expr = lines;

say 'B: ', (sum @expr.race(:8batch).map: { EVAL .trans(<[*+]> => <[⊗⊕]>) }),
  (now - $now).fmt("\t(%0.2f seconds)");


sub infix:<⊕> is equiv(&prefix:<+>) { $^x + $^y }
sub infix:<⊗> is looser(&prefix:<+>) { $^x × $^y }
