PREFABS.Decor_AI_goth_comp_yellow_computer_2x =
{
  file   = "decor/gtd_decor_AI_sets.wad",
  map    = "MAP01",

  prob   = 5000,

  group = "gtd_AI_goth_comp_yellow_stained_glass",

  height = 161,
  where  = "point",
  size   = 108,

  bound_z1 = 0
}

PREFABS.Decor_AI_goth_comp_yellow_computer =
{
  template = "Decor_AI_goth_comp_yellow_computer_2x",
  map    = "MAP02",

  prob   = 2500,

  height = 152,
  size   = 76
}

--

PREFABS.Decor_AI_boiler_tank_1 =
{
  template = "Decor_AI_goth_comp_yellow_computer_2x",
  map    = "MAP20",

  group = "gtd_AI_boiler_room",

  height = 128,
  size = 80
}

--

PREFABS.Decor_AI_boiler_machine_A =
{
  template = "Decor_AI_goth_comp_yellow_computer_2x",
  map    = "MAP20",

  group = "gtd_AI_boiler_control_unit",

  height = 128,
  size = 72
}

PREFABS.Decor_AI_boiler_machine_B =
{
  template = "Decor_AI_goth_comp_yellow_computer_2x",
  map    = "MAP21",

  group = "gtd_AI_boiler_control_unit",

  height = 128,
  size = 76
}

--

PREFABS.Decor_AI_corpse_inset_pillar =
{
  template = "Decor_AI_goth_comp_yellow_computer_2x",
  map    = "MAP30",

  group = "gtd_AI_corpse_inset",

  height = 128,
  size = 96,

  z_fit = "top",
  bound_z2 = 128,

  tex_SDPBBWLA =
  {
    SDPBBWL8 = 1,
    SDPBBWL9 = 1,
    SDPBBWLA = 4,
    SDPBBWLB = 4
  }
}
