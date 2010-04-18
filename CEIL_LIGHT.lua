
CEIL_LIGHT =
{
  brushes =
  {
    -- trim around light
    {
      { x = -40, y = -40, mat = "trim" },
      { x = -40, y =  40, mat = "trim" },
      { x = -40, y =  40, mat = "trim" },
      { x = -40, y = -40, mat = "trim" },
      { b = -16, light = 0.72, mat = "trim" },
    },

    -- light itself
    {
      { x =  32, y = -32, mat = "glowy" },
      { x =  32, y =  32, mat = "glowy" },
      { x = -32, y =  32, mat = "glowy" },
      { x = -32, y = -32, mat = "glowy" },
      { b = -20, delta_z = 8, light = 0.9, mat = "glowy" },
    },
  },
}

