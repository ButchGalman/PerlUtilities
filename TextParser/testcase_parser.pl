
my $Basedir = "euHReka-Testing\/AllTests\/$ARGV[0]";
$cmd = "c:\\msysgit\\msysgit\\bin\\find.exe $Basedir -name \\*.txt -print";
print $cmd;

my @TestFile = `$cmd`;

#my @TestFile = `ls`;
chomp @TestFile;

open(WFH,">$ARGV[0]_NoMatchingTestCase.txt") or die $!;
foreach my $tfile (@TestFile)
{
	$bn = $tfile;
	$pn = $tfile;
	$bn =~ s/.*\/(.*)\.txt$/$1/g;
	$pn =~ s/\//\\/g;
	#print "$bn\n";
	#$searchTests = "grep '$bn' \"$tfile\" -r | wc -l";
	$searchcmd = "grep \"$bn\" \"$pn\" -r | wc -l";
	$searchTests = `$searchcmd`;
	
	#print WFH "$searchcmd\n";
	if ($searchTests == 0) {
		# write to file if one or more match
		print WFH "$pn\n";
	}
	
	
}


sub trim_ws {
	$in = @_[0];
	$in =~ s/[\t\r\n]+//g;
	return $in
}

