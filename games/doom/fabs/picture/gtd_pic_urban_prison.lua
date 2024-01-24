PREFABS.Pic_urban_prison_cell =
{
  file   = "picture/gtd_pic_urban_prison.wad",
  map    = "MAP01",

  prob   = 150,

  rank = 2,
  group  = "gtd_prison_A",
  where  = "seeds",

  texture_pack = "armaetus",

  height = 96,

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 96,

  deep   =  16,

  x_fit = { 36,40 , 216,220 },
  y_fit = { 36,40 },

  thing_18 =
  {
    [10]=1, [12]=1, [15]=1, [18]=1, [19]=1,
    [80]=1, [24]=1, [79]=1, [81]=1, [0]=20
  },
  thing_19 =
  {
    [10]=1, [12]=1, [15]=1, [18]=1, [19]=1,
    [80]=1, [24]=1, [79]=1, [81]=1, [0]=20
  },

  tex_MIDBARS1 = "FENCE2"
}

PREFABS.Pic_urban_prison_cell_compat =
{
  file   = "picture/gtd_pic_urban_prison.wad",
  map    = "MAP01",

  prob   = 150,

  rank = 1,
  group  = "gtd_prison_A",
  where  = "seeds",

  height = 96,

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 96,

  deep   =  16,

  x_fit = { 36,40 , 216,220 },
  y_fit = { 36,40 },

  thing_18 =
  {
    [10]=1, [12]=1, [15]=1, [18]=1, [19]=1,
    [80]=1, [24]=1, [79]=1, [81]=1, [0]=20
  },
  thing_19 =
  {
    [10]=1, [12]=1, [15]=1, [18]=1, [19]=1,
    [80]=1, [24]=1, [79]=1, [81]=1, [0]=20
  }
}
