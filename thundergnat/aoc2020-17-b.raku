# Meh. Slow but good enough.
my $now = now;

my @conway;

my int ($X,$Y,$Z,$W) = 20,20,21,20;

# sigh. quick and easy to write but horribly inefficient to run
for (^$X) X (^$Y) X (^$Z) X (^$W) -> ($x, $y, $z, $w) { @conway[$x;$y;$z;$w] = '.' };

my @init = lines».comb;

for @init -> @row {
    state $s = $Y div 2 - +@init div 2 - 1;
    state $z = ($Z / 2).floor;
    state $w = ($Z / 2).floor;
    my $b = $X div 2 - +@row div 2;
    @row.map: { @conway[$b++;$s;$z;$w] = $_ };
    ++$s;
}

for ^6 {
    my @clone;
    (^$X).race(:2batch).map: -> $x {
       for ^$Y -> $y {
           for ^$Z -> $z {
               for ^$W -> $w {
                   my $active = active($x, $y, $z, $w);
                   my $this = @conway[$x;$y;$z;$w];
                   if $this eq '.' and $active == 3 {
                       @clone[$x;$y;$z;$w] = '#'
                   }
                   elsif $this eq '#' and ($active < 2 or $active > 3) {
                       @clone[$x;$y;$z;$w] = '.'
                   }
                   else {
                       @clone[$x;$y;$z;$w] = @conway[$x;$y;$z;$w];
                   }
               }
           }
        }
    }
    @conway = @clone;
}

say 'B: ', active(), (now - $now).fmt("\t(%0.2f seconds)");


multi active {
    my $count = 0;
    for ^$X -> $x {
        for ^$Y -> $y {
            for ^$Z -> $z {
                for ^$W -> $w {
                    ++$count if @conway[$x;$y;$z;$w] eq '#'
                }
            }
        }
    }
    $count
}

multi active (Int $x, Int $y, Int $z, Int $w) {
    my $count = 0;
    for (($x - 1) max 0) .. (($x + 1) min ($X - 1)) -> $xc {
        for (($y - 1) max 0) .. (($y + 1) min ($Y - 1)) -> $yc {
            for (($z - 1) max 0) .. (($z + 1) min ($Z - 1)) -> $zc {
                for (($w - 1) max 0) .. (($w + 1) min ($W - 1)) -> $wc {
                    next if $xc == $x and $yc == $y and $zc == $z and $wc == $w;
                    ++$count if @conway[$xc;$yc;$zc;$wc] eq '#'
                }
            }
        }
    }
    $count
}
