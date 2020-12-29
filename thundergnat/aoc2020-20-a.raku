my $now = now;

my %tiles = slurp.split(/\n\n+/).map: -> $data {
    my $id = $data.lines[0].comb(/\d+/);
    my @image = flat $data.lines[1..*];
    my @edges = (flat @image[0, 9], @image[*]».substr(0,1).join, @image[*]».substr(9,1).join);
    @edges.append: @edges».flip;
    $id => {'image' => @image, 'edges' => @edges }
}

my @corners;

for %tiles.sort( +*.key ) -> $id {
    my @match;
    for flat $id.value<edges> -> $edge {
        @match.append: |%tiles.grep( {($id.key ne .key) && ($edge ∈ .value<edges>)})».key
    }
    @corners.push: $id.key if +@match.unique == 2;
}

say "A: ", ([*] @corners), (now - $now).fmt("\t(%.2f seconds)");
