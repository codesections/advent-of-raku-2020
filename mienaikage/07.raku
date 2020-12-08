#!/usr/bin/env raku

grammar BagColors {
  token TOP {
    <color> ' bags contain '
    <contents> ** 1..* % [ ' bag' s? ', ' ] ' bag' s? '.'
  }
  token contents {  <amount> ' ' <color> }
  token color    { [<[a..z]>+] ** 2 % ' ' }
  token amount   {  <[0..9]>+ }
}

sub MAIN (
  #| Path to input file
  IO() :$file where *.f = ( .sibling('input/' ~ .extension('txt').basename) with $?FILE.IO ),
  #| Part of the exercise (1 or 2)
  Int  :$part where * == 1|2 = 1,
  #| Color of the bag
  Str  :$color = 'shiny gold',
  --> Nil
) {
  say do given $file.lines.map({
    .&({
      .<color>.Str => .<contents>.map({ .<color>.Str => .<amount>.Int }).Bag
    }) with BagColors.parse($_)
  }).Hash {

    when $part == 1 {
      .&( method ( $elem = $color ) {
        gather {
          for self.pairs {
            if $elem ∈ .value -> | {
              .key.take;
              self.&?ROUTINE(.key).Slip.take;
            }
          }
        }
      }).unique.elems
    }

    when $part == 2 {
      [+] .&( method ( $key = $color ) {
        gather {
          with self{$key} {
            for .pairs {
              .value.take;
              for ^.value -> $ {
                self.&?ROUTINE(.key).Slip.take;
              }
            }
          }
        }
      })
    }

  }
}
