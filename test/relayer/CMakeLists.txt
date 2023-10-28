set(HERMES_VERSION 1.6.0 CACHE STRING "version of hermes")
set(TEST_HERMES_TRUSTING_PERIOD 40s CACHE STRING "trusting period, must be <TEST_STATE_UNBONDING_TIME")

configure_file(config.toml config.toml
  COPYONLY)
configure_file(setup-relayer.sh.in setup-relayer.sh
  @ONLY)
configure_file(cleanup-nodes.sh.in cleanup-nodes.sh
  @ONLY)

add_custom_target(relayer)

function(add_relayer
	fixture_name
	a_chain_id
	b_chain_id
	app
	timeout
  )

  execute_process(
	COMMAND sh -c "printf ${fixture_name} | sed -E 's#([[:upper:]])#_\\1#g' | tr [:upper:] [:lower:] | sed -E 's/^_//'"
	OUTPUT_VARIABLE test_suffix
	OUTPUT_STRIP_TRAILING_WHITESPACE
	COMMAND_ERROR_IS_FATAL ANY
  )

  get_target_property(RELAYER_BINARY_DIR relayer BINARY_DIR)
  add_test(
	NAME relayer_on_${test_suffix}
	COMMAND timeout ${timeout} sh -c "A_CHAIN_ID=${a_chain_id} B_CHAIN_ID=${b_chain_id} APP=${app} ${RELAYER_BINARY_DIR}/setup-relayer.sh"
  )
  set_tests_properties(relayer_on_${test_suffix} PROPERTIES
	FIXTURES_SETUP ${fixture_name}
	FIXTURES_REQUIRED "RelayerImage;Internet"
  )

  add_test(
	NAME cleanup_on_${test_suffix}
	COMMAND sh -c "A_CHAIN_ID=${a_chain_id} B_CHAIN_ID=${b_chain_id} TIMEOUT=30 ${RELAYER_BINARY_DIR}/cleanup-nodes.sh"
  )
  set_tests_properties(cleanup_on_${test_suffix} PROPERTIES
	LABELS cleanup
	FIXTURES_CLEANUP ${fixture_name}
	FIXTURES_REQUIRED "RelayerImage;Internet"
  )
endfunction()

add_test(
  NAME install_relayer_image
  COMMAND sh -c "curl -L https://github.com/informalsystems/hermes/releases/download/v${HERMES_VERSION}/hermes-v${HERMES_VERSION}-x86_64-unknown-linux-gnu.tar.gz | tar -xz && docker build -t ${PROJECT_NAME}/relayer:fixture -f ${CMAKE_CURRENT_SOURCE_DIR}/Dockerfile ."
)
set_tests_properties(install_relayer_image PROPERTIES
  FIXTURES_SETUP RelayerImage
)

add_test(
  NAME uninstall_relayer_image
  COMMAND docker image rm -f ${PROJECT_NAME}/relayer:fixture
)
set_tests_properties(uninstall_relayer_image PROPERTIES
  FIXTURES_CLEANUP RelayerImage
)
