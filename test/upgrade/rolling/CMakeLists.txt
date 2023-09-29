configure_file(upgrade-chain.sh.in upgrade-chain.sh
  @ONLY
)

if(FIXTURE_NEW_APP_VERSION STREQUAL default)
  set(ROLLING_NEW_APP_VERSION local)
else()
  set(ROLLING_NEW_APP_VERSION ${FIXTURE_NEW_APP_VERSION})
endif()

require_app(${APP} ${ROLLING_NEW_APP_VERSION})
add_chain(ChainRolling rolling-0 ${APP} ${FIXTURE_APP_VERSION} ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})

add_test(
  NAME solo_rolling
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=rolling-0 APP=${APP} VERSION=${ROLLING_NEW_APP_VERSION} ./upgrade-chain.sh"
)
set_tests_properties(solo_rolling PROPERTIES
  FIXTURES_REQUIRED ChainRolling
)
