add_test(
  NAME install_image
  COMMAND docker build -t ${PROJECT_NAME}/cosmovisor:${COSMOVISOR_VERSION} ${CMAKE_CURRENT_SOURCE_DIR}
)
set_tests_properties(install_image
  PROPERTIES FIXTURES_SETUP ImageSetup
)
set_tests_properties(install_image
  PROPERTIES FIXTURES_REQUIRED Apps
)

add_test(
  NAME uninstall_image
  COMMAND docker image rm -f ${PROJECT_NAME}/cosmovisor:${COSMOVISOR_VERSION}
)
set_tests_properties(uninstall_image
  PROPERTIES FIXTURES_CLEANUP ImageCleanup
)

add_custom_target(install_image)
