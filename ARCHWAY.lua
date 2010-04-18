
ARCHWAY =
{
  brushes =
  {
    -- frame
    {
      { x = 192, y = -24, mat = "outer" },
      { x = 192, y =  24, mat = "inner" },
      { x = 0,   y =  24, mat = "outer" },
      { x = 0,   y = -24, mat = "outer" },
      { b = "@ht", mat = "outer" },
    },

    -- left side
    {
      { x = 0,  y = -24, mat = "outer" },
      { x = 40, y = -24, mat = "outer" },
      { x = 52, y =  -8, mat = "break" },
      { x = 52, y =   8, mat = "inner" },
      { x = 40, y =  24, mat = "inner" },
      { x = 0,  y =  24, mat = "inner" },
    },

    -- right side
    {
      { x = 192, y =  24, mat = "inner" },
      { x = 152, y =  24, mat = "inner" },
      { x = 140, y =   8, mat = "break" },
      { x = 140, y =  -8, mat = "outer" },
      { x = 152, y = -24, mat = "outer" },
      { x = 192, y = -24, mat = "inner" },
    },
  },
}

