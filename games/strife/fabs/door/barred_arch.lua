--
-- Archway with bars
--

PREFABS.Arch_barred =
{
  file   = "door/barred_arch.wad",
  map    = "MAP01",

  prob   = 35,

  where  = "edge",
  key    = "barred",

  deep   = 16,
  over   = 16,

  seed_w = 1,

  -- no x_fit, hence the wide version gets used when seed_w >= 2,
  -- MSSP: it does now

  x_fit = "frame",

  bound_z1 = 0,
  bound_z2 = 128,

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
},


PREFABS.Arch_barred_wide =
{
  template = "Arch_barred",
  map      = "MAP03",

  prob = 50,

  seed_w = 2,

  x_fit  = "frame",
},


PREFABS.Arch_barred_diag =
{
  file   = "door/barred_arch.wad",
  map    = "MAP02",

  prob   = 50,

  where  = "diagonal",
  key    = "barred",

  bound_z1 = 0,
  bound_z2 = 128,

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",
},
