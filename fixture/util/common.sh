#!/bin/sh

lower() {
	printf $1 | tr [:upper:] [:lower:]
}

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
