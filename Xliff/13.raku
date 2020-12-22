my $input;

# Arithmetic variants which will allow us to preserve original indexing.
# This will help simplify things for Part 2
sub infix:<divv> ($a, $b) {
  return 'x' if $a eq 'x' || $b eq 'x';
  ($a / $b).ceiling;
}

sub infix:<mull> ($a, $b) {
  return 'x' if $a eq 'x' || $b eq 'x';
  $a * $b;
}

sub infix:<subb> ($a, $b) {
  return 'x' if $a eq 'x' || $b eq 'x';
  $a - $b;
}

sub computeResult ($ts) {
  my @d = $ts «divv« @*ids;
  # Result is tuple of (<original index>, <delay from timestamp>)
  (@d «mull» @*ids »subb» $ts).kv.rotor(2).sort( *[1] );
}

sub getIdPositions {
  (gather for @*ids.kv -> $k, $v {
    next if $v eq 'x';
    take [$k, $v]
  });
}

# Part 1
my (@*ids, @gaps);
my $ts = $input.lines[0].Int;
@*ids = $input.lines[1].split(',');
# Identify busIds and their positions for part 2.
my @idPos = getIdPositions;
my @r = computeResult($ts);
say @*ids[ @r[0][0] ] * @r[0][1];

@idPos.gist.say;

# Part 2 - Parallelized.
my ($batch, $degree) = (262144, $*KERNEL.cpu-cores);
$ts = $ts == 939 ?? 0 !!  100007432601076;
#$ts = $ts == 939 ?? 0 !! 100017997058382; # emit error
#$ts = $ts == 939 ?? 0 !! 100000562942644; # Segfault recovery
my ($checkpoint, $l) = (False, Lock.new);
# my $c = $*SCHEDULER.cue(in => 5, every => 5, {
#   $l.protect: { $checkpoint = True }
# });
# my $c1 = $*SCHEDULER.cue(in => 30, every => 30, {
#   say 'Cleaning...';
#   $*VM.request-garbage-collection;
# });

my ($t, $count, $not-finished) = ($ts, 0, True);
my $step = @*ids.min.Int;
my $min-t = ($t div $step) * $step + $step; # Insure we start at the NEXT valid
                                            # ID after our starting TS.

loop {
  CATCH { default { .message.say; .backtrace.concise.say; } }
  # DO NOT do this to Inf. At these numbers, this will eat your memory like
  # Chicklets.
  my $seq = (
    $min-t, $min-t + $step, $min-t + 2 * $step ... ($min-t + $step * $batch)
  );

  if $count %% ($batch * 10000) {
    say "Timestamps checked through { $seq[0] }";
    $count = 0;
  }

  $seq.hyper(:$batch, :$degree).map(-> $t --> Nil {
    CATCH { default { .message.say; .backtrace.concise.say; } }

    #say "T: { $t.^name }";

    # $l.protect: {
    #   say "Timestamps checked through $t" if $checkpoint;
    #   $checkpoint = False;
    # } if $checkpoint;

    # Skip if all bus IDs to not align with this timestamp.
    #say "IDPos: {@idPos.gist}";
    for @idPos {
      #say "{ $*THREAD.id } - { $t + .[0] }/{ .[1] }: { ($t + .[0]) %% .[1] }";
      last unless ($t + .[0]) %% .[1];

      #say "NFT: { $_ } / { @idPos.tail }";

      $not-finished = False if $_ eqv @idPos.tail;
    }
    last if $not-finished;
    say "NF: { $not-finished }";

    # For subsequence check, index and delay must be the same.
    # my $r = computeResult($_).grep(  *[1] ne  'x'  )
    #                          .grep({ .[0] != .[1] })
    #                          .elems
    #                          .not   ?? $_ !! False;
    Nil;
  });
  $min-t += $step * ($batch + 1);
  last unless $not-finished;
}
say "Final timestamp is: $t";

INIT $input = 'input/13.input'.IO.slurp;
# INIT $input = q:to/INPUT/;
#   939
#   7,13,x,x,59,x,31,19
#   INPUT
