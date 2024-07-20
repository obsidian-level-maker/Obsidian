//------------------------------------------------------------------------
//  ImGui utility wrappers
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
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
//------------------------------------------------------------------------

#pragma once

#include <functional>
#include <type_traits>

#include "imgui.h"

namespace sg
{
namespace detail
{
template <typename Fn, typename = std::enable_if_t<std::is_invocable_r_v<void, Fn>>> class ScopeGuard<Fn>;

template <typename Fn> class ScopeGuard<Fn>
{
  public:
    using FnType = Fn;
    ScopeGuard(ScopeGuard &&other) noexcept : _fn(std::forward<Fn>(other._fn)), _active(std::move(other._active))
    {
    }
    ~ScopeGuard()
    {
        if (_active)
            _fn();
    }
    void Cancel()
    {
        _active = false;
    }

    ScopeGuard()                              = delete;
    ScopeGuard(const ScopeGuard &)            = delete;
    ScopeGuard &operator=(const ScopeGuard &) = delete;
    ScopeGuard &operator=(ScopeGuard &&)      = delete;

  private:
    explicit ScopeGuard(Fn &&fn) : _fn(std::forward<Fn>(fn)), _active(true)
    {
    }

    friend ScopeGuard MakeScopeGuard<Fn>(Fn &&);

    Fn   _fn;
    bool _active;
};
template <typename Fn> ScopeGuard<Fn> MakeScopeGuard(Fn &&fn)
{
    return ScopeGuard<Fn>{std::forward<Fn>(fn)};
}

} // namespace detail

using detail::MakeScopeGuard;
using detail::ScopeGuard;

} // namespace sg

namespace UI
{
template <typename EnterFn, typename ExitFn,
          typename = std::enable_if_t<
              std::conjunction_v<std::is_invocable_r<bool, EnterFn>, std::is_invocable_r<void, ExitFn>>>>
struct Widget
{
    Widget(EnterFn &&enter, ExitFn &&exit) : _sg(std::forward<ExitFn>(exit))
    {
        _active = enter();
        if (!_active)
            _sg.Cancel();
    }

    [[nodiscard]] bool Active() const
    {
        return _active;
    }

  private:
    bool                   _active;
    sg::ScopeGuard<ExitFn> _sg;
};

class MainMenuBar
{
  public:
    explicit operator bool() const
    {
        return _w.Active();
    }

  private:
    auto _w = Widget(ImGui::BeginMainMenuBar, ImGui::EndMainMenuBar);
};

class Menu
{
  public:
    explicit Menu(const char *label, bool enabled = true)
        : _w([=] { return ImGui::BeginMenu(label, enabled); }, ImGui::EndMenu)
    {
    }
    explicit operator bool() const
    {
        return _w.Active();
    }

  private:
    Widget<std::function<bool()>, void()> _w;
};

class PushFont
{
  public:
    explicit PushFont(ImFont *font)
    {
        ImGui::PushFont(font);
    }

  private:
    auto _sg = sg::MakeScopeGuard([] { ImGui::PopFont(); });
};

class PushStyle
{
  public:
    PushStyle() = default;

    void Color(ImGuiCol key, const ImVec4 &value)
    {
        ImGui::PushStyleColor(key, value);
        _num_colors++;
    }

    void Var(ImGuiStyleVar key, float value)
    {
        ImGui::PushStyleVar(key, value);
        _num_vars++;
    }
    void Var(ImGuiStyleVar key, const ImVec2 &value)
    {
        ImGui::PushStyleVar(key, value);
        _num_vars++;
    }

  private:
    int  _num_colors = 0;
    int  _num_vars   = 0;
    auto _sg         = sg::MakeScopeGuard([this] {
        ImGui::PopStyleColor(_num_colors);
        ImGui::PopStyleVar(_num_vars);
    });
};
} // namespace UI