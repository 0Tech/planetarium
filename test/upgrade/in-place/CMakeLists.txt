configure_file(upgrade-chain.sh.in upgrade-chain.sh
  @ONLY
)

if(TEST_NEW_APP_VERSION STREQUAL default)
  set(INPLACE_NEW_APP_VERSION dummy)
else()
  set(INPLACE_NEW_APP_VERSION ${TEST_NEW_APP_VERSION})
endif()

require_app(${APP} ${INPLACE_NEW_APP_VERSION})
add_chain(ChainInplace inplace-0 ${APP} ${TEST_APP_VERSION} ${TEST_NUM_REGIONS} ${TEST_NUM_SENTRIES} ${TEST_TIMEOUT})

add_test(
  NAME inplace
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=inplace-0 APP=${APP} VERSION=${INPLACE_NEW_APP_VERSION} ./upgrade-chain.sh"
)
set_tests_properties(inplace PROPERTIES
  LABELS basic
  FIXTURES_REQUIRED ChainInplace
)

unset(INPLACE_NEW_APP_VERSION)
