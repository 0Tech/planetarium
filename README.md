# planetarium

[![license](https://img.shields.io/github/license/0Tech/planetarium)](https://github.com/0Tech/planetarium/blob/main/LICENSE)
[![cosmos-sdk rolling upgrades](https://github.com/0Tech/planetarium/actions/workflows/cosmos-sdk-rolling.yml/badge.svg?event=schedule)](https://github.com/0Tech/planetarium/actions/workflows/cosmos-sdk-rolling.yml)
[![cosmos-sdk in-place migrations](https://github.com/0Tech/planetarium/actions/workflows/cosmos-sdk-in-place.yml/badge.svg?event=schedule)](https://github.com/0Tech/planetarium/actions/workflows/cosmos-sdk-in-place.yml)
[![gaia rolling upgrades](https://github.com/0Tech/planetarium/actions/workflows/gaia-rolling.yml/badge.svg?event=schedule)](https://github.com/0Tech/planetarium/actions/workflows/gaia-rolling.yml)
[![gaia in-place migrations](https://github.com/0Tech/planetarium/actions/workflows/gaia-in-place.yml/badge.svg?event=schedule)](https://github.com/0Tech/planetarium/actions/workflows/gaia-in-place.yml)

## Introduction

You can use this project for:

1. testing [cosmos-sdk](https://github.com/cosmos/cosmos-sdk) based
   applications - [test](./test/README.md)
2. launching & maintaining validator subnet - [playbook](./playbook/README.md)

## Prerequisites

While this project does almost of its jobs in [Docker](https://www.docker.com)
instances, there is a few additional requirements (other than the basic
packages on [Debian GNU/Linux](https://www.debian.org)).

You can install the requirements by:

``` shell
sudo apt install docker-compose cmake jq
```

## Usage

### Configure

At first, you need to configure the project by:

``` shell
build_dir=build  # the folder which you want to output the artifacts into
cmake -S . -B $build_dir
```

After that, you may change some variables by:

``` shell
variable_name=TEST_NUM_REGIONS  # the name of variable
variable_value=7                # set the value of variable to
cmake -S . -B $build_dir -D$variable_name=$variable_value
```

You can provide as many changes as you want, and the changes would be
accumulated. The changes are cached so it persists forever until you override
the change or remove your build directory.

You can see the list of variables which you may want to set:

``` shell
cmake -S . -B $build_dir -L
```

You may also want to read the descriptions:

``` shell
cmake -S . -B $build_dir -LH
```

### Build

Now you may trigger some target. The core targets would be:

* `build`: build the project and make the binaries (e.g. daemon and cosmovisor)

You can trigger a target by:

``` shell
target_name=build
cmake --build $build_dir --target $target_name
```

### Test

You can trigger all the tests by:

``` shell
ctest --test-dir $build_dir
```

Or, a certain test by:

``` shell
test_name=upgrade_chain_auto
ctest --test-dir $build_dir -R $test_name
```
