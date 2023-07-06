cmake_minimum_required(VERSION 3.25.1)

project(planetarium
  LANGUAGES NONE)
enable_testing()

set(APP_NAME cosmos-sdk CACHE STRING "name of app (cosmos-sdk|gaia)")
if(APP_NAME STREQUAL cosmos-sdk)
  set(DAEMON_NAME simd)
  set(DAEMON_HOME /home/${DAEMON_NAME}/.simapp)
elseif(APP_NAME STREQUAL gaia)
  set(DAEMON_NAME gaiad)
  set(DAEMON_HOME /home/${DAEMON_NAME}/.gaia)
else()
  message(FATAL_ERROR "APP_NAME must be (cosmos-sdk|gaia)")
endif()

set(APP_SOURCE_DIR ${CMAKE_SOURCE_DIR}/${APP_NAME})
set(FIXTURE_SYNCDIR /home/${DAEMON_NAME}/sync)

execute_process(
  COMMAND sh -c "git config --file .gitmodules --get submodule.${APP_NAME}.url | sed 's/\.git$//'"
  OUTPUT_VARIABLE APP_URL
  OUTPUT_STRIP_TRAILING_WHITESPACE)

add_subdirectory(daemon)
add_subdirectory(cosmovisor)
add_custom_target(build ALL
  DEPENDS build_daemon build_cosmovisor)

add_subdirectory(fixture)
