if(FIXTURE_NEW_APP_VERSION STREQUAL default)
  set(INPLACE_NEW_APP_VERSION dummy)
else()
  set(INPLACE_NEW_APP_VERSION ${FIXTURE_NEW_APP_VERSION})
endif()

# add_subdirectory(auto)
add_subdirectory(manual)

unset(INPLACE_NEW_APP_VERSION)
