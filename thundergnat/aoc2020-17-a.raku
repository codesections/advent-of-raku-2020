my $now = now;

my @conway;

my ($X,$Y,$Z) = 20,20,21;
for (^$X) X (^$Y) X (^$Z) -> ($x, $y, $z) { @conway[$x;$y;$z] = '.' };

my @init = lines».comb;

for @init -> @row {
    state $s = $Y div 2 - +@init div 2 - 1;
    state $z = ($Z / 2).floor;
    my $b = $X div 2 - +@row div 2;
    @row.map: { @conway[$b++;$s;$z] = $_ };
    ++$s;
}

for ^6 {
    my @clone;
    (^$X).race(:2batch).map: -> $x {
       for ^$Y -> $y {
           for ^$Z -> $z {
               my $active = active($x, $y, $z);
               my $this = @conway[$x;$y;$z];
               if $this eq '.' and $active == 3 {
                   @clone[$x;$y;$z] = '#'
               }
               elsif $this eq '#' and ($active < 2 or $active > 3) {
                   @clone[$x;$y;$z] = '.'
               }
               else {
                   @clone[$x;$y;$z] = @conway[$x;$y;$z];
               }
           }
       }
    }
    @conway = @clone;
}

say 'A: ', active(), (now - $now).fmt("\t(%0.2f seconds)");




multi active {
    my $count = 0;
    for ^$X -> $x {
        for ^$Y -> $y {
            for ^$Z -> $z {
                ++$count if @conway[$x;$y;$z] eq '#'
            }
        }
    }
    $count
}

multi active (Int $x, Int $y, Int $z) {
    my $count = 0;
    for (($x - 1) max 0) .. (($x + 1) min ($X - 1)) -> $xc {
        for (($y - 1) max 0) .. (($y + 1) min ($Y - 1)) -> $yc {
            for (($z - 1) max 0) .. (($z + 1) min ($Z - 1)) -> $zc {
                next if $xc == $x and $yc == $y and $zc == $z;
                ++$count if @conway[$xc;$yc;$zc] eq '#'
            }
        }
    }
    $count
}
