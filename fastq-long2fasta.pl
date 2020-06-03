#!/usr/bin/perl


use strict;
use warnings ;

#!/usr/bin/perl


use strict;
use warnings ;

my $sequence_file = shift or die "Usage: $0 <sequence file>\n" ;
open(FILE, "<$sequence_file") or die "Failed to open file '$sequence_file'\n$!\n";

my $seq_id;
my $seq = "";


while (<FILE>) {
   chomp;
   if (m/^[acgtnwrymsk]+$/i) {
       ### sequence line
       $seq .= $_;
   }
   elsif (m/^\@([\:\-\w\d]+)/) {
       ### Beginning of an entry
       my $new_seq_id = $1;
       print ">$seq_id\n$seq\n" if $seq =~ m/^[acgt]+$/i;
       $seq_id = $new_seq_id;
       $seq = "";
   }
   elsif (m/^\S+$/) {
       ### scores
       #warn"Scores: '$_'\n";
   }
   else {
       die "Could not parse: '$_'\n";
   }
}



