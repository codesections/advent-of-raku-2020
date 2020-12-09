#!/usr/bin/env raku

my @trees = "input".IO.lines.map(*.comb);

say [*] ( [1,1],[3,1],[5,1],[7,1],[1,2] ).map( -> @r { my $c = traverse( @trees, |@r ); note $c; $c; } ); 

sub traverse( @grid, $across, $down ) {
    my $count = 0;
    my $width = @grid[0].elems;
    my %current = ( a => 0, d => 0);
    while %current<d> <= @grid.elems {
        %current<a> += $across;
        %current<d> += $down;
        $count++ if @grid[%current<d>][%current<a> % $width] ~~ '#';
    }
    return $count;
}
