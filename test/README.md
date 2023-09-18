# test

## Introduction

One of the primary goals of this project is testing 
[cosmos-sdk](https://github.com/cosmos/cosmos-sdk) based applications. The
followings are supported for now:

1. `cosmos-sdk`: `simapp` of [cosmos-sdk](https://github.com/cosmos/cosmos-sdk)
2. `gaia`: [gaia](https://github.com/cosmos/gaia)

One can choose a target application of the tests by:

``` shell
app_name=gaia  # the name of application
cmake -S . -B $build_dir -DAPP_NAME=$app_name
```

## Target

One can trigger a target for a test by:

``` shell
test_name=upgrade_chain_rolling
ctest --test-dir $build_dir -R $test_name
```

Before adding a new test, please refer to [fixture](../fixture/README.md)
first.

### upgrade\_chain\_rolling

It tests rolling update of a chain.

Procedure:

1. Setup a chain.
2. Update binary of each node sequentially.
3. Wait for reaching a certain height.

### upgrade\_chain\_manual

It tests in-place migration of a chain.

Procedure:

1. Setup a chain.
2. Submit a proposal for the migration.
3. Place the new binary to all nodes.
4. Wait for reaching a certain height after the upgrade height.

### restart\_sentries

It tests that a chain can continue with recovered sentries.

Procedure:

1. Setup a chain.
2. Stop all the sentries.
3. Make sure the chain has stopped.
4. Start all the sentries again.
5. Wait for reaching a certain height.

### scale\_sentries

It tests scaling of sentries working.

Procedure:

1. Setup a chain.
2. Scale down the sentries.
3. Scale up the sentries.
4. Wait for all the sentries being healthy.

## Variable

There are several variables relevant to the tests:

* `APP_NAME`: name of application
* `FIXTURE_NUM_REGIONS`: number of regions consisting chain cluster
                         (each region has one validator)
* `FIXTURE_NUM_SENTRIES`: number of sentries in each region
* `FIXTURE_DAEMON_VERSION`: version of binary in almost all scenarios
* `FIXTURE_NEW_DAEMON_VERSION`: version of the new binary in upgrade scenarios
