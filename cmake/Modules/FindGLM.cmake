#

#	Try to find GLFW library and include path.
#	Once done this will define
#
#	GLM_FOUND
#	GLM_INCLUDE_DIR
#	GLM_LIBRARY


INCLUDE(FindPackageHandleStandardArgs)
IF ( NOT DEFINED GLM_DIR )
	SET(GLM_DIR ${CONTRIB_ROOT}/glm)
ENDIF()
SET(GLM_LOCATION ${GLM_DIR})

IF (WIN32)
    find_path( GLM_INCLUDE_DIR
        NAMES
            glm/glm.hpp
        PATHS
            ${GLM_LOCATION}/include
            DOC "The directory where glm/glfw3.h resides" )
    find_library( GLM_LIBRARY
          NAMES
              glm_static
          PATHS
              ${GLM_LOCATION}/lib
              ${GLM_LOCATION}/lib/Release
              DOC "The glm library")
ENDIF ()

if (GLM_INCLUDE_DIR AND EXISTS "${GLM_INCLUDE_DIR}/glm/glm.h")
	SET(GLM_FOUND TRUE)
endif ()

mark_as_advanced( GLM_FOUND )
