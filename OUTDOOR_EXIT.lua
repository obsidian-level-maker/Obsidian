
OUTDOOR_EXIT_SWITCH =
{
  brushes =
  {

    -- podium
    {
      { x =  64, y = -64, mat = "podium" },
      { x =  64, y =  64, mat = "podium" },
      { x = -64, y =  64, mat = "podium" },
      { x = -64, y = -64, mat = "podium" },
      { t = 12, mat = "podium" },
    },

    -- base of switch
    {
      { x = -36, y = -24, mat = "base" },
      { x =  36, y = -24, mat = "base" },
      { x =  44, y = -16, mat = "base" },
      { x =  44, y =  16, mat = "base" },
      { x =  36, y =  24, mat = "base" },
      { x = -36, y =  24, mat = "base" },
      { x = -44, y =  16, mat = "base" },
      { x = -44, y = -16, mat = "base" },
      { t = 22, mat = "base" },
    },

    -- switch itself
    {
      { x =  32, y = -8, mat = "base" },
      { x =  32, y =  8, mat = "switch", peg = 1, x_offset = 0, y_offset = 0, line_kind = 11 },
      { x = -32, y =  8, mat = "base" },
      { x = -32, y = -8, mat = "switch", peg = 1, x_offset = 0, y_offset = 0, line_kind = 11 },
      { t = 86, mat = "base" },
    },

    {
      { x = -40, y = 32, mat = "base" },
      { x = -12, y = 48, mat = "base" },
      { x = -20, y = 56, mat = "exit", peg = 1, x_offset = 0, y_offset = 0 },
      { x = -48, y = 40, mat = "base" },
      { t = 28, mat = "base" },
    },

    {
      { x = 40, y = 32, mat = "base" },
      { x = 48, y = 40, mat = "exit", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 20, y = 56, mat = "base" },
      { x = 12, y = 48, mat = "base" },
      { t = 28, mat = "base" },
    },

    {
      { x = -40, y = -32, mat = "base" },
      { x = -48, y = -40, mat = "exit", peg = 1, x_offset = 0, y_offset = 0 },
      { x = -20, y = -56, mat = "base" },
      { x = -12, y = -48, mat = "base" },
      { t = 28, mat = "base" },
    },

    {
      { x = 40, y = -32, mat = "base" },
      { x = 12, y = -48, mat = "base" },
      { x = 20, y = -56, mat = "exit", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 48, y = -40, mat = "base" },
      { t = 28, mat = "base" },
    },
  },
}

