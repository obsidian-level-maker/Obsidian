VANILLA = {}


VANILLA.ENTITIES =
{

}


VANILLA.PARAMETERS = -- These probably aren't required - Dasho
{
  boom_lines = false,
  boom_sectors = false
}


----------------------------------------------------------------


OB_ENGINES["vanilla"] =
{
  label = _("Vanilla DOOM"),

  priority = 100,

  game = "doom2",

  tables =
  {
    VANILLA
  },

  hooks =
  {
  
  }
}
