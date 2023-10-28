configure_file(restart-sentries.sh.in restart-sentries.sh
  @ONLY
)
get_target_property(CHAIN_BINARY_DIR chain BINARY_DIR)
configure_file(scale-sentries.sh.in scale-sentries.sh
  @ONLY
)

add_chain(ChainLiveness liveness-0 ${APP} ${TEST_APP_VERSION} ${TEST_NUM_REGIONS} ${TEST_NUM_SENTRIES} ${TEST_TIMEOUT})

add_test(
  NAME sentry_restart
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=liveness-0 ./restart-sentries.sh"
)
set_tests_properties(sentry_restart PROPERTIES
  LABELS basic
  FIXTURES_REQUIRED ChainLiveness
  RESOURCE_LOCK ChainLivenessAccess
)

add_test(
  NAME sentry_scaling
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=liveness-0 APP=${APP} VERSION=${TEST_APP_VERSION} NUM_REGIONS=${TEST_NUM_REGIONS} NUM_SENTRIES=${TEST_NUM_SENTRIES} ./scale-sentries.sh"
)
set_tests_properties(sentry_scaling PROPERTIES
  LABELS basic
  FIXTURES_REQUIRED ChainLiveness
  RESOURCE_LOCK ChainLivenessAccess
)
