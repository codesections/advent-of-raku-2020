my @seats = slurp.words.map: { Hash.new(
     'row'  => :2(.comb.head(7).join.trans([<F B>] => [0,1])),
     'seat' => :2(.comb.tail(3).join.trans([<L R>] => [0,1])),
)}

my %id = @seats.map: { "{.<row> × 8 + .<seat>}" => $_ };

say 'A: Highest ID: ', %id.max: { +.key };

# maually trim off front and rear rows, you aren't in one of them
for 2..101 -> $row {
    for ^8 -> $seat {
        next if %id{"{$row × 8 + $seat}"}:exists;
        say "B: Empty seat ID: {$row × 8 + $seat}, row $row, seat $seat"
    }
}
