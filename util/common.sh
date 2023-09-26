#!/bin/sh

# every variable must not be empty
assert_variables() {
	for name in $@
	do
		if [ -z "$(eval printf '$'$name)" ]
		then
			echo no variable: $name
			false
		fi
	done
}

# support verbose output
support_verbose() {
	if [ -n "$VERBOSE" ]
	then
		set -x
	else
		exec 1>/dev/null 2>&1
	fi
}

support_verbose