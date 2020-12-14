#/usr/bin/env raku

use v6

sub MAIN ( $file where "example"|"input" ) {
    my $dir = "E";
    my $n = 0;
    my $e = 0;

    for $file.IO.lines.map( { my %h = ( c => $_.substr(0..0), v => $_.substr(1..*).Int ) } ) -> %rules {
        ( $dir, $n, $e ) = process( %rules<c>, %rules<v>, $dir, $n, $e );
    }

    say abs($n) + abs($e);
}

multi sub process( "N", $val, $d, $n, $e ) { ( $d, $n+$val, $e ) }
multi sub process( "S", $val, $d, $n, $e ) { ( $d, $n-$val, $e ) }
multi sub process( "E", $val, $d, $n, $e ) { ( $d, $n, $e+$val ) }
multi sub process( "W", $val, $d, $n, $e ) { ( $d, $n, $e-$val ) }
multi sub process( "F", $val, "N", $n, $e ) { ( "N", $n+$val, $e ) }
multi sub process( "F", $val, "S", $n, $e ) { ( "S", $n-$val, $e ) }
multi sub process( "F", $val, "E", $n, $e ) { ( "E", $n, $e+$val ) }
multi sub process( "F", $val, "W", $n, $e ) { ( "W", $n, $e-$val ) }
multi sub process( $ where "L"|"R", 0, $d, $n, $e ) { ( $d, $n, $e ) }
multi sub process( "L", $val, "N", $n, $e ) { process( "L", $val-90, "W", $n, $e ) }
multi sub process( "L", $val, "S", $n, $e ) { process( "L", $val-90, "E", $n, $e ) }
multi sub process( "L", $val, "E", $n, $e ) { process( "L", $val-90, "N", $n, $e ) }
multi sub process( "L", $val, "W", $n, $e ) { process( "L", $val-90, "S", $n, $e ) }
multi sub process( "R", $val, "N", $n, $e ) { process( "R", $val-90, "E", $n, $e ) }
multi sub process( "R", $val, "S", $n, $e ) { process( "R", $val-90, "W", $n, $e ) }
multi sub process( "R", $val, "E", $n, $e ) { process( "R", $val-90, "S", $n, $e ) }
multi sub process( "R", $val, "W", $n, $e ) { process( "R", $val-90, "N", $n, $e ) }
