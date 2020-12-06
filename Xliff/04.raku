my $input = 'input/04.input'.IO.slurp;
my @categories = <byr iyr eyr hgt hcl ecl pid cid>;

grammar PassportGrammar {
  rule TOP     { <fields>+ % \n  }
  token fields { <field>+ % \s   }
  token field  { <cat>':'<value> }
  token cat    { @categories     }
  token value  { <-[\s]>+        }
}

class PassportGrammarAction {
  method TOP    ($/) { make $/<fields>.map( *.made )             }
  method fields ($/) { make $/<field>. map( *.made ).Hash        }
  method field  ($/) { make Pair.new($/<cat>.Str, $/<value>.Str) }
}

# Part 1
PassportGrammar.parse($input, actions => PassportGrammarAction).made.grep({
  [||](
    .elems == @categories.elems,
    .elems == @categories.elems - 1 && .<cid>.defined.not,
  )
).elems.say;

# Part 2
PassportGrammar.parse($input, actions => PassportGrammarAction).made.grep({
  [&&](
    [||](
      .elems == @categories.elems,
      .elems == @categories.elems - 1 && .<cid>.defined.not,
    ),
    .<byr> ~~ / ^ (\d ** 4) <?{ 1920 <= $/[0].Int <= 2002 }> $ /,
    .<iyr> ~~ / ^ (\d ** 4) <?{ 2010 <= $/[0].Int <= 2020 }> $ /,
    .<eyr> ~~ / ^ (\d ** 4) <?{ 2020 <= $/[0].Int <= 2030 }> $ /,
    .<hgt> ~~ / ^ (\d+) ('cm' | 'in') <?{ $/[1].Str eq 'cm' ?? ( 150 <= $/[0].Int <= 193 )
                                                            !! ( 59  <= $/[0].Int <= 76  ) }> $ /,
    .<hcl> ~~ / ^ '#' <[0..9a..f]> ** 6 $ /,
    .<ecl> ~~ / ^ ['amb' | 'blu' | 'brn' | 'gry' | 'grn' | 'hzl' | 'oth' ] $ /,
    .<pid> ~~ / ^ <[0..9]> ** 9 $ /
  );
}).elems.say;
