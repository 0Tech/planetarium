add_chain(ChainIbcSandboxA sandbox-a-0 ${APP} ${TEST_APP_VERSION} ${TEST_NUM_REGIONS} ${TEST_NUM_SENTRIES} ${TEST_TIMEOUT})
add_chain(ChainIbcSandboxB sandbox-b-0 ${APP} ${TEST_APP_VERSION} ${TEST_NUM_REGIONS} ${TEST_NUM_SENTRIES} ${TEST_TIMEOUT})

add_test(
  NAME ibc_sandbox
  COMMAND sleep 2147483647
)
set_tests_properties(ibc_sandbox PROPERTIES
  LABELS sandbox
  FIXTURES_REQUIRED "ChainIbcSandboxA;ChainIbcSandboxB"
)
