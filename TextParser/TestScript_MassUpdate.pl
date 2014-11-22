#*******************************************************************
#       Program name: TestScript_MassUpdate.pl
#       
#       Author:  Roberto Galman
#       Date:    11/21/2014
#
#       Description: Mass Update Test Script filename & Test
#                    Case Name to follow CamelSpace & Underscore
#                    format
#
#===================================================================
#       History
#===================================================================
#       Version         Date            Description
#       1.0             11/21/2014      Creation
#*******************************************************************


#use strict;
use Getopt::Long;
use File::Basename;
use Cwd;
 
GetOptions( "help"	=> sub{ Usage(); exit;}, # Output Help File
	    "t=s"	=> \$target
	  ) or die "Use -help for more information.\n";

if (not defined $target)
{
	print "ERROR: No input folder";
	Usage();
	exit;
}
#Process Flow
#************
# 1. Open File
# 2. Generate Filename - CamelCase & Remove Space
# 3. Create tmp file with all the Test Cases Renamed
# 3.1 Copy tmp file to target file
# 4. Git Rename to the generated file name
# 

# Define cmd path
my $find = "c:\\msysgit\\msysgit\\bin\\find.exe";
my $git = "c:\\msysgit\\msysgit\\cmd\\git.cmd";

# Flags
my $testcaseflag = 0;


$cmd = "$find $target -name \\*.txt -print";

my @RFTestScripts = `$cmd`;
chomp @RFTestScripts;

open(BFH,">rename.bat") or die $!;
open(LFH,">TSMassUpdate.txt") or die $!;

print LFH "TARGET: $target\n\n======================\n";
foreach my $RF (@RFTestScripts)
{
	$basename = $RF;
	# Extract basename
	$basename =~ s/.*\/(.*)\.txt$/$1/g;
	#Generate Prescribed Filename - i.e. CamelCase with No spaces
	$CamelCaseTrimFn = trim_ws(CamelCase($basename));
	# Replace "/" with "\" for Windows
	$RF =~ s/\//\\/g;
	
	print LFH "Opening $RF...\n\n";
	
	$testcaseflag = 0;
	open my $fh, '<', "$RF"  or die "$!";
	open(WFH,">tmp.txt") or die $!;
	
	# Create tmp file
	while ( my $line = <$fh>) {
		if ($line =~ m/\*Test.*case/i) {
			$testcaseflag = 1;
		}
		
		# Extract Test Case Name then replace with the new name
		if ( $line =~ m/^[^#\t\*].+/) {
			if ($testcaseflag > 0) {
				print WFH "$CamelCaseTrimFn\n";
				print LFH "TESTCASE: $line\n";
			} else {
				print WFH $line;
			}
		} else {
			print WFH $line;
		}
		if ($line =~ m/\*Keyword*/i) {
			$testcaseflag = 0;
		}
		
	}
	close WFH;
	
	# Copy tmp file & overwrite
	system("cp tmp.txt '$RF'");
	# Generate new filename for git mv
	$dirname  = dirname($RF);
	$newfn = $dirname."\\".$CamelCaseTrimFn."\.txt";
	# Had to write the file to a batch script since I'm encountering
	# permission denied error when triggered directly from perl system cmd
	print BFH "call $git mv \"$RF\" \"$newfn\n";
	
	
}
# Run the batch script that will rename everything
system("rename.bat");
close BFH;
close LFH;

#######################################################################
# Subroutine: trim_ws
# Desc: Remove whitespaces from String - Tabs, spaces, return, newline
#######################################################################
sub trim_ws {
	#Remove Whitespaces from String - 
	$in = @_[0];
	$in =~ s/[\s\t\r\n]+//g;
	return $in
}

#######################################################################
# Subroutine: CamelCase
# Desc: Capitalize every first character of the word
#######################################################################
sub CamelCase {
	$in = @_[0];
	$in =~  s/(\w+)/\u$1/g;
	return $in
}

#######################################################################
# Subroutine: Usage
# Desc: Show Help
#######################################################################
sub Usage 
{ 
    print "IMPORTANT: You need to run this script inside the euHReka-Testing local repository!\n\n";
	print "Usage:\n";
	print "\t-t -Path to Target Folder relative to euHReka-Testing folder\n";
	print "Example:\n";

	print "	perl $0 -m AllTests\\Framework \n";

	return(0);
}