configure_file(build.sh.in build.sh
  @ONLY
)
configure_file(generate-source-fingerprint.sh.in generate-source-fingerprint.sh
  @ONLY
)
configure_file(up-to-date.sh.in up-to-date.sh
  @ONLY
)

add_custom_target(generate_daemon_source_fingerprint
  BYPRODUCTS source.sum
  DEPENDS generate-source-fingerprint.sh
  COMMAND sh -c "SUM=source.sum ./generate-source-fingerprint.sh"
  VERBATIM
)
add_custom_command(
  DEPENDS up-to-date.sh generate_daemon_source_fingerprint
  OUTPUT source.touch
  BYPRODUCTS source.sum~
  COMMAND sh -c "SUM=source.sum TOUCH=source.touch ./up-to-date.sh"
  COMMENT "Checking daemon source update ..."
  VERBATIM
)
add_custom_command(
  OUTPUT ${APP}/local/bundle.tar.gz
  DEPENDS build.sh Dockerfile source.touch
  COMMAND sh -c "APP=${APP} SOURCE_DIR=${APP_SOURCE_DIR}/${APP} DEST_DIR=${APP}/local DOCKERFILE=${CMAKE_CURRENT_SOURCE_DIR}/Dockerfile ./build.sh"
  COMMENT "Building daemon ..."
  VERBATIM
)
add_custom_target(build_daemon
  DEPENDS ${APP}/local/bundle.tar.gz
)
