get_target_property(DAEMON_SOURCE_DIR build_daemon SOURCE_DIR)
get_target_property(DAEMON_BINARY_DIR build_daemon BINARY_DIR)
configure_file(prepare-daemons.sh.in prepare-daemons.sh
  @ONLY)

add_test(
  NAME prepare_daemons
  COMMAND sh -c "APP_NAME=${APP_NAME} sh prepare-daemons.sh ${DAEMON_BINARY_DIR}/${APP_NAME}/bundle.tar.gz")
set_tests_properties(prepare_daemons
  PROPERTIES FIXTURES_SETUP Daemons)

add_custom_target(prepare_daemons)
