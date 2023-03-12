--
--  Secret items closets
--

--a secret aera in a garage you need to duck
PREFABS.Item_secret_garage_closet =
{
  file  = "item/dem_secret_closets_urban.wad",
  map   = "MAP01",

  port = "zdoom",

  theme = "urban",
  env = "outdoor",
  prob  = 100,

  key   = "secret",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  jump_crouch = true,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit  = "frame",

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
    STONE3=50, BRICK12=50, BRICK5=50,
    BRONZE1=50, BROWN1=50, BROWN96=50,
    BROWNGRN=50, CEMENT7=50,
    CEMENT9=50,
    },

  can_flip = true,
}

--a secret in a grocery store, shoot the electric panel
PREFABS.Item_secret_store_closet =
{
  file  = "item/dem_secret_closets_urban.wad",
  map   = "MAP02",

  port = "zdoom",

  theme = "urban",
  env = "outdoor",
  prob  = 100,

  key   = "secret",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  texture_pack = "armaetus",
  replaces = "Item_secret_store_closet_vanilla",

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  },

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, STUCCO=50, STUCCO1=50,
    STUCCO3=50, TANROCK2=50, TANROCK3=50,
    SHAWN2=50,
  },

  thing_59 =
  {
    hang_twitching = 50,
    hang_torso = 50,
    hang_leg   = 50,
    hang_leg_gone = 50,
  },

  thing_62 =
  {
    hang_twitching = 50,
    hang_torso = 50,
    hang_leg   = 50,
    hang_leg_gone = 50,
  },

  thing_12 =
  {
    hang_twitching = 50,
    hang_torso = 50,
    hang_leg   = 50,
    hang_leg_gone = 50,
  }
}

PREFABS.Item_secret_store_closet_vanilla =
{
  file  = "item/dem_secret_closets_urban.wad",
  map   = "MAP02",

  port = "zdoom",

  theme = "urban",
  env = "outdoor",
  prob  = 100,

  key   = "secret",

  where  = "seeds",
  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit  = "frame",

  can_flip = true,

  thing_2014 =
  {
    potion = 50,
    helmet = 50,
  },

  tex_DNSTOR02 = "STEP4",
  tex_DNSTOR04 = "STEP4",
  tex_DNSTOR07 = "SHAWN2",

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    STONE2=50, STUCCO=50, STUCCO1=50,
    STUCCO3=50, TANROCK2=50, TANROCK3=50,
    SHAWN2=50,
  },

  thing_59 =
  {
    hang_twitching = 50,
    hang_torso = 50,
    hang_leg   = 50,
    hang_leg_gone = 50,
  },

  thing_62 =
  {
    hang_twitching = 50,
    hang_torso = 50,
    hang_leg   = 50,
    hang_leg_gone = 50,
  },

  thing_12 =
  {
    hang_twitching = 50,
    hang_torso = 50,
    hang_leg   = 50,
    hang_leg_gone = 50,
  }
}

--a secret aera in a burning down building 

PREFABS.Item_secret_yard_closet1 =
{
  file  = "item/dem_secret_closets_urban.wad",
  map   = "MAP03",

  port = "zdoom",
  texture_pack = "armaetus",

  theme = "urban",
  env = "outdoor",

  deep   = 16,
  over   = -16,


  prob  = 1150,

  key   = "secret",

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  jump_crouch = true,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "frame",
  z_fit = "top",

  can_flip = true,

  tex_BRICK9 = {
    BRICK1=50, BRICK10=50, BRICK11=50,
    BRICK2=50, BRICK4=50,
    BRICK6=50, BRICK7=50, BRICK8=50,
    BIGBRIK1=50, BIGBRIK2=50, STONE2=50,
    STONE3=50, BRICK12=50, BRICK5=50,
    BRONZE1=50, BROWN1=50, BROWN96=50,
    BROWNGRN=50, CEMENT7=50,
    CEMENT9=50,
    },

  tex_BRICK9 = {
	BRICK1=50,
	BRICK10=50,
	BRICK11=50,
	BRICK2=50,
	BRICK4=50,
	BRICK6=50,
	BRICK7=50,
	BRICK8=50,
	BIGBRIK1=50,
	BIGBRIK2=50,
	STONE2=50,
	STONE3=50,
	BRICK12=50,
	BRICK5=50,
	BRONZE1=50,
	BROWN1=50,
	BROWN96=50,
	BROWNGRN=50,
	CEMENT7=50,
	CEMENT9=50,
    }
}
--double porch Appartment secret

PREFABS.Item_secret_yard_closet2 =
{
  template = "Item_secret_yard_closet1",
  map      = "MAP04",

  prob  = 240,

  seed_w = 4,
  seed_h = 2,

}

--A secret on top of a big fancy mansion's porch 


PREFABS.Item_secret_yard_closet3 =
{
  template = "Item_secret_yard_closet1",
  map      = "MAP05",

  prob  = 240,

  seed_w = 4,
  seed_h = 2,

}

--A secret in a building filed with skulls

PREFABS.Item_secret_yard_closet4 =
{
  template = "Item_secret_yard_closet1",
  map      = "MAP06",

  jump_crouch = false,

  prob  = 50,

}

--A secret in a downward vent dotting the streets

PREFABS.Item_secret_vent_closet =
{
  template = "Item_secret_yard_closet1",
  map      = "MAP07",


  jump_crouch = false,

  open_to_sky = true,

  prob  = 50,

  seed_w = 1,
  seed_h = 1,

  height = 128,
  deep   = 80,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",
  z_fit = { 65,67 },

}
