my $now = now;

my ($card, $door) = words;

my @loop = 1, {$_ * 7 % 20201227} … *;

# only need to get one to know the other
my @door = 1, {$_ * $card % 20201227} … *;

my $card-loop = @loop.first: * == $door, :k;

say "A: ", (@door[$card-loop]), (now - $now).fmt("\t(%.2f seconds)");
