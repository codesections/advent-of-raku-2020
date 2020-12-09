#!/usr/bin/env raku
my $input = 'input/06.raku'.IO.slurp;
my (@groups, $group, $numInGroup);
for $input.lines {
  if .chars {
    $group{$_}++ for .comb;
    $numInGroup++;
  } else {
    @groups.push: [ $group, $numInGroup ];
    ($numInGroup, $group) = ( 0, {} );
  }
}

# Part 1
@groups.push: [$group, $numInGroup];
@groups.map( *[0].keys.elems ).sum.say;

# Part 2
@groups.map(-> $ge { [ $ge[0].pairs.grep( *.value == $ge[1] ).Hash, $ge[1] ] })
       .map( *[0].keys.elems )
       .sum
       .say;
