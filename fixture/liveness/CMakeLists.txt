configure_file(restart-sentries.sh.in restart-sentries.sh
  @ONLY)
get_target_property(IMAGE_SOURCE_DIR install_image SOURCE_DIR)

add_test(
  NAME restart_sentries
  COMMAND timeout 10m sh -c "PROJECT_NAME=RestartSentries sh restart-sentries.sh")
add_chains(RestartSentries 1 ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} 10m)
set_tests_properties(restart_sentries
  PROPERTIES FIXTURES_REQUIRED RestartSentries)
