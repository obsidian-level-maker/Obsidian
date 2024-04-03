------------------------------------------------------------------------
--  PANEL: Alternate shape grammars
------------------------------------------------------------------------
--
--  Copyright (C) 2016-2017 Andrew Apted
--  Copyright (C) 2019 Reisal
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
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

ALT_SHAPE_GRAMMARS = { }

function ALT_SHAPE_GRAMMARS.setup(self)

  module_param_up(self)

end

OB_MODULES["alt_shape_grammars"] =
{
  name = "alt_shape_grammars",

  label = _("Alternate Shape Grammars"),
    
  where = "arch",
  priority = 102,
  engine = "!idtech_0",
  port = "!limit_enforcing",

  tooltip = _("Options for alternate means of determining the layout of a level."),

  hooks = 
  {
    setup = ALT_SHAPE_GRAMMARS.setup,
  },

  options =
  {

    {
      name = "float_grammar_backhalls",
      label = _("The Backhalls (WIP)"),
      valuator = "slider",
      units = _("% Chance Per Level"),
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      tooltip = _("Sets chance of levels using the Backhalls shape grammar."),
      longtip = _("The true Linear Mode."),
      priority = 103,
      randomize_group = "architecture",
    },

    {
      name = "float_grammar_boxes_of_death",
      label = _("Boxes of Death"),
      valuator = "slider",
      units = _("% Chance Per Level"),
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      tooltip = _("Sets chance of levels using the Boxes of Death shape grammar."),
      longtip = _("It's like that movie Cube, but with .5 less dimensions (if you're a contrarian)."),
      priority = 102,
      randomize_group = "architecture",
    },

    {
      name = "float_grammar_map_01",
      label = _("Eternal Entryway (WIP)"),
      valuator = "slider",
      units = _("% Chance Per Level"),
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      tooltip = _("Sets chance of levels using the Eternal Entryway shape grammar."),
      longtip = _("It's MAP01. This is an example of a non-traditional use of shape grammar to try to force a level layout into a certain shape."),
      priority = 101,
      randomize_group = "architecture",
    },

    {
      name = "float_grammar_oblige_745",
      label = _("The OG"),
      valuator = "slider",
      units = _("% Chance Per Level"),
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      tooltip = _("Sets chance of levels using the OG shape grammar."),
      longtip = _("These are the shapes from Oblige 7.45, one of the earliest examples of the shape grammar system."),
      priority = 100,
      randomize_group = "architecture",
    },

  },
}
