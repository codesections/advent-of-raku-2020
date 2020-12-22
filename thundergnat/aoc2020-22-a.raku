my $now = now;

my @decks = slurp.split(/\n\n+/).map: { [ .lines[1..*] ] }

COMBAT: loop {
    my @cards = @decks[0].shift, @decks[1].shift;
    if @cards[0] > @cards[1] {
        @decks[0].append: @cards;
    }
    else {
        @decks[1].append: @cards.reverse;
    }
    last COMBAT unless +@decks[0] && +@decks[1]
}

my @score = map { sum 1..* Z* .reverse }, @decks;

say "A: ", (max @score), (now - $now).fmt("\t(%.2f seconds)");
