configure_file(upgrade-chain.sh.in upgrade-chain.sh
  @ONLY)

add_test(
  NAME upgrade_chain_rolling
  COMMAND timeout ${TEST_TIMEOUT} sh -c "PROJECT_NAME=UpgradeRolling sh upgrade-chain.sh")
add_chains(UpgradeRolling 1 ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})
set_tests_properties(upgrade_chain_rolling
  PROPERTIES FIXTURES_REQUIRED UpgradeRolling)
