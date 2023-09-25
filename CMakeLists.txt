cmake_minimum_required(VERSION 3.25.1)

set(CMAKE_COLOR_DIAGNOSTICS OFF CACHE BOOL "Enable/Disable color output during build.")

project(planetarium
  LANGUAGES NONE)
enable_testing()

set(APPS
  cosmos/cosmos-sdk
  cosmos/gaia)
set(APP cosmos/cosmos-sdk CACHE STRING "name of app (${APPS})")
if(NOT APP IN_LIST APPS)
  message(FATAL_ERROR "APP must be (${APPS})")
endif()

set(APP_SOURCE_DIR ${CMAKE_SOURCE_DIR}/app)

add_subdirectory(daemon)
add_subdirectory(cosmovisor)
add_custom_target(build ALL
  DEPENDS build_daemon build_cosmovisor)

add_subdirectory(fixture)
add_subdirectory(test)
