#!/bin/bash
set -e

# Install jq
wget http://stedolan.github.io/jq/download/linux64/jq \
	&& chmod a+x jq

for image in $IMAGES; do
	tags=$(curl -X GET https://registry.hub.docker.com/v1/repositories/resin/$image/tags | jq '.[] | .name')

	for tag in $tags; do
		image_name="resin/$image:${tag//\"}"
		sed -e s~#{FROM}~$image_name~g Dockerfile.tpl > Dockerfile
		docker build -t $image_name .
		docker push $image_name
	done
done
