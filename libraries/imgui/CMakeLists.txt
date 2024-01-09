cmake_minimum_required(VERSION 3.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

project(imgui)

add_library(imgui
	imgui.cpp
	imgui.h
	imconfig.h
	imgui_demo.cpp
	imgui_draw.cpp
	imgui_internal.h
	imgui_tables.cpp
	imgui_widgets.cpp
	imstb_rectpack.h
	imstb_textedit.h
	imstb_truetype.h
	backends/imgui_impl_sdl2.h
	backends/imgui_impl_sdl2.cpp
	backends/imgui_impl_sdlrenderer2.h
	backends/imgui_impl_sdlrenderer2.cpp
)

if (WIN32 AND (MSVC OR CLANG))
  target_include_directories(imgui SYSTEM PRIVATE ${OBSIDIAN_LIB_DIR}/sdl2/include)
endif()