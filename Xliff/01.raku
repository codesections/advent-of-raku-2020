#!/usr/bin/env raku
my @input = 'input/1.input'.IO.slurp.lines.map( *.Int );
sub find2020 ($n = 2) {
  for @input.combinations($n) {
    if .sum == 2020 {
      say "({ .[0] } x { .[1] }) = { [*]( |$_ ) }";
      last;
    }
  }
}
find2020;
find2020(3);
