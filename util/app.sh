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
	local version=$2

	if [ $version = dummy ]
	then
		printf v0-Dummy
		return
	fi

	case $app_name in
		gaia)
			_gaia_upgrade_name $version
			;;
	esac
}

_gaia_upgrade_name() {
	local version=$1

	local major=$(printf $version | cut -d . -f 1)
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
