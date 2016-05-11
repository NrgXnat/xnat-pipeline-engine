#!/usr/bin/perl
# Copyright (c) 2010 Washington University
# Author: Mohana Ramaratnam <mohanakannan9@gmail.com>

 use strict;
 use Getopt::Std;
 use warnings;

 use Tie::Handle::CSV;



 my %opts;
 getopts('f:a:c:h', \%opts);

 

 if (exists $opts{h}) {
     print STDERR <<EndOfHelp;
 Parses XNAT Catalog XML to return URI for a collection and file_content
 Options:

   -f <Path to csv file>    (required)
   -a <content attribute within the catalog file>    (required)
   -c <collection>   Define collection label  .

   -h             Show this help information
EndOfHelp
}



 my $file = $opts{f};
 my $catalog_content = $opts{a};
 my $collection = $opts{c};

die "Path to csv file not defined (use -f option)\n" unless defined $file;
die "No content attribute defined (use -a option)\n" unless defined $catalog_content;




    my $fh = Tie::Handle::CSV->new($file, header => 1);
    
    die "Can't open $file: $!" unless defined $fh;

    my $uri = "0"; 	

    while (my $csv_line = <$fh>) {
 	if (defined $collection) {
	   if (($csv_line->{'collection'} eq $collection) && ($csv_line->{'file_content'} eq $catalog_content)) {
		   $uri = $csv_line->{'URI'} ;
		   last;
   	   }
	}else {
	   if ($csv_line->{'file_content'} eq $catalog_content) {
		   $uri =  $csv_line->{'URI'} ;
		   last;
   	   }
	}
    }

    close $fh;
    print "$uri\n";
    exit 0;  	
