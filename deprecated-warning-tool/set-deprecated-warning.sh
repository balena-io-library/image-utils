#!/bin/bash
set -e

# Install jq
wget http://stedolan.github.io/jq/download/linux64/jq \
	&& chmod a+x jq

for image in $IMAGES; do
	tags=$(curl -X GET https://registry.hub.docker.com/v1/repositories/resin/$image/tags | jq '.[] | .name')

	for tag in $tags; do
		tag=${tag//\"}
		image_name="resin/$image:$tag"
		if [[ $tag == *"onbuild"* ]]; then
			version=$(echo $tag | cut -d'-' -f 1)
			if [ $version == 'onbuild' ]; then
				# onbuild tag will be based on latest tag
				version='latest'
			fi
			sed -e s~#{FROM}~resin/$image:$version~g Dockerfile.onbuild.tpl > Dockerfile
		else
			sed -e s~#{FROM}~$image_name~g Dockerfile.tpl > Dockerfile
		fi
		docker build -t $image_name .
		docker push $image_name
	done
done

