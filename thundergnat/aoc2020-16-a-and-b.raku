my $now = now;

my ($rules, $mine, $nearby) = slurp.split(/\n\n+/);

my %rules = $rules.lines.map: {
    my ($name, $lo, $hi) = .split(/': '|' or '/);
    $name => %(
      'lo' => $lo.comb(/\d+/)».Int.minmax,
      'hi' => $hi.comb(/\d+/)».Int.minmax,
      :col(Any),
    )
}

my @valid;

{
    my @invalid;
    for $nearby.lines {
        my $valid = True;
        my @numbers = .comb(/\d+/)».Int;
        next unless +@numbers;
        for @numbers -> $this {
            $valid = False, @invalid.push($this)
              if none %rules.map: -> $rule {
                  ($this ~~ $rule.value<lo>) || ($this ~~ $rule.value<hi>)
              }
        }
        @valid.push: @numbers if $valid; # Needed for part 2, may as well save them now
    }
    say 'A: ', (sum @invalid), (now - $now).fmt("\t(%0.2f seconds)");
}

$now = now;

{
    my @columns = [Z] @valid;
    for ^@columns {
        for @columns.kv -> $col, $these {
            my @maybe;
            for %rules -> $rule {
                next if $rule.value<col> ~~ Numeric;
                @maybe.push: ($rule.key, $col) if all $these.map: -> $this {
                    ($this ~~ $rule.value<lo>) || ($this ~~ $rule.value<hi>)
                }
            }
            %rules{@maybe[0;0]}<col> = @maybe[0;1] if +@maybe == 1;
        }
    }
    my @departures = %rules.grep({ .key.starts-with: 'departure' }).map: { .value<col> };
    say 'B: ', ([*] $mine.lines[1].comb(/\d+/)[|@departures]),
      (now - $now).fmt("\t(%0.2f seconds)");
}
