#!/bin/sh

aws configure set aws_access_key_id $AWS_ID
aws configure set aws_secret_access_key $AWS_KEY

while [ 1 ] ; do
    /job.sh
    sleep $DNS_QUERY_INTERVAL
done
