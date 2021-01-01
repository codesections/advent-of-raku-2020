my $now = now;

my %dir = (:ne(2+3i), :nw(-2+3i), :se(2-3i), :sw(-2-3i), :e(4+0i), :w(-4+0i));

my @list = lines.map: { ($_ ~~ /([ne|nw|se|sw|e|w])+/)[0]».Str }

my %tiles;

%tiles{sum %dir{|$_}}++ for @list;

%tiles{$_}:delete for (%tiles.grep: *.value %% 2)».key;

say "A: ", (+%tiles), (now - $now).fmt("\t(%.2f seconds)");

for ^100 {
    my %adjacent;
    for %tiles -> $tile {
        %adjacent{.value}++ for $tile.key «+« %dir;
    }

    my %flipped;
    for %adjacent -> $tile {
        if %tiles{$tile.key}:exists {
            %flipped{$tile.key} = 1 if $tile.value == 1|2
        }
        else {
            %flipped{$tile.key} = 1 if $tile.value == 2
        }
    }
    %tiles = %flipped;

    print "\b" x 40, "Day {1 + $_}  ", +%tiles;
}

print "\b" x 40;

say "B: ", (+%tiles), (now - $now).fmt("\t(%.2f seconds)");
