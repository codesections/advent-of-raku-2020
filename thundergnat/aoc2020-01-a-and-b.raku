my @expenses = words;

 for 'A: ', 2, 'B: ', 3 -> $title, $part {
      say $title, [*] @expenses.combinations($part).first: { ( [+] $_ ) == 2020 } 
 };
