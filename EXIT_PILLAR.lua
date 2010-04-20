
EXIT_PILLAR =
{
  brushes =
  {
    -- pillar itself
    {
      { x = -32, y = -32, mat = "switch", peg = 1, x_offset = 0, y_offset = 0, line_kind = 11 },
      { x =  32, y = -32, mat = "switch", peg = 1, x_offset = 0, y_offset = 0, line_kind = 11 },
      { x =  32, y =  32, mat = "switch", peg = 1, x_offset = 0, y_offset = 0, line_kind = 11 },
      { x = -32, y =  32, mat = "switch", peg = 1, x_offset = 0, y_offset = 0, line_kind = 11 },
      { t = 128, mat = "switch" },
    },

    -- exit signs
    {
      { x = -60, y = 44, mat = "exitside" },
      { x = -32, y = 60, mat = "exitside" },
      { x = -40, y = 68, mat = "exit", peg = 1, x_offset = 0, y_offset = 0 },
      { x = -68, y = 52, mat = "exitside" },
      { t = 16, light = 0.82, mat = "exitside" },
    },

    {
      { x = 60, y = 44, mat = "exitside" },
      { x = 68, y = 52, mat = "exit", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 40, y = 68, mat = "exitside" },
      { x = 32, y = 60, mat = "exitside" },
      { t = 16, light = 0.82, mat = "exitside" },
    },

    {
      { x = -60, y = -44, mat = "exitside" },
      { x = -68, y = -52, mat = "exit", peg = 1, x_offset = 0, y_offset = 0 },
      { x = -40, y = -68, mat = "exitside" },
      { x = -32, y = -60, mat = "exitside" },
      { t = 16, light = 0.82, mat = "exitside" },
    },

    {
      { x = 60, y = -44, mat = "exitside" },
      { x = 32, y = -60, mat = "exitside" },
      { x = 40, y = -68, mat = "exit", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 68, y = -52, mat = "exitside" },
      { t = 16, light = 0.82, mat = "exitside" },
    },

  },
}

