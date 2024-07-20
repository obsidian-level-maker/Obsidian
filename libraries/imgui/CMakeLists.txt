project(
  imgui
  LANGUAGES CXX
  VERSION 0.1.0
)

add_library(
    imgui
    imgui.cpp
    imgui.h
    imgui_widgets.cpp
    imgui_draw.cpp
    imgui_tables.cpp
    imgui_demo.cpp
)
target_include_directories(
    imgui SYSTEM PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}"
)
if(USE_FREETYPE)
    find_package(Freetype)
    if (Freetype_FOUND)
        message(STATUS "Using FreeType for font shaping.")
        target_sources(
            imgui PRIVATE imgui_freetype.cpp
        )
        target_compile_definitions(
            imgui PUBLIC IMGUI_ENABLE_FREETYPE
        )
        target_link_libraries(
            imgui PUBLIC Freetype::Freetype
        )
    else()
        message(STATUS "Using imstb_truetype for font shaping.")
    endif()
endif()