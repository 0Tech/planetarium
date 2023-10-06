configure_file(generate-compose.py.in generate-compose.py
  @ONLY
)
configure_file(setup-nodes.sh.in setup-nodes.sh
  @ONLY
)
configure_file(cleanup-nodes.sh.in cleanup-nodes.sh
  @ONLY
)
get_target_property(COSMOVISOR_BINARY_DIR build_cosmovisor BINARY_DIR)
get_target_property(APP_PREPARATION_DIR prepare_apps BINARY_DIR)
set(APP_REQUEST_DIR ${APP_PREPARATION_DIR}/request)
configure_file(setup-chain.sh.in setup-chain.sh
  @ONLY
)

add_custom_target(chain)

function(add_chain
	fixture_name
	chain_id
	app
	version
	num_regions
	num_sentries
	timeout
  )

  execute_process(
	COMMAND sh -c "printf ${fixture_name} | sed -E 's#([[:upper:]])#_\\1#g' | tr [:upper:] [:lower:] | sed -E 's/^_//'"
	OUTPUT_VARIABLE test_suffix
	OUTPUT_STRIP_TRAILING_WHITESPACE
	COMMAND_ERROR_IS_FATAL ANY
  )

  require_app(${app} ${version})

  get_target_property(CHAIN_BINARY_DIR chain BINARY_DIR)
  add_test(
	NAME ansible_on_${test_suffix}
	COMMAND timeout ${timeout} sh -c "CHAIN_ID=${chain_id} NUM_REGIONS=${num_regions} NUM_SENTRIES=${num_sentries} ${CHAIN_BINARY_DIR}/setup-nodes.sh"
  )
  set_tests_properties(ansible_on_${test_suffix} PROPERTIES
	FIXTURES_SETUP ${fixture_name}
	FIXTURES_REQUIRED "Image;Internet"
  )

  add_test(
	NAME app_on_${test_suffix}
	COMMAND timeout ${timeout} sh -c "CHAIN_ID=${chain_id} APP=${app} VERSION=${version} NUM_REGIONS=${num_regions} NUM_SENTRIES=${num_sentries} ${CHAIN_BINARY_DIR}/setup-chain.sh"
  )
  set_tests_properties(app_on_${test_suffix} PROPERTIES
	FIXTURES_SETUP ${fixture_name}
	FIXTURES_REQUIRED Apps
	DEPENDS ansible_on_${test_suffix}
  )

  add_test(
	NAME cleanup_on_${test_suffix}
	COMMAND sh -c "CHAIN_ID=${chain_id} TIMEOUT=30 ${CHAIN_BINARY_DIR}/cleanup-nodes.sh"
  )
  set_tests_properties(cleanup_on_${test_suffix} PROPERTIES
	LABELS cleanup
	FIXTURES_CLEANUP ${fixture_name}
	FIXTURES_REQUIRED "Image;Internet"
  )
endfunction()
