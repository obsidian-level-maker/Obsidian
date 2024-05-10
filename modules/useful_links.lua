----------------------------------------------------------------
--  MODULE: Useful Links
----------------------------------------------------------------
--
--  Copyright (C) 2023 The OBSIDIAN Team
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------

OB_MODULES["links_iwads"] =
{
  label = _("Game WADs (Libre/Freeware)"),

  where = "links",
  priority = 101,

  options =
  {
    { 
      name="url_freedoom",     
      label=_("Freedoom (Doom 1/2 Replacement)"),
      url="https://freedoom.github.io/download.html",
    },
    { 
        name="url_blasphemer",     
        label=_("Blasphemer (Heretic Replacement)"),
        url="https://github.com/Catoptromancy/blasphemer",    
    },
    { 
      name="url_hacx",     
      label=_("HacX 1.2"),
      url="https://www.doomworld.com/idgames/themes/hacx/hacx12",    
    },
    { 
      name="url_harmony",     
      label=_("Harmony Compatible"),
      url="https://www.doomworld.com/idgames/levels/doom2/Ports/g-i/harmonyc",    
    },
    { 
      name="url_rekkr",     
      label=_("REKKR"),
      url="https://www.doomworld.com/idgames/levels/doom/megawads/rekkr",    
    },
  }
}

OB_MODULES["links_addons"] =
{
  label = _("Obsidian Addons"),

  where = "links",
  priority = 101,

  options =
  {
    { 
      name="url_edge_classic_pack",     
      label=_("Lobo's EDGE-Classic Enhancements"),
      url="https://obsidian-level-maker.github.io/index.html#_addons",
    },
    { 
        name="url_mobreck_mbf21",     
        label=_("Mobreck's MBF21 Expanded DOOM Beastiary"),
        url="https://www.moddb.com/mods/the-mbf21-expanded-doom-bestiary-project/downloads/medb-addon-for-obsidian",    
    },
    { 
      name="url_doomrla_pickups",     
      label=_("xBEEKAYRANDEEx's DoomRLA Pickups"),
      url="https://obsidian-level-maker.github.io/index.html#_addons",    
    },
    { 
      name="url_heathens_maze",     
      label=_("Heathen's Maze For Heretic - Craneo"),
      url="https://obsidian-level-maker.github.io/index.html#_addons",    
    },
    { 
      name="url_obsidian_jukebox",     
      label=_("Simon-v's Jukebox"),
      url="https://obsidian-level-maker.github.io/index.html#_addons",    
    },
    { 
      name="url_silentzorah_jukebox",     
      label=_("SilentZorah's Jukebox - Craneo"),
      url="https://obsidian-level-maker.github.io/index.html#_addons",    
    },
    { 
      name="url_delta_resource_pack",     
      label=_("MsrSgtShooterPerson's Delta Resource Pack"),
      url="https://obsidian-level-maker.github.io/index.html#_addons",    
    },
  }
}