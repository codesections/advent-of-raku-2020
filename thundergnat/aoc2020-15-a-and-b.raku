my $now = now;

my @start = 2,15,0,9,1,20;

# Initialize
my %seen = @start.kv.map: { "$^v" => [$^k + 1] }

my $start = +@start + 1;

my int $last = @start.tail;
my int $i;

loop ($i = $start; $i <= 2020; $i = $i + 1) {
    my int $next = +%seen{$last} > 1
      ?? (%seen{$last}[*-1] - %seen{$last}[*-2])
      !! 0;
    %seen{$next}.push: $i;
    %seen{$next}.shift if +%seen{$next} > 2;
    $last = $next
}

say "A: ", $last, (now - $now).fmt("\t(%.2f seconds)");
say "It hasn't crashed, just takes a while...";


loop ($i = 2021; $i <= 30_000_000; $i = $i + 1) {
    #say $i, (now - $now).fmt("\t(%.2f seconds)") if $i %% 1_000_000;
    my int $next = +%seen{$last} > 1
      ?? (%seen{$last}[*-1] - %seen{$last}[*-2])
      !! 0;
    %seen{$next}.push: $i;
    %seen{$next}.shift if +%seen{$next} > 2;
    $last = $next
}

say "B: ", $last, (now - $now).fmt("\t(%.2f seconds)");
