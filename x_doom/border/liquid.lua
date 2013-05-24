--
-- Liquid border prefabs
--

DOOM.SKINS.Border_liquid_1x2_t =
{
  file   = "border/liquid_1x2_t.wad"
  group  = "border_liquid"
  shape  = "T"

  seed_w = 1
  seed_h = 2
  add_sky = 1
}


DOOM.SKINS.Border_liquid_2x2_t =
{
  file   = "border/liquid_2x2_t.wad"
  group  = "border_liquid"
  shape  = "T"

  seed_w = 2
  seed_h = 2
  add_sky = 1
}


DOOM.SKINS.Border_liquid_2x2_t_spill =
{
  file   = "border/liquid_2x2_t2.wad"
  group  = "border_liquid"
  shape  = "T"

  seed_w = 2
  seed_h = 2
  add_sky = 1

  prob = 12
}


DOOM.SKINS.Border_liquid_2x2_c =
{
  file   = "border/liquid_2x2_c.wad"
  group  = "border_liquid"
  shape  = "C"

  seed_w = 2
  seed_h = 2
  add_sky = 1
}


DOOM.SKINS.Border_liquid_2x2_o =
{
  file   = "border/liquid_2x2_o.wad"
  group  = "border_liquid"
  shape  = "O"

  seed_w = 2
  seed_h = 2
  add_sky = 1
}

--
-- Group information
--

DOOM.GROUPS.border_liquid =
{
  kind = "border"

  liquid = "any"

  prob = 100
}

