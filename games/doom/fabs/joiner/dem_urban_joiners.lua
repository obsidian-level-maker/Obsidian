--
-- Joiners for urban
--

--a living room joiner
PREFABS.Joiner_living_room =
{
  file   = "joiner/dem_urban_joiners.wad",
  map    = "MAP01",

  port = "zdoom",

  prob   = 3500,

  theme  = "urban",

  env      = "outdoor",
  neighbor = "building",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
    STUCCO=50,  STUCCO1=50,  STUCCO3=50,
  },
}

--a kitchen joiner
PREFABS.Joiner_kitchen =
{
  template = "Joiner_living_room",
  map = "MAP02",

  prob = 7500,

  env      = "outdoor",
  neighbor = "outdoor",

  seed_w = 2,
  seed_h = 3,

  can_flip = true
}

--a bedroom joiner
PREFABS.Joiner_bedroom =
{
  template = "Joiner_living_room",
  map = "MAP03",

  prob = 2500,

  env      = "outdoor",
  neighbor = "outdoor",

  seed_w = 3,
  seed_h = 2,

  texture_pack = "armaetus",
  replaces = "Joiner_bedroom_vanilla"
}

PREFABS.Joiner_bedroom_vanilla =
{
  template = "Joiner_living_room",
  map = "MAP03",

  prob = 2500,

  env      = "outdoor",
  neighbor = "outdoor",

  seed_w = 3,
  seed_h = 2,

  tex_EVILFACA = "WOOD4",
  tex_TVSNOW01 = "SPACEW3",
  flat_GRENFLOR = "GRASS1",
  tex_SKIN4 = "SKIN2",
	tex_GOTH13 = "STONE4",
	tex_COLLITE1 = "SHAWN2",
}

--a bedroom joiner but with a secret
PREFABS.Joiner_bedroom2 =
{
  template = "Joiner_living_room",
  map = "MAP04",

  prob = 2500,

  theme = "urban",

  port = "zdoom",

  env      = "outdoor",
  neighbor = "outdoor",

  style = "secrets",

  seed_w = 3,
  seed_h = 2,

  texture_pack = "armaetus",
  replaces = "Joiner_bedroom2_vanilla",

  thing_2013 =
  {
    soul = 50,
    blue_armor = 50,
  }
}

PREFABS.Joiner_bedroom2_vanilla =
{
  template = "Joiner_living_room",
  map = "MAP04",

  prob = 2500,

  theme = "urban",

  port = "zdoom",

  env      = "outdoor",
  neighbor = "outdoor",

  style = "secrets",

  seed_w = 3,
  seed_h = 2,

  thing_2013 =
  {
    soul = 50,
    blue_armor = 50,
  },

  tex_EVILFACA = "WOOD4",
  tex_TVSNOW01 = "SPACEW3",
  flat_GRENFLOR = "GRASS1",
  tex_SKIN4 = "SKIN2",
	tex_GOTH13 = "STONE4",
	tex_COLLITE1 = "SHAWN2",
}

--an appartment stairwell joiner
PREFABS.Joiner_stairwell =
{
  template = "Joiner_living_room",
  map = "MAP05",

  prob = 5000,

  port = "zdoom",

  env      = "outdoor",
  neighbor = "outdoor",

  style = "steepness",

  seed_w = 2,
  seed_h = 3,

  delta_h = 96,
  nearby_h = 272
}

--a bar joiner
PREFABS.Joiner_bar =
{
  template = "Joiner_living_room",
  map = "MAP06",

  port = "zdoom",

  prob = 3500,

  env = "outdoor",
  neighbor = "building",

  seed_w = 3,
  seed_h = 2,

  texture_pack = "armaetus",
  replaces = "Joiner_bar_vanilla",

  tex_BRICK9 = "BRICK9",
  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, SHAWN4=50, SHAWN5=50,
    STUCCO=50, STUCCO1=50, STUCCO3=50,
    STARGR1=50, GRAY7=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH16=50, GOTH31=50, WD03=50,
  },
}

PREFABS.Joiner_bar_vanilla =
{
  template = "Joiner_living_room",
  map = "MAP06",

  port = "zdoom",

  prob = 3500,

  env = "outdoor",
  neighbor = "building",

  seed_w = 3,
  seed_h = 2,

  tex_BRICK9 = "BRICK9",
  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, 
    STUCCO=50, STUCCO1=50, STUCCO3=50,
    STARGR1=50, GRAY7=50,
    PANEL6=50,  },
  tex_MIDSPAC5 = "MIDSPACE",
  tex_TEKGRDR = "SHAWN1"
}

--a waiting room joiner
PREFABS.Joiner_waiting_room =
{
  template = "Joiner_living_room",
  map = "MAP07",

  port = "zdoom",

  prob = 2500,

  env = "outdoor",
  neighbor = "building",

  seed_w = 3,
  seed_h = 2,

  texture_pack = "armaetus",
  replaces = "Joiner_waiting_room_vanilla",

  tex_BRICK9 = "BRICK9",
  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, SHAWN4=50, SHAWN5=50,
    STUCCO=50,  STUCCO1=50,  STUCCO3=50, STARGR1=50, GRAY7=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH16=50, GOTH31=50, WD03=50
  },
  tex_CPAQLRRE = {
    CPAQLRRE=50, CPGARDEN=50, CPGARDN2=50,
    CPHRSEMN=50, CPHRSMN2=50
  }
}

PREFABS.Joiner_waiting_room_vanilla =
{
  template = "Joiner_living_room",
  map = "MAP07",

  port = "zdoom",

  prob = 2500,

  env = "outdoor",
  neighbor = "building",

  seed_w = 3,
  seed_h = 2,

  tex_BRICK9 = "BRICK9",
  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50,
    STUCCO=50,  STUCCO1=50,  STUCCO3=50, STARGR1=50, GRAY7=50,
    PANEL6=50, },
  tex_CPAQLRRE = {
    SKY1 = 50, SKY2 = 50, SKY3 = 50
  },
  flat_GRENFLOR = "GRASS1",
  flat_SNOW5 = "FLAT19",
  flat_FASHWITE = "FLAT5_4",
  tex_TEKSHAW = "SILVER1",
  tex_SHAWN01C = "SILVER1",
}

--a raided electronic store joiner
PREFABS.Joiner_electronic_store =
{
  template = "Joiner_living_room",
  map = "MAP08",

  port = "zdoom",

  prob = 2500,

  env = "outdoor",
  neighbor = "building",

  seed_w = 3,
  seed_h = 2,

  texture_pack = "armaetus",
  replaces = "Joiner_electronic_store_vanilla",

  tex_BRICK9 = "BRICK9",
  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, SHAWN4=50, SHAWN5=50,
    STUCCO=50,  STUCCO1=50, STUCCO3=50, STARGR1=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH16=50, GOTH31=50, WD03=50
  }
}

PREFABS.Joiner_electronic_store_vanilla =
{
  template = "Joiner_living_room",
  map = "MAP08",

  port = "zdoom",

  prob = 2500,

  env = "outdoor",
  neighbor = "building",

  seed_w = 3,
  seed_h = 2,

  tex_BRICK9 = "BRICK9",
  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50,
    STUCCO=50,  STUCCO1=50, STUCCO3=50, STARGR1=50
  },
  tex_TVSNOW01 = "SPACEW3",
  flat_TILES4 = "FLOOR0_5",

  flat_GROUND04 = "GRASS1",
  tex_GREEN01 = "ZIMMER1",
  tex_FENCE6 = "MIDSPACE",
  tex_COMPSA20 = "BLAKWAL1",
  tex_GROUND04 = "ZIMMER7",
}

--a raided cornerstore
PREFABS.Joiner_cornerstore =
{
  template = "Joiner_living_room",
  map = "MAP09",

  port = "zdoom",

  prob = 4500,

  env = "outdoor",
  neighbor = "building",

  seed_w = 2,
  seed_h = 3,

  texture_pack = "armaetus",
  replaces = "Joiner_cornerstore_vanilla",

  tex_BRICK9 = "BRICK9",
  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, STUCCO=50,  STUCCO1=50,
    STUCCO3=50, STARGR1=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH31=50, BRICK9=50,
    BRICK10=50,TANROCK2=50, TANROCK3=50
  }
}

PREFABS.Joiner_cornerstore_vanilla =
{
  template = "Joiner_living_room",
  map = "MAP09",

  port = "zdoom",

  prob = 4500,

  env = "outdoor",
  neighbor = "building",

  seed_w = 2,
  seed_h = 3,

  tex_BRICK9 = "BRICK9",
  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, STUCCO=50,  STUCCO1=50,
    STUCCO3=50, STARGR1=50,
    PANEL6=50, BRICK9=50,
    BRICK10=50,TANROCK2=50, TANROCK3=50
  },

  tex_DNSTOR02 = "STEP4",
  tex_DNSTOR05 = "STEP4",
  tex_DNSTOR06 = "STEP4",
  tex_DNSTOR09 = "STEP4",
  tex_MIDSPAC5 = "MIDSPACE",
  flat_TILES4 = "FLOOR0_5",
}

--a fairly intact bookstore
PREFABS.Joiner_bookstore =
{
  template = "Joiner_living_room",
  map = "MAP10",

  port = "zdoom",

  prob = 4500,

  env = "outdoor",
  neighbor = "building",

  where = "seeds",
  shape = "I",

  seed_w = 2,
  seed_h = 3,

  texture_pack = "armaetus",
  replaces = "Joiner_bookstore_vanilla",

  tex_BRICK9 = "BRICK9",
  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STUCCO=50, STUCCO1=50,
    STUCCO3=50, BRIKS43=50,
    GOTH31=50,GOTH16=50,GOTH02=50,
    BRICK9=50, TANROCK2=50, TANROCK3=50
  }
}

PREFABS.Joiner_bookstore_vanilla =
{
  template = "Joiner_living_room",
  map = "MAP10",

  port = "zdoom",

  prob = 4500,

  env = "outdoor",
  neighbor = "building",

  where = "seeds",
  shape = "I",

  seed_w = 2,
  seed_h = 3,

  tex_BRICK9 = "BRICK9",
  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STUCCO=50, STUCCO1=50,
    STUCCO3=50,
    BRICK9=50, TANROCK2=50, TANROCK3=50
  },

  tex_PANBOOK1 = "PANBOOK",
  tex_PANBOOK2 = "PANBOOK",
  tex_PANBOOK3 = "PANBOOK",
  tex_PANBOOK4 = "PANBOOK",
  tex_TEKSHAW = "SILVER1",
  tex_FENCE9 = "MIDSPACE",
  tex_COLLITE3 = "COMPBLUE",
  tex_GOTH13 = "SHAWN2",
  flat_GATE4YL = "FLAT5_5",
  flat_GRENFLOR = "GRASS1",
  flat_CEIL4_4 = "CEIL4_2",
  tex_COLLITE1 = "SHAWN2",
  tex_COMPTIL5 = "COMPSPAN",
}

--an elevator shaft
PREFABS.Joiner_elevatorshaft =
{
  template = "Joiner_living_room",
  map    = "MAP11",

  port = "zdoom",

  prob   = 1000,
  skip_prob = 50,

  theme  = "!hell",

  env      = "building",
  neighbor = "building",

  seed_w = 2,
  seed_h = 2,

  delta_h = 256,
  nearby_h = 328,

  texture_pack = "armaetus",

  tex_BRICK9 = "BRICK9",
  tex_BROWN1 = {
    GRAY1=50, GRAY4=50, GRAY5=50, GRAY6=50,
    GRAY7=50, GRAY8=50, GRAY9=50, CEMENT3=50,
    CEMENT7=50,
    CEM01=50, CEM07=50, CEM09=50, PIPE2=50,
    PIPE4=50, SLADWALL=50, TEKLITE=50, BROWN3=50,
    MET2=50, METAL6=50, METAL7=50, PIPEDRK1=50,
    SHAWGRY4=50, SHAWN01C=50, SHAWN01F=50,
    SHAWVEN2=50, SHAWVENT=50
  }
}

--a corrupted elevator shaft
PREFABS.Joiner_elevatorshaftcorr =
{
  template = "Joiner_living_room",
  map    = "MAP12",

  port = "zdoom",

  prob   = 1000,
  skip_prob = 50,

  theme  = "!hell",

  env      = "building",
  neighbor = "building",

  seed_w = 2,
  seed_h = 2,

  delta_h = 256,
  nearby_h = 328,

  texture_pack = "armaetus",

  tex_BRICK9 = "BRICK9",
  tex_BROWN1 = {
    GRAY1=50, GRAY4=50, GRAY5=50, GRAY6=50,
    GRAY7=50, GRAY8=50, GRAY9=50, CEMENT3=50,
    CEMENT7=50,
    CEM01=50, CEM07=50, CEM09=50, PIPE2=50,
    PIPE4=50, SLADWALL=50, TEKLITE=50, BROWN3=50,
    MET2=50, METAL6=50, METAL7=50, PIPEDRK1=50,
    SHAWGRY4=50, SHAWN01C=50, SHAWN01F=50,
    SHAWVEN2=50, SHAWVENT=50
  }
}

--a store entrance
PREFABS.Joiner_commmercial_joiner =
{
  template = "Joiner_living_room",
  map    = "MAP13",

  port = "zdoom",

rank = 1,

  prob   = 1000,

  theme  = "!hell",

  env      = "building",

  group = "dem_wall_commercial",

  seed_w = 2,
  seed_h = 2,

  can_flip = false,


  texture_pack = "armaetus",

}


--a hospital entrance
PREFABS.Joiner_hospital_joiner =
{
  template = "Joiner_living_room",
  map    = "MAP14",

  port = "zdoom",


rank = 1,

  prob   = 1000,

  theme  = "!hell",

  env      = "building",
  neighbor = "building",

  group = "dem_wall_hospital",

  seed_w = 2,
  seed_h = 2,

  can_flip = false,

  texture_pack = "armaetus",

  deep = 16,

}


--a hospital room broken window entrance
PREFABS.Joiner_hospital_room_joiner =
{
  template = "Joiner_living_room",
  map    = "MAP15",

  port = "zdoom",

rank = 1,

  prob   = 1000,

  theme  = "!hell",

  env      = "building",
  neighbor = "outdoor",

  group = "dem_wall_hospital",

  seed_w = 2,
  seed_h = 2,

  can_flip = false,

  texture_pack = "armaetus",

  deep = 32,

  thing_20 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    nothing = 50,
  },

}

--a hospital entrance
PREFABS.Joiner_hospital_joiner2 =
{
  template = "Joiner_living_room",
  map    = "MAP16",

  port = "zdoom",


rank = 1,

  prob   = 1000,

  theme  = "!hell",

  env      = "building",
  neighbor = "outdoor",

  group = "dem_wall_hospital",

  seed_w = 2,
  seed_h = 2,

  can_flip = false,

  texture_pack = "armaetus",

  deep = 16,

}

--a yard and house joiner
PREFABS.Joiner_yard_joiner1 =
{
  template = "Joiner_living_room",
  map    = "MAP17",

  prob   = 3500,

  neighbor = "outdoor",

  z_fit  = "top",

  seed_w = 2,
  seed_h = 3,

  can_flip = false,

  texture_pack = "armaetus",

  deep = 16,
  over = 16,

  tex_CITY01 =
  {

    CITY01 = 50,
    CITY02 = 50,
    CITY03 = 50,
    CITY04 = 50,
    CITY05 = 50,
    CITY06 = 50,
    CITY07 = 50,
    CITY11 = 25,
    CITY12 = 25,
    CITY13 = 25,
    CITY14 = 25,
  },


}

--a yard and house joiner 2
PREFABS.Joiner_yard_joiner2 =
{
  template = "Joiner_living_room",
  map    = "MAP18",

  prob   = 3500,

  neighbor = "outdoor",

  z_fit  = "top",

  seed_w = 2,
  seed_h = 3,

  texture_pack = "armaetus",

  deep = 16,
  over = 16,

  jump_crouch = true,


  tex_CITY01 =
  {

    CITY01 = 50,
    CITY02 = 50,
    CITY03 = 50,
    CITY04 = 50,
    CITY05 = 50,
    CITY06 = 50,
    CITY07 = 50,
    CITY11 = 25,
    CITY12 = 25,
    CITY13 = 25,
    CITY14 = 25,
  },

}

--a yard and house joiner 3
PREFABS.Joiner_yard_joiner3 =
{
  template = "Joiner_living_room",
  map    = "MAP19",


rank = 1,

  prob   = 3500,

  neighbor = "outdoor",

  z_fit  = "top",

  seed_w = 2,
  seed_h = 3,

  texture_pack = "armaetus",

  deep = 16,
  over = 64,

  delta = 64,

  jump_crouch = true,

  tex_CITY01 =
  {

    CITY01 = 50,
    CITY02 = 50,
    CITY03 = 50,
    CITY04 = 50,
    CITY05 = 50,
    CITY06 = 50,
    CITY07 = 50,
    CITY11 = 25,
    CITY12 = 25,
    CITY13 = 25,
    CITY14 = 25,
  },

}

--destroyed yard and house joiner 4
PREFABS.Joiner_yard_joiner4 =
{
  template = "Joiner_living_room",
  map    = "MAP20",

  prob   = 3500,

  neighbor = "outdoor",

  seed_w = 2,
  seed_h = 3,

  z_fit  = "top",

  texture_pack = "armaetus",

  deep = 16,
  over = 16,

  tex_CITY01 =
  {

    CITY01 = 50,
    CITY02 = 50,
    CITY03 = 50,
    CITY04 = 50,
    CITY05 = 50,
    CITY06 = 50,
    CITY07 = 50,
    CITY11 = 25,
    CITY12 = 25,
    CITY13 = 25,
    CITY14 = 25,
  },

}


