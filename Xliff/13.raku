my $input;

sub getIdPositions (@ids) {
  (gather for @ids.kv -> $k, $v {
    next if $v eq 'x';
    take [$k, $v.Int]
  });
}

constant FREE_THREADS = 5;
constant NUM_THREADS  = $*KERNEL.cpu-cores - FREE_THREADS;
constant CHECKPOINT   = 1000;

my ($l, $finished) = (Lock.new, False);
sub computeResults (@ids, $ts, $num) {
  my ($t, $batch) = ($ts, 0);
  OUTERLOOP: loop {
    for @ids {
      return False if $finished;
      # say "$t / { .[0] } / { .[1] }: { ($t + .[0]) %% .[1] }"
      #   unless $finished;
      return False if $batch++ > $num;
      say "Max thread checked through TS $t" if $batch %% CHECKPOINT;
      unless ($t + .[0]) %% .[1] {
        $t += $*minId;
        next OUTERLOOP;
      }
    }
    last;
  }
  $l.protect: { $finished = True };
  return $t;
}

# Part 1
my ($ts, $p, @p) = ($input.lines[0].Int, 0);
# Identify busIds and their positions for part 2.
my @ids = getIdPositions( $input.lines[1].split(',') );
#my ($startT, @*sortedIds) = ( $ts == 939 ?? $ts !! 100000000000000,
my ($startT, @*sortedIds) = ( $ts == 939 ?? $ts !! 100004055963500,
                              |@ids.map( *[1] ).sort );
my $*minId = @*sortedIds.head;
$startT = ($startT div $*minId).floor * $*minId;
loop {
  last if $finished;
  while $p < NUM_THREADS {
    @p.push: start {
      computeResults(@ids, $startT, $*minId * NUM_THREADS ** 2)
    }
    $startT += $*minId * NUM_THREADS ** 2;
    $p++;
  }
  await Promise.anyof(@p);
  my $f = 0;
  @p .= grep({
    # Check for finished threads.
    do if .status != Planned {
      my $r = .result;
      # Output solution if found.
      if $r {
        say "A timestamp solution is { $r }";
        exit;
      }
      $f++;
      False
    } else {
      True
    }
  });
  $p -= $f;
}

INIT $input = 'input/13.input'.IO.slurp;
# INIT $input = q:to/INPUT/;
#   939
#   7,13,x,x,59,x,31,19
#   INPUT
