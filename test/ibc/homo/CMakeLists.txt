configure_file(transfer.sh.in transfer.sh
  @ONLY
)

add_chain(ChainIbcA ibc-a-0 ${APP} ${TEST_APP_VERSION} ${TEST_NUM_REGIONS} ${TEST_NUM_SENTRIES} ${TEST_TIMEOUT})
add_chain(ChainIbcB ibc-b-0 ${APP} ${TEST_APP_VERSION} ${TEST_NUM_REGIONS} ${TEST_NUM_SENTRIES} ${TEST_TIMEOUT})
add_relayer(RelayerIbcAIbcB ibc-a-0 ibc-b-0 ${APP} ${TEST_TIMEOUT})
set_tests_properties(relayer_on_relayer_ibc_a_ibc_b PROPERTIES
  DEPENDS "app_on_chain_ibc_a;app_on_chain_ibc_b")

add_test(
  NAME ibc_transfer
  COMMAND timeout ${TEST_TIMEOUT} sh -c "A_CHAIN_ID=ibc-a-0 B_CHAIN_ID=ibc-b-0 APP=${APP} ./transfer.sh"
)
set_tests_properties(ibc_transfer PROPERTIES
  LABELS ibc
  FIXTURES_REQUIRED "ChainIbcA;ChainIbcB;RelayerIbcAIbcB"
)
