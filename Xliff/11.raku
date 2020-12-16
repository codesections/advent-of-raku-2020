my ($input, @state);
my @rc = ($input.lines.elems, $input.lines[0].chars);
my @grid[ @rc[0]; @rc[1] ];

sub mdClone (@a) {
  my ($m, $n) = @a.shape;
  my @c[$m; $n];
  for ^$m -> $mm {
    @c[$mm; $_] = @a[$mm; $_].clone for ^$n;
  }
  @c;
}

sub gridAt ($m, $n) {
  my @g := @state.tail;
  my ($max-m, $max-n) = @g.shape;
  0 <= $m < $max-m && 0 <= $n < $max-n ?? @g[$m; $n] !! ' ';
}

sub countOccupiedSeats {
  my @g := @state.tail;
  my $occupied = 0;
  my ($max-m, $max-n) = @g.shape;
  for ^$max-m -> $m {
    ++$occupied if @g[$m; $_] eq '#' for ^$max-n;
  }
  $occupied;
}


sub countOccupied ($m, $n) {
  my @g := @state.tail;
  my ($max-m, $max-n) = @g.shape;
  my $count = 0;
  # Rewrite to count occupied seats in all directions with an optional
  # :$recurse parameter to account for Part Two
  ++$count if 0 <= $m - 1 < $max-m && @g[$m - 1; $n    ] eq '#'; # Left
  ++$count if 0 <= $m + 1 < $max-m && @g[$m + 1; $n    ] eq '#'; # Right
  ++$count if 0 <= $n - 1 < $max-n && @g[$m    ; $n - 1] eq '#'; # Top
  ++$count if 0 <= $n + 1 < $max-n && @g[$m    ; $n + 1] eq '#'; # Bottom
  ++$count if 0 <= $m - 1 < $max-m &&
              0 <= $n - 1 < $max-n && @g[$m - 1; $n - 1] eq '#'; # UL
  ++$count if 0 <= $m + 1 < $max-m &&
              0 <= $n + 1 < $max-n && @g[$m + 1; $n + 1] eq '#'; # BR
  ++$count if 0 <= $m + 1 < $max-m &&
              0 <= $n - 1 < $max-n && @g[$m + 1; $n - 1] eq '#'; # UR
  ++$count if 0 <= $m - 1 < $max-m &&
              0 <= $n + 1 < $max-n && @g[$m - 1; $n + 1] eq '#'; # BL
  #say "CO ({ $m }, { $n }) : { $count }";
  #say "{ gridAt($m - 1, $n - 1) }{ gridAt($m    , $n - 1) }{ gridAt($m + 1, $n - 1) }";
  #say "{ gridAt($m - 1, $n    ) }{ gridAt($m    , $n    ) }{ gridAt($m + 1, $n    ) }";
  #say "{ gridAt($m - 1, $n + 1) }{ gridAt($m    , $n + 1) }{ gridAt($m + 1, $n + 1) }";
  #say "=====";
  $count;
}

sub compareGrid(@a, @b) {
  my ($r1, $c1) = @a.shape;
  my ($r2, $c2) = @b.shape;

  return False unless $r1 == $r2 && $c1 == $c2;
  for ^$r1 -> $r {
    return False unless @a[$r;$_] eqv @b[$r;$_] for ^$c1;
  }
  True;
}

for $input.lines.kv -> $k, $v {
  my $c = 0;
  @grid[$k; $c++] = $_ for $v.comb;
}

@state.push: @grid;
my @new-grid := @grid.&mdClone;

my $rounds = 0;
repeat {
  my ($m, $n) = @new-grid.shape;
  # cw: As much as I like the X operator, it is SLOW
  #     compared to the following.
  for ^$m -> $mm {
    # Can parallelize this bit! Not needed for test input.
    for ^$n -> $nn {
      #say "({ $mm }, { $nn }): { @state.tail[$mm; $nn] }";
      @new-grid[$mm; $nn] = do given @state.tail[$mm; $nn] {
        when 'L' { countOccupied($mm, $nn) == 0 ?? '#' !! .clone }
        when '#' { countOccupied($mm, $nn) >= 4 ?? 'L' !! .clone }
        when '.' { countOccupied($mm, $nn); .clone }
        default  { die 'WTF?' }
      }
    }
  }
  #@new-grid.gist.say;

  @state.push: @new-grid;
  @new-grid := @state.tail.&mdClone;
  $rounds++;
} until compareGrid(@state.tail(2).head, @state.tail);
say "Rounds until stability: $rounds";
say "Occupied seats: { countOccupiedSeats }";
say "Time taken: {now - INIT now}s";

# Round 1 stats (non parallel):
# Rounds until stability: 116
# Occupied seats: 2251
# Time taken: 54.3005034s

INIT $input = 'input/11.input'.IO.slurp;
# INIT $input = q:to/INPUT/;
# L.LL.LL.LL
# LLLLLLL.LL
# L.L.L..L..
# LLLL.LL.LL
# L.LL.LL.LL
# L.LLLLL.LL
# ..L.L.....
# LLLLLLLLLL
# L.LLLLLL.L
# L.LLLLL.LL
# INPUT
