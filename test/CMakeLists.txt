set(TEST_TIMEOUT 5m CACHE STRING "timeout for the tests")

add_subdirectory(upgrade)
add_subdirectory(liveness)
