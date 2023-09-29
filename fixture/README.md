# fixture

## Introduction

Setting up a chain is tedious but time-consuming procedure. We provide
[fixtures](https://cmake.org/cmake/help/latest/prop_test/FIXTURES_REQUIRED.html)
for the tests, so one can concentrate on his/her own test logic.

## Functions

### add_chain

It creates an ephemeral chain using your local Docker instances. After the test
has been finished, it will also cleanup the chain.

#### Parameters

1. `fixture_name`: The name of fixture would be based on this parameter.
2. `chain_id`: The chain id of the chain.
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
set_tests_properties(your_test_name PROPERTIES
  FIXTURES_REQUIRED YourFixtureName)
```

And fill your logic in your test script. You will need the scripts in `util`,
to manipulate the Docker instances of your fixture.

``` shell
#!/bin/sh
# content of your-test-script.sh.in
set -e

. @CMAKE_SOURCE_DIR@/fixture/util/common.sh
. @CMAKE_SOURCE_DIR@/fixture/util/service.sh

# your logic comes here
_num_healthy=0
for _validator in $(get_services your-chain-id _ validator)
do
	if [ $(service_health $_validator) = healthy ]
	then
		_num_healthy=$(expr $_num_healthy + 1)
	fi
done

echo The number of the healthy validators is: $_num_healthy

```
