my $now = now;

my @program = lines;

{
    my %memory;
    my $and;
    my $or;

    for @program -> $line {
        my str ($op, $what) = $line.split: ' = ';
        if $op eq 'mask' {
            $and = :2($what.comb.map({$_ eq '0' ?? '0' !! '1'}).join);
            $or  = :2($what.comb.map({$_ eq '1' ?? '1' !! '0'}).join);
        }
        else {
            %memory{$op.substr(4,*-1)} = ($what +& $and) +| $or;
        }
    }

    say 'A: ', %memory.values.sum, (now - $now).fmt("\t(%0.2f seconds)");

}

$now = now;

{
    my %memory;
    my @mask;
    my @bits;

    for @program -> $line {
        my str ($op, $what) = $line.split: ' = ';
        if $op eq 'mask' {
            @mask = $what.comb;
            my int $count = +@mask.grep('X');
            @bits = (^(2 ** $count)).hyper.map: { [.fmt("%{'0'~$count}b").comb] };
        }
        else {
            my @mem = $op.substr(4,*-1).fmt('%036b').comb;
            my str $here = (^36).map({ @mask[$_] eq '0' ?? @mem[$_] !! @mask[$_] }).join;
            my @addr = @bits.race(:batch(8 max +@bits div 8)).map: -> @b {
                ~$here.subst(/'X'/, { @b[$++] }, :g).parse-base(2)
            };
            @addr.map: { %memory{$_} = $what };
        }
    }

    say 'B: ', %memory.values.sum, (now - $now).fmt("\t(%0.2f seconds)");
}
