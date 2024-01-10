//----------------------------------------------------------------------------
//  OBSIDIAN UI Header
//----------------------------------------------------------------------------
//
//  Copyright (c) 2024 The OBSIDIAN Team
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//----------------------------------------------------------------------------

#ifndef __UI_APP_H__
#define __UI_APP_H__

#ifdef _MSC_VER
#include "SDL.h"
#elif __APPLE__
#include <SDL.h>
#else
#include <SDL2/SDL.h>
#endif

#include <string>
#include <memory>

#include "backends/imgui_impl_sdl2.h"
#include "backends/imgui_impl_sdlrenderer2.h"
#include "imgui.h"

class UI_Window {
 public:
  struct Settings {
    std::string title;
    const int width{1280};
    const int height{720};
  };

  explicit UI_Window(const Settings& settings);
  ~UI_Window();

  [[nodiscard]] SDL_Window* get_native_window() const;
  [[nodiscard]] SDL_Renderer* get_native_renderer() const;

 private:
  SDL_Window* m_window{nullptr};
  SDL_Renderer* m_renderer{nullptr};
};

class UI_App {
   public:
    // widgets go here I guess

   public:
    UI_App();
    ~UI_App();

    int run();
    void stop();

   private:
    int m_exit_status{0};
    bool m_running{true};
    std::unique_ptr<UI_Window> m_window{nullptr};
    bool m_show_some_panel{true};
};

extern UI_App *main_win;

#endif /* __UI_APP_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
