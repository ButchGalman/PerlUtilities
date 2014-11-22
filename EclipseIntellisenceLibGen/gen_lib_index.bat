rm euHReka-Testing\robot-indices\*.index
python -m robot.libdoc "ews_automationframework\src\EWSLibrary" EWSLibrary.xml
python -m robot.libdoc BuiltIn Built.xml
cat Built.xml >> EWSLibrary.xml
perl generate_library_index.pl

#Flows
perl flow_parser.pl
cat Flow.index >> BuiltIn.index
mkdir euHReka-Testing\robot-indices
mkdir Core-Flows\robot-indices
cp BuiltIn.index euHReka-Testing\robot-indices
cp BuiltIn.index Core-Flows\robot-indices
rm *.index
rm *.txt
rm *.xml
