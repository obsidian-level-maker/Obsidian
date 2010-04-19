
SMALL_EXIT =
{
  brushes =
  {

    {
      { x = 248, y =  0, mat = "outer" },
      { x = 248, y = 48, mat = "outer" },
      { x =   8, y = 48, mat = "outer" },
      { x =   8, y =  0, mat = "outer" },
      { t = 0, mat = "outer" },
    },

    {
      { x = 248, y = -24, mat = "outer" },
      { x = 248, y =  48, mat = "outer" },
      { x =   8, y =  48, mat = "outer" },
      { x =   8, y = -24, mat = "outer" },
      { b = 128, mat = "outer" },
    },

    {
      { x = 248, y =  48, mat = "wall" },
      { x = 248, y = 248, mat = "wall" },
      { x =   8, y = 248, mat = "wall" },
      { x =   8, y =  48, mat = "wall" },
      { t = 0, mat = "floor" },
    },

    {
      { x = 248, y =  48, mat = "wall" },
      { x = 248, y = 248, mat = "wall" },
      { x =   8, y = 248, mat = "wall" },
      { x =   8, y =  48, mat = "wall" },
      { b = 128, mat = "ceil" },
    },

    {
      { x = 32, y =   0, mat = "wall" },
      { x = 32, y = 256, mat = "wall" },
      { x =  8, y = 256, mat = "wall" },
      { x =  8, y =   0, mat = "wall" },
    },

    {
      { x = 248, y =   0, mat = "wall" },
      { x = 248, y = 256, mat = "wall" },
      { x = 224, y = 256, mat = "wall" },
      { x = 224, y =   0, mat = "wall" },
    },


    {
      { x = 160, y = 48, mat = "door", peg = 1, x_offset = 0, y_offset = 0, line_kind = 1 },
      { x = 160, y = 64, mat = "door", peg = 1, x_offset = 0, y_offset = 0, line_kind = 1 },
      { x =  96, y = 64, mat = "door", peg = 1, x_offset = 0, y_offset = 0, line_kind = 1 },
      { x =  96, y = 48, mat = "door", peg = 1, x_offset = 0, y_offset = 0, line_kind = 1 },
      { b = 8, mat = "door" },
    },


    {
      { x = 160, y = 32, mat = "wall" },
      { x = 160, y = 80, mat = "wall" },
      { x =  96, y = 80, mat = "wall" },
      { x =  96, y = 32, mat = "outer" },
      { b = 72, mat = "frame" },
    },


    {
      { x =  0, y =  80, mat = "outer" },
      { x =  0, y = -24, mat = "outer" },
      { x = 32, y = -24, mat = "outer" },
      { x = 96, y =  32, mat = "key", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 96, y =  48, mat = "track", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 96, y =  64, mat = "key", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 96, y =  80, mat = "wall" },
    },

    {
      { x = 60, y =  -8, mat = "exitside" },
      { x = 68, y = -16, mat = "exit", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 96, y =   0, mat = "exitside" },
      { x = 88, y =   8, mat = "exitside" },
      { b = 112, mat = "exitside" },
    },

    {
      { x = 256, y =  80, mat = "wall" },
      { x = 160, y =  80, mat = "key", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 160, y =  64, mat = "track", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 160, y =  48, mat = "key", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 160, y =  32, mat = "outer" },
      { x = 224, y = -24, mat = "outer" },
      { x = 256, y = -24, mat = "outer" },
    },

    {
      { x = 196, y = -8, mat = "exitside" },
      { x = 168, y = 8, mat = "exitside" },
      { x = 160, y = 0, mat = "exit", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 188, y = -16, mat = "exitside" },
      { b = 112, mat = "exitside" },
    },


    {
      { x = 248, y =  8, mat = "wall" },
      { x = 248, y = 32, mat = "wall" },
      { x = 168, y = 32, mat = "break", peg = 1, x_offset = 0, y_offset = 0 },
      { x = 160, y = 32, mat = "switch", peg = 0, x_offset = 0, y_offset = 0, line_kind = 11 },
      { x =  96, y = 32, mat = "break", peg = 1, x_offset = 0, y_offset = 0 },
      { x =  88, y = 32, mat = "wall" },
      { x =   8, y = 32, mat = "wall" },
      { x =   8, y =  8, mat = "wall" },
    },
  },
}


