--
-- Cavey archway with vines
--


---------- JOINER VERSIONS -----------------------


PREFABS.Joiner_cave_hole1 =
{
  file   = "joiner/cave_hole_joiner.wad",
  map    = "MAP01",

  prob   = 50,

  env      = "!cave",
  neighbor = "cave",

  kind   = "joiner",
  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 32,144 },

  force_flip = false
}


PREFABS.Joiner_cave_hole1_B =
{
  template = "Joiner_cave_hole1",

  env      = "cave",
  neighbor = "any",

  force_flip = true
}


PREFABS.Joiner_cave_hole1_CC =
{
  template = "Joiner_cave_hole1",
  map      = "MAP02",

  env      = "cave",
  neighbor = "cave",
}

PREFABS.Joiner_cave_hole1_key1 =
{
  file   = "joiner/cave_hole_joiner.wad",
  map    = "MAP03",

  prob   = 50,

  env      = "!cave",
  neighbor = "cave",

  key    = "k_one",

  kind   = "joiner",
  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 32,144 },

  force_flip = false
}

PREFABS.Joiner_cave_hole1_B_key1 =
{
  template = "Joiner_cave_hole1_key1",

  env      = "cave",
  neighbor = "any",

  force_flip = true
}

PREFABS.Joiner_cave_hole1_key2 =
{
  template = "Joiner_cave_hole1_key1",
  map = "MAP04",
  key = "k_two"
}

PREFABS.Joiner_cave_hole1_B_key2 =
{
  template = "Joiner_cave_hole1_key1",

  map = "MAP04",

  env      = "cave",
  neighbor = "any",

  force_flip = true,

  key = "k_two"
}

PREFABS.Joiner_cave_hole1_key3 =
{
  template = "Joiner_cave_hole1_key1",
  map = "MAP05",
  key = "k_three"
}

PREFABS.Joiner_cave_hole1_B_key3 =
{
  template = "Joiner_cave_hole1_key1",

  map = "MAP05",

  env      = "cave",
  neighbor = "any",

  force_flip = true,

  key = "k_three"
}

PREFABS.Joiner_cave_hole2_key1 =
{
  file   = "joiner/cave_hole_joiner.wad",
  map    = "MAP06",

  prob   = 50,

  env      = "!cave",
  neighbor = "cave",

  key    = "k_one",

  kind   = "joiner",
  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 32,144 },

  force_flip = false
}

PREFABS.Joiner_cave_hole2_B_key1 =
{
  template = "Joiner_cave_hole2_key1",

  env      = "cave",
  neighbor = "any",

  force_flip = true
}

PREFABS.Joiner_cave_hole2_key2 =
{
  template = "Joiner_cave_hole2_key1",
  map = "MAP07",
  key = "k_two"
}

PREFABS.Joiner_cave_hole2_B_key2 =
{
  template = "Joiner_cave_hole2_key1",

  map = "MAP07",

  env      = "cave",
  neighbor = "any",

  force_flip = true,

  key = "k_two"
}

PREFABS.Joiner_cave_hole2_key3 =
{
  template = "Joiner_cave_hole2_key1",
  map = "MAP08",
  key = "k_three"
}

PREFABS.Joiner_cave_hole2_B_key3 =
{
  template = "Joiner_cave_hole2_key1",

  map = "MAP08",

  env      = "cave",
  neighbor = "any",

  force_flip = true,

  key = "k_three"
}

PREFABS.Joiner_cave_hole1_barred1 =
{
  file   = "joiner/cave_hole_joiner.wad",
  map    = "MAP09",

  prob   = 50,

  env      = "!cave",
  neighbor = "cave",

  key    = "barred",
  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  kind   = "joiner",
  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 32,144 },

  force_flip = false
}

PREFABS.Joiner_cave_hole1_B_barred1 =
{
  template = "Joiner_cave_hole1_barred1",

  env      = "cave",
  neighbor = "any",

  force_flip = true
}

PREFABS.Joiner_cave_hole1_barred2 =
{
  file   = "joiner/cave_hole_joiner.wad",
  map    = "MAP10",

  prob   = 50,

  env      = "!cave",
  neighbor = "cave",

  key    = "barred",
  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  kind   = "joiner",
  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = { 32,144 },

  force_flip = false
}

PREFABS.Joiner_cave_hole1_B_barred2 =
{
  template = "Joiner_cave_hole1_barred2",

  env      = "cave",
  neighbor = "any",

  force_flip = true
}