HARMONY.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"
    _where  = "middle"

    top = "O_BOLT"
  }


  ----| EXITS |----

  Exit_pillar =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

    switch = "SW2SLAD"
    exit = "EXITSIGN"
    exitside = "PURPLE_UGH"

    use_sign = 1
    special = 11
    tag = 0
  }


  ----| STAIRS |----

  Stair_Up1 =
  {
    _prefab = "STAIR_6"
    _where  = "floor"
    _deltas = { 32,48,48,64,64,80 }
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "floor"
    _deltas = { -32,-48,-64,-64,-80,-96 }
  }


  ---| LOCKED DOORS |---

  Locked_green =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kc_green"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112
    door_h = 112
    door = "BIGDOOR4"
    key = "GREENWALL"
    track = "DOORTRAK"

    special = 32
    tag = 0
  }

  Locked_yellow =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kc_yellow"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    door_h = 112
    door = "BIGDOOR4"
    key = "YELLOWLITE"
    track = "DOORTRAK"

    special = 34
    tag = 0
  }

  Locked_purple =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "kc_purple"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    door_h = 112
    door = "BIGDOOR4"
    key = "PURPLE_UGH"
    track = "DOORTRAK"

    special = 33
    tag = 0  -- kind_mult=28
  }


  ---| SWITCHED DOORS |---

  Door_SW_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switch = "sw_blue"
    _long = 192
    _deep = 32

    w = 128
    h = 112

    door = "BIGDOOR3"
    track = "DOORTRAK"

    door_h = 112
    special = 0
  }

  Switch_blue1 =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "middle"
    _switch = "sw_blue"

    switch_h = 64
    switch = "SW2COMM"
    side = "METAL"
    base = "METAL"
    x_offset = 0
    y_offset = 0
    special = 103
  }


  ---| TELEPORTERS |---

  Teleporter1 =
  {
    _prefab = "TELEPORT_PAD"
    _where  = "middle"

    tele = "TELEPORT"
    side = "TELEPORT"

    x_offset = 0
    y_offset = 0
    peg = 1

    special = 97
    effect = 8
    light = 255
  }


  ---| PICTURES |---

  Pic_Logo =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "LOGO_1"
    pic_w = 128
    pic_h = 128

    light = 48
  }


  ---| HALLWAY PIECES |---

  Hall_Basic_I =
  {
    _prefab = "HALL_BASIC_I"
    _shape  = "I"
  }

  Hall_Basic_C =
  {
    _prefab = "HALL_BASIC_C"
    _shape  = "C"
  }

  Hall_Basic_T =
  {
    _prefab = "HALL_BASIC_T"
    _shape  = "T"
  }

  Hall_Basic_P =
  {
    _prefab = "HALL_BASIC_P"
    _shape  = "P"
  }

  Hall_Basic_I_Stair =
  {
    _prefab = "HALL_BASIC_I_STAIR"
    _shape  = "IS"
  }

  Hall_Basic_I_Lift =
  {
    _prefab = "HALL_BASIC_I_LIFT"
    _shape  = "IL"
    _tags   = 1

    lift = "LIFT"
    top  = "LIFT"

    raise_W1 = 130
    lower_WR = 88  -- 120
    lower_SR = 62  -- 123
  }
}

HARMONY.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_pillar = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50 }

  logos = { Pic_Logo = 50 }

  keys = { kc_green=50, kc_purple=50, kc_yellow=50 }

  switches = { sw_blue=50 }

  switch_fabs = { Switch_blue1 = 50 }

  locked_doors = { Locked_green=50, Locked_purple=50, Locked_yellow=50,
                   Door_SW_blue = 50 }

  teleporters = { Teleporter1 = 50 }

  hallway_groups = { basic = 50 }

  mini_halls = { Hall_Basic_I = 50 }
}