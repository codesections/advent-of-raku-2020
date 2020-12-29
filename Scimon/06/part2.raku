#!/usr/bin/env perl

sub MAIN( Str $file = "example"|"input" ) {
    my $count = 0;
    my @answers;
    my $size;
    for $file.IO.lines -> $line {
        if $line ~~ "" {
            $count += count-all( @answers, $size );
            @answers = [];
            $size = 0;
        } else {
            @answers.push( |$line.comb );
            $size++;
        }
    }
    $count += count-all( @answers, $size );
    say $count;
}

sub count-all( @answers, $size ) {
    @answers.Bag.grep( { $_.value == $size } ).elems ;
}
