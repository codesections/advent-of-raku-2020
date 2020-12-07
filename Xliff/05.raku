my $input = 'input/05.input'.IO.slurp;

sub rowid (@a) { @a[0] * 8 + @a[1] }

sub subdivide(Range $a) {
  my $p = ($a.max - $a.min) div 2 + $a.min;
  ( ($a.min .. $p), ($p+1 .. $a.max) )
}

# Part 1
my (@seat-ids, $max-id);
say ($max-id = (@seat-ids = $input.lines.map({
  my ($r, $c) = ( (0..127), (0..7) );
  .comb.map({
    $r = $_ eq 'F' ?? $r.&subdivide[0]
                   !! $r.&subdivide[1] if $_ eq <F B>.any;
    $c = $_ eq 'L' ?? $c.&subdivide[0]
                   !! $c.&subdivide[1] if $_ eq <L R>.any;
    (
      $r.min == $r.max ?? $r.min !! $r,
      $c.min == $c.max ?? $c.min !! $c
    );
  }).tail.&rowid
})).max);

# Part 2
.say if $_ == @seat-ids.none for ($min-id .. $max-id);
