# test

## Introduction

One of the primary goals of this project is testing 
[cosmos-sdk](https://github.com/cosmos/cosmos-sdk) based applications. The
followings are supported for now:

1. `cosmos/cosmos-sdk`: `simapp` of
[cosmos/cosmos-sdk](https://github.com/cosmos/cosmos-sdk)
2. `cosmos/gaia`: [cosmos/gaia](https://github.com/cosmos/gaia)

One can choose a target application of the tests by:

``` shell
app=cosmos/gaia  # application for tests
cmake -S . -B $build_dir -DAPP=$app
```

## Target

One can trigger a target for a test by:

``` shell
test_name=rolling  # name of test target
ctest --test-dir $build_dir -R $test_name
```

Before adding a new test, please refer to [fixture](#fixture) first.

### rolling

It tests rolling update of a chain.

Procedure:

1. Setup a chain.
2. Update binary of each node sequentially.
3. Wait for reaching a certain height.

### inplace

It tests in-place migration of a chain.

Procedure:

1. Setup a chain.
2. Submit a proposal for the migration.
3. Place the new binary to all nodes.
4. Wait for reaching a certain height after the upgrade height.

### sentry\_restart

It tests that a chain can continue with recovered sentries.

Procedure:

1. Setup a chain.
2. Stop all the sentries.
3. Make sure the chain has stopped.
4. Start all the sentries again.
5. Wait for reaching a certain height.

### sentry\_scaling

It tests scaling of sentries working.

Procedure:

1. Setup a chain.
2. Scale down the sentries.
3. Scale up the sentries.
4. Wait for all the sentries being healthy.

## Variable

There are several variables relevant to the tests:

* `APP_NAME`: name of application
* `TEST_NUM_REGIONS`: number of regions consisting chain cluster
                         (each region has one validator)
* `TEST_NUM_SENTRIES`: number of sentries in each region
* `TEST_APP_VERSION`: version of app in almost all scenarios
* `TEST_NEW_APP_VERSION`: version of the new app in upgrade scenarios


# fixture

## Introduction

Many tests may need the same preparations before they can operate. It would be
frustrating if one have to implement or copy-and-paste the procedures into each
test. For example, setting up a chain is tedious but time-consuming procedure.
We provide
[fixtures](https://cmake.org/cmake/help/latest/prop_test/FIXTURES_REQUIRED.html)
for the tests, so one can concentrate on their own test logic.

## Functions

### add\_chain()

It creates an ephemeral chain using your local Docker instances. After the test
has been finished, it will also cleanup the chain. For detailed information,
please refer to [chain](./chain/README.md).

#### Parameters

1. `fixture_name`: The name of fixture would be based on this parameter.
2. `chain_id`: The chain id of the chain. It must be unique.
3. `app_name`: The name of application used in the chain.
4. `num_regions`: The number of subnets in each chain in the fixture.
5. `num_sentries`: The number of sentries in each subnet.
6. `timeout`: If it takes longer than this value to setup the chain,
subsequent tests would fail (for the debugging).

#### Example

Create a test and make it use a new fixture. The corresponding CMake file would
be:

``` cmake
configure_file(your-test-script.sh.in your-test-script.sh
  @ONLY)

add_chain(YourFixtureName your-chain-id your-app app-version 4 10 10m)
add_test(
  NAME your_test_name
  COMMAND ./your-test-script.sh
set_tests_properties(your_test_name PROPERTIES
  FIXTURES_REQUIRED YourFixtureName)
```

And fill your logic in your test script. You will need the scripts in `util`,
to manipulate the Docker instances of your fixture.

``` shell
#!/bin/sh
# content of your-test-script.sh.in
set -e

. @CMAKE_SOURCE_DIR@/util/common.sh
. @CMAKE_SOURCE_DIR@/test/util/service.sh

# your logic comes here
_num_healthy=0
for _validator in $(get_services your-chain-id _ validator)
do
	if [ "$(service_health $_validator)" = healthy ]
	then
		_num_healthy=$(expr $_num_healthy + 1)
	fi
done

echo The number of the healthy validators is: $_num_healthy

```
