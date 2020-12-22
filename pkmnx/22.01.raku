#!/usr/bin/env raku

sub MAIN() {

  my $h = {};
  my $p = "";
  my @ps = [];
  my $totalCards = 0;

  for lines() -> $l {
     if ( $l ~~ /layer.*?(\d+)/ ) {
        $p = $0 + 0;
        @ps.push($p +0);
     }
     if ( $p.chars > 0 and  $l ~~ /^\d+/ ) {
       $h{$p}.push($l +0);
       $totalCards++;
     }
  }

   my @stack = ();
   my $round = 1;
   my $max;
   my $processing = True;

   while ( $processing ) {

      @ps.map(-> $p {
         @stack.push({ id => @stack.elems, p => $p, c => $h{$p}.shift } );
      });
 
      $max = @stack.max({$_{"c"}});

      if ( $max{"id"} == 0 ) { 
          while ( @stack ) { 
             my $cd = @stack.shift;
             $h{ $max{"p"} }.push( $cd{"c"} );
          }
      } else {
          while ( @stack ) { 
             my $cd = @stack.pop;
             $h{ $max{"p"} }.push( $cd{"c"} );
          }
      }

      $round++;

      @ps.map(-> $p {
          $processing = False if $h{$p}.elems == 0;
      })

   }

   my $val = 0;
   my $ar = $h{$max{"p"}};
   if ( $ar.elems == $totalCards ) { 
      my $t = $totalCards;
      $ar.map( -> $c {
         $val += $c * $t;
         $t--;
      });
   }

   $val.say;
}
