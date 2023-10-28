add_test(
  NAME install_image
  COMMAND docker build -t ${PROJECT_NAME}/cosmovisor:fixture ${CMAKE_CURRENT_SOURCE_DIR}
)
set_tests_properties(install_image PROPERTIES
  FIXTURES_SETUP Image
)

add_test(
  NAME uninstall_image
  COMMAND docker image rm -f ${PROJECT_NAME}/cosmovisor:fixture
)
set_tests_properties(uninstall_image PROPERTIES
  FIXTURES_CLEANUP Image
)
