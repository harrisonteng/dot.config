#This program reads from a dictionary file and outputs each word along with
#it's md5 hash value into a .csv file.

# Set the dictionary file to load.
my $inputfile = "dict.txt";

# Set the name of the output file.
my $outputfile = ">output.csv";

# The guts of the script.
use Digest::MD5 qw(md5_hex);
use strict;

my $i = 0;

open(DICT, $inputfile);
open(OUTPUT, $outputfile);
my @lines  = <DICT>;
my $size = @lines;
while ($i < $size) {
	my $word = @lines[$i];
	while ($word =~ /\s/)
	{
	chop($word)
	}	
	my $md = md5_hex($word);
	print OUTPUT "$word,$md\n";
	print "Parsing line $i : $word,$md\n";
	$i++;
}
close DICT;
close OUTPUT;
	
