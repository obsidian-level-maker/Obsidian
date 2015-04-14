--------------------------------------------------------------------
--  The Plutonia Experiment
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2015 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

PLUTONIA = { }


PLUTONIA.PARAMETERS =
{
  bex_map_prefix = "PHUSTR_"
}


--------------------------------------------------------------------

OB_GAMES["plutonia"] =
{
  label = "Plutonia Exp."

  extends = "doom2"

  tables =
  {
    PLUTONIA
  }
}

