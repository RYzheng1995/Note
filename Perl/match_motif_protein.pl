#!/usr/bin/perl -w
use POSIX qw(strftime);
use Getopt::Std;
use File::Basename;

###############################################################################
#Get the parameter and provide the usage.
###############################################################################
my %opts;
getopts( 'i:o:d:h:', \%opts );
my $start_time=time;
print strftime("Start time is %Y-%m-%d %H:%M:%S\n", localtime(time));
print "Database file is $opts{d}\n" if defined($opts{d});
$opts{h}=0 unless defined($opts{h});

###############################################################################
#Read the database in memory(opt)
###############################################################################
open DATABASE,"<$opts{d}";
while (<DATABASE>) {
        chomp;
        if (/>/) {
            $chr=$_;
#           print $chr,"\n";
        }else{
            $database{$chr}.=$_;
        }
}
close DATABASE;

###############################################################################
#Main text.
###############################################################################
open OUTPUT,">$opts{o}";
foreach  my $key(keys %database) {
	while ($database{$key}=~/L.C.E/g) {
		my $pos=pos($database{$key});
		print OUTPUT "$key\n$pos\n$`\n$&\n$'\n";
	}
}
close OUTPUT;

###############################################################################
#Record the program running time!
###############################################################################
my $duration_time=time-$start_time;
print strftime("End time is %Y-%m-%d %H:%M:%S\n", localtime(time));
print "This compute totally consumed $duration_time s\.\n";

###############################################################################
#Scripts usage and about.
###############################################################################
sub usage {
    die(
        qq/
Usage:    match_motif_protein.pl -i inpute_file -o output_file -d database	-h header num
Function: Template for Perl
Command:  -i inpute file name (Must)
          -o output file name (Must)
          -d database file name
          -h header number, default 0
Author:   Liu Yong-Xin, woodcorpse\@163.com, QQ:42789409
Version:  v1.1
Update:   2013-08-22
Notes:    
\n/
    )
}