--
-- Start pedestal
--

PREFABS.Start_basic =
{
  file   = "start/basic.wad"
  where  = "middle"

  flat_FLAT22 = "O_BOLT"
  tex_SHAWN2  = "O_BOLT"

  -- pass the non-standard players through the ENTITIES table, to
  -- allow them to be removed if a game/port does not support them.
  thing_4001 = "player5"
  thing_4002 = "player6"
  thing_4003 = "player7"
  thing_4004 = "player8"
}

