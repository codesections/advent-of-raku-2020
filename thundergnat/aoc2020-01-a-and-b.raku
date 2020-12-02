my @expenses = @*ARGS[0].IO.slurp.words;

-> $part { say [*] @expenses.combinations($part).first: { ( [+] $_ ) == 2020 } } for 2, 3;
