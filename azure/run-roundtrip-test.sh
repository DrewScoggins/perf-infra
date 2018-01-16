if [ ! -d "./benchview" ]; then
    mkdir benchview
    curl "http://benchviewtestfeed.azurewebsites.net/nuget/FindPackagesById()?id='Microsoft.BenchView.JSONFormat'" | grep "content type" | sed "$ s/.*src=\"\([^\"]*\)\".*/\1/;tx;d;:x" | xargs curl -o benchview.zip
    unzip -q -o benchview.zip -d ./benchview
fi

TIME=`date +%H:%M:%S`

echo $TIME
echo Running ColdStart
/home/anscoggi/perf-infra/azure/run-roundtrip.py --endpoint https://test-service-2.azurewebsites.net/api/CSharpColdStart?code=Q3Vz/ryJM3KAadF5llRyRUoU7OMKLUrdrjefgWIBRF4NDa8nFqNIcQ== --coldstart
echo $TIME
echo Running End to End
/home/anscoggi/perf-infra/azure/run-roundtrip.py --endpoint https://test-service-2.azurewebsites.net/api/hellocsharp?code=l6eQNrHbdcaFeayabWmvyIgYrhi3SmiAmVxtNLmlweWoyUoeLFHakg== --endtoend

DATE=`date '+%Y-%m-%d %H:%M'`
BUILDNUM=`date +%Y%m%d%H%M`
TIMESTAMP=`date +%Y-%m-%dT%H:%M:%SZ`
echo $DATE
python3.5 ./benchview/tools/submission-metadata.py --user-email "dotnet-bot@microsoft.com" --name "Azure Function test $DATE"
python3.5 ./benchview/tools/machinedata.py
python3.5 ./benchview/tools/build.py --branch "Azure Functions" --number $BUILDNUM --source-timestamp="$TIMESTAMP" --repository https://www.github.com/dotnet/perfinfra --type rolling
python3.5 ./benchview/tools/measurement.py csv dataend.csv --metric "Elapsed Time" --unit "milliseconds" --better desc
python3.5 ./benchview/tools/measurement.py csv datacold.csv --metric "Elapsed Time" --unit "milliseconds" --better desc --append
python3.5 ./benchview/tools/submission.py measurement.json --build build.json --machine-data machinedata.json --metadata submission-metadata.json --group "Azure Function Perf" --type "rolling" --config-name "End to end" --config Location "Same RG" --architecture x64 --machinepool "Azure Functions"
python3.5 ./benchview/tools/upload.py submission.json --container coreclr

rm *.json
rm -rf benchview
rm -rf *.csv
rm *.zip
