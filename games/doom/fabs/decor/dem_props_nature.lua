--
-- Cave props
--


---- cave vines ----

PREFABS.Decor_dem_cavevines1 =
{
  file   = "decor/dem_props_nature.wad",
  map    = "MAP01",

  prob   = 4500,
  env    = "cave",

  where  = "point",
  size   = 104,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 224,

  z_fit = "stretch",

  tex_MIDVINE1 = {
    MIDVINE1=50, MIDVINE2=50,
    },

  texture_pack = "armaetus",

}

PREFABS.Decor_dem_cavevines2 =
{
  template  = "Decor_dem_cavevines1",
  map    = "MAP02",


}

PREFABS.Decor_dem_cavevines2 =
{
  template  = "Decor_dem_cavevines1",
  map    = "MAP03",


}

PREFABS.Decor_dem_cavevines2 =
{
  template  = "Decor_dem_cavevines1",
  map    = "MAP04",


}

PREFABS.Decor_dem_cavevines2 =
{
  template  = "Decor_dem_cavevines1",
  map    = "MAP05",


}

PREFABS.Decor_dem_cavevines2 =
{
  template  = "Decor_dem_cavevines1",
  map    = "MAP06",


}

PREFABS.Decor_dem_cavevines2 =
{
  template  = "Decor_dem_cavevines1",
  map    = "MAP07",


}

PREFABS.Decor_dem_cavevines2 =
{
  template  = "Decor_dem_cavevines1",
  map    = "MAP08",


}

PREFABS.Decor_dem_cavevines2 =
{
  template  = "Decor_dem_cavevines1",
  map    = "MAP09",


}


---- campfireC ----

PREFABS.Decor_dem_campfireC =
{
  file   = "decor/dem_props_nature.wad",
  map    = "MAP10",

  theme = "!hell",

  prob   = 3000,

  env    = "nature",

  sink_mode = "never",

  where  = "point",
  size   = 104,

  bound_z1 = 0,
  bound_z2 = 224,

texture_pack = "armaetus",


}

---- cave stalactites/stalagmites ----

PREFABS.Decor_dem_stala1 =
{
  file   = "decor/dem_props_nature.wad",
  map    = "MAP11",

  prob   = 3000,

  env    = "cave",

  where  = "point",
  size   = 104,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "stretch",

  liquid = true,

}

PREFABS.Decor_dem_stala2 =
{
  template  = "Decor_dem_stala1",
  map    = "MAP12",

  liquid = false


}

PREFABS.Decor_dem_stala3 =
{
  template  = "Decor_dem_stala1",
  map    = "MAP13",

  liquid = true,


}

PREFABS.Decor_dem_stala4 =
{
  template  = "Decor_dem_stala1",
  map    = "MAP14",

  liquid = true,


}

PREFABS.Decor_dem_stala5 =
{
  template  = "Decor_dem_stala1",
  map    = "MAP15",

  liquid = true,


}

PREFABS.Decor_dem_stala6 =
{
  template  = "Decor_dem_stala1",
  map    = "MAP16",

  liquid = false


}

PREFABS.Decor_dem_stala7 =
{
  template  = "Decor_dem_stala1",
  map    = "MAP17",

  liquid = false

}

PREFABS.Decor_dem_stala8 =
{
  template  = "Decor_dem_stala1",
  map    = "MAP18",

  liquid = true,

}

PREFABS.Decor_dem_stala9 =
{
  template  = "Decor_dem_stala1",
  map    = "MAP19",

  liquid = false

}

---- cave stalactites/stalagmites with vines ----

PREFABS.Decor_dem_stalav1 =
{
  file   = "decor/dem_props_nature.wad",
  map    = "MAP20",

  prob   = 3000,

  env    = "cave",

  where  = "point",
  size   = 104,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "stretch",

  tex_MIDVINE1 = {
    MIDVINE1=50, MIDVINE2=50,
    },

texture_pack = "armaetus",

  liquid = true,

}

PREFABS.Decor_dem_stalav2 =
{
  template  = "Decor_dem_stalav1",
  map    = "MAP21",

  liquid = false,

  z_fit = { 12,128 }
}

PREFABS.Decor_dem_stalav3 =
{
  template  = "Decor_dem_stalav1",
  map    = "MAP22",

  liquid = true,

  z_fit = { 12,128 }
}

PREFABS.Decor_dem_stalav4 =
{
  template  = "Decor_dem_stalav1",
  map    = "MAP23",

  liquid = true,

  z_fit = { 12,128 }
}

PREFABS.Decor_dem_stalav5 =
{
  template  = "Decor_dem_stalav1",
  map    = "MAP24",

  liquid = false,
}

---- outdoors and cave ruins ----

PREFABS.Decor_dem_ruins1 =
{
  file   = "decor/dem_props_nature.wad",
  map    = "MAP25",

  theme = "!hell",

  prob   = 3000,

  env    = "nature",

  where  = "point",
  size   = 104,

  bound_z1 = 0,
  bound_z2 = 128,

texture_pack = "armaetus",

}

PREFABS.Decor_dem_ruins2 =
{
  template  = "Decor_dem_ruins1",
  map    = "MAP26",

}

PREFABS.Decor_dem_ruinsjs1 =
{
  file   = "decor/dem_props_nature.wad",
  map    = "MAP27",
  engine = "zdoom",

  theme = "!hell",

  prob   = 800,

  style = "secrets",

  jump_crouch = true,

  env    = "nature",

  where  = "point",
  size   = 104,

  bound_z1 = 0,
  bound_z2 = 152,

texture_pack = "armaetus",

  thing_2023 =
  {
    green_armor = 50,
    berserk = 50,
    invis = 50,
    allmap = 50,
    goggles = 50,
  }

}

PREFABS.Decor_dem_ruinsjs2 =
{
  template  = "Decor_dem_ruinsjs1",
  map    = "MAP28",

}

----  cave radium ore ----

PREFABS.Decor_dem_radium_ore1 =
{
  file   = "decor/dem_props_nature.wad",
  map    = "MAP29",

  prob   = 4500,

  env    = "cave",

  where  = "point",
  size   = 104,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",

texture_pack = "armaetus",

}

PREFABS.Decor_dem_radium_ore2 =
{
  template  = "Decor_dem_radium_ore1",
  map    = "MAP30",

  engine = "zdoom",

  z_fit = { 26,60 },


}

PREFABS.Decor_dem_radium_ore3 =
{
  template  = "Decor_dem_radium_ore1",
  map    = "MAP31",

}

PREFABS.Decor_dem_radium_ore4 =
{
  template  = "Decor_dem_radium_ore1",
  map    = "MAP32",

}

PREFABS.Decor_dem_radium_ore5 =
{
  template  = "Decor_dem_radium_ore1",
  map    = "MAP33",

  z_fit = "stretch",

}

PREFABS.Decor_dem_radium_ore6 =
{
  template  = "Decor_dem_radium_ore1",
  map    = "MAP34",

  z_fit = { 52,120 },

}

PREFABS.Decor_dem_radium_ore7 =
{
  template  = "Decor_dem_radium_ore1",
  map    = "MAP35",

  engine = "zdoom",

  z_fit = "bottom",

}

PREFABS.Decor_dem_radium_ore8 =
{
  template  = "Decor_dem_radium_ore1",
  map    = "MAP36",

  z_fit = "bottom",

}

PREFABS.Decor_dem_radium_ore9 =
{
  template  = "Decor_dem_radium_ore1",
  map    = "MAP37",

  engine = "zdoom",

  z_fit = { 80,88 },

}

PREFABS.Decor_dem_radium_ore10 =
{
  template  = "Decor_dem_radium_ore1",
  map    = "MAP38",

  engine = "zdoom",

}

PREFABS.Decor_dem_radium_ore11 =
{
  template  = "Decor_dem_radium_ore1",
  map    = "MAP39",

  size   = 64,

}