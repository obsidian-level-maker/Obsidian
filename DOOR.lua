
DOOR_PREFAB =
{
  brushes =
  {
    -- step
    {
      { x = 192, y = -24, mat = "step" },
      { x = 192, y =  24, mat = "step" },
      { x =   0, y =  24, mat = "step" },
      { x =   0, y = -24, mat = "step" },
      { T = 8, mat = "step", light = 0.7 },
    },

    -- frame
    {
      { x = 192, y = -24, mat = "outer" },
      { x = 192, y =  24, mat = "inner" },
      { x = 0,   y =  24, mat = "outer" },
      { x = 0,   y = -24, mat = "outer" },
      { B = 80, mat = "frame" },
    },

    -- door itself
    {
      { x = 160, y = -8, kind = "?line_kind", mat = "door", peg=1, x_offset=0, y_offset=0 },
      { x = 160, y =  8, kind = "?line_kind", mat = "door", peg=1, x_offset=0, y_offset=0 },
      { x =  32, y =  8, kind = "?line_kind", mat = "door", peg=1, x_offset=0, y_offset=0 },
      { x =  32, y = -8, kind = "?line_kind", mat = "door", peg=1, x_offset=0, y_offset=0 },
      { B = 16, mat = "door", light = 0.7, tag = "?tag" },
    },

    -- left side
    {
      { x = 32, y =  -8, mat = "track", peg=1, x_offset=0, y_offset=0 },
      { x = 32, y =   8, mat = "key",   peg=1, x_offset=0, y_offset=0 },
      { x = 14, y =  24, mat = "key",   peg=1, x_offset=0, y_offset=0 },
      { x = 14, y = -24, mat = "key",   peg=1, x_offset=0, y_offset=0 },
    },

    {
      { x = 14, y = -24, mat = "outer" },
      { x = 14, y =  24, mat = "inner" },
      { x =  0, y =  24, mat = "outer" },
      { x =  0, y = -24, mat = "outer" },
    },

    -- right side
    {
      { x = 160, y =  -8, mat = "key",   peg=1, x_offset=0, y_offset=0 },
      { x = 178, y = -24, mat = "key",   peg=1, x_offset=0, y_offset=0 },
      { x = 178, y =  24, mat = "key",   peg=1, x_offset=0, y_offset=0 },
      { x = 160, y =   8, mat = "track", peg=1, x_offset=0, y_offset=0 },
    },

    {
      { x = 178, y = -24, mat = "outer" },
      { x = 192, y = -24, mat = "outer" },
      { x = 192, y =  24, mat = "inner" },
      { x = 178, y =  24, mat = "outer" },
    },
  },
}

