set(TEST_DOWNLOAD_BINARIES false)

configure_file(../upgrade-chain.sh.in upgrade-chain.sh
  @ONLY
)

request_app(${APP} ${INPLACE_NEW_APP_VERSION})
add_chain(upgrade-manual ${APP} ${FIXTURE_APP_VERSION} ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})

add_test(
  NAME upgrade_chain_manual
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=upgrade-manual APP=${APP} VERSION=${INPLACE_NEW_APP_VERSION} ./upgrade-chain.sh"
)
set_tests_properties(upgrade_chain_manual
  PROPERTIES FIXTURES_REQUIRED UpgradeManual
)
