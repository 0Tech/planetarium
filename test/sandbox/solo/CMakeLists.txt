add_chain(ChainSandbox sandbox-0 ${APP} ${TEST_APP_VERSION} ${TEST_NUM_REGIONS} ${TEST_NUM_SENTRIES} ${TEST_TIMEOUT})

add_test(
  NAME solo_sandbox
  COMMAND sleep 2147483647
)
set_tests_properties(solo_sandbox PROPERTIES
  LABELS sandbox
  FIXTURES_REQUIRED ChainSandbox
)
