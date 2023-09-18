configure_file(restart-sentries.sh.in restart-sentries.sh
  @ONLY)
get_target_property(CHAIN_BINARY_DIR chain BINARY_DIR)
configure_file(scale-sentries.sh.in scale-sentries.sh
  @ONLY)

add_test(
  NAME restart_sentries
  COMMAND timeout ${TEST_TIMEOUT} sh -c "PROJECT_NAME=RestartSentries sh restart-sentries.sh")
add_chains(RestartSentries 1 ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})
set_tests_properties(restart_sentries
  PROPERTIES FIXTURES_REQUIRED RestartSentries)

add_test(
  NAME scale_sentries
  COMMAND timeout ${TEST_TIMEOUT} sh -c "PROJECT_NAME=ScaleSentries NUM_CHAINS=1 NUM_REGIONS=${FIXTURE_NUM_REGIONS} NUM_SENTRIES=${FIXTURE_NUM_SENTRIES} sh scale-sentries.sh")
add_chains(ScaleSentries 1 ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})
set_tests_properties(scale_sentries
  PROPERTIES FIXTURES_REQUIRED ScaleSentries)
