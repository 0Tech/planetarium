#!/bin/sh

region_name() {
	local index=$1

	printf region%02d $1
}

service_name() {
	local type=$1
	local region_id=$2
	local chain_id=$3

	# TODO
	local hostname=
	if [ $type = seat ] || [ $type = sentry ] || [ $type = full ]
	then
		hostname=${type}00
	else
		hostname=${type}
	fi

	printf $hostname.$region_id:$chain_id
}

_container_name() {
	local name=$1

	local chain_id=$(printf $name | cut -d : -f 2)
	local local_name=$(printf $name | cut -d : -f 1)
	docker-compose -p $chain_id ps -q -- $local_name
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
	local chain_id=$1
	local region_id=$2
	local type=$3

	local services=$(docker-compose -p $chain_id ps --services)
	if [ -n "$region_id" ] && [ $region_id != _ ]
	then
		services=$(printf "$services" | grep -E '\.'$region_id'$')
	fi

	if [ -n "$type" ] && [ $type != _ ]
	then
		services=$(printf "$services" | grep -E ^$type'[[:digit:]]*\.')
	fi

	echo "$services" | sed 's/$/:'$chain_id'/'
}

get_control_services() {
	local chain_id=$1
	local region_id=$2

	get_services "$chain_id" "$region_id" administrator
}

get_managed_services() {
	local chain_id=$1
	local region_id=$2

	get_services "$chain_id" "$region_id" | grep -Ev '^administrator\.'
}

service_health() {
	local name=$1

	docker inspect $(_container_name $name) | jq -er .[0].State.Health.Status
}

service_status() {
	local name=$1

	docker inspect $(_container_name $name) | jq -er .[0].State.Status
}
