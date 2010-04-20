
PILLAR =
{
  brushes=
  {
    -- main stem
    {
      { x =  32, y = -32, mat = "pillar", peg=1, x_offset=0, y_offset=0 },
      { x =  32, y =  32, mat = "pillar", peg=1, x_offset=0, y_offset=0 },
      { x = -32, y =  32, mat = "pillar", peg=1, x_offset=0, y_offset=0 },
      { x = -32, y = -32, mat = "pillar", peg=1, x_offset=0, y_offset=0 },
    },

    -- trim closest to stem
    {
      { x =  40, y = -40, mat = "trim2" },
      { x =  40, y =  40, mat = "trim2" },
      { x = -40, y =  40, mat = "trim2" },
      { x = -40, y = -40, mat = "trim2" },
      { t = 20, mat = "trim2" },
    },

    {
      { x =  40, y = -40, mat = "trim2" },
      { x =  40, y =  40, mat = "trim2" },
      { x = -40, y =  40, mat = "trim2" },
      { x = -40, y = -40, mat = "trim2" },
      { b = 108, mat = "trim2" },
    },

    -- roundish and lowest trim
    {
      { x = -40, y = -56, mat = "trim1" },
      { x =  40, y = -56, mat = "trim1" },
      { x =  56, y = -40, mat = "trim1" },
      { x =  56, y =  40, mat = "trim1" },
      { x =  40, y =  56, mat = "trim1" },
      { x = -40, y =  56, mat = "trim1" },
      { x = -56, y =  40, mat = "trim1" },
      { x = -56, y = -40, mat = "trim1" },
      { t = 6, mat = "trim1" },
    },

    {
      { x = -40, y = -56, mat = "trim1" },
      { x =  40, y = -56, mat = "trim1" },
      { x =  56, y = -40, mat = "trim1" },
      { x =  56, y =  40, mat = "trim1" },
      { x =  40, y =  56, mat = "trim1" },
      { x = -40, y =  56, mat = "trim1" },
      { x = -56, y =  40, mat = "trim1" },
      { x = -56, y = -40, mat = "trim1" },
      { b = 122, mat = "trim1" },
    },
  },
}

