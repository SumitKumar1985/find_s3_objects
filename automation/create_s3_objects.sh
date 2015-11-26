#!/usr/bin/env bash

# Create the desired buckets and copy over the test files.

SCRIPT_NAME="$0"

if [ $# -ne 2 ]
then
	echo "Error: missing argument(s)"
	echo "Usage: ${SCRIPT_NAME} profile domain_name"
	exit 1
fi

PROFILE="$1"
DOMAIN_NAME="$2"

BUCKETS=$(ls -l ./data/ | grep '^d' | awk '{ print $NF }')

for bucket_name in ${BUCKETS} 
do
	FQBN="${DOMAIN_NAME}.${bucket_name}"
	aws --profile ${PROFILE} s3 mb s3://${FQBN}
	aws --profile ${PROFILE} s3 cp --recursive ./data/${bucket_name}/* s3://${FQBN}
	echo "Copied test data into ${FQBN}"
done

while read bucket_name
do
	FQBN="${DOMAIN_NAME}.${bucket_name}"
	echo "Listing bucket: ${FQBN}
	aws --profile ${PROFILE} s3 ls s3://{FQBN}
done < buckets
