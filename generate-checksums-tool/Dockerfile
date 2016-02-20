FROM resin/amd64-debian:jessie

RUN apt-get update && apt-get install -y --no-install-recommends \
		curl python python-pip \
	&& rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN pip install awscli

COPY . /

CMD ./generate-checksums.sh
