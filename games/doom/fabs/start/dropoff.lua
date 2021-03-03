--
-- Closet with a drop-off
--

PREFABS.Start_Dropoff =
{
  file   = "start/dropoff.wad",

  prob   = 80,
  theme  = "tech",

  where  = "seeds",

  seed_w = 2,
  deep   =  16,
  over   = -16,

  height = 128,

  x_fit  = "frame",
  y_fit  = "top",

  nearby_h = 160,

  thing_45 =
  {
   mercury_lamp = 50,
   mercury_small = 50,
   lamp       = 50,
  },

}

PREFABS.Start_Dropoff_hell =
{
  template = "Start_Dropoff",

  prob   = 100,
  theme  = "hell",

  thing_45 =
 {
  blue_torch = 50,
  green_torch = 50,
  red_torch = 50,
  candelabra = 50,
 },

 tex_METAL4 = "SUPPORT3",

}

PREFABS.Start_Dropoff_urban =
{
  template = "Start_Dropoff",

  prob   = 100,
  theme  = "urban",

  thing_45 =
 {
  blue_torch = 50,
  green_torch = 50,
  red_torch = 50,
 },

 tex_METAL4 = "WOOD4",
 flat_CEIL5_2 = "FLAT5_2",

}
