use v6.d;

my $contents = 'input'.IO.slurp;

my @passport;
for $contents.split("\n\n") -> $batch {
    my %p;
    for $batch.split(/:s \s | \n/) -> $field {
        next if $field eq ''; # ignore trailing field on last line
        for $field.split(':') -> $k,$v {
            %p{$k} = $v;
        }
    }
    @passport.push(%p);
}

my $valid_count = 0;
for @passport -> %p {
    $valid_count += valid_fields(%p);
}
say "Part One: $valid_count";

$valid_count = @passport.map({ (valid_fields($_) and validate_fields($_)) ?? 1 !! 0 }).sum;
say "Part Two: $valid_count";

sub valid_fields (%passport) {
#    say "passport: {%passport}";
#    say "valid: {%passport<byr iyr eyr hgt hcl ecl pid>:exists.min}";
    return %passport<byr iyr eyr hgt hcl ecl pid>:exists.min;
}

sub validate_fields (%passport) {
    my $rval = 1;
    $rval = 0 unless %passport<byr> ~~ /^\d ** 4$/ and 1920 <= %passport<byr> <= 2002;
    $rval = 0 unless %passport<iyr> ~~ /^\d ** 4$/ and 2010 <= %passport<iyr> <= 2020;
    $rval = 0 unless %passport<eyr> ~~ /^\d ** 4$/ and 2020 <= %passport<eyr> <= 2030;

    if (%passport<hgt> ~~ /^(\d+)(cm | in)$/) {
        my ($height, $unit) = ($0, $1);
        if ($unit eq 'cm') {
            $rval = 0 unless 150 <= $height <= 193;
        } elsif ($unit eq 'in') {
            $rval = 0 unless 59 <= $height <= 76;
        }
    }
    else {
        $rval = 0;
    }

    $rval = 0 unless %passport<hcl> ~~ /^\#<[0..9 a..f]> ** 6$/;
    $rval = 0 unless %passport<ecl> ~~ /^(amb|blu|brn|gry|grn|hzl|oth)$/;
    $rval = 0 unless %passport<pid> ~~ /^\d ** 9$/;

    return $rval;
}
