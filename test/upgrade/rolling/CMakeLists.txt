configure_file(upgrade-chain.sh.in upgrade-chain.sh
  @ONLY)

add_test(
  NAME upgrade_chain_rolling
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=upgrade-rolling APP=${APP} ./upgrade-chain.sh")

if(FIXTURE_NEW_DAEMON_VERSION STREQUAL default)
  request_daemon(${APP} local)
else()
  request_daemon(${APP} ${FIXTURE_NEW_DAEMON_VERSION})
endif()

add_chain(upgrade-rolling ${APP} ${FIXTURE_DAEMON_VERSION} ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})
set_tests_properties(upgrade_chain_rolling
  PROPERTIES FIXTURES_REQUIRED UpgradeRolling)
