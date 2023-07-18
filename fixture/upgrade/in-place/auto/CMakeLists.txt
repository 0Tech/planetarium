set(DAEMON_ALLOW_DOWNLOAD_BINARIES true)

configure_file(../upgrade-chain.sh.in upgrade-chain.sh
  @ONLY)

add_test(
  NAME upgrade_chain_auto
  COMMAND timeout 10m sh -c "PROJECT_NAME=UpgradeAuto sh upgrade-chain.sh 0")
add_chains(UpgradeAuto 1 ${FIXTURE_NUM_REGIONS} ${FIXTURE_NUM_SENTRIES} 10m)
set_tests_properties(upgrade_chain_auto
  PROPERTIES FIXTURES_REQUIRED UpgradeAuto)
