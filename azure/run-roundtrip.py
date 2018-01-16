#!/usr/bin/python
import argparse
import json
import sys
import subprocess
import time

def _parse_args(argv):
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument('--endpoint', type=str, help='The path to the Azure Function endpoint')
    parser.add_argument('--endtoend', action='store_true', default=False, help='Selects the run to be end-to-end')
    parser.add_argument('--coldstart', action='store_true', default=False, help='Selects the run to be coldstart')
    return parser.parse_args(argv)

def make_end_to_end_request_to_endpoint(endpoint):
    #Warmup the endpoint
    artillery_warmup_cmdline = ['artillery', 'quick', '--duration', '10', '--rate', '10', '--num', '1', '{}'.format(endpoint)]
    subprocess.check_call(artillery_warmup_cmdline)
    artillery_cmdline = ['artillery', 'quick', '--output', 'load.json', '--duration', '30', '--rate', '10', '--num', '1', '{}'.format(endpoint)]
    subprocess.check_call(artillery_cmdline)

def make_cold_request_to_endpoint(endpoint):
    #Warmup the endpoint
    artillery_cmdline = ['artillery', 'quick', '--output', 'load.json', '--count', '1', '--num', '1', '{}'.format(endpoint)]
    subprocess.check_call(artillery_cmdline)


def parse_artillery_output(config):
    data = json.load(open('load.json'))
    output_data = dict()
    output_data["median"] = data["aggregate"]["latency"]["median"]
    output_data["maximum"] = data["aggregate"]["latency"]["max"]
    if config.endtoend:
        output_data["p95"] = data["aggregate"]["latency"]["p95"]
        output_data["p99"] = data["aggregate"]["latency"]["p99"]
    return output_data

def output_csv(data_to_upload, config):
    for datum in data_to_upload.keys():
        if config.endtoend:
            csv_file = open("dataend.csv", "a")
            csv_file.write("Azure Function End-to-end test,{},{}\n".format(datum, data_to_upload[datum]))
        elif config.coldstart:
            csv_file = open("datacold.csv", "a")
            csv_file.write("Azure Function ColdStart test,{},{}\n".format(datum, data_to_upload[datum]))

def main(argv):
    config = _parse_args(argv[1:])
    data_to_upload = ""
    if config.endtoend:
        make_end_to_end_request_to_endpoint(config.endpoint)
        data_to_upload = parse_artillery_output(config)
        output_csv(data_to_upload, config)
        print("Finished end to end test")
    elif config.coldstart:
        for i in range(0,6):
            make_cold_request_to_endpoint(config.endpoint)
            data_to_upload = parse_artillery_output(config)
            output_csv(data_to_upload, config)
            print("Finished iteration {} of cold start".format(i))
            time.sleep(60*30)

if __name__ == '__main__':
    main(sys.argv)
