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
-- Only contains uppercase letters, digits, and some punctuation.
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
      { x=0.43750, y=1.00000 }
      { x=0.22500, y=0.94500 }
      { x=0.04167, y=0.76667 }
      { x=0.00000, y=0.52500 }
      { x=0.03333, y=0.27917 }
      { x=0.14167, y=0.08333 }
      { x=0.29167, y=0.00000 }
      { x=0.43750, y=0.00000 }
      { x=0.60000, y=0.03000 }
      { x=0.75417, y=0.08500 }
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
    ry = { 338,232 }
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
    x, y     -- origin coordinate for transform function
             -- x is the left coord, y is the baseline

    func     -- function(T, x, y) to transform coords to screen space

    along    -- current horizontal position when drawing a string
             -- starts at 0.  units are "local" (NOT screen space)

    spacing  -- space between characters (in "local" space)

    max_along  -- measured width of current string (in "local" space)


    ==== style stuff ====

    fw, fh   -- font width / height

    thick    -- thickness of the drawing pen
--]]


function Title_transform_Straight(T, x, y)
  -- simplest transform: a pure translation
  return T.x + x * T.fw, T.y - y * T.fh
end


function Title_transform_Italics(T, x, y)
  return T.x + x * T.fw + (y - 0.5) * T.fh * 0.3, T.y - y * T.fh
end


function Title_transform_Perspective(T, x, y)
  local m = x / T.max_along

  m = m ^ 0.7
  x = m * T.max_along

  m = 1.2 - m * 0.6

  local n = (1.0 - m) / 2

  return T.x + x * T.fw, T.y - (y * m + n) * T.fh
end


function Title_transform_FatTop(T, x, y)
  local m = x / T.max_along

  m = (1 - (m * 2)) / 3

  return T.x + x * T.fw + (1-y) * m * T.fh, T.y - y * T.fh
end


function Title_transform_FatBottom(T, x, y)
  local m = x / T.max_along

  m = (1 - (m * 2)) / 3

  return T.x + x * T.fw + y * m * T.fh, T.y - y * T.fh
end



TITLE_TRANSFORM_LIST =
{
  straight    = Title_transform_Straight
  italics     = Title_transform_Italics
  perspective = Title_transform_Perspective
  fat_top     = Title_transform_FatTop
  fat_bottom  = Title_transform_FatBottom
}


------------------------------------------------------------------------


function Title_make_stroke(T, x1,y1, x2,y2)
  x1, y1 = T.func(T, x1, y1)
  x2, y2 = T.func(T, x2, y2)

  gui.title_draw_line(x1 + T.ofs_x, y1 + T.ofs_y, x2 + T.ofs_x, y2 + T.ofs_y)
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
  T.along = T.along + local_w * info.width + T.spacing
end



function Title_measure_char(ch, spacing)
  local local_w = 1.0

  if string.match(ch, "[a-z]") then
    local_w = 0.8
    ch = string.upper(ch)
  end

  local info = TITLE_LETTER_SHAPES[ch]

  if not info then return 0 end

  return local_w * info.width + spacing
end



function Title_draw_string(T, text)
  T.along = 0

  for i = 1, #text do
    local ch = string.sub(text, i, i)

    Title_draw_char(T, ch)
  end
end



function Title_measure_string(text, spacing)
  local width = 0

  for i = 1, #text do
    local ch = string.sub(text, i, i)

    -- do not include the spacing on the final letter
    if i == #text then spacing = 0 end

    width = width + Title_measure_char(ch, spacing)
  end

  return width
end



function Title_centered_string(T, mx, my, text, style)
  assert(style.mode)

  -- do not create really tall letters
  if T.fh / T.fw > 2.5 then
     T.fh = T.fw * 2.5
  end


  -- measure string and set position --

  local width = Title_measure_string(text, T.spacing)

  T.max_along = width

  width = width * T.fw

  T.x = mx - width * 0.5
  T.y = my + T.fh  * 0.5

  local base_ofs = 0 - T.thick / 2

  local thick


 
  -- TODO : support "thin_horiz" and "thin_vert" pens
  -- [ not real pens, just use different box_w than box_h ]

  gui.title_prop("pen_type", T.pen_type or "circle")


  -- do the outlines --

  if style.outlines then
    gui.title_prop("render_mode", "solid")

    for i = #style.outlines, 1, -1 do
      local outline = style.outlines[i]

      gui.title_prop("color", outline)

      if style.outline_mode == "shadow" then
        thick = T.thick + i

        T.ofs_x = base_ofs
        T.ofs_y = base_ofs

      elseif style.outline_mode == "shadow2" then
        thick = T.thick + i

        T.ofs_x = base_ofs - i
        T.ofs_y = base_ofs

      elseif style.outline_mode == "zoom" then
        thick = T.thick + i

        T.ofs_x = base_ofs - i / 2
        T.ofs_y = base_ofs + i * 1.5

      else  -- the normal "surround" mode
        thick = T.thick + i * 2

        T.ofs_x = base_ofs - i
        T.ofs_y = base_ofs - i
      end

      gui.title_prop("box_w", thick)
      gui.title_prop("box_h", thick)

      Title_draw_string(T, text)
    end
  end


  -- do central part of text --

  if style.mode == "texture" then
    gui.title_prop("texture", "data/masks/" .. style.texture .. ".tga")
  else
    gui.title_prop("render_mode", style.mode)

    for k = 1, 4 do
      if style.colors[k] then
        gui.title_prop("color" .. k, style.colors[k])
      end
    end
  end

  if style.mode == "gradient" or style.mode == "gradient3" then
    gui.title_prop("grad_y1", T.y - T.fh + 1)
    gui.title_prop("grad_y2", T.y - 1)
  end

  gui.title_prop("box_w", T.thick)
  gui.title_prop("box_h", T.thick)

  T.ofs_x = base_ofs
  T.ofs_y = base_ofs

  Title_draw_string(T, text)
end



function Title_widest_size_to_fit(text, box_w, max_w, spacing)
  for w = max_w, 11, -1 do
    if w * Title_measure_string(text, spacing) <= box_w then
      return w
    end
  end

  return 10
end


------------------------------------------------------------------------


TITLE_MAIN_STYLES =
{
  --- Solid styles ---

  solid_blue =
  {
    prob = 25

    mode = "solid"

    colors = { "#00f" }

    outline_mode = "shadow2"
    outlines = { "#00c", "#009", "#006", "#000" }

    narrow = 0.6

    alt =
    {
      mode = "solid"
      colors = { "#ccf" }
      outline_mode = "zoom"
      outlines = { "#77f", "#00f", "#000" }
    }
  }

  solid_red =
  {
    prob = 25

    mode = "solid"

    colors = { "#f00" }

    outline_mode = "shadow2"
    outlines = { "#c00", "#900", "#600", "#000" }

    narrow = 0.6

    alt =
    {
      mode = "solid"
      colors = { "#fff" }
      outline_mode = "surround"
      outlines = { "#f44", "#900", "#000" }
    }
  }

  solid_green =
  {
    prob = 25

    mode = "solid"

    colors = { "#0f0" }

    outline_mode = "shadow"
    outlines = { "#0c0", "#090", "#060", "#000" }

    narrow = 0.4
  }

  solid_black_lightblue =
  {
    prob = 25

    mode = "solid"

    colors = { "#000" }

    outlines = { "#009", "#99f", "#ddd" }

    narrow = 0.7
  }

  shaded_white_n_blue =
  {
    mode = "solid"

    colors = { "#fff" }

    outline_mode = "shadow"
    outlines = { "#bbf", "#99f", "#55f", "#22f", "#00f", "#009", "#004", "#000" }

    narrow = 0.4
  }

  shaded_white_n_red =
  {
    mode = "solid"

    colors = { "#fff" }

    outline_mode = "zoom"
    outlines = { "#f99", "#f66", "#e00", "#b00", "#800", "#400", "#000" }

    narrow = 0.4
  }

  --- Gradient styles ---

  gradient_white_black =
  {
    mode = "gradient"

    colors = { "#fff", "#000" }

    outlines = { "#000", "#555" }
  }

  gradient_green_black =
  {
    mode = "gradient"

    colors = { "#7e6", "#000" }

    outlines = { "#231", "#342" }
  }

  gradient_pink_black =
  {
    mode = "gradient3"

    colors = { "#c77", "#611", "#000" }

    outlines = { "#000", "#933" }
  }

  gradient_black_brown =
  {
    mode = "gradient3"

    colors = { "#000", "#752", "#fb8" }

    outlines = { "#432", "#000" }
  }

  grad3_white_red_black =
  {
    mode = "gradient3"

    colors = { "#fff", "#f00", "#000" }

    outlines = { "#c00" }
  }

  grad3_white_blue_black =
  {
    mode = "gradient3"

    colors = { "#fff", "#00f", "#000" }

    outlines = { "#00c" }
  }

  grad3_white_orange_black =
  {
    mode = "gradient3"

    colors = { "#fff", "#720", "#000" }

    outlines = { "#000" }
  }

  gradmirror_orange_white =
  {
    mode = "gradient3"

    colors = { "#720", "#fff", "#720" }

    outlines = { "#000" }
  }

  gradmirror_yellow_orange =
  {
    mode = "gradient3"

    colors = { "#ff7", "#620", "#ff7" }

    outlines = { "#000", "#000", "#000" }

    narrow = 0.7
  }

  --- Textured styles ---

  groovy_1 =
  {
    mode = "texture"

    texture = "groovy1"

    outlines = { "#000", "#864", "#000" }
  }

  compgreen_1 =
  {
    prob = 15

    mode = "texture"

    texture = "compgreen"

    outlines = { "#000", "#cb4" }

    narrow = 0.9
  }

  yellowish_1 =
  {
    mode = "texture"

    texture = "yellowish"

    outlines = { "#654", "#ca8", "#000" }
  }

  redrock_1 =
  {
    mode = "texture"

    texture = "redrock"

    outline_mode = "zoom"
    outlines = { "#c66", "#933", "#622", "#511" }
  }

  fireblu_1 =
  {
    mode = "texture"

    texture = "fireblu"

    outlines = { "#ccc", "#000" }
  }

  shawn_1 =
  {
    mode = "texture"

    texture = "shawn_r"

    outlines = { "#643", "#321", "#000" }

    narrow = 0.8
  }
}


TITLE_SUB_STYLES =
{
  white =
  {
    mode = "solid"
    colors = { "#ddd" }
    outlines = { "#000" }
  }

  yellow =
  {
    prob = 25
    mode = "solid"
    colors = { "#ff7" }
    outlines = { "#431" }
  }

  yellow_outline =
  {
    mode = "solid"
    colors = { "#000" }
    outlines = { "#ff7" }
  }

  red_outline =
  {
    mode = "solid"
    colors = { "#000" }
    outlines = { "#f44" }
  }

  lightbrown =
  {
    mode = "solid"
    colors = { "#ea7" }
    outlines = { "#431" }
  }

  green =
  {
    mode = "solid"
    colors = { "#6d5" }
    outlines = { "#242" }
  }

  purple =
  {
    mode = "solid"
    colors = { "#f0f" }
    outlines = { "#505" }
  }
}


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
  --   (c) fourth value can be "The"
  --
  local words = {}

  for w in string.gmatch(GAME.title, "%w+") do
    table.insert(words, w)
  end

  local top_line

  if words[1] == "The" or words[1] == "A" or words[1] == "An" then
    top_line = table.remove(words, 1)
  end

  -- handle titles like "X of the Y"
  if #words >= 4 then
    words[2] = words[2] .. " " .. words[3]
    words[3] = words[4]
  end

  -- no choice?
  if #words < 2 then return GAME.title end

  local split_prob = 70

  if #GAME.title <= 12 then split_prob =  30 end
  if #GAME.title >= 17 then split_prob = 100 end

  if not rand.odds(split_prob) then return GAME.title end

  -- multiple lines
  if words[3] then
    return words[1], words[3], words[2], top_line
  else
    return words[1], words[2], nil,      top_line
  end
end



function Title_calc_max_thickness(fw, fh)
  -- TODO (1) : if pen style is thin_horiz/thin_vert, ignore that axis

  -- TODO (2) : slighly reduced value for perspective/fat_top/fat_bottom

  fw = math.min(fw, fh)

  fw = int(fw / 5 + 0.5)

  if fw < 1 then return 1 end

  return fw
end



function Title_pick_style(style_tab, reqs)

  local function matches(def)
    return true
  end

  local tab = {}

  each name,def in style_tab do
    if matches(def) then
      tab[name] = def.prob or 50
    end
  end

  if table.empty(tab) then
    error("No title styles matching requirements")
  end

  local name = rand.key_by_probs(tab)

  return style_tab[name]
end



function Title_add_title()

  -- determine if we have one or two main lines
  local line1, line2, mid_line, top_line = Title_split_into_lines()

  if line1 then line1 = string.upper(line1) end
  if line2 then line2 = string.upper(line2) end

  if mid_line then mid_line = string.upper(mid_line) end


  -- determine what kind of sub-title we will draw (if any)
  local sub_title

  local bottom_line

  if rand.odds(67) then
    if #GAME.sub_title <= 4 and string.upper(GAME.sub_title) == GAME.sub_title then
      -- this will be part of main title (a "version" string)
      bottom_line = GAME.sub_title
    else
      sub_title = GAME.sub_title
    end
  end


  local main_lines = 1 + sel(line2, 1, 0)

  local other_lines = sel(top_line, 1, 0) + sel(mid_line, 1, 0) + sel(bottom_line, 1, 0)

  local num_lines  = main_lines + other_lines


  -- figure out sizes of main area and sub-title area
  local bb_main = { w=280 }
  local bb_sub  = { w=240 }

  bb_main.h = 110 + num_lines * 5
  bb_sub.h  =  50 - num_lines * 5

  bb_main.x = (320 - bb_main.w) / 2
  bb_main.y = 20

  bb_sub.x  = (320 - bb_sub.w) / 2
  bb_sub.y  = 190 - bb_sub.h

  if not sub_title then
    bb_main.w = 260
    bb_main.x = (320 - bb_main.w) / 2

    bb_main.h = sel(bottom_line, 145, 135)
    bb_main.y = sel(bottom_line,  20,  22)

    -- dummy values (not used)
    bb_sub.h = 5
    bb_sub.y = 195
  end

  if top_line then
    bb_main.y = bb_main.y - 5
    bb_main.h = bb_main.h + 5
  end

--[[
  stderrf("bb_main =\n%s\n\n", table.tostr(bb_main))
  stderrf("bb_sub  =\n%s\n\n", table.tostr(bb_sub))

  gui.title_prop("color", "#070")
  gui.title_draw_rect(bb_main.x, bb_main.y, bb_main.w, bb_main.h)

  gui.title_prop("color", "#00f")
  gui.title_draw_rect(bb_sub.x, bb_sub.y, bb_sub.w, bb_sub.h)
--]]


  -- pick the styles to use
  local style = Title_pick_style(TITLE_MAIN_STYLES, {})

  -- FIXME : this used for the smaller words, often make it different (and simpler)
  local mid_style = style.alt or style


  -- vertical sizing of the main title
  local line_h = bb_main.h / (main_lines * 2 + other_lines)


  -- choose font sizes for the main lines
  local w1, w2

  local spacing = 0.45

  if not line2 then
    w1 = Title_widest_size_to_fit(line1, bb_main.w, 50, spacing)
    w2 = w1
  else
    w1 = Title_widest_size_to_fit(line1, bb_main.w - 30, 50, spacing)
    w2 = Title_widest_size_to_fit(line2, bb_main.w,      50, spacing)

    if false then
      w1 = math.min(w1, w2)
      w2 = w1
    end
  end

  local w3 = math.min(w1, w2) * 0.6


  local h1 = line_h * 1.2
  local h2 = line_h * 1.4

  local h3 = line_h * 0.7

--[[
stderrf("line_h = %1.1f\n", line_h)
stderrf("font sizes: %d x %d  |  %d x %d  |  %d x %d\n", w1,h1, w2,h2, w3,h3)
--]]


  -- FIXME !!! find a good naming scheme for the title parts


  -- decide geometry for major parts --

  local line1_T = { fw=w1, fh=h1, spacing=spacing }
  local line2_T = { fw=w2, fh=h2, spacing=spacing }
  local   mid_T = { fw=w3, fh=h3, spacing=spacing }

  local GEOMETRIES = { straight=60, italics=30, perspective=20, fat_bottom=20, fat_top=10 }

  local geometry1 = rand.key_by_probs(GEOMETRIES)

  line1_T.func = TITLE_TRANSFORM_LIST[geometry1]
  line2_T.func = TITLE_TRANSFORM_LIST[geometry1]
    mid_T.func = TITLE_TRANSFORM_LIST[geometry1]

  if rand.odds(50) or geometry1 == "perspective" then
    if geometry1 == "straight" then
      mid_T.func = TITLE_TRANSFORM_LIST["italics"]
    else
      mid_T.func = TITLE_TRANSFORM_LIST["straight"]
    end
  end


  line2_T.thick = Title_calc_max_thickness(line2_T.fw, line2_T.fh) * (style.narrow or 1)
  line1_T.thick = line2_T.thick

  mid_T.thick = Title_calc_max_thickness(mid_T.fw, mid_T.fh) * (mid_style.narrow or 1)


  -- decide pen type
  local PEN_TYPES = { circle=50, box=50 }

  if not style.texture then
    PEN_TYPES.slash  = 15
    PEN_TYPES.slash2 = 15
  end

  line1_T.pen_type = rand.key_by_probs(PEN_TYPES)
  line2_T.pen_type = line1_T.pen_type


  --- draw main title lines ---

  local mx = 160
  local my = bb_main.y

  if top_line then
    Title_centered_string(mid_T, mx, my + line_h/2, top_line, mid_style)
    my = my + line_h
  end

  if line1 then
    Title_centered_string(line1_T, mx, my + line_h, line1, style)
    my = my + line_h * 2
  end

  if mid_line then
    Title_centered_string(mid_T, mx, my + line_h/2 + 1, mid_line, mid_style)
    my = my + line_h
  end

  if line2 then
    Title_centered_string(line2_T, mx, my + line_h, line2, style)
    my = my + line_h * 2
  end

  if bottom_line then
    mid_T.fw = mid_T.fw * 2
    mid_T.fh = mid_T.fh * 1.4

    my = my + 10

    Title_centered_string(mid_T, mx, my + line_h/2, bottom_line, mid_style)
  end


  --- draw the sub-title ---

  if sub_title then
    -- create the transform
    local sub_T = {}

    -- TODO : more variety than this [ depends on the other parts though! ]
    local sub_geometry = "straight"

    sub_T.func = TITLE_TRANSFORM_LIST[sub_geometry]
    assert(sub_T.func)

    local mx = 160
    local my = bb_sub.y + bb_sub.h / 2

    style = Title_pick_style(TITLE_SUB_STYLES, {})

    sub_T.fw = rand.sel(25, 13, 11)
    sub_T.fh = 13
    sub_T.spacing = rand.sel(50, 0.3, 0.4)

    sub_T.thick = Title_calc_max_thickness(sub_T.fw, sub_T.fh)

    -- adjust for a mix of upper/lower case
    if string.upper(GAME.sub_title) != GAME.sub_title then
      my = my - sub_T.fh / 8
    end

    Title_centered_string(sub_T, mx, my, GAME.sub_title, style)
  end
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

