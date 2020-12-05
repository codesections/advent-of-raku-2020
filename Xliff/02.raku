#!/usr/bin/env raku
my $input = 'input/02.input'.IO.slurp;
my ($valid, $valid2) = 0 xx 2;
for $input.lines {
  use MONKEY-SEE-NO-EVAL;
  my ($hi, $lo, $letter);
  my ($policy, $password) = .split(': ');
  my $vchars = $password;

  given $policy.split(' ').reverse {
    my $l = "<-[{ $letter = .[0] }]>";
    $vchars ~~ s:g/<$l>//;
    ($lo, $hi) = .[1].split('-');
  }

  $valid++  if $lo <= $vchars.chars <= $hi;
  $valid2++ if [^^](
    $password.substr($lo - 1, 1) ne $letter,
    $password.substr($hi - 1, 1) ne $letter
  );
}
say "1: { $valid  } valid passwords";
say "2: { $valid2 } valid passwords";
