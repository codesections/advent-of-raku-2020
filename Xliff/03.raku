#!/usr/bin/env raku
my $input = 'input/03.input'.IO.slurp;
my $width = $input.lines.map( *.chars ).max;
sub treesBySlope($across = 3, $down = 1) {
  my ($i, $trees) = 0 xx 2;
  for $input.lines.skip(1).rotor($down) {
    $trees++
      if .tail.substr( ($i += $across) % $width, 1) eq '#';
  }
  say "$across x $down: $trees";
  $trees;
}

my @slopes = ( (1, 1), (5, 1), (3, 1), (7, 1), (1, 2) );

say [*](
  |(gather for @slopes {
    take treesBySlope( |$_ )
  })
);
