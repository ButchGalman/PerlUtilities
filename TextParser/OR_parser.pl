$pathCore = "Core-Flows\\resources\\";
$pathTests = "euHReka-Testing\\AllTests\\";
$InFile = "euHReka-Testing\\object_repository.py";


open(WFH,">OR.txt") or die $!;
open my $fh, '<', $InFile  or die "$InFile: $!";
while ( my $line = <$fh> ) {
	if ($line =~ m/[^#]"(.*)"\s+:\s+("|').*("|')/i ){
		
		#print "$1\n";
		$searchFlows = `grep "$1" '$pathCore' -ri | wc -l`;
		$searchTests = `grep "$1" '$pathTests' -ri | wc -l`;
		if (($searchFlows > 0) || ($searchTests > 0) ) {
			# write to file if one or more match
			print WFH $line;
		}
		
	} else {
		#write to file
		# Remove commented-out ORs
		if ($line =~ m/#"(.*)"\s+:\s+("|').*("|')/i ){
			print $line
		} else {
			print WFH $line;
		}
	}

}

sub trim_ws {
	$in = @_[0];
	$in =~ s/[\t\r\n]+//g;
	return $in
}