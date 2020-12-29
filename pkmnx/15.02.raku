#!/usr/bin/env raku

sub MAIN() {

   my $lim = 30000000;
   my @input = <14 8 16 0 1 17>;

   my $h = [];

   my $hd;
   my $cnt = 2;
   @input.map(-> $n { $h[$n] = $cnt++; $hd = $n });

   for ( (@input.elems +1) .. $lim ) -> $i {
      my $tail = 0;
      $tail = $i - $h[$hd] if $h[$hd].defined;

      $h[$hd] = $i;
      $hd = $tail;
   }

   $hd.say;

}
