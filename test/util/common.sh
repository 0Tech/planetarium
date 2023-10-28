#!/bin/sh

wait_pids() {
	local pids=$@

	for _pid in $pids
	do
		tail --pid $_pid -f /dev/null
	done
}
