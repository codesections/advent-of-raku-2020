my ($input, $weakness) = ('input/09.input'.IO.slurp);
#constant BATCH = 5;
constant BATCH    = 25;
constant PARALLEL = 10;

my @list = $input.lines.map( *.Int );
# Part 1
for @list.rotor( Pair.new(BATCH + 1, BATCH * -1) )
         .rotor(PARALLEL)
{
  my @p = gather for $_ {
    take start {
      print '.';
      .head(BATCH).combinations(2).map( *.sum ).any != .tail ?? .tail !! Nil;
    }
  }
  await Promise.allof(@p);
  if @p.map( *.result ).grep( * ~~ Int ) -> $r {
    ($weakness = $r[0]).say;
    last;
  }
}

# Part 2
for (2...^@list.elems).map({
  @list.rotor( Pair.new($_, -1 * ($_ - 1)), :partial ) }
).rotor(10) {
  my @p = gather for $_ {
    take start {
      print '.';
      .map({ [ $_, .sum ] }).grep({ .[1] == $weakness });
    }
  }
  await Promise.allof(@p);
  if (my $r = @p.map( *.result ).grep( *.elems )).elems {
    ($r[0][0][0].min, $r[0][0][0].max).gist.say;
    ($r[0][0][0].min, $r[0][0][0].max).sum.say;
    last;
  }
}


# INIT $input = q:to/INPUT/;
# 35
# 20
# 15
# 25
# 47
# 40
# 62
# 55
# 65
# 95
# 102
# 117
# 150
# 182
# 127
# 219
# 299
# 277
# 309
# 576
# INPUT
