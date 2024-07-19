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