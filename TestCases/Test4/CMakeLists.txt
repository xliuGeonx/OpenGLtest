# OpenGLTest 2019
# Developped By Trigolds
# -----------------------------------------------------------------------------
# ----------------------------- Project configuration -------------------------
# -----------------------------------------------------------------------------

# Environment
SET(TestName Test4)
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
	$<BUILD_INTERFACE:${GLM_INCLUDE_DIR}>
    $<INSTALL_INTERFACE:include/>  # <prefix>/include
	)
	SET_TARGET_PROPERTIES(${TestName} PROPERTIES COMPILE_DEFINITIONS "${DefinitionFlags}")
	SET_PROPERTY(TARGET ${TestName} PROPERTY CXX_STANDARD 98)
	LIST(APPEND OpenGL_LIB ${GLEW_LIBRARY} ${GLFW_LIBRARY} OpenGL32.lib ${GLM_LIBRARY})
	TARGET_LINK_LIBRARIES(${TestName} LINK_PUBLIC ${OpenGL_LIB})
# -- copy dll collection
	SET(GLSL_REF ${CMAKE_CURRENT_SOURCE_DIR}/glsl)
	LIST(APPEND GLSL_LIST ${GLSL_REF})
	COLLECT_GLSL_FROM_DIRS(GLSL_LIST)
	LIST(APPEND DLLs ${GLEW_DLL} ${USED_DLLS} ${GLSL_FILES})
	FOREACH( f ${DLLs})
    ADD_CUSTOM_COMMAND(TARGET ${TestName} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy ${f} $<TARGET_FILE_DIR:${TestName}> )  
	ENDFOREACH()
ENDIF()

Message(STATUS "Done TestCase ${TestName}:")