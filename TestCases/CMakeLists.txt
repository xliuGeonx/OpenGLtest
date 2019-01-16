# OpenGLTest 2019
# Developped By Trigolds
# -----------------------------------------------------------------------------
# ----------------------------- Project configuration -------------------------
# -----------------------------------------------------------------------------

LIST(APPEND Test2_list Test2 Test2_layout Test2_uniform)
LIST(APPEND Test3_list Test3)
LIST(APPEND Test4_list Test4)
LIST(APPEND Test5_list Test5)
LIST(APPEND Test6_list Test6)
LIST(APPEND Test7_list Test7)
LIST(APPEND Test8_list Test8)
LIST(APPEND Test9_list Test9)
LIST(APPEND TEST_DIRS Test1 ${Test2_list} ${Test3_list} ${Test4_list} ${Test5_list} ${Test6_list} ${Test7_list} ${Test8_list} ${Test9_list})
FOREACH(T_DIR ${TEST_DIRS})
	ADD_SUBDIRECTORY(${T_DIR})
ENDFOREACH()
