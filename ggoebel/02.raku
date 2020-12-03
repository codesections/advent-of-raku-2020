use v6.d;

my token integer { <digit>+ }
my token minimum { <integer> }
my token maximum { <integer> }
my token hyphen { '-' }
my token match { <:alpha> }
my token colon { ':' }
my token password { <:alpha>+ }

my rule policy {
    <minimum>
    <hyphen>
    <maximum>
    <match>
}

my rule entry {
    <policy>
    <colon>
    <password>
}

my @input = 'input'.IO.lines;

# Part One
my $valid_count = 0;
for @input -> $line {
    if ($line ~~ /<entry>/) {
        my ($min, $max, $match) = $<entry><policy><minimum maximum match>.map: { .Stringy };
        my $password = ~$<entry><password>;
        my $count    = ($password ~~ m:g/$match/).elems;
        if ($min <= $count <= $max) {
            $valid_count++;
        }
    }
}
say "Part One: valid password count = $valid_count";

# Part Two
$valid_count = 0;
for @input -> $line {
    if ($line ~~ /<entry>/) {
        my ($pos1, $pos2, $match) = $<entry><policy><minimum maximum match>.map: { .Stringy };
        my $password = ~$<entry><password>;
        # adjust $pos1 and $pos2 from 1-indexing to 0-indexing
        if ($password.substr-eq($match, --$pos1) xor $password.substr-eq($match, --$pos2)) {
            $valid_count++;
        }
    }
}
say "Part Two: valid password count = $valid_count";
