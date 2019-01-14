# OpenGLTest 2019
# Developped By Trigolds
# -----------------------------------------------------------------------------
# ----------------------------- Project configuration -------------------------
# -----------------------------------------------------------------------------

LIST(APPEND Test2_list Test2 Test2_layout Test2_uniform)
LIST(APPEND TEST_DIRS Test1 ${Test2_list})
FOREACH(T_DIR ${TEST_DIRS})
	ADD_SUBDIRECTORY(${T_DIR})
ENDFOREACH()
