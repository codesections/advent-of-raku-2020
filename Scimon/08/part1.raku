#!/usr/bin/env raku

use v6;

sub MAIN( Str $file where "input"|"example" ) {
    my @ops = $file.IO.lines.map( { my @o = $_.split(" ");@o[1].=Int; { op => @o[0], nm => @o[1] }  } );
    my $idx = 0;
    my $acc = 0;
    my %seen;

    while ( ! %seen{$idx} ) {
        %seen{$idx} = True;
        ( $idx, $acc ) = perform( @ops[$idx]<op>, @ops[$idx]<nm>, $idx, $acc );
    }

    say $acc;
}

multi sub perform( "nop", $val, $idx, $acc ) {
    return ( $idx+1, $acc );
}

multi sub perform( "acc", $val, $idx, $acc ) {
    return ( $idx+1, $acc+$val );
}

multi sub perform( "jmp", $val, $idx, $acc ) {
    return ( $idx+$val, $acc );
}
