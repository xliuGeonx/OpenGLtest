# GVDBX 2018
# Developped By Trigolds
# GVDB library CMakeLists
# -----------------------------------------------------------------------------
# ----------------------------- Project configuration -------------------------
# -----------------------------------------------------------------------------

# # -- library Name name
# SET(GVDB_LIB "${PROJECT_NAME}.GVDB_LIB")
# SET(GVDB_LIB ${GVDB_LIB} PARENT_SCOPE)
# Message(STATUS "-------------------------------")
# Message(STATUS "Processing Library ${GVDB_LIB}:")

# LIST(APPEND gvdb GVDB)
# FOREACH(I_DIR ${InputOutputComponnents})
  # ADD_SUBDIRECTORY(${I_DIR})  
  # SET(${I_DIR} ${${I_DIR}} PARENT_SCOPE)
  # SET(${I_DIR}_LIB_INCLUDE_DIR ${${I_DIR}_LIB_INCLUDE_DIR} PARENT_SCOPE)
# ENDFOREACH()

ADD_SUBDIRECTORY(GVDB)
ADD_SUBDIRECTORY(TestCases)