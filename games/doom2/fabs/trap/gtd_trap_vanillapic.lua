-- Disabled - presently unworkable due to a mixture of conditions.

--[[PREFABS.Trap_gtd_closet_vanillapic_tech =
{
  file = "trap/gtd_trap_vanillapic.wad",
  map = "MAP01",

  prob = 50,

  port = "zdoom",
  theme = "tech",
  env = "building",

  kind = "trap",

  where  = "seeds",
  shape  = "U",

  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  x_fit = {20,60 , 196,236},
  y_fit = { 56,72 },

  bound_z1 = 0,
  bound_z2 = 128,

  tex_METAL = "DOORSTOP",
  tex_COMPSTA1 =
  {
    COMPSTA1 = 5,
    COMPSTA2 = 5,
    LITEBLU1 = 5,
    SPACEW3 = 5,
  },
  flat_CEIL5_2 = "FLAT20",

  tag_1 = "?trap_tag"
}

PREFABS.Trap_gtd_closet_vanillapic_urban =
{
  template = "Trap_gtd_closet_vanillapic_tech",

  theme = "urban",

  tex_COMPBLUE = "TEKWALL4",
  tex_METAL = "METAL",
  tex_COMPSTA1 =
  {
    COMPSTA1 = 5,
    COMPSTA2 = 5,
    SPACEW3 = 5,
    WOOD4 = 5,
  },
  flat_CEIL5_2 = "CEIL5_2"
}

PREFABS.Trap_gtd_closet_vanillapic_hell =
{
  template = "Trap_gtd_closet_vanillapic_tech",

  theme = "hell",

  tex_COMPBLUE = "FIREWALA",
  tex_METAL = "METAL",
  tex_COMPSTA1 =
  {
    WOOD4 = 5,
    SP_FACE1 = 5,
    SP_FACE2 = 5,
    FIREWALA = 5,
    FIRELAVA = 5,
  },
  flat_CEIL5_2 = "CEIL5_2"
}]]
