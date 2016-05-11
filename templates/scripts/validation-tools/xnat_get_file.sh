#!/bin/bash 
# Author: Mohana Ramaratnam (mohanakannan9@gmail.com)
# This program will fetch the file from the collection and specified by catalog_content and write to rule_file
# XNAT Host
# XNAT User
# XNAT Password
# Project ID
# Catalog content
# Collection
# Path to rule file


program=$0; 
program=$program:t;

host=$1;
user=$2;
password=$3;
projectid=$4;
catalog_content=$5;
collection=$6;
rule_file=$7

# Get the CSV file from XNAT
# Get the URI
# Get the file corresponding to the URI

csv_file=tmp.csv;

uri="REST/projects/$projectid/files?format=csv";

XNATRestClient  -u $user -p $password -host $host -m GET -remote  $uri > $csv_file

if [ $status ]; then
  echo $program": execution aborted";
  exit -1;
fi  

# Parse the CSV file to get the uri

uri=`@PIPELINE_DIR_PATH@/validation-tools/parse_csv.pl -f tmp.csv -a $catalog_content -c $collection`;

 \rm -rf $csv_file

if [ $status ]; then
  echo $program": execution aborted";
  exit -1;
fi  

if [ $uri = "0" ]; then
  echo $program": execution halted. No such content tag set";
  exit 0;
fi  


XNATRestClient  -u $user -p $password -host $host -m GET -remote  $uri > $rule_file

if [ $status ]; then
  echo $program": execution aborted";
  exit -1;
fi  

