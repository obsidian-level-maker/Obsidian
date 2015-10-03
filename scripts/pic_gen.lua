------------------------------------------------------------------------
--  Title-pic generator
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2015 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------


--
-- The shapes of these characters are based on the DejaVu TTF font.
-- Only contains uppercase letters and a few punctuation symbols.
--

TITLE_LETTER_SHAPES =
{
  [" "] =
  {
    width = 0.5000
    points = { }
  }

  ["'"] =
  {
    width = 0.0833
    points =
    {
      { x=0.08333, y=1.00000 }
      { x=0.08333, y=0.88333 }
      { x=0.04167, y=0.80000 }
      { x=0.00000, y=0.75833 }
    }
  }

  ["-"] =
  {
    width = 0.3375
    points =
    {
      { x=0.00000, y=0.36250 }
      { x=0.33750, y=0.36250 }
    }
  }

  ["."] =
  {
    width = 0.2000
    points =
    {
      { x=0.10000, y=0.0 }
      { x=0.10000, y=0.0 }
    }
  }

  [":"] =
  {
    width = 0.2000
    points =
    {
      { x=0.10000, y=0.68750 }
      { x=0.10000, y=0.68750 }
      {}
      { x=0.10000, y=0.13750 }
      { x=0.10000, y=0.13750 }
    }
  }

  ["A"] =
  {
    width = 0.8083
    points =
    {
      { x=0.00000, y=0.00417 }
      { x=0.40417, y=0.99167 }
      { x=0.80833, y=0.00417 }
      {}
      { x=0.14167, y=0.33333 }
      { x=0.67083, y=0.33333 }
    }
  }

  ["B"] =
  {
    width = 0.5958
    points =
    {
      { x=0.00000, y=0.00000 }
      { x=0.00000, y=1.00000 }
      { x=0.34583, y=1.00000 }
      { x=0.44167, y=0.97083 }
      { x=0.54167, y=0.86667 }
      { x=0.55833, y=0.77500 }
      { x=0.52917, y=0.63750 }
      { x=0.43333, y=0.55833 }
      { x=0.29167, y=0.53750 }
      { x=0.00000, y=0.53750 }
      {}
      { x=0.29167, y=0.53750 }
      { x=0.51667, y=0.46250 }
      { x=0.58333, y=0.36667 }
      { x=0.59583, y=0.27917 }
      { x=0.55833, y=0.11667 }
      { x=0.45000, y=0.02083 }
      { x=0.34583, y=0.00000 }
      { x=0.00000, y=0.00000 }
    }
  }

  ["C"] =
  {
    width = 0.7542
    points =
    {
      { x=0.75000, y=0.91667 }
      { x=0.59167, y=1.00000 }
      { x=0.43750, y=1.02500 }
      { x=0.22500, y=0.97500 }
      { x=0.04167, y=0.76667 }
      { x=0.00000, y=0.52500 }
      { x=0.03333, y=0.27917 }
      { x=0.14167, y=0.08333 }
      { x=0.29167, y=-0.00417 }
      { x=0.43750, y=-0.02917 }
      { x=0.60000, y=0.00000 }
      { x=0.75417, y=0.07500 }
    }
  }

  ["D"] =
  {
    width = 0.7458
    points =
    {
      { x=0.00000, y=0.00000 }
      { x=0.00000, y=1.00000 }
      { x=0.28750, y=1.00000 }
      { x=0.49167, y=0.95833 }
      { x=0.65833, y=0.84167 }
      { x=0.73333, y=0.64167 }
      { x=0.74583, y=0.51667 }
      { x=0.72917, y=0.30833 }
      { x=0.63333, y=0.12500 }
      { x=0.43333, y=0.01667 }
      { x=0.30833, y=0.00000 }
      { x=0.00000, y=0.00000 }
    }
  }

  ["E"] =
  {
    width = 0.5500
    points =
    {
      { x=0.55000, y=0.00000 }
      { x=0.00000, y=0.00000 }
      { x=0.00000, y=1.00000 }
      { x=0.53750, y=1.00000 }
      {}
      { x=0.00000, y=0.53750 }
      { x=0.52083, y=0.53750 }
    }
  }

  ["F"] =
  {
    width = 0.4792
    points =
    {
      { x=0.00000, y=0.00000 }
      { x=0.00000, y=1.00000 }
      { x=0.47917, y=1.00000 }
      {}
      { x=0.00000, y=0.53750 }
      { x=0.42917, y=0.53750 }
    }
  }

  ["G"] =
  {
    width = 0.7833
    points =
    {
      { x=0.49583, y=0.45833 }
      { x=0.78333, y=0.45833 }
      { x=0.78333, y=0.04583 }
      { x=0.61667, y=-0.01667 }
      { x=0.46250, y=-0.02917 }
      { x=0.28333, y=0.00417 }
      { x=0.12500, y=0.11250 }
      { x=0.02500, y=0.29167 }
      { x=0.00000, y=0.48333 }
      { x=0.04583, y=0.75000 }
      { x=0.15417, y=0.91667 }
      { x=0.33750, y=1.00000 }
      { x=0.45833, y=1.01250 }
      { x=0.66250, y=0.99167 }
      { x=0.77917, y=0.93333 }
    }
  }

  ["H"] =
  {
    width = 0.6667
    points =
    {
      { x=0.00000, y=0.00000 }
      { x=0.00000, y=1.00000 }
      {}
      { x=0.00000, y=0.53333 }
      { x=0.66667, y=0.53333 }
      {}
      { x=0.66667, y=0.00000 }
      { x=0.66667, y=1.00000 }
    }
  }

  ["I"] =
  {
    width = 0.3333
    points =
    {
      { x=0.16667, y=0.00000 }
      { x=0.16667, y=1.00000 }
      {}
      { x=0.00000, y=0.00000 }
      { x=0.33333, y=0.00000 }
      {}
      { x=0.00000, y=1.00000 }
      { x=0.33333, y=1.00000 }
    }
  }

  ["J"] =
  {
    width = 0.4458
    points =
    {
      { x=0.11250, y=1.00000 }
      { x=0.44583, y=1.00000 }
      {}
      { x=0.28750, y=1.00000 }
      { x=0.28750, y=0.27500 }
      { x=0.25417, y=0.10000 }
      { x=0.19583, y=0.02917 }
      { x=0.10833, y=0.00000 }
      { x=0.00000, y=0.00000 }
    }
  }

  ["K"] =
  {
    width = 0.5917
    points =
    {
      { x=0.00000, y=0.00000 }
      { x=0.00000, y=1.00000 }
      {}
      { x=0.54167, y=1.00000 }
      { x=0.03583, y=0.53333 }
      { x=0.59167, y=0.00000 }
    }
  }

  ["L"] =
  {
    width = 0.5292
    points =
    {
      { x=0.52917, y=0.00000 }
      { x=0.00000, y=0.00000 }
      { x=0.00000, y=1.00000 }
    }
  }

  ["M"] =
  {
    width = 0.7167
    points =
    {
      { x=0.00000, y=0.00000 }
      { x=0.00000, y=1.00000 }
      { x=0.02500, y=1.00000 }
      { x=0.35833, y=0.21250 }
      { x=0.69167, y=1.00000 }
      { x=0.71667, y=1.00000 }
      { x=0.71667, y=0.00000 }
    }
  }

  ["N"] =
  {
    width = 0.6042
    points =
    {
      { x=0.00000, y=0.00000 }
      { x=0.00000, y=1.00000 }
      { x=0.02500, y=1.00000 }
      { x=0.57917, y=0.00000 }
      { x=0.60417, y=0.00000 }
      { x=0.60417, y=1.00000 }
    }
  }

  ["O"] =
  {
    width = 0.8250
    points =
    {
      { x=0.00000, y=0.50833 }
      { x=0.03750, y=0.75000 }
      { x=0.15000, y=0.92917 }
      { x=0.29167, y=1.00833 }
      { x=0.40833, y=1.02083 }
      { x=0.62500, y=0.96667 }
      { x=0.75833, y=0.81250 }
      { x=0.81250, y=0.63750 }
      { x=0.82500, y=0.49167 }
      { x=0.78333, y=0.24583 }
      { x=0.65833, y=0.06250 }
      { x=0.52500, y=-0.00833 }
      { x=0.40417, y=-0.02500 }
      { x=0.26250, y=0.00417 }
      { x=0.10000, y=0.11667 }
      { x=0.02083, y=0.30417 }
      { x=0.00000, y=0.50833 }
    }
  }

  ["P"] =
  {
    width = 0.5417
    points =
    {
      { x=0.00000, y=0.00000 }
      { x=0.00000, y=1.00000 }
      { x=0.29167, y=1.00000 }
      { x=0.42917, y=0.95833 }
      { x=0.52083, y=0.84583 }
      { x=0.54167, y=0.73333 }
      { x=0.50417, y=0.57500 }
      { x=0.38333, y=0.47083 }
      { x=0.28750, y=0.45417 }
      { x=0.00000, y=0.45417 }
    }
  }

  ["Q"] =
  {
    width = 0.8250
    points =
    {
      { x=0.00000, y=0.50833 }
      { x=0.03750, y=0.75000 }
      { x=0.15000, y=0.92917 }
      { x=0.29167, y=1.00833 }
      { x=0.40833, y=1.02083 }
      { x=0.62500, y=0.96667 }
      { x=0.75833, y=0.81250 }
      { x=0.81250, y=0.63750 }
      { x=0.82500, y=0.49167 }
      { x=0.78333, y=0.24583 }
      { x=0.65833, y=0.06250 }
      { x=0.52500, y=-0.00833 }
      { x=0.40417, y=-0.02500 }
      { x=0.26250, y=0.00417 }
      { x=0.10000, y=0.11667 }
      { x=0.02083, y=0.30417 }
      { x=0.00000, y=0.50833 }
      {}
      { x=0.54583, y=-0.03333 }
      { x=0.69583, y=-0.19583 }
    }
  }

  ["R"] =
  {
    width = 0.6000
    points =
    {
      { x=0.00000, y=0.00000 }
      { x=0.00000, y=1.00000 }
      { x=0.29167, y=1.00000 }
      { x=0.42917, y=0.95833 }
      { x=0.52083, y=0.84583 }
      { x=0.54167, y=0.73333 }
      { x=0.50417, y=0.57500 }
      { x=0.38333, y=0.47083 }
      { x=0.28750, y=0.45417 }
      { x=0.00000, y=0.45417 }
      {}
      { x=0.31250, y=0.42500 }
      { x=0.39583, y=0.37083 }
      { x=0.51250, y=0.02917 }
      { x=0.60000, y=0.00000 }
    }
  }

  ["S"] =
  {
    width = 0.6208
    points =
    {
      { x=0.00000, y=0.06250 }
      { x=0.17500, y=0.00000 }
      { x=0.31250, y=-0.02500 }
      { x=0.45833, y=0.00417 }
      { x=0.57500, y=0.08333 }
      { x=0.62083, y=0.24167 }
      { x=0.58333, y=0.37083 }
      { x=0.44167, y=0.47500 }
      { x=0.15833, y=0.55000 }
      { x=0.05000, y=0.64167 }
      { x=0.02083, y=0.77917 }
      { x=0.06250, y=0.91667 }
      { x=0.17917, y=1.00000 }
      { x=0.32083, y=1.02083 }
      { x=0.48333, y=1.00000 }
      { x=0.60417, y=0.93750 }
    }
  }

  ["T"] =
  {
    width = 0.8333
    points =
    {
      { x=0.41667, y=0.00000 }
      { x=0.41667, y=1.00000 }
      {}
      { x=0.00000, y=1.00000 }
      { x=0.83333, y=1.00000 }
    }
  }

  ["U"] =
  {
    width = 0.6625
    points =
    {
      { x=0.00000, y=1.00000 }
      { x=0.00000, y=0.35833 }
      { x=0.02500, y=0.17083 }
      { x=0.09583, y=0.05833 }
      { x=0.21667, y=-0.00833 }
      { x=0.32917, y=-0.02500 }
      { x=0.44167, y=-0.01250 }
      { x=0.55417, y=0.04167 }
      { x=0.62500, y=0.12917 }
      { x=0.66250, y=0.35833 }
      { x=0.66250, y=1.00000 }
    }
  }

  ["V"] =
  {
    width = 0.8208
    points =
    {
      { x=0.00000, y=1.00000 }
      { x=0.37500, y=0.00000 }
      { x=0.40000, y=0.00000 }
      { x=0.82083, y=1.00000 }
    }
  }

  ["W"] =
  {
    width = 1.1292
    points =
    {
      { x=0.00000, y=1.00000 }
      { x=0.25417, y=0.00000 }
      { x=0.29583, y=0.00000 }
      { x=0.55417, y=0.58333 }
      { x=0.58750, y=0.58333 }
      { x=0.82917, y=0.00000 }
      { x=0.87083, y=0.00000 }
      { x=1.12917, y=1.00000 }
    }
  }

  ["X"] =
  {
    width = 0.7250
    points =
    {
      { x=0.00000, y=-0.00833 }
      { x=0.69167, y=1.00000 }
      {}
      { x=0.04583, y=1.00000 }
      { x=0.72500, y=0.00000 }
    }
  }

  ["Y"] =
  {
    width = 0.7125
    points =
    {
      { x=0.35000, y=-0.00417 }
      { x=0.36250, y=0.49167 }
      { x=0.00000, y=1.00000 }
      {}
      { x=0.36250, y=0.49167 }
      { x=0.71250, y=1.00000 }
    }
  }

  ["Z"] =
  {
    width = 0.8292
    points =
    {
      { x=0.82917, y=0.00000 }
      { x=0.00000, y=0.00000 }
      { x=0.80833, y=1.00000 }
      { x=0.01667, y=1.00000 }
    }
  }

-- end of letter_shapes
}


------------------------------------------------------------------------


--struct TRANSFORM
--[[
    x, y    -- reference coord for transform function
            -- e.g. x is left coord, y is the baseline

    func    -- function(T, x, y) to transform a coord

    curved  -- true if lines will be bent (become curved), which
            -- means we need to split them into small segments

    along   -- current horizontal position when drawing a string
            -- starts at 0

    w, h    -- size of characters

    color   -- color to draw the characters

    bw, bh  -- thickness of drawn strokes

    spacing -- optional field, adds onto the info.width field
--]]


function Title_get_normal_transform(x, y, w, h)
  local T =
  {
    x = x
    y = y
    w = w
    h = h
  }

  -- simplest transform: a pure translation
  T.func = function(T, x, y)
    return T.x + x, T.y - y
  end

  return T
end



function Title_make_stroke(T, x1,y1, x2,y2)
  x1, y1 = T.func(T, x1, y1)
  x2, y2 = T.func(T, x2, y2)

  gui.title_draw_line(x1, y1, x2, y2, T.color, T.bw, T.bh)
end



function Title_draw_char(T, ch)
  -- we draw lowercase characters as smaller uppercase ones
  local w = T.w
  local h = T.h

  if string.match(ch, "[a-z]") then
    w = w * 0.8
    h = h * 0.7
    ch = string.upper(ch)
  end


  local info = TITLE_LETTER_SHAPES[ch]

  if not info then return end


  -- draw the lines --

  for i = 1, #info.points - 1 do
    local x1 = info.points[i].x
    local y1 = info.points[i].y

    local x2 = info.points[i + 1].x
    local y2 = info.points[i + 1].y

    if not x1 or not x2 then continue end

    x1 = T.along + x1 * w ; y1 = y1 * h
    x2 = T.along + x2 * w ; y2 = y2 * h

    Title_make_stroke(T, x1,y1, x2,y2)
  end

  -- advance horizontally for next character
  T.along = T.along + w * (info.width + (T.spacing or 0.3))
end



function Title_measure_char(ch, w, spacing)
  if string.match(ch, "[a-z]") then
    w = w * 0.8
    ch = string.upper(ch)
  end

  local info = TITLE_LETTER_SHAPES[ch]

  if not info then return 0 end

  return w * (info.width + (spacing or 0.3))
end



function Title_draw_string(T, text)
  T.along = 0

  for i = 1, #text do
    local ch = string.sub(text, i, i)

    Title_draw_char(T, ch)
  end
end



function Title_measure_string(text, w, spacing)
  local width = 0

  for i = 1, #text do
    local ch = string.sub(text, i, i)

    width = width + Title_measure_char(ch, w, spacing)
  end

  return width
end



function Title_parse_style(T, style)
  --
  -- style is 3 hex digits, a ':', then two thickness digits
  --
  local color_str = string.match(style, "(%w%w%w):")
  local box_str   = string.match(style, ":(%w%w)")

  if color_str == nil or box_str == nil then
    error("Title-gen: bad style string: " .. style)
  end

  T.color = "#" .. color_str

  T.bw = 0 + string.sub(box_str, 1, 1)
  T.bh = 0 + string.sub(box_str, 2, 2)
end



function Title_styled_string(T, text, styles)
  each style in styles do
    Title_parse_style(T, style)
    Title_draw_string(T, text)
  end
end


------------------------------------------------------------------------


OB_TITLE_DIR = ""


function Title_add_background()
  local BACKGROUNDS =
  {
    space1 = 15
    space2 = 50
    space3 = 50
    space4 = 50

    hell_1 = 50
    hell_2 = 50
    hell_3 = 50

    cave1  = 50

    landscape1 = 20
    landscape2 = 20
    landscape3 = 50
  }

  local name = rand.key_by_probs(BACKGROUNDS)

  gui.title_load_image(0, 0, OB_TITLE_DIR .. "/" .. name .. ".tga")
end



function Title_add_main_title(sub_type)
  -- the 'sub_type' can be "none", "version", "phrase"

  local T = Title_get_normal_transform(0, 100, 30, 40)

  Title_styled_string(T, GAME.title, {"f00:55", "ff0:33"} )
end



function Title_add_sub_title()
  -- TODO
end



function Title_add_credit()
  local CREDIT_LINES =
  {
    "Proudly bought to you by OBLIGE"
    "Another great OBLIGE production"
    "From the foundries of OBLIGE"
    "Copyright MMXV: OBLIGE Level Maker"
    "A new fun-packed wad by OBLIGE"
    "Revel in the OBLIGE experience"
  }

  local credit = rand.pick(CREDIT_LINES)

  local T = Title_get_normal_transform(10, 192, 9, 8)

  Title_styled_string(T, credit, {"333:33", "bbb:11"} )

  gui.title_load_image(282, 162, OB_TITLE_DIR .. "/logo1.tga")
end



function Title_generate()
  assert(GAME.title)
  assert(GAME.PALETTES)
  assert(GAME.PALETTES.normal)

  gui.title_create(320, 200, "#000")

  gui.title_set_palette(GAME.PALETTES.normal)


  OB_TITLE_DIR = gui.get_install_dir() .. "/data/titles"

  Title_add_background()
  Title_add_credit()
  Title_add_main_title("none")
  Title_add_sub_title()

  gui.title_write("TITLEPIC")
end

