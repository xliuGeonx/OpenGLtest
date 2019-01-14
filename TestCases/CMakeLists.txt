# OpenGLTest 2019
# Developped By Trigolds
# -----------------------------------------------------------------------------
# ----------------------------- Project configuration -------------------------
# -----------------------------------------------------------------------------

LIST(APPEND TEST_DIRS Test1 Test2 Test2_layout)
FOREACH(T_DIR ${TEST_DIRS})
	ADD_SUBDIRECTORY(${T_DIR})
ENDFOREACH()
