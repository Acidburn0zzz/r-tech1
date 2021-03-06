# - Find openlayer
# Find the native OPENLAYER includes and library
#
#  OPENLAYER_INCLUDE_DIR  - where to find OpenLayer.h, etc.
#  OPENLAYER_INCLUDE_DIRS - where to find OpenLayer.h and the rest of its dependency includes
#  OPENLAYER_LIBRARIES    - List of libraries when using OpenLayer.
#  OPENLAYER_FOUND        - True if OpenLayer found.

FIND_PACKAGE(ALLEGRO)
FIND_PACKAGE(ALLEGROGL)
FIND_PACKAGE(OpenGL)
FIND_PACKAGE(PNG)
FIND_PACKAGE(FREETYPE)
FIND_PACKAGE(ZLIB)

IF (OPENLAYER_INCLUDE_DIR)
  # Already in cache, be silent
  SET(OPENLAYER_FIND_QUIETLY TRUE)
ENDIF (OPENLAYER_INCLUDE_DIR)

FIND_PATH(OPENLAYER_INCLUDE_DIR OpenLayer.hpp
  /usr/local/include
  /usr/include
  $ENV{MINGDIR}/include
)

SET(OPENLAYER_NAMES openlayer openlayerlib openlayerdll)
FIND_LIBRARY(OPENLAYER_LIBRARY
NAMES ${OPENLAYER_NAMES}
PATHS /usr/lib /usr/local/lib $ENV{MINGDIR}/lib)

IF (OPENLAYER_INCLUDE_DIR AND OPENLAYER_LIBRARY)
   SET(OPENLAYER_FOUND TRUE)
    SET( OPENLAYER_LIBRARIES ${OPENLAYER_LIBRARY} ${ALLEGROGL_LIBRARY} ${ALLEGRO_LIBRARY} ${PNG_LIBRARY} ${FREETYPE_LIBRARY} ${ZLIB_LIBRARY} ${OPENGL_LIBRARIES})
    SET( OPENLAYER_INCLUDE_DIRS ${OPENLAYER_INCLUDE_DIR} ${FREETYPE_INCLUDE_DIR} ${ZLIB_INCLUDE_DIR})
ELSE (OPENLAYER_INCLUDE_DIR AND OPENLAYER_LIBRARY)
   SET(OPENLAYER_FOUND FALSE)
   SET( OPENLAYER_LIBRARIES )
ENDIF (OPENLAYER_INCLUDE_DIR AND OPENLAYER_LIBRARY)

IF (OPENLAYER_FOUND)
   IF (NOT OPENLAYER_FIND_QUIETLY)
      MESSAGE(STATUS "Found OpenLayer: ${OPENLAYER_LIBRARY}")
   ENDIF (NOT OPENLAYER_FIND_QUIETLY)
ELSE (OPENLAYER_FOUND)
   IF (OPENLAYER_FIND_REQUIRED)
      MESSAGE(STATUS "Looked for OpenLayer libraries named ${OPENLAYER_NAMES}.")
      MESSAGE(FATAL_ERROR "Could NOT find OpenLayer library")
   ENDIF (OPENLAYER_FIND_REQUIRED)
ENDIF (OPENLAYER_FOUND)

MARK_AS_ADVANCED(
  OPENLAYER_LIBRARY
  OPENLAYER_INCLUDE_DIR
  OPENLAYER_INCLUDE_DIRS
  )