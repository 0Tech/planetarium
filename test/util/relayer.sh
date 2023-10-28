#!/bin/sh

relayer_name() {
	local a_chain_id=$1
	local b_chain_id=$2

	local relayer_dir=$a_chain_id_$b_chain_id
	printf ${relayer_dir}_relayer
}

relayer_exec() {
	local a_chain_id=$1
	local b_chain_id=$2
	local command=$3

	docker exec $(relayer_name $a_chain_id $b_chain_id) sh -c "$command"
}

create_connection() {
	local a_chain_id=$1
	local b_chain_id=$2

	relayer_exec $a_chain_id $b_chain_id "hermes --json create connection --a-chain $a_chain_id --b-chain $b_chain_id"
}

create_channel() {
	local port=$1
	local a_connection=$2
	local a_chain_id=$3
	local b_chain_id=$4
	
	relayer_exec $a_chain_id $b_chain_id "hermes --json create channel --a-port $port --b-port $port --a-connection $a_connection --a-chain $a_chain_id"
}
