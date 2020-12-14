my $now = now;

my %bags = lines.map: { # meh, not elegant but it works
    next unless .chars; # skip empty lines
    my ($outer, $inner) = .split(' bags contain ');
    my %contents = $inner.split(',').map: -> $this {
        my $count = $this.words[0];
        my $what = $this.words[1,2].join: ' ';
        if $count eq 'no' {
            $count = 0;
            $what = 'none'; # whatever
        }
        $what => $count;
    }
    $outer => %contents;
}


my @matryoshka;
my @search = 'shiny gold';

while my $this = @search.shift {
    my @these = %bags.grep({ .value{$this}:exists })».key;
    next unless +@these;
    @search.append: @these;
    @matryoshka.append: @these;
}

say 'A: ', +@matryoshka.unique, (now - $now).fmt("\t(%.2f seconds)");

$now = now;

@search = 'shiny gold';
my $bag-count;

while $this = @search.shift {
    %bags{$this}.map: {
        $bag-count += .value;
        @search.append: .key xx .value;
    }
}

say 'B: ', $bag-count, (now - $now).fmt("\t(%.2f seconds)");;
