cmake_minimum_required(VERSION 3.10)
project(video_module LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg/include
    ${CMAKE_CURRENT_SOURCE_DIR}/LuaJIT/src
)

link_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/ffmpeg/lib
    ${CMAKE_CURRENT_SOURCE_DIR}/LuaJIT/src
)

add_library(video SHARED
    src/video.cpp
    src/lua_video.cpp
)

if(MSVC)
    target_compile_options(video PRIVATE
        $<$<CONFIG:Release>:/O2 /Oi /Gy /DNDEBUG /Ob2>
        $<$<CONFIG:RelWithDebInfo>:/O2 /Zi /DNDEBUG /Ob2>
    )

    set_target_properties(video PROPERTIES
        LINK_FLAGS_RELEASE "/LTCG /OPT:REF /OPT:ICF"
        LINK_FLAGS_RELWITHDEBINFO "/LTCG /OPT:REF /OPT:ICF"
    )

else()
    target_compile_options(video PRIVATE
        $<$<CONFIG:Release>:-O3 -march=native -flto -DNDEBUG>
        $<$<CONFIG:RelWithDebInfo>:-O2 -g -march=native -flto>
    )
    target_link_options(video PRIVATE
        $<$<CONFIG:Release>:-flto -s>
        $<$<CONFIG:RelWithDebInfo>:-flto>
    )
endif()

if (WIN32)
    target_link_libraries(video
        lua51.lib
        avformat.lib
        avcodec.lib
        swresample.lib
        swscale.lib
        avutil.lib
    )
else()
    target_link_libraries(video
        lua51
        avformat
        avcodec
        swresample
        swscale
        avutil
    )
endif()

set_target_properties(video PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
)
