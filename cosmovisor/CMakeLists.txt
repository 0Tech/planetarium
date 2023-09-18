set(COSMOVISOR_VERSION 1.4.0 CACHE STRING "cosmovisor version")

configure_file(build.sh.in build.sh
  @ONLY)

add_custom_command(
  OUTPUT cosmovisor
  DEPENDS build.sh Dockerfile
  COMMAND ./build.sh ${CMAKE_CURRENT_SOURCE_DIR}/Dockerfile
  COMMENT "Building cosmovisor"
  VERBATIM)
add_custom_target(build_cosmovisor
  DEPENDS cosmovisor)
