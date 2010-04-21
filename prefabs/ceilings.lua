
PREFAB.CEIL_LIGHT =
{
  ceiling_relative = true,

  brushes =
  {
    -- trim around light
    {
      { x = -40, y = -40, mat = "trim" },
      { x =  40, y = -40, mat = "trim" },
      { x =  40, y =  40, mat = "trim" },
      { x = -40, y =  40, mat = "trim" },
      { b = -16, mat = "trim" },
    },

    -- light itself
    {
      { x = -32, y = -32, mat = "glowy" },
      { x =  32, y = -32, mat = "glowy" },
      { x =  32, y =  32, mat = "glowy" },
      { x = -32, y =  32, mat = "glowy" },
      { b = -18, delta_z = 10, light = 0.9, mat = "glowy" },
    },
  },
}

