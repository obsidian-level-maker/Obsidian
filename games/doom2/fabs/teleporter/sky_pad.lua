--
-- Outdoor teleporter platform
--

PREFABS.Teleporter_sky_pad =
{
  file   = "teleporter/sky_pad.wad",
  map    = "MAP01",

  rank   = 2,
  prob   = 50,
  theme  = "!tech",

  env    = "outdoor",
  open_to_sky = 1,

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  x_fit  = { 40,48, 208,216 },

  tag_1 = "?out_tag",
  tag_2 = "?in_tag",

  thing_55 =
{
  blue_torch = 50,
  blue_torch_sm = 50,
  green_torch = 50,
  green_torch_sm = 50,
  red_torch = 50,
  red_torch_sm = 50,
},

flat_GATE1 = { GATE1=50, GATE2=50, GATE3=50, GATE4=50 },

sector_8  = { [8]=60, [2]=15, [3]=15, [8]=15, [17]=20 },

}


PREFABS.Teleporter_sky_pad_tech =
{
  template = "Teleporter_sky_pad",

  theme = "tech",

  -- replace blue torches with bollard lamps
  thing_55 = "lamp",
}

