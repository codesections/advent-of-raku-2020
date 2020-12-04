#!/usr/bin/env raku

my @fields := <byr cid ecl eyr hcl hgt iyr pid>;

grammar PassportPart1 {
  token TOP   { [ <field> ':' \S+ ] ** 1..* % \s+ }
  token field { @fields }
}

grammar PassportPart2 {
  my @field-patterns = @fields.map({ " $_':' <$_> " });
  token TOP { ( <@field-patterns> ) ** 1..* % \s+ }

  token byr { ( <[0..9]> ** 4 ) <?{ 1920 ≤ $/[0].Int ≤ 2002 }> }
  token cid {  \S+ }
  token ecl {  [ amb || blu || brn || gry || grn || hzl || oth ] }
  token eyr {  ( <[0..9]> ** 4 ) <?{ 2020 ≤ $/[0].Int ≤ 2030 }> }
  token hcl { '#' <.xdigit> ** 6 }
  token hgt {
    [
      || ( <[0..9]> ** 3 ) <?{ 150 ≤ $/[0].Int ≤ 193 }> 'cm'
      || ( <[0..9]> ** 2 ) <?{ 59  ≤ $/[0].Int ≤ 76  }> 'in'
    ]
  }
  token iyr { ( <[0..9]> ** 4 ) <?{ 2010 ≤ $/[0].Int ≤ 2020 }> }
  token pid { <[0..9]> ** 9 }
}

sub MAIN (
  IO() :$file where *.f      = $?FILE.IO.sibling('input/04.txt'), #= Path to input file
  Int  :$part where * == 1|2 = 1, #= Part of the exercise (1 or 2)
  --> Nil
) {
  given $file.slurp.split("\n" x 2, :skip-empty) {
    when $part == 1 {
      .grep({ PassportPart1.parse(.trim)<field>».Str ⊇ @fields ∖ <cid> })
        .elems
        .say;
    }

    when $part == 2 {
      .grep({ PassportPart2.parse(.trim)[0].map({ .subst(/':'.*/) if $_ }) ⊇ @fields ∖ <cid> })
        .elems
        .say;
    }
  }
}
