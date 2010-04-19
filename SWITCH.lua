
SMALL_SWITCH =
{
  brushes=
  {
    -- the base
    {
      { x = -40, y = -40, mat = "side" },
      { x =  40, y = -40, mat = "side" },
      { x =  56, y = -24, mat = "side" },
      { x =  56, y =  24, mat = "side" },
      { x =  40, y =  40, mat = "side" },
      { x = -40, y =  40, mat = "side" },
      { x = -56, y =  24, mat = "side" },
      { x = -56, y = -24, mat = "side" },
      { t = 12, light = 0.66, mat = "side" },
    },

    -- switch itself
    {
      { x =  32, y = -8, mat = "side" },
      { x =  32, y =  8, kind = "?line_kind", tag = "?tag", mat = "switch", peg=1, x_offset="?x_offset", y_offset="?y_offset" },
      { x = -32, y =  8, mat = "side" },
      { x = -32, y = -8, mat = "side" },
      { t = 76, light = 0.66, mat = "side" },
    },
  },
}

