set(TEST_DOWNLOAD_BINARIES true)

configure_file(../upgrade-chain.sh.in upgrade-chain.sh
  @ONLY
)

require_app(${APP} ${INPLACE_NEW_APP_VERSION})
add_chain(ChainInplaceAuto inplace-auto-0 ${APP} ${TEST_APP_VERSION} ${TEST_NUM_REGIONS} ${TEST_NUM_SENTRIES} ${TEST_TIMEOUT})

add_test(
  NAME solo_inplace_auto
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=inplace-auto-0 APP=${APP} VERSION=${INPLACE_NEW_APP_VERSION} ./upgrade-chain.sh"
)
set_tests_properties(solo_inplace_auto PROPERTIES
  FIXTURES_REQUIRED ChainInplaceAuto
)
