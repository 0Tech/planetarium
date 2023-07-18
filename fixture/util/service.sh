#!/bin/sh

service_name() {
	local type=$1
	local region=$2
	local chain=$3

	printf $type.region-$region.chain-$chain
}

_container_name() {
	local name=$1

	docker-compose -p $PROJECT_NAME ps -q -- $name
}

service_exec() {
	local name=$1
	local command="$2"

	docker exec $(_container_name $name) sh -c "$command"
}

service_exec_as_user() {
	local name=$1
	local user=$2
	local command="$3"

	docker exec -u $user $(_container_name $name) sh -c "$command"
}

service_wait() {
	local name=$1
	local file=$2

	service_exec $name "while ! [ -f $file ]; do sleep 1; done"
}

service_push() {
	local name=$1
	local src=$2
	local dst=$3

	docker cp $src $(_container_name $name):$dst
}

service_fetch() {
	local name=$1
	local src=$2
	local dst=$3

	docker cp $(_container_name $name):$src $dst
}

get_services() {
	local type=$1

	local services="$(docker-compose -p $PROJECT_NAME ps --services)"
	if [ -n "$type" ]
	then
		printf "$services" | grep -E ^$type\.
	else
		printf "$services"
	fi
}

service_health() {
	local name=$1

	docker inspect $(_container_name $name) | jq -er .[0].State.Health.Status
}

service_status() {
	local name=$1

	docker inspect $(_container_name $name) | jq -er .[0].State.Status
}

assert_variables PROJECT_NAME
