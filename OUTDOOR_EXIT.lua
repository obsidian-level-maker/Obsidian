
OUTDOOR_EXIT_SWITCH =
{


{
  { x = 160, y = 32, mat = "podium", },
  { x = 160, y = 160, mat = "podium", },
  { x = 32, y = 160, mat = "podium", },
  { x = 32, y = 32, mat = "podium", },
  { t = 188, mat = "podium", },
},

{
  { x = -36, y = -24, mat = "base", },
  { x = 36, y = -24, mat = "base", },
  { x = 44, y = -16, mat = "base", },
  { x = 44, y = 16, mat = "base", },
  { x = 36, y = 24, mat = "base", },
  { x = -36, y = 24, mat = "base", },
  { x = -44, y = 16, mat = "base", },
  { x = -44, y = -16, mat = "base", },
  { t = 192, mat = "base", },
},

{
  { x = 32, y = -8, mat = "base", },
  { x = 32, y = 8, mat = "switch", peg = 1, x_offset = 0, y_offset = 0, line_kind = 11, },
  { x = -32, y = 8, mat = "base", },
  { x = -32, y = -8, mat = "switch", peg = 1, x_offset = 0, y_offset = 0, line_kind = 11, },
  { t = 256, mat = "base", },
},

{
  { x = 56, y = 128, mat = "base", },
  { x = 84, y = 144, mat = "base", },
  { x = 76, y = 152, mat = "exit", peg = 1, x_offset = 0, y_offset = 0, },
  { x = 48, y = 136, mat = "base", },
  { t = 204, mat = "base", },
},

{
  { x = 136, y = 128, mat = "base", },
  { x = 144, y = 136, mat = "exit", peg = 1, x_offset = 0, y_offset = 0, },
  { x = 116, y = 152, mat = "base", },
  { x = 108, y = 144, mat = "base", },
  { t = 204, mat = "base", },
},

{
  { x = 56, y = 64, mat = "base", },
  { x = 48, y = 56, mat = "exit", peg = 1, x_offset = 0, y_offset = 0, },
  { x = 76, y = 40, mat = "base", },
  { x = 84, y = 48, mat = "base", },
  { t = 204, mat = "base", },
},

{
  { x = 136, y = 64, mat = "base", },
  { x = 108, y = 48, mat = "base", },
  { x = 116, y = 40, mat = "exit", peg = 1, x_offset = 0, y_offset = 0, },
  { x = 144, y = 56, mat = "base", },
  { t = 204, mat = "base", },
},


},
