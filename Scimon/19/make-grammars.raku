#!/usr/bin/env raku

use v6;

sub MAIN() {
    use Test;
    use lib ".";
    for ( "example1", "example2", "input", "input2", "example3", "example4" ) -> $file {
        make-grammar( $file );
        use-ok( $file.tclc );
    }
}

sub make-grammar( $file ) {
    my $grammar-name = $file.tclc;

    my @out = "unit grammar {$grammar-name};";
    
    for $file.IO.lines -> $line {
        last unless $line;
        my $match = ( $line ~~ /^ $<tok>=(\d+) ": " [[ $<rules>=( (\d+)+ % " " )+ % " | " ]|[ '"' $<val>=(.+) '"' ]] $/ );
        my $token = $match<tok>.Int == 0 ?? 'TOP' !! "tok{$match<tok>.Int}";
        if $match<val> {
            @out.push( "token $token \{ '{$match<val>.Str}' \};" );
        } else {
            @out.push( "regex $token \{ " ~ $match<rules>.map( { $_.list.map( *.map( { "<tok{$_.Str}>" } ) ).join(" ") } ).join( " | " ) ~ ' };' );
        }
    }
    "{$grammar-name}.rakumod".IO.spurt( @out.join("\n") );
}
