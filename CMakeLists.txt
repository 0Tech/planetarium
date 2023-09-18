cmake_minimum_required(VERSION 3.25.1)

project(planetarium
  LANGUAGES NONE)
enable_testing()

set(APP_NAMES cosmos-sdk gaia)
set(APP_NAME cosmos-sdk CACHE STRING "name of app (${APP_NAMES})")
if(NOT APP_NAME IN_LIST APP_NAMES)
  message(FATAL_ERROR "APP_NAME must be (${APP_NAMES})")
endif()

set(APP_SOURCE_DIR ${CMAKE_SOURCE_DIR}/${APP_NAME})

execute_process(
  COMMAND sh -c "git config --file .gitmodules --get submodule.${APP_NAME}.url | sed 's/\.git$//'"
  OUTPUT_VARIABLE APP_URL
  OUTPUT_STRIP_TRAILING_WHITESPACE)

add_subdirectory(daemon)
add_subdirectory(cosmovisor)
add_custom_target(build ALL
  DEPENDS build_daemon build_cosmovisor)

add_subdirectory(fixture)
add_subdirectory(test)
