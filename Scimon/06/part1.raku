#!/usr/bin/env perl

sub MAIN( Str $file = "example"|"input" ) {
    my $count = 0;
    my @answers;
    for $file.IO.lines -> $line {
        if $line ~~ "" {
            $count += count-unique( @answers );
            @answers = [];
        } else {
            @answers.push( |$line.comb );
        }
    }
    $count += count-unique( @answers );
    say $count;
}

sub count-unique( @answers ) {
    @answers.Set.elems;
}
