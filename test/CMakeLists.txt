set(TEST_TIMEOUT 10m CACHE STRING "timeout for the tests")

add_subdirectory(upgrade)
add_subdirectory(liveness)
