#!/bin/sh

assert_docker() {
	if ! docker info >/dev/null 2>&1
	then
		cmake -E echo "Error: You must have access to docker: add your uid to docker group" >&2
		false
	fi
}

debian_codenames() {
	cat <<EOF
bookworm
bullseye
buster
stretch
jessie
EOF
}

guess_image_tag() {
	local name=$1
	local version=$2

	for _codename in $(debian_codenames)
	do
		_tag=$version-$_codename
		if docker manifest inspect $name:$_tag >/dev/null
		then
			printf $_tag
			break
		fi
	done
}

assert_docker
