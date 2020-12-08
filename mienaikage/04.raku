#!/usr/bin/env raku

my @fields := <byr cid ecl eyr hcl hgt iyr pid>;

grammar Passport {
  token simple { [ ( @fields ) ':' \S+ ] ** 1..* % \s+ }

  my @field-patterns = @fields.map({ '$<key>=' ~ "[$_] ':' <value=.$_>" });

  token TOP { <pairs=@field-patterns> ** 1..* % \s+ }
  token byr { <[0..9]> ** 4 <?{ $/.Int ~~ 1920..2002 }> }
  token cid { \S+ }
  token ecl { amb || blu || brn || gry || grn || hzl || oth }
  token eyr { <[0..9]> ** 4 <?{ $/.Int ~~ 2020..2030 }> }
  token hcl { '#' <.xdigit> ** 6 }
  token hgt {
    [
      || <[0..9]> ** 3 <?{ $/.Int ~~ 150 .. 193 }> 'cm'
      || <[0..9]> ** 2 <?{ $/.Int ~~  59 ..  76 }> 'in'
    ]
  }
  token iyr { <[0..9]> ** 4 <?{ $/.Int ~~ 2010..2020 }> }
  token pid { <[0..9]> ** 9 }
}

sub MAIN (
  #| Path to input file
  IO() :$file where *.f = ( .sibling('input/' ~ .extension('txt').basename) with $?FILE.IO ),
  #| Part of the exercise (1 or 2)
  Int  :$part where * == 1|2 = 1,
  --> Nil
) {
  say do given $part {
    when 1 {
      result { Passport.parse( $_, :rule<simple> )[0]».Str }
    }
    when 2 {
      result { Passport.parse($_)<pairs>.map({ ~.<key> if $_ }) }
    }
  };

  sub result ( &parser --> Int ) {
    $file.slurp.split("\n" x 2, :skip-empty)».trim
      .map(&parser)
      .grep(* ⊇ @fields ∖ <cid>)
      .elems
    ;
  }
}
