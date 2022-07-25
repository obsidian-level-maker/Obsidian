------------------------------------------------------------------------
--  NUKEM THEMES
------------------------------------------------------------------------

NUKEM.SINKS =
{
  -- sky holes --

  sky_plain =
  {
    mat   = "_SKY",
    dz    = 64,
  },

  -- liquid floor --

  liquid_plain =
  {
    mat = water,
    dz  = -12
  }

}


NUKEM.THEMES =
{
  DEFAULTS =
  {

    keys =
    {
      k_yellow = 50,
    },

    skyboxes =
    {

    },

    cage_lights = { 0, 8, 12, 13 },

    pool_depth = 24
  },


  nukem_city =
  {

   style_list =
    {
      caves = { none=60, few=40, some=12, heaps=2 },
      outdoors = { none=10, few=35, some=90, heaps=30 },
      pictures = { few=20, some=80, heaps=30 },
      hallways = { none=30, few=80, some=15, heaps=10 },
      windows = { few=25, some=50, heaps=90 },
      cages = { none=30, few=50, some=20, heaps=10 },
      liquids = { none=45, few=30, some=20, heaps=5 },
      doors = { few=20, some=70, heaps=30 },
      steepness = { few=25, some=50, heaps=90 },
      big_rooms = { none=25, few=40, some=25, heaps=15 },
      ambushes = { none=5, few=20, some=75, heaps=30 },
      teleporters = { none=20, few=30, some=65, heaps=10 },
      keys = { none=15, few=50, some=50, heaps=20 },
      symmetry = { none=40, few=30, some=35, heaps=25 },
      switches = { none=20, few=60, some=40, heaps=10 },
      secrets = { few=5, some=80, heaps=25 },
      traps   = { none=10, few=40, some=70, heaps=25 },
      barrels = { none=10, few=50, some=20, heaps=5 }
    },

    liquids =
    {
      water  = 50,
      slime = 15,
      plasma = 10,
    },

    narrow_halls =
    {
      vent = 50
    },

    wide_halls =
    {
      deuce = 50
    },

    floor_sinks =
    {
      liquid_plain = 50
    },

    ceiling_sinks =
    {
      sky_plain = 50
    },

    fences =
    {
      STONES = 30,
      BSTONES = 10,
      WOOD3 = 20
    },

    cage_mats =
    {
      STONES = 30,
      BSTONES = 10,
      WOOD3 = 20
    },

    facades =
    {
      BRN_BRICK = 30,
      WINDOW1 = 10,
      WINDOW2 = 20,
      BRICK2 = 10,
      GRNBRICK = 30,
      GRAYBRICK = 10,
      REDSLATS = 30,
      IRON = 10
    },

    fence_groups =
    {
      PLAIN = 50
    },

    fence_posts =
    {
      Post = 50
    },

    beam_groups =
    {
      beam_metal = 50
    },

    window_groups =
    {
      straddle = 70,
    },

    wall_groups =
    {
      PLAIN = 50
    },

    cave_torches =
    {

    },

    outdoor_torches =
    {

    },

    ceil_light_prob = 70,

    scenic_fences =
    {
      MASKWALL5 = 50,
    },

    sink_style =
    {
      sharp = 1,
      curved = 0.1
    },

    steps_mat = "IRON",

    post_mat  = "WOOD3"

  }

}


NUKEM.ROOM_THEMES =
{

  nukem_city_Generic =
  {
    env  = "building",
    prob = 50,

    walls =
    {
      BRN_BRICK = 30,
      WINDOW1 = 10,
      WINDOW2 = 20,
      BRICK2 = 10,
      GRNBRICK = 30,
      GRAYBRICK = 10,
      REDSLATS = 30,
      IRON = 10
    },

    floors =
    {
      GRAYCIRCLE = 50,
      CLANG1 = 50,
      GRAYFLAT = 50,
      REDCARPET = 50
    },

    ceilings =
    {
      IRON = 30,
      GRAYCIRCLE = 10,
      ROOF1 = 20,
      ROOF2 = 10,
    }
  },

 nukem_city_Hallway_curve =
  {
    env   = "hallway",
    group = "curve",
    prob = 50,

    walls =
    {
      BRN_BRICK = 30,
      WINDOW1 = 10,
      WINDOW2 = 20,
      BRICK2 = 10,
      GRNBRICK = 30,
      GRAYBRICK = 10,
      REDSLATS = 30,
      IRON = 10
    },

    floors =
    {
      GRAYCIRCLE = 50,
      CLANG1 = 50,
      GRAYFLAT = 50,
      REDCARPET = 50
    },

    ceilings =
    {
      IRON = 30,
      GRAYCIRCLE = 10,
      ROOF1 = 20,
      ROOF2 = 10,
    }
  },

  nukem_city_Hallway_vent =
  {
    env   = "hallway",
    group = "vent",
    prob = 50,

    walls =
    {
      BRN_BRICK = 30,
      WINDOW1 = 10,
      WINDOW2 = 20,
      BRICK2 = 10,
      GRNBRICK = 30,
      GRAYBRICK = 10,
      REDSLATS = 30,
      IRON = 10
    },

    floors =
    {
      GRAYCIRCLE = 50,
      CLANG1 = 50,
      GRAYFLAT = 50,
      REDCARPET = 50
    },

    ceilings =
    {
      IRON = 30,
      GRAYCIRCLE = 10,
      ROOF1 = 20,
      ROOF2 = 10,
    }
  },

  nukem_city_Outdoors =
  {
    env  = "outdoor",
    prob = 50,

    floors =
    {
      MUD=50, 
      GRASS=50,
      CRETE1=20, 
      CONC1=20, 
      CONC2=20,
      BLOCKS1=30, 
      BLOCKS2=30,
      ROCK1=15, 
      ROCK2=15, 
      ROCK3=15, 
      ROCK4=15,
      ROCK5=15, 
      ROCK6=15, 
      ROCK7=15,
      SMROCK1=20, 
      SMROCK2=20, 
      SMROCK3=20
    },

    naturals =
    {
      MUD=50, 
      GRASS=50,
      CRETE1=20, 
      CONC1=20, 
      CONC2=20,
      BLOCKS1=30, 
      BLOCKS2=30,
      ROCK1=15, 
      ROCK2=15, 
      ROCK3=15, 
      ROCK4=15,
      ROCK5=15, 
      ROCK6=15, 
      ROCK7=15,
      SMROCK1=20, 
      SMROCK2=20, 
      SMROCK3=20
    },

    porch_floors =
    {
      MUD=50, 
      GRASS=50,
      CRETE1=20, 
      CONC1=20, 
      CONC2=20,
      BLOCKS1=30, 
      BLOCKS2=30,
      ROCK1=15, 
      ROCK2=15, 
      ROCK3=15, 
      ROCK4=15,
      ROCK5=15, 
      ROCK6=15, 
      ROCK7=15,
      SMROCK1=20, 
      SMROCK2=20, 
      SMROCK3=20
    },

  },

  nukem_city_Cave =
  {
    env  = "cave",
    prob = 50,

    floors =
    {
      MUD=50, 
      GRASS=50,
      CRETE1=20, 
      CONC1=20, 
      CONC2=20,
      BLOCKS1=30, 
      BLOCKS2=30,
      ROCK1=15, 
      ROCK2=15, 
      ROCK3=15, 
      ROCK4=15,
      ROCK5=15, 
      ROCK6=15, 
      ROCK7=15,
      SMROCK1=20, 
      SMROCK2=20, 
      SMROCK3=20
    },

    walls =
    {
      MUD=50, 
      GRASS=50,
      CRETE1=20, 
      CONC1=20, 
      CONC2=20,
      BLOCKS1=30, 
      BLOCKS2=30,
      ROCK1=15, 
      ROCK2=15, 
      ROCK3=15, 
      ROCK4=15,
      ROCK5=15, 
      ROCK6=15, 
      ROCK7=15,
      SMROCK1=20, 
      SMROCK2=20, 
      SMROCK3=20
    }
  }

}
------------------------------------------------------------------------


NUKEM.ROOMS =
{
  GENERIC =
  {
    env = "any"
  },

  OUTSIDE =
  {
    env = "outdoor",
    prob = 50
  }

}


------------------------------------------------------------------------


OB_THEMES["nukem_city"] =
{
  label = _("Nukem City"),
  game = "nukem",
  name_theme = "URBAN",
  mixed_prob = 50
}

