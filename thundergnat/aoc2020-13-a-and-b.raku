my ($timestamp, $busses) = lines;

my @in-service = $busses.comb(/\d+/);

my @departing = @in-service «-» $timestamp «%« @in-service;
my $earliest  = min @departing;
my $key = @departing.first: $earliest, :k;

say 'A: ', @in-service[$key] × @departing[$key];



my @busses = ($busses.split: ',').kv.map: {
    next if $^v eq 'x';
    %('o' => $^k, 'b' => +$v)
}

my $init = @busses[0]<o>;
my $skip = @busses[0]<b>;

say 'B: ',
(@busses.skip(1).map( {
    $init = ($init, * + $skip … *).first: (.<o> + *) %% .<b>;
    $skip ×= .<b>;
    $init
  } )
).tail;
