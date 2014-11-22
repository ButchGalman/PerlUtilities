#use strict;
#use XML::Parser;
my @params = ();
my $kw = "init";
$parameters = "";
$path = "Core-Flows\\resources\\";

@flows = ('EOD_GL_FWK_CAP.txt','EOD_GL_WA_ED_Pers_Action.txt');


open(WFH,">Flow.index") or die $!;
foreach (@flows) {
	$full = $path . $_;
	print $full;
	open my $fh, '<', $full  or die "$full: $!";
	

	while ( my $line = <$fh> ) {
		if ($line =~ m/^[^#\t\*].+/i ){
			$kw = $line;
			#print $kw;
			
		}
		if ($line =~ m/\[Arguments\]/i){
			$param = $line;
			$param =~ s/\[Arguments\](.*)/$1/;
			$trim_kw = trim_ws($kw);
			$param =~ s/^\t+(.*)/$1/;
			$cmd = $trim_kw . "\t" . $param;
			print WFH $cmd;
		}
	}
}
sub trim_ws {
	$in = @_[0];
	$in =~ s/[\t\r\n]+//g;
	return $in
}