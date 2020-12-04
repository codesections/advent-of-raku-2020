#!/usr/bin/env raku

$*IN.nl-in = "\n\n";

sub MAIN( Str $pt2 ) {

   my @data = getData();

   my @mus = <byr iyr eyr hgt hcl ecl pid>;

   my $cntok = 0;
   my $cnt1 = 0;

   for ( @data ) -> $h {

      my $cnt = 0;
      my @not = ();
      for (@mus) {
         if ( $h{$_}:!exists ) {
           $cnt++;
           push @not, $_;
         }
      }

      if ($cnt > 0 ) {
         #  @not.say;
      } else {

        $cnt1++;

        if ( ( $h{'byr'} ~~ /^\d\d\d\d$/ && $h{'byr'} >= 1920 && $h{'byr'} <= 2002 ) &&
             ( $h{'iyr'} ~~ /^\d\d\d\d$/ && $h{'iyr'} >= 2010 && $h{'iyr'} <= 2020 ) &&
             ( $h{'eyr'} ~~ /^\d\d\d\d$/ && $h{'eyr'} >= 2020 && $h{'eyr'} <= 2030 ) &&
             ( $h{'hgt'} ~~ /^\d+(cm|in)$/ ) &&
             ( $h{'hcl'} ~~ /^\#<[ 0 .. 9 a .. f ]> ** 6$/ ) &&
             ( $h{'ecl'} ~~ /^(amb|blu|brn|gry|grn|hzl|oth)$/ ) &&
             ( $h{'pid'} ~~ /^<[0 .. 9]> ** 9$/
         ) ) {

            my $hOK = 0;
            if ( $h{'hgt'} ~~ /cm/ &&  $h{'hgt'} ~~ /(\d+)/ ) {
               my $n = $0;
               if ( $n >= 150 && $n <= 193 ) {
                  $hOK++;
               }
            }
            elsif ( $h{'hgt'} ~~ /in/ &&  $h{'hgt'} ~~ /(\d+)/ ) {
               my $n = $0;
               if ( $n >= 59 && $n <= 76 ) {
                  $hOK++;
               }
            }

            if ( $hOK > 0 ) {
               $cntok++;
            }

         }

      }

   }

   if ( $pt2 ~~ "2" ) {
      $cntok.say;
   } else {
      $cnt1.say;
   }

}

sub getData() { 
   my @data = ();
   for lines() -> $l is copy {
      $l ~~ s:g/\n/ /;
      
      my $h;
      for $l.split(/\s/) {
         $h{$0} = "$1" if /(.*) \: (.*)/;
      }
      @data.push( $h );
   }
   return @data;
}
