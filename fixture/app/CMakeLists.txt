get_target_property(APP_SOURCE_DIR build_app SOURCE_DIR)
get_target_property(APP_BINARY_DIR build_app BINARY_DIR)
configure_file(prepare-apps.sh.in prepare-apps.sh
  @ONLY
)

add_custom_target(prepare_apps)

function(request_app
	app
	version
  )

  get_target_property(APP_PREPARATION_DIR prepare_apps BINARY_DIR)
  execute_process(
	COMMAND sh -c "APP=${app} VERSION=${version} ${APP_PREPARATION_DIR}/prepare-apps.sh"
	COMMAND_ERROR_IS_FATAL ANY
  )
endfunction()

add_test(
  NAME prepare_apps
  COMMAND prepare-apps.sh
)
set_tests_properties(prepare_apps
  PROPERTIES FIXTURES_SETUP Apps
)
