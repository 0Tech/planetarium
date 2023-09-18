configure_file(generate-compose.py.in generate-compose.py
  @ONLY)
configure_file(setup-nodes.sh.in setup-nodes.sh
  @ONLY)
configure_file(cleanup-nodes.sh.in cleanup-nodes.sh
  @ONLY)
get_target_property(COSMOVISOR_BINARY_DIR build_cosmovisor BINARY_DIR)
get_target_property(DAEMON_BINARY_DIR prepare_daemons BINARY_DIR)
configure_file(setup-chains.sh.in setup-chains.sh
  @ONLY)

add_custom_target(chain)

function(add_chain
	chain_id
	app_name
	daemon_version
	num_regions
	num_sentries
	timeout
  )

  # GNU only
  execute_process(
	COMMAND sh -c "printf ${chain_id} | sed -r 's#(^|-)([a-z])#\\U\\2#g'"
	OUTPUT_VARIABLE fixture_name
	OUTPUT_STRIP_TRAILING_WHITESPACE)

  get_target_property(CHAIN_BINARY_DIR chain BINARY_DIR)
  add_test(
	NAME setup_nodes_${chain_id}
	COMMAND timeout ${timeout} sh -c "CHAIN_ID=${chain_id} NUM_REGIONS=${num_regions} NUM_SENTRIES=${num_sentries} sh ${CHAIN_BINARY_DIR}/setup-nodes.sh")
  set_tests_properties(setup_nodes_${chain_id}
	PROPERTIES FIXTURES_SETUP ${fixture_name}NodesSetup)
  set_tests_properties(setup_nodes_${chain_id}
	PROPERTIES FIXTURES_REQUIRED ImageSetup)

  add_test(
	NAME setup_chains_${chain_id}
	COMMAND timeout ${timeout} sh -c "CHAIN_ID=${chain_id} APP_NAME=${app_name} DAEMON_VERSION=${daemon_version} NUM_REGIONS=${num_regions} NUM_SENTRIES=${num_sentries} sh ${CHAIN_BINARY_DIR}/setup-chains.sh")
  set_tests_properties(setup_chains_${chain_id}
	PROPERTIES FIXTURES_SETUP ${fixture_name})
  set_tests_properties(setup_chains_${chain_id}
	PROPERTIES FIXTURES_REQUIRED ${fixture_name}NodesSetup)

  get_target_property(CHAIN_SOURCE_DIR chain SOURCE_DIR)
  add_test(
	NAME cleanup_nodes_${chain_id}
	COMMAND sh -c "CHAIN_ID=${chain_id} sh ${CHAIN_BINARY_DIR}/cleanup-nodes.sh")
  set_tests_properties(cleanup_nodes_${chain_id}
	PROPERTIES FIXTURES_CLEANUP ${fixture_name})
  set_tests_properties(cleanup_nodes_${chain_id}
	PROPERTIES FIXTURES_REQUIRED ImageCleanup)
endfunction(add_chain)
