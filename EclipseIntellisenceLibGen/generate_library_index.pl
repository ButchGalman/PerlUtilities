#use strict;
#use XML::Parser;
my @params = ();
my $kw = "init";
$parameters = "";

open my $fh, '<', "EWSLibrary.xml"  or die "EWSLibrary.xml: $!";
open(WFH,">BuiltIn.index") or die $!;

while ( my $line = <$fh> ) {
	if ($line =~ m/\<kw name=\"(.+)\"\>/i ){
		$kw = $line;
		$kw =~ s/\<kw name=\"(.*)\"\>/$1/;
	}
	if (($line =~ m/\<arg\>(.*)\<\/arg\>/i)){
		$param = $line;
		$param =~ s/\<arg\>(.*)\<\/arg\>/$1/;
		if ( $kw ne "init" ) {
			$parameters = $parameters . "\t" . $param
		}
	}
	
	if ( $line =~ m/\<\/kw\>/i ) {
		$kw = trim_ws($kw);
		$parameters = trim_ws($parameters);
		$info = $kw . $parameters;
		print WFH "$info\n";
		$parameters = ""
	}
}

sub trim_ws {
	$in = @_[0];
	$in =~ s/[\r\n]+//g;
	chomp($in);
	return $in
}