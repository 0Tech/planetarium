configure_file(restart-sentries.sh.in restart-sentries.sh
  @ONLY
)
get_target_property(CHAIN_BINARY_DIR chain BINARY_DIR)
configure_file(scale-sentries.sh.in scale-sentries.sh
  @ONLY
)

add_chain(ChainLiveness liveness-0 ${APP} ${FIXTURE_APP_VERSION} ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})

add_test(
  NAME solo_sentry_restart
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=liveness-0 ./restart-sentries.sh"
)
set_tests_properties(solo_sentry_restart PROPERTIES
  FIXTURES_REQUIRED ChainLiveness
  RESOURCE_LOCK ChainLivenessAccess
)

add_test(
  NAME solo_sentry_scaling
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=liveness-0 APP=${APP} VERSION=${FIXTURE_APP_VERSION} NUM_REGIONS=${FIXTURE_NUM_REGIONS} NUM_SENTRIES=${FIXTURE_NUM_SENTRIES} ./scale-sentries.sh"
)
set_tests_properties(solo_sentry_scaling PROPERTIES
  FIXTURES_REQUIRED ChainLiveness
  RESOURCE_LOCK ChainLivenessAccess
)
