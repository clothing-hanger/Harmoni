cmake_minimum_required(VERSION 3.10)
project(video_module LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_library(video SHARED
    src/video.cpp
    src/lua_video.cpp
)

if (MSVC)
    target_compile_options(video PRIVATE
        $<$<CONFIG:Release>:/O2 /Oi /Gy /DNDEBUG /Ob2>
        $<$<CONFIG:RelWithDebInfo>:/O2 /Zi /DNDEBUG /Ob2>
    )

    target_link_options(video PRIVATE
        $<$<CONFIG:Release>:/LTCG /OPT:REF /OPT:ICF>
        $<$<CONFIG:RelWithDebInfo>:/LTCG /OPT:REF /OPT:ICF>
    )
else()
    target_compile_options(video PRIVATE
        $<$<CONFIG:Release>:-O3 -DNDEBUG>
        $<$<CONFIG:RelWithDebInfo>:-O2 -g>
    )

    target_link_options(video PRIVATE
        $<$<CONFIG:Release>:-s>
    )
endif()

if (MSVC)
    target_include_directories(video PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg/include
        ${CMAKE_CURRENT_SOURCE_DIR}/LuaJIT/src
    )

    target_link_libraries(video PRIVATE
        lua51.lib
        avformat.lib
        avcodec.lib
        swresample.lib
        swscale.lib
        avutil.lib
    )

else()
    find_package(PkgConfig REQUIRED)

    pkg_check_modules(FFMPEG REQUIRED
        libavformat
        libavcodec
        libswscale
        libswresample
        libavutil
    )

    pkg_check_modules(LUAJIT REQUIRED luajit)

    target_include_directories(video PRIVATE
        ${FFMPEG_INCLUDE_DIRS}
        ${LUAJIT_INCLUDE_DIRS}
    )

    target_link_libraries(video PRIVATE
        ${FFMPEG_LIBRARIES}
        ${LUAJIT_LIBRARIES}
    )

    target_compile_options(video PRIVATE
        ${FFMPEG_CFLAGS_OTHER}
        ${LUAJIT_CFLAGS_OTHER}
    )
endif()

set_target_properties(video PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
)
