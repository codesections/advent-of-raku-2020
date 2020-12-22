my $now = now;

my @food = lines.map: {
    my ($ingredients, $warning) = .split(' (contains ');
    {'ingredient' => [$ingredients.comb(/\w+/)],
     'allergen' => [$warning.comb(/\w+/)] }
 }

my %allergens;

for (flat @food[*]»<allergen>»[*]).unique -> $allergen {
    %allergens{$allergen} = ([∩] @food.grep(  { $allergen ∈ .<allergen> } )»<ingredient>).SetHash;
}

loop {
    last if all(%allergens.values».total) == 1;
    my @one = %allergens.grep( { .value.total == 1 } );
    for @one -> $o {
        for %allergens -> $a {
            next if +$a.value.keys == 1;
            %allergens{$a.key}.unset($o.value.keys.first);
        }
    }
}

my $foods = @food[*]»<ingredient>»[*].BagHash;

$foods{.value.keys.first}:delete for %allergens;

say "A: ", ($foods.total), (now - $now).fmt("\t(%.2f seconds)");

say "B: ", (%allergens.sort( *.key )».values.map( { .first.keys.first } ).join: ','),
  (now - $now).fmt("\t(%.2f seconds)");
