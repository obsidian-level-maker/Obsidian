------------------------------------------------------------------------
--  PANEL: Alternate shape grammars
------------------------------------------------------------------------
--
--  Copyright (C) 2016-2017 Andrew Apted
--  Copyright (C) 2019 Armaetus
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
      name = "float_grammar_boxes_of_death",
      label = _("Boxes of Death"),
      valuator = "slider",
      units = _("% Chance Per Level"),
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      tooltip = _("Sets chance of levels using the Boxes of Death shape grammar."),
      longtip = _("Gives levels a chance of being generated using Boxes of Death shape grammar. With this grammar, rooms are square shaped, with the occasional chunk taken out of one of the corners or sides. Room sizes are very consistent."),
      priority = 102,
      randomize_group = "architecture",
    },

    {
      name = "float_grammar_oblige_745",
      label = _("Oblige 7.45"),
      valuator = "slider",
      units = _("% Chance Per Level"),
      min = 0,
      max = 100,
      increment = 1,
      default = 0,
      tooltip = _("Sets chance of levels using the shape grammar from Oblige v7.45."),
      longtip = _("Gives levels a chance of being generated using the shape grammar from Oblige v7.45. This is primarily to provide a simpler grammar for facilitating new game support, but is available for curious users as well."),
      priority = 102,
      randomize_group = "architecture",
    },

  },
}
