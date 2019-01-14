#

#	Try to find GLFW library and include path.
#	Once done this will define
#
#	GLFW_FOUND
#	GLFW_INCLUDE_DIR
#	GLFW_LIBRARY


INCLUDE(FindPackageHandleStandardArgs)
IF ( NOT DEFINED GLFW_DIR )
	SET(GLFW_DIR ${CONTRIB_ROOT}/GLFW)
ENDIF()
SET(GLFW_LOCATION ${GLFW_DIR})

IF (WIN32)
    find_path( GLFW_INCLUDE_DIR
        NAMES
            GLFW/glfw3.h
        PATHS
            ${GLFW_LOCATION}/include
            ${GLFW_LOCATION}/include
            $ENV{GLFW_LOCATION}/include
            $ENV{PROGRAMFILES}/GLEW/include
            ${GLFW_LOCATION}
            $ENV{GLFW_LOCATION}
            DOC "The directory where GLFW/glfw3.h resides" )
    find_library( GLFW_LIBRARY
          NAMES
              glfw3
          PATHS
              ${GLFW_LOCATION}/lib
              ${GLFW_LOCATION}/lib/Release
              DOC "The GLFW library")
ENDIF ()

if (GLFW_INCLUDE_DIR AND EXISTS "${GLFW_INCLUDE_DIR}/GLFW/glfw3.h")
	SET(GLFW_FOUND TRUE)
endif ()

mark_as_advanced( GLFW_FOUND )
