# Meh. Slow but good enough.
my $now = now;

my @conway;

my int ($X,$Y,$Z,$W) = 20,20,21,20;

for (^$X) X (^$Y) X (^$Z) -> ($x, $y, $z) { @conway[$x;$y;$z] = ['.' xx $W] };

my @init = lines».comb;

for @init -> @row {
    state $s = $Y div 2 - +@init div 2 - 1;
    state $z = ($Z / 2).floor;
    state $w = ($Z / 2).floor;
    my $b = $X div 2 - +@row div 2;
    @row.map: { @conway[$b++;$s;$z;$w] = $_ };
    ++$s;
}

say "init ", (now - $now).fmt("\t(%0.2f seconds)");

for ^6 {
    my $r = now;
    my @clone;
    (^$X).race(:2batch).map: -> int $x {
       for ^$Y -> int $y {
           for ^$Z -> int $z {
               for ^$W -> int $w {
                   my $active = active($x, $y, $z, $w);
                   my $this = @conway[$x;$y;$z;$w];
                   if $this eq '.' and $active == 3 {
                       @clone[$x;$y;$z;$w] = '#'
                   }
                   elsif $this eq '#' and ($active < 2 or $active > 3) {
                       @clone[$x;$y;$z;$w] = '.'
                   }
                   else {
                       @clone[$x;$y;$z;$w] = $this;
                   }
               }
           }
       }
    }
    @conway = @clone;
    say "$_ ", (now - $r).fmt("\t(%0.2f seconds)");
}

say 'B: ', active(), (now - $now).fmt("\t(%0.2f seconds)");


multi active {
    my $count = 0;
    for ^$X -> int $x {
        for ^$Y -> int $y {
            for ^$Z -> int $z {
                for ^$W -> int $w {
                    ++$count if @conway[$x;$y;$z;$w] eq '#'
                }
            }
        }
    }
    $count
}

multi active (int $x, int $y, int $z, int $w) {
    my $count = 0;
    for (($x - 1) max 0) .. (($x + 1) min ($X - 1)) -> int $xc {
        for (($y - 1) max 0) .. (($y + 1) min ($Y - 1)) -> int $yc {
            for (($z - 1) max 0) .. (($z + 1) min ($Z - 1)) -> int $zc {
                for (($w - 1) max 0) .. (($w + 1) min ($W - 1)) -> int $wc {
                    next if $xc == $x and $yc == $y and $zc == $z and $wc == $w;
                    ++$count if @conway[$xc;$yc;$zc;$wc] eq '#'
                }
            }
        }
    }
    $count
}
