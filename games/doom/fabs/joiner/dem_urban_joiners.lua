--
-- Joiners for urban
--

--a living room joiner
PREFABS.Joiner_living_room =
{
  file   = "joiner/dem_urban_joiners.wad",
  map    = "MAP01",

  engine = "zdoom",

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

  prob = 3000,

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

  prob = 3000,

  env      = "outdoor",
  neighbor = "outdoor",

  seed_w = 3,
  seed_h = 2,

  tex_EVILFACA = "WOOD4",
  tex_TVSNOW01 = "SPACEW3"
}

--a bedroom joiner but with a secret
PREFABS.Joiner_bedroom2 =
{
  template = "Joiner_living_room",
  map = "MAP04",

  prob = 2500,

  theme = "urban",

  engine = "zdoom",

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

  engine = "zdoom",

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
  flat_GRENFLOR = "GRASS1"
}

--an appartment stairwell joiner
PREFABS.Joiner_stairwell =
{
  template = "Joiner_living_room",
  map = "MAP05",

  prob = 5000,

  engine = "zdoom",

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

  engine = "zdoom",

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

  engine = "zdoom",

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
    STONE2=50, SHAWN4=50, SHAWN5=50,
    STUCCO=50, STUCCO1=50, STUCCO3=50,
    STARGR1=50, GRAY7=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH16=50, GOTH31=50, WD03=50,
  },

  tex_TEKGRDR = "SHAWN1"
}

--a waiting room joiner
PREFABS.Joiner_waiting_room =
{
  template = "Joiner_living_room",
  map = "MAP07",

  engine = "zdoom",

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

  engine = "zdoom",

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
    STONE2=50, SHAWN4=50, SHAWN5=50,
    STUCCO=50, STUCCO1=50,  STUCCO3=50, STARGR1=50, GRAY7=50,
    PANEL6=50,
  },
  tex_CPAQLRRE = {
    SKY1 = 50, SKY2 = 50, SKY3 = 50
  },
  flat_FASHWITE = "CRATOP1",
  flat_SNOW5 = "CRATOP1"
}

--a raided electronic store joiner
PREFABS.Joiner_electronic_store =
{
  template = "Joiner_living_room",
  map = "MAP08",

  engine = "zdoom",

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

  engine = "zdoom",

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
    STONE2=50, SHAWN4=50, SHAWN5=50,
    STUCCO=50,  STUCCO1=50, STUCCO3=50, STARGR1=50
  },
  tex_TVSNOW01 = "SPACEW3",
  flat_TILES4 = "FLOOR0_5",

  flat_GROUND04 = "GRASS1",
  tex_GREEN01 = "ZIMMER1"
}

--a raided cornerstore
PREFABS.Joiner_cornerstore =
{
  template = "Joiner_living_room",
  map = "MAP09",

  engine = "zdoom",

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

  engine = "zdoom",

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
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH31=50, BRICK9=50,
    BRICK10=50,TANROCK2=50, TANROCK3=50
  },

  tex_DNSTOR05 = "STEP4",
  tex_DNSTOR06 = "STEP4",
  tex_DNSTOR09 = "STEP4",
  tex_MIDSPAC5 = "MIDSPACE"
}

--a fairly intact bookstore
PREFABS.Joiner_bookstore =
{
  template = "Joiner_living_room",
  map = "MAP10",

  engine = "zdoom",

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

  engine = "zdoom",

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
    STUCCO3=50, BRIKS43=50,
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
  flat_GRENFLOR = "GRASS1"
}

--an elevator shaft
PREFABS.Joiner_elevatorshaft =
{
  template = "Joiner_living_room",
  map    = "MAP11",

  engine = "zdoom",

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

  engine = "zdoom",

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
