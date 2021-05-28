my $input;
my @startingItems = $input.lines[0].split(',');
my %lastSaid = @startingItems.kv.map(-> $k, $v {
  Pair.new($v, $k + 1)
}).Hash;

sub playGame ($r) {
  my ($justSaid, $currentRound) = (0, %lastSaid.elems);
  loop {
    my $lastJustSaid = $justSaid;
    ++$currentRound;
    if %lastSaid{$justSaid} -> $lastTimeSaid {
      say "Last time $justSaid was said was $lastTimeSaid";
      $justSaid = $currentRound - $lastTimeSaid;
    } else {
      say "$justSaid has never been said";
      $justSaid = 0;
    }
    %lastSaid{$lastJustSaid} = $currentRound;
    say "{ $currentRound } → $lastJustSaid: $justSaid";
    last if $currentRound >= $r;
  }
}

playGame(2020);     # Round 1
playGame(30000000); # Round 2

#INIT $input = '0,3,6';
INIT $input = '0,13,1,8,6,15';
