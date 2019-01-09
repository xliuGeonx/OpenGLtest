# GVDBX 2018
# Developped By Trigolds
# GVDB library TestCases CMakeLists
# -----------------------------------------------------------------------------
# ----------------------------- Project configuration -------------------------
# -----------------------------------------------------------------------------

SET(${GVDB_LIB}_TEST TRUE CACHE BOOL "Generate testcases for ${GVDB_LIB} library - default: ON")

IF(${GVDB_LIB}_TEST)
  LIST(APPEND TEST_DIRS 3DPrint)
  FOREACH(T_DIR ${TEST_DIRS})
    ADD_SUBDIRECTORY(${T_DIR})
  ENDFOREACH()
ENDIF()
