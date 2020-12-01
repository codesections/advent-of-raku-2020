#!/usr/bin/env raku

sub MAIN() {

   my @lines = lines;

   my $fn = sub ( @l, $bag, $hit ) {
      ( ([+] $_) ==$hit ) && return ([*] $_) for @l.combinations($bag)
   };

   $fn( @lines, 3, 2020 ).say;
   $fn( @lines, 2, 2020 ).say;

}
