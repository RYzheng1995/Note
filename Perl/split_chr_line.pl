#!/usr/bin/perl -w
use POSIX qw(strftime);
use Getopt::Std;
use File::Basename;

###############################################################################
#Get the parameter and provide the usage.
###############################################################################
my %opts;
getopts( 'i:o:d:h:c:', \%opts );
&usage unless ( exists $opts{i} && exists $opts{o} );
my $start_time=time;
print strftime("Start time is %Y-%m-%d %H:%M:%S\n", localtime(time));
print "Input file is $opts{i}\nOutput file is $opts{o}\n";
print "Database file is $opts{d}\n" if defined($opts{d});
$opts{h}=0 unless defined($opts{h});
$opts{c}=0 unless defined($opts{c});


###############################################################################
#Main text.
###############################################################################
open INPUT,"<$opts{i}";
$name=basename($opts{i});
`mkdir $opts{o}`;
while ($opts{h}>0) { #filter header
	<INPUT>;
	$opts{h}--;
}
my $c=$opts{c}; #get the column of chromosome
$_=<INPUT>;
@tmp=split/\t/;
$chr=$tmp[$c];
open OUTPUT,">>$opts{o}$chr\_$name";
print OUTPUT $_;
while (<INPUT>) {
	my @tmp=split/\t/;
	if ($chr ne $tmp[$c]) {
		$chr=$tmp[$c];
		open OUTPUT,">>$opts{o}$chr\_$name";
	}
	print OUTPUT $_;

}

close INPUT;
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
Usage:    split_chr_line.pl -i inpute_file -o output_file -d database	-h header num
Function: split big genome mapping into each chromosome in one file of directory
Command:  -i inpute file name (Must), each line have a genome position
          -o output file name (Must)
          -d database file name
          -h header number, default 0
          -c column, set the chromsome site, default 0
Author:   Liu Yong-Xin, woodcorpse\@163.com, QQ:42789409
Version:  v1.0
Update:   2014-08-21
Notes:    
\n/
    )
}