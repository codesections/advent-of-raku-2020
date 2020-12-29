my $now = now;

my ($rules, $messages) = slurp.split(/\n\n+/);

my %rules;
$rules.lines.map: {
    my ($k, $v) = .split(': ');
    %rules{$k} = $v;
}

# Part 2 override two rules
%rules<8>  = '42 | 42 8';
%rules<11> = '42 31 | 42 11 31';

my $grammar = "grammar d19 \{\n\tregex TOP \{ ^ ";
$grammar ~= "<t{$_}> " for %rules<0>.comb(/\d+/);
$grammar ~=  "\$ }\n";

%rules<0>:delete;

for %rules.sort( { +.key } ) {
    $grammar ~= "\t";
    $grammar ~= (.value.contains('|') ?? 'regex' !! 'token');
    $grammar ~= " t{.key} \{ {.value.subst(/(\d+)/, { "<t{$0}>" }, :g)} \}\n";
}
$grammar ~= "}\n";

my $fh = open('d19b.raku', :w) or die $fh;

$fh.say: $grammar, "\n\nmy \$count = 0;";

my @messages = $messages.lines;

for @messages -> $message {
    $fh.say("++\$count if d19.parse('$message');");
}

$fh.say("say \$count;");

$fh.close;

say "B: ", (run('raku', 'd19b.raku', :out).out.get),
  (now - $now).fmt("\t(%.2f seconds)");

unlink 'd19b.raku';
