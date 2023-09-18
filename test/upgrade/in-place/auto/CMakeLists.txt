set(TEST_DOWNLOAD_BINARIES true)

configure_file(../upgrade-chain.sh.in upgrade-chain.sh
  @ONLY)

add_test(
  NAME upgrade_chain_auto
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=upgrade-auto APP_NAME=${APP_NAME} DAEMON_VERSION=${FIXTURE_NEW_DAEMON_VERSION} sh upgrade-chain.sh")
add_chain(upgrade-auto ${APP_NAME} ${FIXTURE_DAEMON_VERSION} ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})
set_tests_properties(upgrade_chain_auto
  PROPERTIES FIXTURES_REQUIRED UpgradeAuto)
