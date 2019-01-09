# GVDBX 2018
# Developped By Trigolds
# Project CMakeLists
# -----------------------------------------------------------------------------
# ----------------------------- Project configuration -------------------------
# -----------------------------------------------------------------------------

CMAKE_MINIMUM_REQUIRED(VERSION 3.1)
# CMAKE_POLICY(SET CMP0054 NEW)
# -----------------------------------------------------------------------------
# ------------------------- Functions and macro -------------------------------
# -----------------------------------------------------------------------------
MACRO(opt OPTION HELP VALUE)
 OPTION(BARRACUDA_USE_${OPTION} ${HELP} ${VALUE})
 SET(OPT_TEXI "${OPT_TEXI}\n@item BARRACUDA_USE_${OPTION}\n${HELP} (default: ${VALUE})")
ENDMACRO(opt)
MACRO(optpp OPTION HELP VALUE)
 OPTION(POSTPRO_USE_${OPTION} ${HELP} ${VALUE})
 SET(OPT_TEXIP "${OPT_TEXIP}\n@item POSTPRO_USE_${OPTION}\n${HELP} (default: ${VALUE})")
ENDMACRO(optpp)

FUNCTION(COLLECT_SRC_FROM_DIRS DIRS)
  FOREACH(folder ${${DIRS}})
    FILE(
      GLOB
      source_files_one_dir
      ${folder}/[^.]*.h      
      ${folder}/[^.]*.hxx          
      ${folder}/[^.]*.ipp  
      ${folder}/[^.]*.hpp  
      ${folder}/[^.]*.hh
      ${folder}/[^.]*.cc      
      ${folder}/[^.]*.c
      ${folder}/[^.]*.cxx
      ${folder}/[^.]*.cpp
      ${folder}/[^.]*.occa
    )
    LIST(APPEND SOURCE_FILES_LIST ${source_files_one_dir})
  ENDFOREACH()
  SET(SOURCE_FILES ${SOURCE_FILES_LIST} PARENT_SCOPE)
ENDFUNCTION()# 
# -----------------------------------------------------------------------------
FUNCTION(COLLECT_DDL_FROM_FILES  files_list) 
  FOREACH(f ${${files_list}})
    GET_FILENAME_COMPONENT(f_ext ${f} EXT )
    IF(f_ext)
      IF(${f_ext} STREQUAL ".so" )
        IF(NOT WIN32)
          GET_FILENAME_COMPONENT(f_without_ext ${f} NAME_WE )
          GET_FILENAME_COMPONENT(f_dir ${f} DIRECTORY)
          SET(f_pattern  "${f_without_ext}.so*" )
          FILE(GLOB  all_f ${f_dir}/${f_pattern})
          LIST(APPEND dlls_list ${all_f})
        ENDIF()
	  ELSEIF(${f_ext} STREQUAL ".ptx")
        IF(WIN32)
          LIST(APPEND dlls_list ${f})
        ENDIF()
	  ELSEIF(${f_ext} STREQUAL ".glsl")
        IF(WIN32)
          LIST(APPEND dlls_list ${f})
        ENDIF()
      ELSEIF(${f_ext} STREQUAL ".dll")
        IF(WIN32)
          LIST(APPEND dlls_list ${f})
        ENDIF()
      ELSEIF(${f_ext} STREQUAL ".lib")
        IF(WIN32)        
          GET_FILENAME_COMPONENT(f_dir ${f} DIRECTORY )
          GET_FILENAME_COMPONENT(f_without_ext ${f} NAME_WE )
          SET(f_dd "${f_dir}/${f_without_ext}.dll")
          IF(EXISTS "${f_dd}")          
            LIST(APPEND dlls_list ${f_dd})
          ELSE()
            SET(f_dd "${f_dir}/../bin/${f_without_ext}.dll")
            IF(EXISTS "${f_dd}")          
              LIST(APPEND dlls_list ${f_dd})
            ELSE()
              STRING(REPLACE "lib" "" f_without_lib ${f_without_ext})
              SET(f_dd "${f_dir}/${f_without_lib}.dll")
              IF(EXISTS "${f_dd}")            
                LIST(APPEND dlls_list ${f_dd})
              ENDIF()
            ENDIF()       
          ENDIF()
        ENDIF()
      ENDIF()
    ENDIF()
  ENDFOREACH()
  SET(USED_DLLS ${USED_DLLS} ${dlls_list} PARENT_SCOPE)
ENDFUNCTION()


if(NOT PROJECT_DIRECTORY)
  SET(PROJECT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endif()
# MESSAGE(WARNING "PROJECT_DIRECTORY: ${PROJECT_DIRECTORY}" )
# Additional folders to search for CMake modules
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_DIRECTORY}/cmake/Modules")
# Define project with default languages (C and CXX)
PROJECT(GVDBX)
# -----------------------------------------------------------------------------
# ----------------------------- Project configuration -------------------------
# -----------------------------------------------------------------------------

# find Boost
SET(Boost_NO_SYSTEM_PATHS true)
SET (Boost_USE_STATIC_LIBS ON CACHE BOOL "use static libraries from Boost")
SET(Boost_USE_MULTITHREAD ON) #SET a flag
SET(BOOST_LIB_LIST)
IF(NOT WIN32)
  #  LIST(APPEND BOOST_LIB_LIST program_options log log_setup thread regex mpi serialization iostreams filesystem system)
   LIST(APPEND BOOST_LIB_LIST program_options log log_setup thread regex serialization iostreams filesystem system locale)
  FIND_PACKAGE(ICU REQUIRED COMPONENTS i18n uc)
  INCLUDE_DIRECTORIES(${ICU_INCLUDE_DIRS})
  LINK_DIRECTORIES(${ICU_LIBRARY_DIRS})
  COLLECT_DDL_FROM_FILES(ICU_LIBRARIES)
  FIND_PACKAGE(ZLIB REQUIRED)
  INCLUDE_DIRECTORIES(${ZLIB_INCLUDE_DIRS})
  LINK_DIRECTORIES(${ZLIB_LIBRARY_DIRS})
  COLLECT_DDL_FROM_FILES(ZLIB_LIBRARIES)
ELSE()
  #  LIST(APPEND BOOST_LIB_LIST regex mpi serialization iostreams system filesystem )
  LIST(APPEND BOOST_LIB_LIST regex serialization iostreams system filesystem )
ENDIF()
FIND_PACKAGE(Boost REQUIRED COMPONENTS ${BOOST_LIB_LIST})
INCLUDE_DIRECTORIES(SYSTEM ${Boost_INCLUDE_DIRS})
LINK_DIRECTORIES(${Boost_LIBRARY_DIRS})
SET(BOOST_DLLS)
IF(NOT Boost_USE_STATIC_LIBS )
  IF(WIN32)    
    ADD_DEFINITIONS(-DBOOST_ALL_NO_LIB)
    ADD_DEFINITIONS(-DBOOST_ALL_DYN_LINK)
  ENDIF()
  FOREACH(l ${BOOST_LIB_LIST})
    STRING(TOUPPER ${l} v)
    LIST(APPEND BOOST_DLLS ${Boost_${v}_LIBRARY_RELEASE})
  ENDFOREACH()
  MESSAGE( " BOOST_DLLS :-> ${BOOST_DLLS}")
  COLLECT_DDL_FROM_FILES(BOOST_DLLS)
ENDIF()

# -- Include contributes --
if ( NOT DEFINED CONTRIB_ROOT_DIR )
  MESSAGE(FATAL_ERROR "CONTRIB_ROOT_DIR is not defined" )
endif()

# -- Include directories --
ADD_SUBDIRECTORY(gvdb)
