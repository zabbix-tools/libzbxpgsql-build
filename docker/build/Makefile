all: build

build:
	docker build -t libzbxpgsql/build .

run:
	docker run \
		-it \
		--rm \
		libzbxpgsql/build \
		/bin/bash
