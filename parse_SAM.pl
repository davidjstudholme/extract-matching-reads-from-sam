#!/usr/bin/perl -w

use strict;
use warnings ;
use Statistics::Descriptive;

my $sam_file = shift or die;

my $isizes = Statistics::Descriptive::Full->new();

open (SAMFILE, "<$sam_file") or die "Failed to open file '$sam_file'\n$!\n";

while(<SAMFILE>) {
    chomp;
    if (m/^\@/) {
	### This is a header line
    } else {
	my @fields = split /\t/;
	my ($qname,
	    $flag,
	    $rname,
	    $pos,
	    $mapq,
	    $cigar,
	    $mrnm,
	    $mpos,
	    $isize,
	    $seq,
	    $qual,
	    ) = @fields;

	if ($isize) {
	    #If the two reads in a pair are mapped to the same reference, ISIZE equals the difference between the coordinate of
	    # the 5ʼ-end of the mate and of the 5ʼ-end of the current read; otherwise ISIZE equals 0 (by the “5ʼ-end” we mean the
	    # 5ʼ-end of the original read, so for Illumina short-insert paired end reads this calculates the difference in mapping
	    # coordinates of the outer edges of the original sequenced fragment). ISIZE is negative if the mate is mapped to a
	    # smaller coordinate than the current read.

	    ### Get size of insert
	    #warn "isize = $isize\n" ;
	    $isizes->add_data(abs($isize)); 
	}

	### is this read unmapped?
	my $unmapped = $flag & 4;
	my $mate_unmapped = $flag & 8;
	
	if ($unmapped and $mate_unmapped) {
	    #warn "$seq is unmapped\n";
	} else {
	    #warn "$seq is mapped\n";
	}
	
	#print ">$qname $qual\n$seq\n" unless $unmapped; #fasta
	print "\@$qname\n$seq\n+\n$qual\n" unless $unmapped and $mate_unmapped; # fastq


    }
}
close SAMFILE;	


my $mean = int $isizes->mean();
my $var  = int $isizes->variance();
my $median = int $isizes->median();
my $max = int $isizes->max();
my $min = int $isizes->min();
my $sum = int $isizes->sum();

warn "mean=$mean\n";
warn "median=$median\n";
warn "var=$var\n";
warn "max=$max\n";
warn "min=$min\n";
