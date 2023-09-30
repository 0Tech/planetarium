#!/bin/sh

app_exec() {
	local service_name=$1
	local app=$2
	local command=$3

	local daemon=$(daemon $(app_name $app))

	service_exec_as_user $service_name cosmovisor "$daemon $command"
}

query_tx() {
	local service_name=$1
	local app=$2
	local txhash=$3

	while ! _result=$(app_exec $service_name $app "query tx $txhash 2>/dev/null")
	do
		sleep 1
	done
	echo $_result
}

assert_tx() {
	local result=$1

	[ $(echo $result | jq -er .code ) -eq 0 ]
}

broadcast_tx() {
	local service_name=$1
	local app=$2
	local command=$3

	local response=$(app_exec $service_name $app "tx $command --gas auto --gas-adjustment 1.5 --yes")
	[ -n "$response" ]

	echo $response | jq -er .txhash
}
