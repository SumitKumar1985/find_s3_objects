#!/usr/bin/env bash

# Create the desired buckets and copy over the test files.

SCRIPT_NAME="$0"

if [ $# -ne 3 ]
then
	echo "Error: missing argument(s)"
	echo "Usage: ${SCRIPT_NAME} profile domain_name queue_arn"
	exit 1
fi

PROFILE="$1"
DOMAIN_NAME="$2"
QUEUE_ARN="$3"

# Create the bucket notification configuration

cp notification_configuration.json.template notification_configuration.json
sed -i '' "s/QUEUE-ARN/${QUEUE_ARN}/" notification_configuration.json

# Create buckets with notification configuration

BUCKETS=$(ls -l ./data/ | grep '^d' | awk '{ print $NF }')

for bucket_name in ${BUCKETS} 
do
	FQBN="${DOMAIN_NAME}.${bucket_name}"
	aws --profile ${PROFILE} s3 rm --recursive s3://${FQBN}
	aws --profile ${PROFILE} s3 rb s3://${FQBN}
	aws --profile ${PROFILE} s3 mb s3://${FQBN}
	aws --profile ${PROFILE} s3api put-bucket-notification-configuration --bucket ${FQBN} \
		--notification-configuration file://notification_configuration.json
	aws --profile ${PROFILE} s3 cp --recursive ./data/${bucket_name} s3://${FQBN}
	echo "Copied test data into ${FQBN}"
done

for bucket_name in ${BUCKETS} 
do
	FQBN="${DOMAIN_NAME}.${bucket_name}"
	echo "Listing bucket: ${FQBN}"
	aws --profile ${PROFILE} s3 ls s3://${FQBN}
done

rm notification_configuration.json
