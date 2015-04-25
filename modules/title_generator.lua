----------------------------------------------------------------
--  MODULE: title-pic generator
----------------------------------------------------------------
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
----------------------------------------------------------------

TITLE_GEN = { }


-- The shapes of these characters are based on the DejaVu TTF font.

TITLE_GEN.letter_shapes =
{
  ["-"] =
  {
    lines = { 270, 240,  351, 240, -1,-1,
      0, 0 }
  }

  [":"] =
  {
    lines = { 300, 210,  320, 210, -1,-1,
      300, 270,  320, 210, -1,-1,
      0, 0 }
  }

  ["'"] =
  {
    lines = { 310, 87,  310, 115,  300, 135,  290, 145, -1,-1,
      0, 0 }
  }

  ["A"] =
  {
    lines = { 213, 326,  310, 89,  407, 326, -1,-1,
      247, 247,  374, 247, -1,-1,
      0, 0 }
  }

  ["B"] =
  {
    lines = { 249, 327,  249, 87,  332, 87,  355, 94,  379, 119,  383, 141,  376, 174,  353, 193,  319, 198,  249, 198, -1,-1,
      319, 198,  373, 216,  389, 239,  392, 260,  383, 299,  357, 322,  332, 327,  249, 327, -1,-1,
      0, 0 }
  }

  ["C"] =
  {
    lines = { 407, 107,  369, 87,  332, 81,  281, 93,  237, 143,  227, 201,  235, 260,  261, 307,  297, 328,  332, 334,  371, 327,  408, 309, -1,-1,
      0, 0 }
  }

  ["D"] =
  {
    lines = { 227, 327,  227, 87,  296, 87,  345, 97,  385, 125,  403, 173,  406, 203,  402, 253,  379, 297,  331, 323,  301, 327,  227, 327, -1,-1,

      0, 0 }
  }

  ["E"] =
  {
    lines = { 383, 327,  251, 327,  251, 87,  380, 87, -1,-1,
      251, 198,  376, 198, -1,-1,
      0, 0 }
  }

  ["F"] =
  {
    lines = { 261, 327,  261, 87,  376, 87, -1,-1,
      261, 198,  364, 198, -1,-1,
      0, 0 }
  }

  ["G"] =
  {
    lines = { 332, 217,  401, 217,  401, 316,  361, 331,  324, 334,  281, 326,  243, 300,  219, 257,  213, 211,  224, 147,  250, 107,  294, 87,  323, 84,  372, 89,  400, 103, -1,-1,
      0, 0 }
  }

  ["H"] =
  {
    lines = { 231, 327,  231, 87, -1,-1,
      231, 199,  391, 199, -1,-1,
      391, 327,  391, 87, -1,-1,
      0, 0 }
  }

  ["I"] =
  {
    lines = { 310, 327,  310, 87, -1,-1,
      270, 327,  350, 327, -1,-1,
      270, 87,   350, 87, -1,-1,
      0, 0 }
  }

  ["J"] =
  {
    lines = { 270, 87,  350, 87, -1,-1,
      312, 87,   312, 261,  304, 303,  290, 320,  269, 327,  243, 327, -1,-1,
      0, 0 }
  }

  ["K"] =
  {
    lines = { 263, 327,  263, 87, -1,-1,
      274, 199,  393, 87, -1,-1,
      274, 199,  405, 327, -1,-1,
      0, 0 }
  }

  ["L"] =
  {
    lines = { 391, 327,  264, 327,  264, 87, -1,-1,
      0, 0 }
  }

  ["M"] =
  {
    lines = { 224, 327,  224, 87,  230, 87,  310, 276,  390, 87,  396, 87,  396, 327, -1,-1,
      0, 0 }
  }

  ["N"] =
  {
    lines = { 231, 327,  231, 87,  237, 87,  370, 327,  376, 327,  376, 87, -1,-1,
      0, 0 }
  }

  ["O"] =
  {
    lines = { 213, 205,  222, 147,  249, 104,  283, 85,  311, 82,  363, 95,  395, 132,  408, 174,  411, 209,  401, 268,  371, 312,  339, 329,  310, 333,  276, 326,  237, 299,  218, 254,  213, 205, -1,-1,
      0, 0 }
  }

  ["P"] =
  {
    lines = { 256, 327,  256, 87,  326, 87,  359, 97,  381, 124,  386, 151,  377, 189,  348, 214,  325, 218,  256, 218, -1,-1,
      0, 0 }
  }

  ["Q"] =
  {
    lines = { 213, 205,  222, 147,  249, 104,  283, 85,  311, 82,  363, 95,  395, 132,  408, 174,  411, 209,  401, 268,  371, 312,  339, 329,  310, 333,  276, 326,  237, 299,  218, 254,  213, 205, -1,-1,
      344, 335,  380, 374, -1,-1,
      0, 0 }
  }

  ["R"] =
  {
    lines = { 256, 327,  256, 87,  326, 87,  359, 97,  381, 124,  386, 151,  377, 189,  348, 214,  325, 218,  256, 218, -1,-1,
      331, 225,  351, 238,  379, 320,  400, 327, -1,-1,
      0, 0 }
  }

  ["S"] =
  {
    lines = { 235, 312,  277, 327,  310, 333,  345, 326,  373, 307,  384, 269,  375, 238,  341, 213,  273, 195,  247, 173,  240, 140,  250, 107,  278, 87,  312, 82,  351, 87,  380, 102, -1,-1,
      0, 0 }
  }

  ["T"] =
  {
    lines = { 311, 327,  311, 87, -1,-1,
      211, 87,  411, 87, -1,-1,
      0, 0 }
  }

  ["U"] =
  {
    lines = { 230, 87,  230, 241,  236, 286,  253, 313,  282, 329,  309, 333,  336, 330,  363, 317,  380, 296,  389, 241,  389, 87, -1,-1,
      0, 0 }
  }

  ["V"] =
  {
    lines = { 213, 87,  303, 327,  309, 327,  410, 87, -1,-1,
      0, 0 }
  }

  ["W"] =
  {
    lines = { 170, 87,  231, 327,  241, 327,  303, 187, 311, 187,  369, 327, 379, 327,  441, 87, -1,-1,
      0, 0 }
  }

  ["X"] =
  {
    lines = { 223, 329,  389, 87, -1,-1,
      234,  87,  397, 327, -1,-1,
      0, 0 }
  }

  ["Y"] =
  {
    lines = { 308, 328,  311, 209,  224, 87, -1,-1,
      311, 209,  395, 87, -1,-1,
      0, 0 }
  }

  ["Z"] =
  {
    lines = { 410, 327,  211, 327,  405, 87,  215, 87, -1,-1,
      0, 0 }
  }
}



function process_one_letter(name, info)
  gui.printf("  [\"%s\"] = \n", name)
  gui.printf("  {\n")

  local SIZE = (327 - 87)

  -- determine width --

  local x_min =  9999
  local x_max = -9999

  for i = 1, #info.lines, 2 do
    local x = info.lines[i]

    if x < 1 then continue end

    x_min = math.min(x_min, x)
    x_max = math.max(x_max, x)
  end

  local width = (x_max - x_min) / SIZE

  gui.printf("    width = %1.4f\n", width)

  -- translate and scale lines --

  gui.printf("    points =\n")
  gui.printf("    {\n")

  for i = 1, #info.lines, 2 do
    local x = info.lines[i]
    local y = info.lines[i + 1]

    if x == 0 then continue end

    if x < 0 then
      if info.lines[i + 2] and info.lines[i+2] > 0 then
        gui.printf("      {}\n")
      end
      continue
    end

    x = (x - x_min) / SIZE
    y = (y -    87) / SIZE

    y = 1.0 - y  -- distance up from base-line

    gui.printf("      { x=%1.5f, y=%1.5f }\n", x, y);
  end

  gui.printf("    }\n")
  gui.printf("  }\n")
  gui.printf("\n")
end



function process_letters()
  local keys = table.keys(TITLE_GEN.letter_shapes)
  table.sort(keys)

  gui.printf("TITLE_GEN.letter_shapes =\n")
  gui.printf("{\n")

  each name in keys do
    local info = TITLE_GEN.letter_shapes[name]
    assert(info)

    process_one_letter(name, info)
  end

  gui.printf("}\n")
end



function TITLE_GEN.draw_char(ch, trans, style)
  local info = TITLE_GEN.letter_shapes[ch]

  if not info then return end

  for i = 0, #info.lines - 1, 2 do
    local x1 = info.lines[i + 1]
    local y1 = info.lines[i + 2]
    local x2 = info.lines[i + 3]
    local y2 = info.lines[i + 4]

    if not x1 or not x2 then break; end

stderrf("LINE : (%d %d) .. (%d %d)\n", x1,y1, x2,y2)

    if x1 < 1 or x2 < 1 then continue end

local div = 10

    x1 = trans.x + x1 / div
    y1 = trans.y + y1 / div
    x2 = trans.x + x2 / div
    y2 = trans.y + y2 / div

    gui.title_draw_line(x1, y1, x2, y2, style.color, style.bw, style.bh)
  end
end



function TITLE_GEN.generate_title()
  assert(GAME.title)
  assert(GAME.PALETTES)
  assert(GAME.PALETTES.normal)

  -- don't bother for a single map
--[[
  if OB_CONFIG.length == "single" then
    return
  end
--]]


process_letters()
do return end


  gui.title_create(320, 200, "#00b")

  gui.title_set_palette(GAME.PALETTES.normal)

for i = -80,400 do
  local x = i + 20
  local y = 0
  local x2 = i - 20
  local y2 = 200

  local ity = math.clamp(0, (i - 40) / 240, 1) * 255
  local col = { ity, ity, ity }

  gui.title_draw_line(x, y, x2, y2, col, 2, 2)
end

local trans = { x=0, y=100 }
for pass = 1, 3 do
  local style
  if pass == 1 then
    style = { color="#200", bw=6, bh=5 }
  elseif pass == 2 then
    style = { color="#500", bw=4, bh=3 }
  else
    style = { color="#a00", bw=2, bh=1 }
  end
for i = 0, 10 do
  trans.x = 0 + i * 24
  TITLE_GEN.draw_char(string.char(65 + i), trans, style)
end
end


  -- TODO

  gui.title_write("TITLEPIC")
end


----------------------------------------------------------------

OB_MODULES["title_generator"] =
{
  label = "Title Generator"

  game = { doom1=1, doom2=1 }

  hooks =
  {
    all_done = TITLE_GEN.generate_title
  }
}

