configure_file(restart-sentries.sh.in restart-sentries.sh
  @ONLY)
get_target_property(CHAIN_BINARY_DIR chain BINARY_DIR)
configure_file(scale-sentries.sh.in scale-sentries.sh
  @ONLY)

add_test(
  NAME restart_sentries
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=restart-sentries sh restart-sentries.sh")
add_chain(restart-sentries ${APP_NAME} ${FIXTURE_DAEMON_VERSION} ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})
set_tests_properties(restart_sentries
  PROPERTIES FIXTURES_REQUIRED RestartSentries)

add_test(
  NAME scale_sentries
  COMMAND timeout ${TEST_TIMEOUT} sh -c "CHAIN_ID=scale-sentries APP_NAME=${APP_NAME} DAEMON_VERSION=${FIXTURE_DAEMON_VERSION} NUM_REGIONS=${FIXTURE_NUM_REGIONS} NUM_SENTRIES=${FIXTURE_NUM_SENTRIES} sh scale-sentries.sh")
add_chain(scale-sentries ${APP_NAME} ${FIXTURE_DAEMON_VERSION} ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})
set_tests_properties(scale_sentries
  PROPERTIES FIXTURES_REQUIRED ScaleSentries)
