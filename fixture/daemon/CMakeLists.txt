get_target_property(DAEMON_SOURCE_DIR build_daemon SOURCE_DIR)
get_target_property(DAEMON_BINARY_DIR build_daemon BINARY_DIR)
configure_file(prepare-daemons.sh.in prepare-daemons.sh
  @ONLY)

add_custom_target(prepare_daemons)

function(request_daemon
	app
	version
  )

  get_target_property(DAEMON_PREPARE_DIR prepare_daemons BINARY_DIR)
  execute_process(
	COMMAND sh -c "APP=${app} VERSION=${version} ${DAEMON_PREPARE_DIR}/prepare-daemons.sh"
	COMMAND_ERROR_IS_FATAL ANY)
endfunction(request_daemon)

add_test(
  NAME prepare_daemons
  COMMAND prepare-daemons.sh)
set_tests_properties(prepare_daemons
  PROPERTIES FIXTURES_SETUP Daemons)
