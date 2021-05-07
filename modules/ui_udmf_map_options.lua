------------------------------------------------------------------------
--  PANEL: UDMF Map Options
------------------------------------------------------------------------
--
--  Copyright (C) 2021 Dashodanger
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

UI_UDMF_MAP_OPTIONS = { }

UI_UDMF_MAP_OPTIONS.MAP_FORMAT_CHOICES = 
{
  "binary",  _("Binary"),
  "udmf", _("UDMF"),
}

OB_MODULES["ui_udmf_map_options"] =
{
  label = _("Map Build Options"),
  
  engine = "advanced",

  side = "left",
  priority = 105,

  options =
  {
    {
      name = "bool_build_reject_udmf",
      label = _("Build REJECT"),
      valuator = "button",
      default = 0,
      tooltip = "Choose to build a proper REJECT lump (Binary map format only). WARNING: This can be very time consuming!",
    },
    {
      name = "bool_build_nodes",
      label = _("Build Nodes"),
      valuator = "button",
      default = 0,
      tooltip = "For ZDoom Only: Choose to either build nodes or allow the engine itself to do so " ..
      "upon loading the map. Other UDMF supporting engines require node building to be enabled.",
    },
    {
      name = "map_format",
      label = _("Map Format"),
      choices = UI_UDMF_MAP_OPTIONS.MAP_FORMAT_CHOICES,
      default = "udmf",
      tooltip = "Choose between UDMF and binary map format.",
    }
  }
}
