add_test(
  NAME setup_internet
  COMMAND docker network create --internal internet
)
set_tests_properties(setup_internet PROPERTIES
  FIXTURES_SETUP Internet
)

add_test(
  NAME cleanup_internet
  COMMAND docker network rm internet
)
set_tests_properties(cleanup_internet PROPERTIES
  FIXTURES_CLEANUP Internet
)
