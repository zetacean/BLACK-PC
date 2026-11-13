cmake_minimum_required(VERSION 3.25)
project(black_subtitle_tests LANGUAGES CXX)

include(CTest)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(black_subtitle_tests
    subtitle_tests.cpp
    ../src/common/subtitles_data.cpp
    ../src/common/subtitle_layout.cpp
)
target_include_directories(black_subtitle_tests PRIVATE ../src)
if(MSVC)
    target_compile_options(black_subtitle_tests PRIVATE /EHsc /W4)
else()
    target_compile_options(black_subtitle_tests PRIVATE -Wall -Wextra -Wpedantic)
endif()
add_test(NAME black_subtitle_tests COMMAND black_subtitle_tests)

add_executable(black_save_storage_tests
    save_storage_tests.cpp
    ../src/common/save_storage.cpp
)
target_include_directories(black_save_storage_tests PRIVATE ../src)
if(MSVC)
    target_compile_options(black_save_storage_tests PRIVATE /EHsc /W4)
endif()
add_test(NAME black_save_storage_tests COMMAND black_save_storage_tests)
