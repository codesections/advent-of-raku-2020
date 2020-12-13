my @seats = slurp.words.map: { Hash.new(
     'row'  => :2(.substr(0,7).trans([<F B>] => [0,1])),
     'seat' => :2(.substr(7).trans([<L R>] => [0,1])),
)}

my %id = @seats.map: { "{.<row> × 8 + .<seat>}" => $_ };

say 'A: ', %id.max( { +.key } ).key;

# maually trim off front and rear rows, you aren't in one of them
for 2..101 -> $row {
    for ^8 -> $seat {
        next if %id{"{$row × 8 + $seat}"}:exists;
        say "B: {$row × 8 + $seat}"
    }
}
