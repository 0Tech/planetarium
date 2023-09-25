#!/bin/sh

app_name() {
	local app=$1

	printf $app | cut -d / -f 2
}

assert_app_name() {
	local app_name=$1

	case $app_name in
		cosmos-sdk|gaia)
		;;
		*)
			echo "app `$app_name` is not supported"
			false
			;;
	esac
}

daemon_name() {
	local app_name=$1

	case $app_name in
		cosmos-sdk)
			printf simd
			;;
		gaia)
			printf gaiad
			;;
	esac
}

daemon_home() {
	local app_name=$1

	local user=cosmovisor
	local home=/home/$user

	case $app_name in
		cosmos-sdk)
			printf $home/.simapp
			;;
		gaia)
			printf $home/.gaia
			;;
	esac
}

upgrade_name() {
	local app_name=$1
	local daemon_version=$2

	local candidate=
	case $app_name in
		gaia)
			candidate=$(_gaia_upgrade_name $daemon_version)
		;;
	esac

	if [ -z "$candidate" ]
	then
		candidate=v0-Dummy
	fi
	printf $candidate
}

_gaia_upgrade_name() {
	local daemon_version=$1

	local major=$(printf $daemon_version | cut -d . -f 1)
	if [ $major -ge 10 ]
	then
		printf v$major
	else
		case $major in
			9)
				printf v9-Lambda
				;;
			8)
				printf v8-Rho
				;;
			7)
				printf v7-Theta
				;;
		esac
	fi
}
