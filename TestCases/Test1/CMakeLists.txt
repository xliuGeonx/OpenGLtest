# OpenGLTest 2019
# Developped By Trigolds
# -----------------------------------------------------------------------------
# ----------------------------- Project configuration -------------------------
# -----------------------------------------------------------------------------

# Environment
SET(TestName Test1)
SET(TestName ${TestName} PARENT_SCOPE)
Message(STATUS "-------------------------------")
Message(STATUS "Processing TestCase ${TestName}:")

LIST(APPEND ${TestName}_SRC_DIR  ${CMAKE_CURRENT_SOURCE_DIR})
SET(${TestName}_SRC_DIR ${${TestName}_SRC_DIR})
SET(${TestName}_SRC_DIR ${${TestName}_SRC_DIR} PARENT_SCOPE)

IF(TARGET ${TestName})
	MESSAGE(WARNING "${TestName} is already defined.")
ELSE()
	collect_src_from_dirs(${TestName}_SRC_DIR)
	ADD_EXECUTABLE(${TestName} ${SOURCE_FILES})
	TARGET_INCLUDE_DIRECTORIES(${TestName} PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${GLEW_INCLUDE_DIR}>
	$<BUILD_INTERFACE:${GLFW_INCLUDE_DIR}>
    $<INSTALL_INTERFACE:include/>  # <prefix>/include
	)
	SET_TARGET_PROPERTIES(${TestName} PROPERTIES COMPILE_DEFINITIONS "${DefinitionFlags}")
	SET_PROPERTY(TARGET ${TestName} PROPERTY CXX_STANDARD 98)
	LIST(APPEND OpenGL_LIB ${GLEW_LIBRARY} ${GLFW_LIBRARY} OpenGL32.lib)
	TARGET_LINK_LIBRARIES(${TestName} LINK_PUBLIC ${OpenGL_LIB})
# -- copy dll collection
	LIST(APPEND DLLs ${GLEW_DLL} ${USED_DLLS})
	FOREACH( f ${DLLs})
    ADD_CUSTOM_COMMAND(TARGET ${TestName} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy ${f} $<TARGET_FILE_DIR:${TestName}> )  
	ENDFOREACH()
ENDIF()