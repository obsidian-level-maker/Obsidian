--
-- Joiners for hell
--

--room of mirrors1,
PREFABS.Joiner_mirrors1 =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP01",

  engine = "zdoom",

  prob   = 1000,

  filter = "mirror_maze",

  theme  = "hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,
}

--room of mirrors2,
PREFABS.Joiner_mirrors2 =
{
  template = "Joiner_mirrors1",
  map    = "MAP02",

  filter = "mirror_maze",

  seed_w = 2,
  seed_h = 3,
}

--rift1,
PREFABS.Joiner_rift1 =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP03",

  engine = "zdoom",

  prob   = 1250,

  theme  = "hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  texture_pack = "armaetus",
}

--rift2,
PREFABS.Joiner_rift2 =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP04",

  engine = "zdoom",

  prob   = 1250,

  theme  = "hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  texture_pack = "armaetus",
}


--rift3,
PREFABS.Joiner_rift3 =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP05",

  engine = "zdoom",

  prob   = 1250,

  theme  = "hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  texture_pack = "armaetus",
}

--rift4,
PREFABS.Joiner_rift4 =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP06",

  engine = "zdoom",

  prob   = 1250,

  theme  = "hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  texture_pack = "armaetus",
}

--room of mirrors1V2,
PREFABS.Joiner_mirrors1V2 =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP07",

  engine = "zdoom",

  prob   = 1000,

  filter = "mirror_maze",

  theme  = "hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,
}

--room of mirrors2V2,
PREFABS.Joiner_mirrors2V2 =
{
  template = "Joiner_mirrors1V2",
  map    = "MAP08",

  seed_w = 2,
  seed_h = 3,
}

--room of mirrors1V3,
PREFABS.Joiner_mirrors1V3 =
{
  template = "Joiner_mirrors1V2",
  map    = "MAP09",
}

--room of mirrors1V4,
PREFABS.Joiner_mirrors1V4 =
{
  template = "Joiner_mirrors1V2",
  map    = "MAP10",
}

--room of mirrors3 mazeish
PREFABS.Joiner_mirrors3 =
{
  template = "Joiner_mirrors1V2",
  map    = "MAP11",
}

--room of mirrors4 mazeish
PREFABS.Joiner_mirrors4 =
{
  template = "Joiner_mirrors1V2",
  map    = "MAP12",

  seed_w = 2,
  seed_h = 3,
}

--rift1 trapped
PREFABS.Joiner_rift1trap =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP13",

  engine = "zdoom",

  prob   = 1250,

  theme  = "hell",

  style  = "cages",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  texture_pack = "armaetus",
}

--rift4 trapped
PREFABS.Joiner_rift4trap =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP14",

  engine = "zdoom",

  prob   = 1250,

  theme  = "hell",

  style  = "cages",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  texture_pack = "armaetus",
}

--room of mirrors1 secret
PREFABS.Joiner_mirrors1S =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP15",

  engine = "zdoom",

  prob   = 550,

  filter = "mirror_maze",

  theme  = "hell",

  style = "secrets",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  thing_2013 =
  {
    soul = 50,
    blue_armor = 50,
  },
}

--room of mirrors2 secret
PREFABS.Joiner_mirrors2S =
{
  template = "Joiner_mirrors1S",
  map    = "MAP16",

  seed_w = 2,
  seed_h = 3,
}

--room of eyes1,
PREFABS.Joiner_eyes1 =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP17",

  engine = "zdoom",

  prob   = 1250,

  theme  = "hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,


}

--room of eyes2,
PREFABS.Joiner_eyes2 =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP18",

  engine = "zdoom",

  prob   = 1250,

  theme  = "hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,


}

--room of eyes3,
PREFABS.Joiner_eyes3 =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP19",

  engine = "zdoom",

  prob   = 1250,


  theme  = "hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,


}

--room of eyes4,
PREFABS.Joiner_eyes4 =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP20",

  engine = "zdoom",

  prob   = 1250,


  theme  = "hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,


}

--room of eyes1secret
PREFABS.Joiner_eyes1s =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP21",

  engine = "zdoom",

  prob   = 550,

  theme  = "hell",

  style = "secrets",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  thing_2023 =
  {
    green_armor = 50,
    berserk = 50,
    invis = 50,
    allmap = 50,
    goggles = 50,
  },

}

--room of eyes2secret
PREFABS.Joiner_eyes2s =
{
  file   = "joiner/dem_hell_joiners.wad",
  map    = "MAP22",

  engine = "zdoom",

  prob   = 550,

  theme  = "hell",

  style = "secrets",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  thing_2023 =
  {
    green_armor = 50,
    berserk = 50,
    invis = 50,
    allmap = 50,
    goggles = 50,
  },
}
