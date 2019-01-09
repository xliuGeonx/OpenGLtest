# GVDBX 2018
# Developped By Trigolds
# GVDB library TeatCase 3DPrint CMakeLists
# -----------------------------------------------------------------------------
# ----------------------------- Project configuration -------------------------
# -----------------------------------------------------------------------------

# Environment
SET(3DPrint_EXE GVDB_3DPrint)
SET(3DPrint_EXE ${3DPrint_EXE} PARENT_SCOPE)
Message(STATUS "-------------------------------")
Message(STATUS "Processing TestCase ${3DPrint_EXE}:")
####################################################################################
# Bootstrap
#
find_path ( HELPERS "Helpers.cmake" HINTS 
    ${CMAKE_MODULE_PATH}
    ${CONTRIB_ROOT_DIR}/sample_utils
)

# SET(PTX_FILES_DIR ${CONTRIB_ROOT_DIR}/sample_utils CACHE PATH "ptx files for 3Dprint")

if ( ${HELPERS} STREQUAL "HELPERS-NOTFOUND" )
    set ( CMAKE_MODULE_PATH "***FULL PATH TO***/gvdb/cmake/Modules" CACHE PATH "Full path to gvdb/cmake/Modules" )
    message ( FATAL_ERROR "\n
    Please set the CMAKE_MODULE_PATH 
    to the full path of for ./gvdb/cmake/Modules above
    and configure again." )
endif()
include( ${CMAKE_MODULE_PATH}/Helpers.cmake )     
include( ${CMAKE_MODULE_PATH}/Packages.cmake )     

# SET( SAMPLE_UTILS_DIR ${CONTRIB_ROOT_DIR}/sample_utils )

#####################################################################################
# Sample requirements

set ( REQUIRE_OPENGL "1" )
set ( REQUIRE_PNG "1" )
set ( REQUIRE_TGA "1" )
set ( REQUIRE_GLEW "1" )
set ( REQUIRE_MAIN "1" )
set ( REQUIRE_NVGUI "1" )

####################################################################################
# Add Utils
#
_add_package_Utils()

#####################################################################################
# Add GVDB
#
# _add_package_GVDB()
add_definitions(-DUSE_GVDB)
add_definitions(-DSIM_CODE)
include_directories(${GVDB_INCLUDE_DIR})
####################################################################################
# Add CUDA
#
_add_package_CUDA()

# ####################################################################################
# # Compile PTX Files
# #
# file(GLOB CUDA_FILES RELATIVE "${PTX_FILES_DIR}" *.cu *.cuh)
# message ( STATUS "Build CUDA kernels: ${CUDA_FILES}" )
# _COMPILEPTX ( SOURCES ${CUDA_FILES} TARGET_PATH ${CMAKE_CURRENT_BINARY_DIR} GENERATED PTX_FILES INCLUDE "${CMAKE_CURRENT_SOURCE_DIR},${GVDB_INCLUDE_DIR}" OPTIONS -arch=compute_30 -code=sm_30 --ptxas-options=-v -O3 --use_fast_math --maxrregcount=128 )

#####################################################################################
# Asset Path
#
if ( NOT DEFINED ASSET_PATH ) 
  get_filename_component ( _assets "${PROJECT_DIRECTORY}/source/shared_assets" REALPATH )
  set ( ASSET_PATH ${_assets} CACHE PATH "Full path to gvdb/shared_assets/" )  
endif()

####################################################################################
# Executable
#
file(GLOB SOURCE_FILES *.cpp *.hpp *.inl *.h *.c)
_LIST_ALL_SOURCE ( FILES ${SOURCE_FILES} ${PACKAGE_SOURCE_FILES} ${UTIL_SOURCE_FILES} ${CUDA_FILES} ${PTX_SOURCES} )
include_directories ("${CMAKE_CURRENT_SOURCE_DIR}")    
add_definitions(-DGVDB_IMPORTS -DGLEW_STATIC -DGLEW_NO_GLU)  
add_definitions(-DASSET_PATH="${ASSET_PATH}/")
add_executable (${3DPrint_EXE} ${ALL_SOURCE_FILES} )
set_property ( TARGET ${3DPrint_EXE} APPEND PROPERTY DEPENDS ${PTX_SOURCES} )
set_target_properties( ${3DPrint_EXE}
  PROPERTIES
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
  LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)
#####################################################################################
# Additional Libraries
#
LIST(INSERT GVDBXLinkedLibraries 0 ${LIBRARIES_OPTIMIZED} ${LIBRARIES_DEBUG} ${PLATFORM_LIBRARIES} ${GVDB_LIB})
LIST(REMOVE_DUPLICATES GVDBXLinkedLibraries)
_LINK ( TARGET ${3DPrint_EXE} OPT ${GVDBXLinkedLibraries})
MESSAGE(STATUS "GVDBXLinkedLibraries: ${GVDBXLinkedLibraries}" )

# -- copy dll collection
#
# COLLECT_DDL_FROM_FILES(GVDB_LIB_BIN_DIR)
# MESSAGE(WARNING "GVDB_LIB_BIN_DIR: ${GVDB_LIB_BIN_DIR}" )
# MESSAGE(STATUS "Libraries that will be copied: ${GVDB_DLLS}")
# FOREACH( f ${GVDB_DLLS})
  # ADD_CUSTOM_COMMAND(TARGET ${3DPrint_EXE} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy ${f} $<TARGET_FILE_DIR:${3DPrint_EXE}> )  
# ENDFOREACH() 

# -- copy example file
#
LIST(APPEND example_files ${CMAKE_CURRENT_SOURCE_DIR}/data/lucy.obj ${CMAKE_CURRENT_SOURCE_DIR}/data/arial.tga ${CMAKE_CURRENT_SOURCE_DIR}/data/arial.bin)
# SET(example_file ${CMAKE_CURRENT_SOURCE_DIR}/data/lucy.obj)
FOREACH( f ${example_files})
  ADD_CUSTOM_COMMAND(TARGET ${3DPrint_EXE} POST_BUILD COMMAND ${CMAKE_COMMAND} -E copy ${f} $<TARGET_FILE_DIR:${3DPrint_EXE}> )  
ENDFOREACH() 