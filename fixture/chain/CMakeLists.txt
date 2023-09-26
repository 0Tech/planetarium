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
get_target_property(DAEMON_BINARY_DIR prepare_daemons BINARY_DIR)
set(DAEMON_REQUEST_DIR ${DAEMON_BINARY_DIR}/request)
configure_file(setup-chain.sh.in setup-chain.sh
  @ONLY
)

add_custom_target(chain)

function(add_chain
	chain_id
	app
	version
	num_regions
	num_sentries
	timeout
  )

  request_daemon(${app} ${version})

  # GNU only
  execute_process(
	COMMAND sh -c "printf ${chain_id} | sed -r 's#(^|-)([a-z])#\\U\\2#g'"
	OUTPUT_VARIABLE fixture_name
	OUTPUT_STRIP_TRAILING_WHITESPACE
	COMMAND_ERROR_IS_FATAL ANY
  )

  get_target_property(CHAIN_BINARY_DIR chain BINARY_DIR)
  add_test(
	NAME setup_nodes_${chain_id}
	COMMAND timeout ${timeout} sh -c "CHAIN_ID=${chain_id} NUM_REGIONS=${num_regions} NUM_SENTRIES=${num_sentries} ${CHAIN_BINARY_DIR}/setup-nodes.sh"
  )
  set_tests_properties(setup_nodes_${chain_id}
	PROPERTIES FIXTURES_SETUP ${fixture_name}NodesSetup
  )
  set_tests_properties(setup_nodes_${chain_id}
	PROPERTIES FIXTURES_REQUIRED "ImageSetup;InternetSetup"
  )

  add_test(
	NAME setup_chain_${chain_id}
	COMMAND timeout ${timeout} sh -c "CHAIN_ID=${chain_id} APP=${app} VERSION=${version} NUM_REGIONS=${num_regions} NUM_SENTRIES=${num_sentries} ${CHAIN_BINARY_DIR}/setup-chain.sh"
  )
  set_tests_properties(setup_chain_${chain_id}
	PROPERTIES FIXTURES_SETUP ${fixture_name}
  )
  set_tests_properties(setup_chain_${chain_id}
	PROPERTIES FIXTURES_REQUIRED ${fixture_name}NodesSetup
  )

  get_target_property(CHAIN_SOURCE_DIR chain SOURCE_DIR)
  add_test(
	NAME cleanup_nodes_${chain_id}
	COMMAND sh -c "CHAIN_ID=${chain_id} ${CHAIN_BINARY_DIR}/cleanup-nodes.sh"
  )
  set_tests_properties(cleanup_nodes_${chain_id}
	PROPERTIES FIXTURES_CLEANUP ${fixture_name}
  )
  set_tests_properties(cleanup_nodes_${chain_id}
	PROPERTIES FIXTURES_REQUIRED "ImageCleanup;InternetCleanup"
  )
endfunction()

add_test(
  NAME setup_internet
  COMMAND docker network create --internal internet
)
set_tests_properties(setup_internet
  PROPERTIES FIXTURES_SETUP InternetSetup
)

add_test(
  NAME cleanup_internet
  COMMAND docker network rm internet
)
set_tests_properties(cleanup_internet
  PROPERTIES FIXTURES_CLEANUP InternetCleanup
)
