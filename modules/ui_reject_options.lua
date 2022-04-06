------------------------------------------------------------------------
--  PANEL: REJECT Builder Options
------------------------------------------------------------------------
--
--  Copyright (C) 2021-2022 Dashodanger
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

UI_REJECT_OPTIONS = { }

function UI_REJECT_OPTIONS.setup(self)

  module_param_up(self)

end

OB_MODULES["ui_reject_options"] =
{

  name = "ui_reject_options",

  label = _("Map Build Options"),
  
  engine = "!advanced",

  side = "left",
  priority = 105,

  hooks = 
  {
    pre_setup = UI_REJECT_OPTIONS.setup,
  },

  options =
  {
    {
      name = "bool_build_reject",
      label = _("Build REJECT"),
      valuator = "button",
      default = 0,
      tooltip = "Choose to build a proper REJECT lump.",
      longtip = "If this option is not selected, a blank REJECT lump with the proper size will be inserted into the map instead." ..
      "\n\nThis is to prevent errors with some engines that are expecting a \"full\" REJECT lump to be present."
    }
  }
}

UI_UDMF_MAP_OPTIONS = { }

function UI_UDMF_MAP_OPTIONS.setup(self)
  
  module_param_up(self)

end

UI_UDMF_MAP_OPTIONS.MAP_FORMAT_CHOICES = 
{
  "binary",  _("Binary"),
  "udmf", _("UDMF"),
}

OB_MODULES["ui_udmf_map_options"] =
{

  name = "ui_udmf_map_options",

  label = _("Map Build Options"),
  
  engine = "eternity", -- Other UDMF-capable engines may go in this group in the future - Dasho

  side = "left",
  priority = 105,

  hooks = 
  {
    pre_setup = UI_UDMF_MAP_OPTIONS.setup,
  },

  options =
  {
    {
      name = "map_format",
      label = _("Map Format"),
      choices = UI_UDMF_MAP_OPTIONS.MAP_FORMAT_CHOICES,
      default = "udmf",
      tooltip = "Choose between UDMF and binary map format.",
    }
  }
}

UI_ZDOOM_MAP_OPTIONS = { }

function UI_ZDOOM_MAP_OPTIONS.setup(self)
  
  module_param_up(self)

end

UI_ZDOOM_MAP_OPTIONS.MAP_FORMAT_CHOICES = 
{
  "binary",  _("Binary"),
  "udmf", _("UDMF"),
}

OB_MODULES["ui_zdoom_map_options"] =
{

  name = "ui_zdoom_map_options",

  label = _("Map Build Options"),
  
  engine = "zdoom",

  side = "left",
  priority = 105,

  hooks = 
  {
    pre_setup = UI_ZDOOM_MAP_OPTIONS.setup,
  },

  options =
  {
    {
      name = "bool_build_nodes_zdoom",
      label = _("Build Nodes"),
      valuator = "button",
      default = 0,
      tooltip = "Choose to either build nodes or allow the engine itself to do so " ..
      "upon loading the map.",
      longtip = "ZDoom is capable of building its own nodes in either Binary or UDMF.\n\n" ..
        "Obsidian uses the same internal nodebuilder as ZDoom, so maps should be compatible either way."
    },
    {
      name = "map_format_zdoom",
      label = _("Map Format"),
      choices = UI_ZDOOM_MAP_OPTIONS.MAP_FORMAT_CHOICES,
      default = "udmf",
      tooltip = "Choose between UDMF and binary map format.",
    }
  }
}
