#!/bin/bash
set -e

S3_ROOT='http://resin-packages.s3.amazonaws.com'

printf "$ACCESS_KEY\n$SECRET_KEY\n$REGION_NAME\n\n" | aws configure
aws s3 ls --recursive s3://$BUCKET_NAME/node/ | awk '{print $4}' > temp
aws s3 ls --recursive s3://$BUCKET_NAME/golang/ | awk '{print $4}' >> temp

echo "### Resin in-house binary checksums" > SHASUMS256.txt

while read line; do
	url="$S3_ROOT/$line"
	filename=$(basename $line)
	echo "Processing $filename"
	curl -SLO "$url"
	sha256sum "$filename" >> SHASUMS256.txt
	rm -f $filename
done <temp

aws s3 cp SHASUMS256.txt "s3://$BUCKET_NAME/"
