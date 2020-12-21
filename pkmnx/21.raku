#!/usr/bin/env raku

sub MAIN() {

   my $f = {};
   my $i = {};

   my $cnt = 0;
   for lines() -> $l {
      if ( $l ~~ / (.*) \s+ .*ntains\s+ (.*?) \) / ) {
         my @ing = (split /\s+/, $0).grep(/\w+/);
         my @con = (split /\,\s+/, $1).grep(/\w+/);

         for (@ing) -> $in {
            $i{$in}.push($cnt);
         }
         for (@con) -> $cn {
            $f{$cn}.push($cnt);
         }

      }
      $cnt++;
   }

   my $removing = True;

   my $remcnt = 0;
   for $i.kv -> $k, $v {
      if ( $v.elems == 1 ) {
         $i{$k}:delete;
         $remcnt++;
      }
   }

   my $list = {};

   while ( $removing ) {

      my $cnts = {};

      for $f.kv -> $k, $v {
         for $i.kv -> $ki, $vi {
            my $nv = ( $v.Set (&) $vi.Set );
            if ( $nv ~~ $v.Set ) {
               $cnts{$k}{$ki}++;
            }
         }
      }

      for $cnts.kv -> $k, $v {
         if ( $v.elems == 1 ) {
            my $rem = {};
            $f{$k}.map({$rem{$_}++});
            $f{$k}:delete;

            for $cnts{$k}.kv -> $kk, $vv {
                $i{$kk}:delete;
                $list{$k} = $kk;
            }

         }
      }

      if ( $cnts.keys.elems == 0 ) { 
         $removing = False;
      }
   }

   
   for $i.kv -> $ki, $vi {
#      $ki.say;
      $remcnt += $vi.elems;
   }

   $remcnt.say;

   $list.keys.sort().map({$list{$_}}).join(",").say;
}
