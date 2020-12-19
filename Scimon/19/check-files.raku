#!/usr/bin/env/raku

use v6;
use lib ".";

multi sub MAIN ( "example1" ) {
    use Example1;
    my &parser = sub ( $line ) { so Example1.parse($line) }
    say check-lines( "example1", &parser );
}

sub check-lines( $file, &parser ) {
    my $count;
    for $file.IO.lines -> $line {
        $count++ if &parser($line);
    }
    return $count;
}

multi sub MAIN( "example2" ) {
    use Example2;
    my &parser = sub ( $line ) { so Example2.parse($line) }
    say check-lines( "example2", &parser );
}

multi sub MAIN( "input" ) {
    use Input;
    my &parser = sub ( $line ) { so Input.parse($line) }
    say check-lines( "input", &parser );
}

multi sub MAIN( "input2" ) {
    use Input2;
    my &parser = sub ( $line ) { so Input2.parse($line) }
    say check-lines( "input2", &parser );
}

multi sub MAIN ( "example3" ) {
    use Example3;
    my &parser = sub ( $line ) { so Example3.parse($line) }
    say check-lines( "example3", &parser );
}

multi sub MAIN ( "example4" ) {
    use Example4;
    my &parser = sub ( $line ) { so Example4.parse($line) }
    say check-lines( "example4", &parser );
}
