configure_file(restart-sentries.sh.in restart-sentries.sh
  @ONLY
)
get_target_property(CHAIN_BINARY_DIR chain BINARY_DIR)
configure_file(scale-sentries.sh.in scale-sentries.sh
  @ONLY
)

add_chain(liveness ${APP} ${FIXTURE_DAEMON_VERSION} ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})

add_test(
  NAME restart_sentries
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=liveness ./restart-sentries.sh"
)
set_tests_properties(restart_sentries
  PROPERTIES FIXTURES_REQUIRED Liveness
)

add_test(
  NAME scale_sentries
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=liveness APP=${APP} VERSION=${FIXTURE_DAEMON_VERSION} NUM_REGIONS=${FIXTURE_NUM_REGIONS} NUM_SENTRIES=${FIXTURE_NUM_SENTRIES} ./scale-sentries.sh"
)
set_tests_properties(scale_sentries
  PROPERTIES FIXTURES_REQUIRED Liveness
)
