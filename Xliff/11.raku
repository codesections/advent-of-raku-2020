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

sub oob ($m, $n) {
  not (0 <= $m < $*max-m && 0 <= $n < $*max-n)
}

sub gridAt ($m, $n) {
  oob($m, $n) ?? ' ' !! @state.tail[$m; $n];
}

sub countOccupiedSeats {
  my $occupied = 0;
  for ^$*max-m -> $m {
    ++$occupied if @*g[$m; $_] eq '#' for ^$*max-n;
  }
  $occupied;
}

sub isAdjacent ($m, $n, :$recurse, *%dir) {
  return 0 if oob($m, $n);
  return 1 if @state.tail[$m; $n] eq '#';
  return 0 if @state.tail[$m; $n] eq 'L';
  return isAdjacent($m - 1, $n,     :$recurse, :l ) if $recurse && %dir<l>;
  return isAdjacent($m + 1, $n,     :$recurse, :r ) if $recurse && %dir<r>;
  return isAdjacent($m,     $n - 1, :$recurse, :t ) if $recurse && %dir<t>;
  return isAdjacent($m,     $n + 1, :$recurse, :b ) if $recurse && %dir<b>;
  return isAdjacent($m + 1, $n + 1, :$recurse, :br) if $recurse && %dir<br>;
  return isAdjacent($m - 1, $n + 1, :$recurse, :bl) if $recurse && %dir<bl>;
  return isAdjacent($m - 1, $n - 1, :$recurse, :tl) if $recurse && %dir<tl>;
  return isAdjacent($m + 1, $n - 1, :$recurse, :tr) if $recurse && %dir<tr>;
  return 0;
}

sub countOccupied ($m, $n, :$recurse ) {
  my $count = 0;

  ++$count if isAdjacent($m - 1, $n    , :l,  :$recurse);
  ++$count if isAdjacent($m + 1, $n    , :r,  :$recurse);
  ++$count if isAdjacent($m    , $n - 1, :t,  :$recurse);
  ++$count if isAdjacent($m    , $n + 1, :b,  :$recurse);
  ++$count if isAdjacent($m - 1, $n - 1, :tl, :$recurse);
  ++$count if isAdjacent($m - 1, $n + 1, :bl, :$recurse);
  ++$count if isAdjacent($m + 1, $n - 1, :tr, :$recurse);
  ++$count if isAdjacent($m + 1, $n + 1, :br, :$recurse);
  if $*DEBUG > 2 {
    say "CO ({ $m }, { $n }) : { $count }";
    say "{ gridAt($m - 1, $n - 1) }{ gridAt($m    , $n - 1) }{ gridAt($m + 1, $n - 1) }";
    say "{ gridAt($m - 1, $n    ) }{ gridAt($m    , $n    ) }{ gridAt($m + 1, $n    ) }";
    say "{ gridAt($m - 1, $n + 1) }{ gridAt($m    , $n + 1) }{ gridAt($m + 1, $n + 1) }";
    say "=====";
  }
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

sub findSolution (@grid, $tol = 4, :$recurse = False) {
  @state.push: @grid;
  my @*g := @grid.&mdClone;

  constant MAXTHREAD = 15;
  my $rounds = 0;
  my ($*max-m, $*max-n) = @*g.shape;

  repeat {
    # cw: As much as I like the X operator, it is SLOW
    #     compared to the following.
    my ($p, @p) = (0);
    for ^$*max-n -> $nn {
      if $p > MAXTHREAD {
        await Promise.anyof(@p);
        $p -= @p.grep( *.status != Planned ).elems;
        @p = @p.grep( *.status == Planned );
      }

      @p.push: start {
        for ^$*max-m -> $mm {
          @*g[$mm; $nn] = do given @state.tail[$mm; $nn] {
            CATCH { default { .message.say; .backtrace.concise.say } }
            when 'L' { countOccupied($mm, $nn, :$recurse) == 0 ?? '#'
                                                               !! .clone }

            when '#' { countOccupied($mm, $nn, :$recurse) >= $tol ?? 'L'
                                                                  !! .clone }

            when '.' { .clone }
            default  { die 'WTF?' }
          }
        }
      }
      $p++;
    }
    await Promise.allof(@p);

    @state.push: @*g;
    @*g := @state.tail.&mdClone;
    $rounds++;

    @state.tail.gist.say if $*DEBUG;
  } until compareGrid(@state.tail(2).head, @state.tail);
  say "Rounds until stability: $rounds";
  say "Occupied seats: { countOccupiedSeats }";
  say "Time taken: { now - INIT now }s";
}

sub MAIN (:d(:$debug) = 0, :$dd, :$ddd) {
  my $*DEBUG = $debug;
  $*DEBUG = 2 if $dd;
  $*DEBUG = 3 if $ddd;

  for $input.lines.kv -> $k, $v {
    my $c = 0;
    @grid[$k; $c++] = $_ for $v.comb;
  }

  # Part 1
  # Round 1 stats (non parallel):
  # Rounds until stability: 116
  # Occupied seats: 2251
  # Time taken: 54.3005034s
  #findSolution(@grid);

  # Part 2
  findSolution(@grid, 5, :recurse);
}

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
