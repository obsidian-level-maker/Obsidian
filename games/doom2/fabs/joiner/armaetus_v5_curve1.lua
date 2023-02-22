PREFABS.Joiner_armaetus_v5_curve1 =
{
  file   = "joiner/armaetus_v5_curve1.wad",
  map    = "MAP01",

  theme  = "tech",

  prob   = 120,
  style  = "steepness",

  env      = "!cave",
  neighbor = "!cave",

  where  = "seeds",
  shape  = "L",

  seed_w = 2,
  seed_h = 2,

  delta_h  = 80,
  nearby_h = 128,

  thing_2028 =
  {
    lamp = 50,
    mercury_lamp = 50,
    mercury_small = 50,
  },

  tex_STEP5 = "STEP4",

}

PREFABS.Joiner_armaetus_v5_curve1_urban =
{
  template   = "Joiner_armaetus_v5_curve1",

  theme = "urban",

  prob = 120,

  thing_2028 =
  {
    lamp = 50,
    mercury_lamp = 50,
    mercury_small = 50,
    blue_torch = 50,
    green_torch = 50,
    red_torch = 50,
    candelabra = 20,
    burning_barrel = 25,
  },

  tex_STEP5 = "STEP6",

}

PREFABS.Joiner_armaetus_v5_curve1_hell_torches =
{
  template   = "Joiner_armaetus_v5_curve1",

  prob = 125,

  theme = "hell",

  thing_2028 =
  {
    blue_torch = 50,
    green_torch = 50,
    red_torch = 50,
    blue_torch_sm = 50,
    green_torch_sm = 50,
    red_torch_sm = 50,
    candelabra   = 25,
  },
}

PREFABS.Joiner_armaetus_v5_curve1_hell_gore =
{
  template   = "Joiner_armaetus_v5_curve1",

  prob = 125,

  theme = "hell",

  thing_2028 =
  {
    skull_pole = 20,
    skull_kebab = 20,
    impaled_human = 50,
    impaled_twitch = 50,
    gutted_victim1 = 30,
    gutted_victim2 = 30,
    gutted_torso1  = 30,
    gutted_torso2  = 30,
    gutted_torso3  = 30,
    gutted_torso4  = 30,
    hang_arm_pair  = 35,
    hang_torso     = 35,
    hang_twitching = 35,
  },

}

PREFABS.Joiner_armaetus_v5_curve1_hellish_pillars =
{
  template   = "Joiner_armaetus_v5_curve1",

  prob = 125,

  theme = "!tech",

  thing_2028 =
  {
    green_pillar = 50,
    green_column = 50,
    red_pillar   = 50,
    red_column   = 50,
  },
}

PREFABS.Joiner_armaetus_v5_curve1_eye =
{
  template   = "Joiner_armaetus_v5_curve1",

  prob = 40,

  thing_2028 = "evil_eye",

}
