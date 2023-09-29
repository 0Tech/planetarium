set(TEST_DOWNLOAD_BINARIES false)

configure_file(../upgrade-chain.sh.in upgrade-chain.sh
  @ONLY
)

require_app(${APP} ${INPLACE_NEW_APP_VERSION})
add_chain(ChainInplaceManual inplace-manual-0 ${APP} ${FIXTURE_APP_VERSION} ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})

add_test(
  NAME solo_inplace_manual
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=inplace-manual-0 APP=${APP} VERSION=${INPLACE_NEW_APP_VERSION} ./upgrade-chain.sh"
)
set_tests_properties(solo_inplace_manual PROPERTIES
  FIXTURES_REQUIRED ChainInplaceManual
)
