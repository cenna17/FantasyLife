cmake_minimum_required(VERSION 3.14)
project(shell_tests LANGUAGES C CXX)

# Require C++14 for GoogleTest
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Include GoogleTest
include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
  DOWNLOAD_EXTRACT_TIMESTAMP FALSE
)
FetchContent_MakeAvailable(googletest)

# Enable testing
include(CTest)
enable_testing()

# -------------------------------
# Build the shell executable
# -------------------------------
add_executable(shell src/task0.c)
target_include_directories(shell PRIVATE include)

# -------------------------------
# Build the GoogleTest executable
# -------------------------------
add_executable(shell_test gtest/shell_test.cpp)
target_include_directories(shell_test PRIVATE include)

# Link your shell library (if any other C files are needed) and GoogleTest
target_link_libraries(shell_test PRIVATE GTest::gtest_main pthread)

# Make sure shell_test depends on shell executable
add_dependencies(shell_test shell)

# Discover tests automa
