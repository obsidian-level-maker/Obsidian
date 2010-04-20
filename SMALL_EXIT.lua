
SMALL_EXIT =
{
  brushes =
  {

    -- outer walls
    {
      { x = 0, y =   0, mat = "outer" },
      { x = 8, y =   0, mat = "outer" },
      { x = 8, y = 256, mat = "outer" },
      { x = 0, y = 256, mat = "outer" },
    },

    {
      { x = 248, y =   0, mat = "outer" },
      { x = 256, y =   0, mat = "outer" },
      { x = 256, y = 256, mat = "outer" },
      { x = 248, y = 256, mat = "outer" },
    },

    {
      { x =   8, y = 248, mat = "outer" },
      { x = 248, y = 248, mat = "outer" },
      { x = 248, y = 256, mat = "outer" },
      { x =   8, y = 256, mat = "outer" },
    },

    {
      { x =   8, y =  0, mat = "outer" },
      { x = 248, y =  0, mat = "outer" },
      { x = 248, y = 48, mat = "outer" },
      { x =   8, y = 48, mat = "outer" },
      { t = 0.3, mat = "outer" },
    },

    {
      { x =   8, y = -24, mat = "outer" },
      { x = 248, y = -24, mat = "outer" },
      { x = 248, y =  48, mat = "outer" },
      { x =   8, y =  48, mat = "outer" },
      { b = 128, mat = "outer" },
    },

    -- inner walls
    {
      { x =  8, y =  80, mat = "inner" },
      { x = 16, y =  80, mat = "inner" },
      { x = 16, y = 248, mat = "inner" },
      { x =  8, y = 248, mat = "inner" },
    },

    {
      { x = 240, y =  80, mat = "inner" },
      { x = 248, y =  80, mat = "inner" },
      { x = 248, y = 248, mat = "inner" },
      { x = 240, y = 248, mat = "inner" },
    },


    {
      { x =   8, y =  48, mat = "floor" },
      { x = 248, y =  48, mat = "floor" },
      { x = 248, y = 248, mat = "floor" },
      { x =   8, y = 248, mat = "floor" },
      { t = 0.3, mat = "floor" },
    },

    {
      { x =   8, y =  48, mat = "ceil" },
      { x = 248, y =  48, mat = "ceil" },
      { x = 248, y = 248, mat = "ceil" },
      { x =   8, y = 248, mat = "ceil" },
      { b = 128, mat = "ceil" },
    },

    -- the switch iteslf
    {
      { x =  16, y = 240, mat = "inner" },
      { x =  88, y = 240, mat = "break",  peg = 1, x_offset = 0, y_offset = 0 },
      { x =  96, y = 240, mat = "switch", peg = 0, x_offset = 0, y_offset = 0, line_kind = 11 },
      { x = 160, y = 240, mat = "break",  peg = 1, x_offset = 0, y_offset = 0 },
      { x = 168, y = 240, mat = "inner" },
      { x = 240, y = 240, mat = "inner" },
      { x = 240, y = 248, mat = "inner" },
      { x =  16, y = 248, mat = "inner" },
    },


    -- door itself
    {
      { x = 160, y = 48, mat = "door", peg = 1, x_offset = 0, y_offset = 0, line_kind = 1 },
      { x = 160, y = 64, mat = "door", peg = 1, x_offset = 0, y_offset = 0, line_kind = 1 },
      { x =  96, y = 64, mat = "door", peg = 1, x_offset = 0, y_offset = 0, line_kind = 1 },
      { x =  96, y = 48, mat = "door", peg = 1, x_offset = 0, y_offset = 0, line_kind = 1 },
      { b = 16, delta_z=-16, mat = "door" },
    },

    {
      { x = 160, y = 32, mat = "inner" },
      { x = 160, y = 80, mat = "inner" },
      { x =  96, y = 80, mat = "inner" },
      { x =  96, y = 32, mat = "outer" },
      { b = 72, mat = "frame" },
    },

    -- side of door
    {
      { x =  0, y =  80, mat = "outer" },
      { x =  0, y = -24, mat = "outer" },
      { x = 32, y = -24, mat = "outer" },
      { x = 96, y =  32, mat = "key", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 96, y =  48, mat = "track", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 96, y =  64, mat = "key", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 96, y =  80, mat = "inner" },
    },

    {
      { x = 256, y =  80, mat = "inner" },
      { x = 160, y =  80, mat = "key", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 160, y =  64, mat = "track", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 160, y =  48, mat = "key", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 160, y =  32, mat = "outer" },
      { x = 224, y = -24, mat = "outer" },
      { x = 256, y = -24, mat = "outer" },
    },

    -- exit signs
    {
      { x = 60, y =  -8, mat = "exitside" },
      { x = 68, y = -16, mat = "exit", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 96, y =   0, mat = "exitside" },
      { x = 88, y =   8, mat = "exitside" },
      { b = 112, mat = "exitside" },
    },

    {
      { x = 196, y = -8, mat = "exitside" },
      { x = 168, y = 8, mat = "exitside" },
      { x = 160, y = 0, mat = "exit", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 188, y = -16, mat = "exitside" },
      { b = 112, mat = "exitside" },
    },

  },
}


