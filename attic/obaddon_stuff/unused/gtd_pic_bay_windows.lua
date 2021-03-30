PREFABS.Pic_bay_windows =
{
  file   = "picture/gtd_pic_bay_windows.wad"
  map    = "MAP01"

  prob   = 0
  theme = "!hell"

  env = "building"

  where  = "seeds"
  height = 128

  seed_w = 2
  seed_h = 1

  deep = 16
  over = -16

  bound_z1 = 0
  bound_z2 = 128

  x_fit = "frame"
  y_fit = {120, 136}
}

PREFABS.Pic_bay_windows_3x =
{
  template = "Pic_bay_windows"

  map = "MAP02"

  seed_w = 3
}
