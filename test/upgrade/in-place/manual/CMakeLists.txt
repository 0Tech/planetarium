set(TEST_DOWNLOAD_BINARIES false)

configure_file(../upgrade-chain.sh.in upgrade-chain.sh
  @ONLY)

add_test(
  NAME upgrade_chain_manual
  COMMAND timeout ${TEST_TIMEOUT} sh -c "PROJECT_NAME=UpgradeManual sh upgrade-chain.sh")
add_chains(UpgradeManual 1 ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} ${TEST_TIMEOUT})
set_tests_properties(upgrade_chain_manual
  PROPERTIES FIXTURES_REQUIRED UpgradeManual)
