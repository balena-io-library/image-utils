#!/bin/bash
set -e

docker build -t checksum-generator .
docker run --rm -e ACCESS_KEY=$ACCESS_KEY \
				-e SECRET_KEY=$SECRET_KEY \
				-e BUCKET_NAME=$BUCKET_NAME checksum-generator

docker rmi -f checksum-generator
