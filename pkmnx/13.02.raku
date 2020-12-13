#!/usr/bin/env raku

sub MAIN() {

   my $nms = {};
   my $cnt = 0;
   lines().grep(/','/).split(/','/).map({ $nms{$_.Int} = $cnt if $_ ~~ /\d+/; $cnt++ });

   my $inc = 1;
   my @st = (0);
   for ( $nms.kv ) -> $k, $v {
    
     my $pos = @st.head;
     @st = ();
   
     while ( @st.elems < 2 ) {
        ( ($pos + $v) %% $k ) && @st.push($pos);
        $pos += $inc if @st.elems < 2;
     }

     $inc = $pos - @st.head;

   }

   say @st.head;

}
