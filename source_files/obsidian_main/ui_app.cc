//----------------------------------------------------------------------------
//  OBSIDIAN UI
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
// Based off of the starter SDL2+ImGUi example at
// https://github.com/MartinHelmut/cpp-gui-template-sdl2, with the following
// license:
//
//  Copyright (c) 2024 Martin Helmut Fieber
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


#include "ui_app.h"

UI_Window::UI_Window(const Settings& settings) {
  auto window_flags{
	static_cast<SDL_WindowFlags>(
	  SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI
	)
  };
  constexpr int window_center_flag{SDL_WINDOWPOS_CENTERED};

  m_window = SDL_CreateWindow(
      settings.title.c_str(),
      window_center_flag,
      window_center_flag,
      settings.width,
      settings.height,
      window_flags
  );

  auto renderer_flags{
    static_cast<SDL_RendererFlags>(
      SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_ACCELERATED
    )
  };
  m_renderer = SDL_CreateRenderer(
    m_window, -1, renderer_flags
  );

  if (m_renderer == nullptr) {
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "ERROR", SDL_GetError(), NULL);
    return;
  }
}

UI_Window::~UI_Window() {
  SDL_DestroyRenderer(m_renderer);
  SDL_DestroyWindow(m_window);
}

SDL_Window* UI_Window::get_native_window() const {
  return m_window;
}

SDL_Renderer* UI_Window::get_native_renderer() const {
  return m_renderer;
}

UI_App::UI_App() {
  unsigned int init_flags {
    SDL_INIT_VIDEO | SDL_INIT_TIMER
  };
  if (SDL_Init(init_flags) != 0) {
    SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "ERROR", SDL_GetError(), NULL);
    m_exit_status = 1;
  }

  m_window = std::make_unique<UI_Window>(
    UI_Window::Settings{"OBSIDIAN Level Maker"}
  );
}

UI_App::~UI_App() {
  ImGui_ImplSDLRenderer2_Shutdown();
  ImGui_ImplSDL2_Shutdown();
  ImGui::DestroyContext();
  SDL_Quit();
}

int UI_App::run() {
  if (m_exit_status == 1) {
    return m_exit_status;
  }

  IMGUI_CHECKVERSION();
  ImGui::CreateContext();
  ImGuiIO& io{ImGui::GetIO()};

  ImGui_ImplSDL2_InitForSDLRenderer(
    m_window->get_native_window(),
    m_window->get_native_renderer()
  );
  ImGui_ImplSDLRenderer2_Init(
    m_window->get_native_renderer()
  );

  m_running = true;
  while (m_running) {
    SDL_Event event{};
    while (SDL_PollEvent(&event) == 1) {
      ImGui_ImplSDL2_ProcessEvent(&event);

      if (event.type == SDL_QUIT) {
        stop();
      }
    }

    ImGui_ImplSDLRenderer2_NewFrame();
    ImGui_ImplSDL2_NewFrame();
    ImGui::NewFrame();

    if (m_show_some_panel) {
      ImGui::Begin("Test Panel", &m_show_some_panel);
      ImGui::Text("Welcome to OBSIDIAN!");
      ImGui::End();
    }

    ImGui::Render();

    SDL_SetRenderDrawColor(
      m_window->get_native_renderer(),
      100, 100, 100, 255
    );
    SDL_RenderClear(m_window->get_native_renderer());
    ImGui_ImplSDLRenderer2_RenderDrawData(
      ImGui::GetDrawData()
    );
    SDL_RenderPresent(
      m_window->get_native_renderer()
    );
  }

  return m_exit_status;
}

void UI_App::stop() {
  m_running = false;
}