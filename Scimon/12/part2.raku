#/usr/bin/env raku

use v6

sub MAIN ( $file where "example"|"input" ) {
    my $wn = 1;
    my $we = 10;
    my $sn = 0;
    my $se = 0;

    for $file.IO.lines.map( { my %h = ( c => $_.substr(0..0), v => $_.substr(1..*).Int ) } ) -> %rules {
        ( $sn, $se, $wn, $we ) = process( %rules<c>, %rules<v>, $sn, $se, $wn, $we );
    }

    say abs($sn) + abs($se);
}

multi sub process( "N", $val, $sn, $se, $wn, $we ) { ( $sn, $se, $wn+$val, $we ) }
multi sub process( "S", $val, $sn, $se, $wn, $we ) { ( $sn, $se, $wn-$val, $we ) }
multi sub process( "E", $val, $sn, $se, $wn, $we ) { ( $sn, $se, $wn, $we+$val ) }
multi sub process( "W", $val, $sn, $se, $wn, $we ) { ( $sn, $se, $wn, $we-$val ) }
multi sub process( "F", $val, $sn, $se, $wn, $we ) { ( $sn+($wn*$val), $se+($we*$val), $wn, $we ) }
multi sub process( $ where "L"|"R", 0, $sn, $se, $wn, $we ) { ( $sn, $se, $wn, $we ) }
multi sub process( "L", $val, $sn, $se, $wn, $we ) { process( "L", $val-90, $sn, $se, $we, -$wn ) }
multi sub process( "R", $val, $sn, $se, $wn, $we ) { process( "R", $val-90, $sn, $se, -$we, $wn ) }
