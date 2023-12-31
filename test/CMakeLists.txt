# test behavior
set(TEST_TIMEOUT 10m CACHE STRING "timeout for each test")

# nodes for each chain
set(TEST_NUM_REGIONS 4 CACHE STRING "number of the regions in each test")
set(TEST_NUM_SENTRIES 2 CACHE STRING "number of the sentries in each region")
set(TEST_CLIENT_KEYRING_BACKEND test CACHE STRING "keyring backend")
mark_as_advanced(TEST_CLIENT_KEYRING_BACKEND)

# config.toml of app
set(TEST_CONFIG_TIMEOUT_COMMIT 1s CACHE STRING "timeout_commit")
set(TEST_CONFIG_TIMEOUT_PRECOMMIT 1s CACHE STRING "timeout_precommit")
set(TEST_CONFIG_TIMEOUT_PREVOTE 1s CACHE STRING "timeout_prevote")
set(TEST_CONFIG_TIMEOUT_PROPOSE 1s CACHE STRING "timeout_propose")
mark_as_advanced(
  TEST_CONFIG_TIMEOUT_COMMIT
  TEST_CONFIG_TIMEOUT_PRECOMMIT
  TEST_CONFIG_TIMEOUT_PREVOTE
  TEST_CONFIG_TIMEOUT_PROPOSE)

# genesis.json of app
set(TEST_STATE_BOND_DENOM uatom CACHE STRING "bond denom")
mark_as_advanced(TEST_STATE_BOND_DENOM)
set(TEST_STATE_BALANCE 1000000000 CACHE STRING "initial balance of each operator in ${TEST_STATE_BOND_DENOM}")
set(TEST_STATE_DELEGATION 1000000 CACHE STRING "initial delegation of each operator to its validator in ${TEST_STATE_BOND_DENOM}, MUST be >1000000")
set(TEST_STATE_MIN_DEPOSIT 1000 CACHE STRING "x/gov min_deposit in ${TEST_STATE_BOND_DENOM}")
set(TEST_STATE_VOTING_PERIOD 10s CACHE STRING "x/gov voting_period")
set(TEST_STATE_UNBONDING_TIME 60s CACHE STRING "x/staking unbonding_time")

# app.toml of app
set(TEST_APP_MINIMUM_GAS_PRICE 0.001 CACHE STRING "min gas price in ${TEST_STATE_BOND_DENOM}")

# versions of app
set(TEST_APP_VERSION local CACHE STRING "version of app. `local` is locally built one.")
set(TEST_NEW_APP_VERSION default CACHE STRING "version of new app. `local` is locally built one, `dummy` is dummy binary, `default` is scenario default one.")

add_subdirectory(app)
add_subdirectory(runtime)
add_subdirectory(internet)
add_subdirectory(chain)
add_subdirectory(upgrade)
add_subdirectory(liveness)
add_subdirectory(relayer)
add_subdirectory(ibc)

add_subdirectory(sandbox)
