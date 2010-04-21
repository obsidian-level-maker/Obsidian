
PREFAB.PICTURE =
{
  brushes =
  {
    -- wall behind picture
    {
      { x =   0, y =  0, mat = "wall" },
      { x = 192, y =  0, mat = "wall" },
      { x = 192, y = 12, mat = "wall" },
      { x =   0, y = 12, mat = "wall" },
    },

    -- picture itself
    {
      { x =  64, y = 12 },
      { x = 128, y = 12 },
      { x = 128, y = 16, mat = "pic", peg="?peg", x_offset="?x_offset", y_offset="?y_offset", kind="?line_kind" },
      { x =  64, y = 16 },
    },

    -- right side wall
    {
      { x = 0, y = 12, mat = "wall" },
      { x = 8, y = 12, mat = "wall" },
      { x = 8, y = 24, mat = "wall" },
      { x = 0, y = 24, mat = "wall" },
    },

    {
      { x =  8, y = 12, mat = "wall" },
      { x = 64, y = 12, mat = "side" },
      { x = 64, y = 24, mat = "wall" },
      { x =  8, y = 24, mat = "side" },
    },

    -- left side wall
    {
      { x = 184, y = 12, mat = "wall" },
      { x = 192, y = 12, mat = "wall" },
      { x = 192, y = 24, mat = "wall" },
      { x = 184, y = 24, mat = "wall" },
    },

    {
      { x = 128, y = 12, mat = "wall" },
      { x = 184, y = 12, mat = "side" },
      { x = 184, y = 24, mat = "wall" },
      { x = 128, y = 24, mat = "side" },
    },

    -- frame bottom
    {
      { x = 128, y = 12, mat = "wall" },
      { x = 128, y = 24, mat = "wall" },
      { x =  64, y = 24, mat = "wall", flags = 1 },
      { x =  64, y = 12, mat = "wall" },
      { t = 32, mat = "floor" },
    },

    -- frame top
    {
      { x = 128, y = 12, mat = "wall" },
      { x = 128, y = 24, mat = "wall" },
      { x =  64, y = 24, mat = "wall", flags = 1 },
      { x =  64, y = 12, mat = "wall" },
      { b = 96, light = "?light", mat = "floor" },
    },
  },
}

