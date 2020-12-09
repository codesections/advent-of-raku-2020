#!/usr/bin/env raku
my $input = 'input/07.input'.IO.slurp;

grammar BagGrammar {
    regex  TOP      { <bag-rule>+ }
    regex  bag-rule {
        <bag> <.ws> 'contain' <.ws> [ <amount> <.ws> <bag> ]+ % ', ' ".""\n"?
    }
    token  amount   { 'no other' | \d+ }
    regex  bag      { [ $<color>=((\w+)+ % <.ws>) <.ws> ]? 'bag''s'? }
}

my %rules;
class BagGrammarActions {
  method bag-rule ($/) {
    for $/<bag>.skip(1).kv -> $k, $v {
      my $base-color = $/<bag>[0]<color>.Str;
      if $v<color> {
        %rules{$base-color}.push: {
          color  => $v<color>.Str,
          amount => (try $/<amount>[$k].Int) // 0
        };
      } else {
        %rules{$base-color} = [];
      }
    }
  }
}

my @found-at;
multi sub containsColor ( $color, $node-color, $visited is rw ) {
  return True  if $node-color eq @found-at.any;
  return True  if $color      eq $node-color;
  return False if $color      eq $visited.any;
  $visited.push: $node-color;
  for %rules{$node-color}[] {
    if containsColor($color, .<color>, $visited) {
      @found-at.push: $node-color;
      return True;
    }
  }

  False;
}

multi sub containsColor ($color) {
  my $visited = [];
  my $c = 0;
  for %rules.keys {
    containsColor($color, $_, $visited);
    print (++$c %% 20).not ?? '.' !! $c;
  }
  @found-at.elems;
}

sub bagsInBags ($color) {
  say $color;
  return 1 unless %rules{$color}.elems;
  1 + %rules{$color}.map({ .<amount> * bagsInBags(.<color>) }).sum;
}

BagGrammar.parse($input, actions => BagGrammarActions);
# Part 1
# cw: Was this task supposed to take 31 minutes on an i9-7900x, using the
#     real input?!?
#say containsColor('shiny gold');
# Part 2
say bagsInBags('shiny gold') - 1;

# INIT $input = q:to/INPUT/;
# light red bags contain 1 bright white bag, 2 muted yellow bags.
# dark orange bags contain 3 bright white bags, 4 muted yellow bags.
# bright white bags contain 1 shiny gold bag.
# muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
# shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
# dark olive bags contain 3 faded blue bags, 4 dotted black bags.
# vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
# faded blue bags contain no other bags.
# dotted black bags contain no other bags.
# shiny gold bags contain 2 dark red bags.
# dark red bags contain 2 dark orange bags.
# dark orange bags contain 2 dark yellow bags.
# dark yellow bags contain 2 dark green bags.
# dark green bags contain 2 dark blue bags.
# dark blue bags contain 2 dark violet bags.
# dark violet bags contain no other bags.
# INPUT
