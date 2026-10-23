cmake_minimum_required(VERSION 3.15)
project(connectivity_cleanup_test LANGUAGES CXX)
enable_testing()

if(NOT WIN32)
  message(FATAL_ERROR "This regression exercises real Windows COM.")
endif()
foreach(required FLUTTER_WRAPPER_DIR FLUTTER_ENGINE_DIR)
  if(NOT IS_DIRECTORY "${${required}}")
    message(FATAL_ERROR "Set ${required} to the existing Flutter SDK directory.")
  endif()
endforeach()

add_library(flutter_wrapper_plugin STATIC
  "${FLUTTER_WRAPPER_DIR}/core_implementations.cc"
  "${FLUTTER_WRAPPER_DIR}/plugin_registrar.cc"
  "${FLUTTER_WRAPPER_DIR}/standard_codec.cc")
target_compile_features(flutter_wrapper_plugin PUBLIC cxx_std_17)
target_compile_options(flutter_wrapper_plugin PRIVATE /utf-8)
target_include_directories(flutter_wrapper_plugin PUBLIC
  "${FLUTTER_WRAPPER_DIR}/include" "${FLUTTER_ENGINE_DIR}")
target_link_libraries(flutter_wrapper_plugin PUBLIC
  "${FLUTTER_ENGINE_DIR}/flutter_windows.dll.lib")

add_executable(connectivity_cleanup_test
  connectivity_cleanup_test.cpp "../network_manager.cpp")
target_compile_features(connectivity_cleanup_test PRIVATE cxx_std_17)
target_compile_options(connectivity_cleanup_test PRIVATE /utf-8)
target_compile_definitions(connectivity_cleanup_test PRIVATE FLUTTER_PLUGIN_IMPL)
target_link_libraries(connectivity_cleanup_test PRIVATE
  flutter_wrapper_plugin ole32 oleaut32 uuid iphlpapi)
add_custom_command(TARGET connectivity_cleanup_test POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${FLUTTER_ENGINE_DIR}/flutter_windows.dll"
    "$<TARGET_FILE_DIR:connectivity_cleanup_test>")

add_test(NAME preserves_callers_com_apartment COMMAND connectivity_cleanup_test)
