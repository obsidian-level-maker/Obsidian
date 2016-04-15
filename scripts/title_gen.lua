------------------------------------------------------------------------
--  Title-pic generator
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2015-2016 Andrew Apted
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
    width = 0.8600
    points =
    {
      { x=0.00000, y=0.00000 }
      { x=0.00000, y=1.00000 }
      { x=0.03000, y=1.00000 }
      { x=0.43000, y=0.21250 }
      { x=0.83000, y=1.00000 }
      { x=0.86000, y=1.00000 }
      { x=0.86000, y=0.00000 }
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
      { x=0.29167, y=1.00000 }
      { x=0.40833, y=1.00000 }
      { x=0.62500, y=0.96667 }
      { x=0.75833, y=0.81250 }
      { x=0.81250, y=0.63750 }
      { x=0.82500, y=0.49167 }
      { x=0.78333, y=0.24583 }
      { x=0.65833, y=0.06250 }
      { x=0.52500, y=0.00000 }
      { x=0.40417, y=0.00000 }
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
    width = 0.7200
    points =
    {
      { x=0.36000, y=-0.00417 }
      { x=0.36000, y=0.49167 }
      { x=0.00000, y=1.00000 }
      {}
      { x=0.36000, y=0.49167 }
      { x=0.72000, y=1.00000 }
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

  ["0"] =
  {
    width = 0.6
    rx = { 82,145 }
    ry = { 150,48 }
    points =
    {
      { x=118, y=150 }
      { x=108, y=149 }
      { x= 92, y=142 }
      { x= 85, y=122 }

      { x= 84, y=95 }
      { x= 87, y=70 }
      { x=100, y=54 }

      { x=118, y=48 }
      { x=126, y=48 }
      { x=137, y=54 }
      { x=145, y=70 }

      { x=150, y=95 }
      { x=145, y=122 }
      { x=136, y=142 }
      { x=126, y=149 }
      { x=118, y=150 }
    }
  }

  ["1"] =
  {
    width = 0.6
    rx = { 184,249 }
    ry = { 152,48 }
    points =
    {
      { x=220,y=151 }
      { x=220,y= 48 }
      { x=190,y= 63 }
      {}
      { x=184,y=152 }
      { x=249,y=152 }
    }
  }

  ["2"] =
  {
    width = 0.6
    rx = { 285,347 }
    ry = { 152,46 }
    points =
    {
      { x=285, y=54 }
      { x=302, y=46 }
      { x=320, y=46 }
      { x=334, y=51 }
      { x=343, y=64 }
      { x=343, y=79 }
      { x=336, y=96 }

      { x=285, y=151 }
      { x=346, y=151 }
    }
  }

  ["3"] =
  {
    width = 0.6
    rx = { 388,450 }
    ry = { 152,42 }
    points =
    {
      { x=388, y=42 }
      { x=450, y=42 }
      { x=444, y=78 }
      { x=434, y=87 }
      { x=420, y=93 }
      { x=408, y=93 }
      {}
      { x=420, y=93 }
      { x=432, y=97 }
      { x=445, y=105 }
      { x=450, y=119 }
      { x=450, y=130 }
      { x=442, y=143 }
      { x=426, y=152 }
      { x=410, y=152 }
      { x=388, y=147 }
    }
  }

  ["4"] =
  {
    width = 0.6
    rx = { 490,558 }
    ry = { 152,48 }
    points =
    {
      { x=558,y=121 }
      { x=490,y=121 }
      { x=539,y=48  }
      { x=539,y=152 }
    }
  }

  ["5"] =
  {
    width = 0.6
    rx = { 82,142 }
    ry = { 341,234 }
    points =
    {
      { x=137,y=232 }
      { x=88, y=232 }
      { x=88, y=278 }
      { x=102,y=273 }
      { x=115,y=273 }
      { x=134,y=282 }
      { x=142,y=300 }
      { x=142,y=312 }

      { x=130,y=330 }
      { x=115,y=338 }
      { x=100,y=338 }
      { x= 82,y=332 }
    }
  }

  ["6"] =
  {
    width = 0.6
    rx = { 185,249 }
    ry = { 341,231 }
    points =
    {
      { x=245,y=238 }
      { x=231,y=231 }
      { x=221,y=231 }
      { x=204,y=237 }
      { x=190,y=255 }
      { x=185,y=276 }
      { x=185,y=292 }
      { x=189,y=319 }
      { x=202,y=336 }
      { x=214,y=340 }
      { x=223,y=340 }
      { x=242,y=330 }
      { x=249,y=313 }
      { x=249,y=298 }
      { x=241,y=283 }
      { x=226,y=273 }
      { x=214,y=273 }
      { x=201,y=279 }
      { x=191,y=293 }
    }
  }

  ["7"] =
  {
    width = 0.6
    rx = { 285,347 }
    ry = { 341,232 }
    points =
    {
      { x=285,y=232 }
      { x=347,y=232 }
      { x=307,y=341 }
    }
  }

  ["8"] =
  {
    width = 0.6
    rx = { 388,451 }
    ry = { 340,231 }
    points =
    {
      { x=415,y=281 }
      { x=427,y=281 }
      { x=442,y=272 }
      { x=449,y=261 }
      { x=449,y=250 }
      { x=441,y=238 }

      { x=427,y=231 }
      { x=415,y=231 }
      { x=399,y=239 }
      { x=392,y=250 }
      { x=392,y=261 }
      { x=400,y=272 }

      { x=415,y=281 }
      { x=427,y=281 }
      { x=442,y=290 }
      { x=451,y=302 }
      { x=451,y=318 }
      { x=444,y=331 }

      { x=427,y=340 }
      { x=415,y=340 }
      { x=397,y=331 }
      { x=388,y=318 }
      { x=388,y=302 }
      { x=398,y=290 }
      { x=415,y=281 }
    }
  }

  ["9"] =
  {
    width = 0.6
    rx = { 490,554 }
    ry = { 339,232 }
    points =
    {
      { x=494,y=335 }
      { x=511,y=339 }
      { x=522,y=339 }
      { x=534,y=334 }
      { x=547,y=318 }
      { x=554,y=294 }
      { x=554,y=274 }
      { x=549,y=249 }
      { x=538,y=236 }

      { x=528,y=232 }
      { x=516,y=232 }
      { x=499,y=240 }
      { x=490,y=257 }
      { x=490,y=272 }
      { x=500,y=290 }
      { x=515,y=297 }
      { x=526,y=297 }
      { x=539,y=290 }
      { x=548,y=277 }
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
    return T.x + x * T.w, T.y - y * T.h
  end

  -- italics !!
  T.Ifunc = function(T, x, y)
    return T.x + (x + y * 0.5 * T.h / T.w) * T.w, T.y - y * T.h
  end

  -- text shorter at the top
  T.KKfunc = function(T, x, y)
    local m = x / T.max_along
    m = ((m * 2) - 1) / 3
    return T.x + (x + (1-y) * m) * T.w, T.y - y * T.h
  end

  -- text shrinking towards the right
  T.RRfunc = function(T, x, y)
    local m = x / T.max_along
    m = 1.4 - m * 0.8
    local n = (1.0 - m) / 2
    return T.x + x * T.w, T.y - (y * m + n) * T.h
  end

  return T
end



function Title_make_stroke(T, x1,y1, x2,y2)
  x1, y1 = T.func(T, x1, y1)
  x2, y2 = T.func(T, x2, y2)

  gui.title_draw_line(x1, y1, x2, y2)
end



function Title_draw_char(T, ch)
  -- we draw lowercase characters as smaller uppercase ones
  local local_w = 1.0
  local local_h = 1.0

  if string.match(ch, "[a-z]") then
    local_w = 0.8
    local_h = 0.7

    ch = string.upper(ch)
  end


  local info = TITLE_LETTER_SHAPES[ch]

  -- ignore any unknown characters
  if not info then return end


  -- draw the lines --

  for i = 1, #info.points - 1 do
    local x1 = info.points[i].x
    local y1 = info.points[i].y

    local x2 = info.points[i + 1].x
    local y2 = info.points[i + 1].y

    if not x1 or not x2 then continue end

    x1 = T.along + x1 * local_w ; y1 = y1 * local_h
    x2 = T.along + x2 * local_w ; y2 = y2 * local_h

    Title_make_stroke(T, x1,y1, x2,y2)
  end

  -- advance horizontally for next character
  T.along = T.along + local_w * (info.width + (T.spacing or 0.3))
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

  color_str = "#" .. color_str

  gui.title_prop("color", color_str)

  local bw = 0 + ("0x" .. string.sub(box_str, 1, 1))
  local bh = 0 + ("0x" .. string.sub(box_str, 2, 2))

  gui.title_prop("box_w", bw)
  gui.title_prop("box_h", bh)

--gui.title_prop("pen_type", "slash2")

-- TEST CRUD
  gui.title_prop("render_mode", "gradmirror")
  gui.title_prop("color2", "#321")
  gui.title_prop("grad_y1", 50)
  gui.title_prop("grad_y2", 100)

-- MORE TEST CRUD
  gui.title_prop("render_mode", "random")
  gui.title_prop("color",  "#000")
  gui.title_prop("color2", "#fff")
  gui.title_prop("color3", "#fff")
  gui.title_prop("color4", "#fff")
end



function Title_styled_string(T, text, styles)
  each style in styles do
    Title_parse_style(T, style)
    Title_draw_string(T, text)
  end
end



function Title_styled_string_centered(T, text, styles)

  T.max_along = Title_measure_string(text, 1.0, T.spacing)

  local width = Title_measure_string(text, T.w, T.spacing)

  T.x = int((320 - width) * 0.5) + 4

  Title_styled_string(T, text, styles)
end



function Title_widest_size_to_fit(text, box_w, max_w, spacing)
  for w = max_w, 11, -1 do
    if Title_measure_string(text, w, spacing) <= box_w then
      return w
    end
  end

  return 10
end


------------------------------------------------------------------------


function Title_add_background()
  local DIR = "games/" .. assert(GAME.game_dir) .. "/titles"

  local backgrounds = gui.scan_directory(DIR, "*.tga")

  if not backgrounds or table.empty(backgrounds) then
    error("Failed to scan 'data/titles' directory")
  end

  local filename = rand.pick(backgrounds)

  gui.printf("Using title background: %s\n", filename)

  gui.title_load_image(0, 0, DIR .. "/" .. filename)
end



function Title_split_into_lines()
  --
  -- Determines whether to use one or two main lines for the title.
  -- It will depend on the length of the title (somewhat).
  -- Return can be:
  --   (a) a single string -- use it on a single line
  --   (b) two or three words -- first two are main lines, third is the
  --       little "of", "in", etc.. to be placed in-between
  --
  local words = {}

  for w in string.gmatch(GAME.title, "%w+") do
    table.insert(words, w)
  end

  -- handle titles like "X of the Y"
  if #words >= 4 then
    words[2] = words[2] .. " " .. words[3]
    words[3] = words[4]
  end

  -- no choice?
  if #words < 2 then return GAME.title end

  local single_prob = 40

  if #GAME.title <= 11 then single_prob = 75 end
  if #GAME.title >= 17 then single_prob =  0 end

  if rand.odds(single_prob) then return GAME.title end

  -- multiple lines
  if words[3] then
    return words[1], words[3], words[2]
  else
    return words[1], words[2]
  end
end



function Title_add_title()

  -- determine what kind of sub-title we will draw (if any)
  local sub_title_mode = "none"

  if rand.odds(67) then
    sub_title_mode = "phrase"

    if #GAME.sub_title <= 4 and string.upper(GAME.sub_title) == GAME.sub_title then
      sub_title_mode = "version"
    end
  end


  local TITLE_STYLES =
  {
    {
      styles = { "999:77", "000:55" }
      alt    = { "000:77", "bbb:33" }

      spacing = 0.45
    }

    {
      styles = { "ff0:77", "730:55" }
      alt    = { "730:77", "ff0:33" }

      spacing = 0.45
    }

    {
      styles = { "00f:99", "fed:55" }
      alt    = { "fed:99", "00a:55" }

      spacing = 0.45
    }
  }

  local info = rand.pick(TITLE_STYLES)


  -- determine if we have one or two main lines
  local line1, line2, mid_line = Title_split_into_lines()

line1 = string.upper(line1)
if line2 then line2 = string.upper(line2) end


  local title_y = 95

  if line2 then title_y = title_y - 35 end
  if sub_title_mode == "none" then title_y = title_y + 10 end


  -- choose font sizes for the main lines
  local w1, w2

  if not line2 then
    w1 = Title_widest_size_to_fit(line1, 312, 50, info.spacing)
    w2 = w1
  else
    w1 = Title_widest_size_to_fit(line1, 246, 50, info.spacing)
    w2 = Title_widest_size_to_fit(line2, 216, 50, info.spacing)

    if false then
      w1 = math.min(w1, w2)
      w2 = w1
    end
  end


  local hh = 40

  if line2 and mid_line then hh = 30 end


  -- draw the main title lines

  local T = Title_get_normal_transform(0, title_y, w1, hh)

  if info.spacing then T.spacing = info.spacing end

  local style1 = info.styles
  local style2 = info.alt

  if rand.odds(30*0) and sub_title_mode != "version" then
    style1, style2 = style2, style1
  end


--gui.title_load_image(322, 0, "data/masks/camo1.tga")



  Title_styled_string_centered(T, line1, style1)

  if mid_line then
    T.w = math.min(w1, w2) * 0.7
    T.h = T.h * 0.7
    T.y = title_y + 26

    Title_styled_string_centered(T, mid_line, style2)
  end

  if line2 then
    title_y = title_y + 60

    T.w = w2
    T.h = hh
    T.y = title_y

    Title_styled_string_centered(T, line2, style1)
  end


  -- draw the sub-title

  if sub_title_mode == "none" then return end

  local SUB_STYLES =
  {
    {
      alt = { "300:44", "f00:22" }
      spacing = 0.4
    }
    {
      alt = { "242:44", "6c6:22" }
      spacing = 0.3
    }
    {
      alt = {"300:44", "f94:22"}
      spacing = 0.3
    }
    {
      alt = {"00c:44", "005:22"}
      spacing = 0.4
    }
    {
      alt = {"431:44", "a86:22"}
      spacing = 0.3
    }
    {
      alt = {"707:44", "f0f:22"}
      spacing = 0.5
    }
  }

  T.y = 160

  if not line2 then T.y = T.y - 25 end

  if sub_title_mode == "version" then
    -- often use the same style
    if rand.odds(35) then
      info = rand.pick(TITLE_STYLES)
    end

    T.w = math.min(w1, w2)
    T.h = T.w

    if line2 then
      T.h = T.h * 0.7
    else
      T.w = T.w * 1.5
    end

    T.y = T.y + 10

  else  -- a phrase

    info = rand.pick(SUB_STYLES)

    T.w = 12
    T.h = 16
  end


  Title_styled_string_centered(T, GAME.sub_title, info.alt)
end



function Title_add_credit()
  gui.title_prop("color", "#000")

  gui.title_draw_rect(310, 190, 10, 10)

  gui.title_load_image(285, 163, "data/logo1.tga")
end



function process_raw_fonts()
  local function update(CH)
    gui.debugf("    points =\n")
    gui.debugf("    {\n")

    each P in CH.points do
      local x = P.x
      local y = P.y

      if x == nil and y == nil then
        gui.debugf("      {}\n")
        continue
      end

      x = (P.x - CH.rx[1]) / (CH.rx[2] - CH.rx[1])
      y = (P.y - CH.ry[1]) / (CH.ry[2] - CH.ry[1])

      x = x * 0.6

      P.x = x
      P.y = y

      gui.debugf("      { x=%1.4f, y=%1.4f }\n", x, y)
    end

    gui.debugf("    }\n")

    CH.rx = nil
    CH.ry = nil
  end

  local keys = table.keys(TITLE_LETTER_SHAPES)
  table.sort(keys)

  each let in keys do
    local CH = TITLE_LETTER_SHAPES[let]
    if CH.rx then
      gui.debugf("RAW FONT '%s'\n", let)
      update(CH)
    end
  end
end



function Title_generate()
  assert(GAME.title)
  assert(GAME.PALETTES)
  assert(GAME.PALETTES.normal)


process_raw_fonts()


  gui.title_create(320, 200, "#000")

  gui.title_set_palette(GAME.PALETTES.normal)

  Title_add_background()

  gui.title_write("INTERPIC")

  Title_add_credit()
  Title_add_title()

  gui.title_write("TITLEPIC")

  gui.title_free()
end

