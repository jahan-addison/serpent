cmake_minimum_required(VERSION 3.16)
project(
  serpent
  VERSION 1.0
  LANGUAGES NONE)

include(ExternalProject)

# Build the assembler
set(ASSEMBLER_BINARY_DIR "${CMAKE_BINARY_DIR}/external/as")

ExternalProject_Add(
  assembler
  SOURCE_DIR "${CMAKE_SOURCE_DIR}/external/as"
  BINARY_DIR "${ASSEMBLER_BINARY_DIR}"
  INSTALL_COMMAND ""
  BUILD_BYPRODUCTS "${ASSEMBLER_BINARY_DIR}/aslc86k")

# Assemble
set(ASM_INPUT "${CMAKE_SOURCE_DIR}/src/serpent.s")
set(ASM_INTERMEDIATE "${CMAKE_SOURCE_DIR}/src/serpent.vms")
set(ASM_OUTPUT "${CMAKE_BINARY_DIR}/serpent.vms")

add_custom_command(
  OUTPUT "${ASM_OUTPUT}"
  COMMAND "${ASSEMBLER_BINARY_DIR}/aslc86k" -I "${CMAKE_SOURCE_DIR}/include/"
          "${ASM_INPUT}"
  COMMAND ${CMAKE_COMMAND} -E copy "${ASM_INTERMEDIATE}" "${ASM_OUTPUT}"
  DEPENDS assembler "${ASM_INPUT}" "${CMAKE_SOURCE_DIR}/include/sfr.i"
  COMMENT "Assembling serpent.vms"
  VERBATIM)

add_custom_target(serpent ALL DEPENDS "${ASM_OUTPUT}")
