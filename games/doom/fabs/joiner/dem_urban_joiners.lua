--
-- Joiners for urban
--

--a living room joiner
PREFABS.Joiner_living_room =
{
  file   = "joiner/dem_urban_joiners.wad",
  map    = "MAP01",

  engine = "zdoom",

  prob   = 2000,

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
  file = "joiner/dem_urban_joiners.wad",
  map = "MAP02",

  prob = 4500,

  theme = "urban",

  env      = "outdoor",
  neighbor = "outdoor",

  where = "seeds",
  shape = "I",

  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit = "frame",

  can_flip = true,

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
     BRICK6=50, BRICK7=50, BRICK8=50,
     BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
     STUCCO=50, STUCCO1=50, STUCCO3=50,
    },
}

--a bedroom joiner
PREFABS.Joiner_bedroom =
{
  file = "joiner/dem_urban_joiners.wad",
  map = "MAP03",

  prob = 2000,

  theme = "urban",

  engine = "zdoom",

  env      = "outdoor",
  neighbor = "outdoor",

  where = "seeds",
  shape = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  can_flip = true,

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
     BRICK6=50, BRICK7=50, BRICK8=50,
     BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
     STUCCO=50, STUCCO1=50, STUCCO3=50,
    },
}

--a bedroom joiner but with a secret
PREFABS.Joiner_bedroom2 =
{
  file = "joiner/dem_urban_joiners.wad",
  map = "MAP04",

  prob = 2000,

  theme = "urban",

  engine = "zdoom",

  env      = "outdoor",
  neighbor = "outdoor",

  style = "secrets",

  where = "seeds",
  shape = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  can_flip = true,

  thing_2013 =
  {
    soul = 50,
    blue_armor = 50,
  },

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
     BRICK6=50, BRICK7=50, BRICK8=50,
     BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
     STUCCO=50, STUCCO1=50, STUCCO3=50,
    },
}

--an appartment stairwell joiner
PREFABS.Joiner_stairwell =
{
  file = "joiner/dem_urban_joiners.wad",
  map = "MAP05",

  prob = 5000,

  theme = "urban",

  engine = "zdoom",

  env      = "outdoor",
  neighbor = "outdoor",

  where = "seeds",
  shape = "I",

  style = "steepness",

  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  delta_h = 96,
  nearby_h = 272,

  can_flip = true,

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
     BRICK6=50, BRICK7=50, BRICK8=50,
     BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
     STUCCO=50, STUCCO1=50, STUCCO3=50,
    },
}

--a bar joiner
PREFABS.Joiner_bar =
{
  file   = "joiner/dem_urban_joiners.wad",
  map    = "MAP06",

  engine = "zdoom",

  prob   = 2000,

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

  texture_pack = "armaetus",

  can_flip = true,

  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, SHAWN4=50, SHAWN5=50,
    STUCCO=50,  STUCCO1=50,  STUCCO3=50, STARGR1=50, GRAY7=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH16=50, GOTH31=50, WD03=50,
  },
}

--a waiting room joiner
PREFABS.Joiner_waiting_room =
{
  file   = "joiner/dem_urban_joiners.wad",
  map    = "MAP07",

  engine = "zdoom",

  prob   = 2000,

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

  texture_pack = "armaetus",

  can_flip = true,

  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, SHAWN4=50, SHAWN5=50,
    STUCCO=50,  STUCCO1=50,  STUCCO3=50, STARGR1=50, GRAY7=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH16=50, GOTH31=50, WD03=50,
  },

  tex_CPAQLRRE = {
    CPAQLRRE=50, CPGARDEN=50, CPGARDN2=50,
    CPHRSEMN=50, CPHRSMN2=50,
  },
}

--a raided electronic store joiner
PREFABS.Joiner_electronic_store =
{
  file   = "joiner/dem_urban_joiners.wad",
  map    = "MAP08",

  engine = "zdoom",

  prob   = 2000,

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

  texture_pack = "armaetus",

  can_flip = true,

  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, SHAWN4=50, SHAWN5=50,
    STUCCO=50,  STUCCO1=50,  STUCCO3=50, STARGR1=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH16=50, GOTH31=50, WD03=50,
  },

}


--a raided cornerstore
PREFABS.Joiner_cornerstore =
{
  file   = "joiner/dem_urban_joiners.wad",
  map    = "MAP09",

  engine = "zdoom",

  prob   = 4500,

  theme  = "urban",

  env      = "outdoor",
  neighbor = "building",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  can_flip = true,

  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, STUCCO=50,  STUCCO1=50,
    STUCCO3=50, STARGR1=50,
    PANEL6=50, BRIKS40=50, BRIKS43=50,
    GOTH31=50, BRICK9=50,
    BRICK10=50,TANROCK2=50, TANROCK3=50,
  },

}

--a fairly intact bookstore
PREFABS.Joiner_bookstore =
{
  file   = "joiner/dem_urban_joiners.wad",
  map    = "MAP10",

  engine = "zdoom",

  prob   = 4500,

  theme  = "urban",

  env      = "outdoor",
  neighbor = "building",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 3,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  texture_pack = "armaetus",

  can_flip = true,

  tex_STARTAN1 = {
    BRICK1=50, BRICK12=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STUCCO=50, STUCCO1=50,
    STUCCO3=50, BRIKS43=50,
    GOTH31=50,GOTH16=50,GOTH02=50,
    BRICK9=50, TANROCK2=50, TANROCK3=50,
  },

}

--an elevator shaft
PREFABS.Joiner_elevatorshaft =
{
  file   = "joiner/dem_urban_joiners.wad",
  map    = "MAP11",

  engine = "zdoom",

  prob   = 1000,
  skip_prob = 50,

  theme  = "!hell",

  env      = "building",
  neighbor = "building",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  delta_h = 256,
  nearby_h = 328,

  texture_pack = "armaetus",

  can_flip = true,

  tex_BROWN1 = {
    GRAY1=50, GRAY4=50, GRAY5=50, GRAY6=50,
    GRAY7=50, GRAY8=50, GRAY9=50, CEMENT3=50,
    CEMENT7=50,
    CEM01=50, CEM07=50, CEM09=50, PIPE2=50,
    PIPE4=50, SLADWALL=50, TEKLITE=50, BROWN3=50,
    MET2=50, MET6=50, MET7=50, PIPEDRK1=50,
    SHAWGRY4=50, SHAWN01C=50, SHAWN01F=50,
    SHAWVEN2=50, SHAWVENT=50,
  },
}

--a corrupted elevator shaft
PREFABS.Joiner_elevatorshaftcorr =
{
  file   = "joiner/dem_urban_joiners.wad",
  map    = "MAP12",

  engine = "zdoom",

  prob   = 1000,
  skip_prob = 50,

  theme  = "!hell",

  env      = "building",
  neighbor = "building",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit  = "frame",

  delta_h = 256,
  nearby_h = 328,

  texture_pack = "armaetus",

  can_flip = true,

  tex_BROWN1 = {
    GRAY1=50, GRAY4=50, GRAY5=50, GRAY6=50,
    GRAY7=50, GRAY8=50, GRAY9=50, CEMENT3=50,
    CEMENT7=50,
    CEM01=50, CEM07=50, CEM09=50, PIPE2=50,
    PIPE4=50, SLADWALL=50, TEKLITE=50, BROWN3=50,
    MET2=50, MET6=50, MET7=50, PIPEDRK1=50,
    SHAWGRY4=50, SHAWN01C=50, SHAWN01F=50,
    SHAWVEN2=50, SHAWVENT=50,
  },
}
