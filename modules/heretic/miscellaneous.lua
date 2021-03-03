------------------------------------------------------------------------
--  MODULE: Miscellaneous Stuff
------------------------------------------------------------------------
--
--  Copyright (C) 2009      Enhas
--  Copyright (C) 2009-2017 Andrew Apted
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
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

MISC_STUFF_HERETIC = { }

MISC_STUFF_HERETIC.YES_NO =
{
  "no",  _("No"),
  "yes", _("Yes"),
}

MISC_STUFF_HERETIC.LIGHTINGS =
{
  "flat",    _("FLAT"),
  "lower",   _("Lower"),
  "normal",  _("Normal"),
  "higher",  _("Higher"),
}

MISC_STUFF_HERETIC.LIGHT_CHOICES =
{
  "-3",   _("Pitch-black"),
  "-2",   _("Gloomy"),
  "-1",   _("Darker"),
  "none", _("NONE"),
  "+1",   _("Brighter"),
  "+2",   _("Vivid"),
  "+3",   _("Radiant"),
}

MISC_STUFF_HERETIC.LIVEMAP_CHOICES =
{
  "step", _("Per Step (Very Slow)"),
  "room", _("Per Room (Slightly Slow)"),
  "none", _("No Live Minimap"),
}

MISC_STUFF_HERETIC.SINK_STYLE_CHOICES =
{
  "themed", _("Per Theme"),
  "curved", _("Curved"),
  "sharp", _("Sharp"),
  "random", _("Random"),
}

MISC_STUFF_HERETIC.HEIGHT_CHOICES =
{
  "short",     _("Mostly Short"),
  "short-ish", _("Slightly Short"),
  "normal",    _("Normal"),
  "tall-ish",  _("Slightly Tall"),
  "tall",      _("Mostly Tall"),
  "mixed",     _("Mix It Up"),
}

MISC_STUFF_HERETIC.WINDOW_BLOCKING_CHOICES =
{
  "not_on_vistas", _("Not on Vistas"),
  "never",         _("Never"),
  "all",           _("All"),
}

MISC_STUFF_HERETIC.RAIL_BLOCKING_CHOICES =
{
  "never",       _("Never"),
  "on_occasion", _("Occasional"),
  "all",         _("All"),
}

MISC_STUFF_HERETIC.LIQUID_SINK_OPTIONS =
{
  "yes",          _("Yes"),
  "not_damaging", _("No Damaging"),
  "no",           _("No"),
}

MISC_STUFF_HERETIC.LINEAR_START_CHOICES =
{
  "100",     _("All"),
  "75",      _("75% of All Levels"),
  "50",      _("50% of All Levels"),
  "25",      _("25% of All Levels"),
  "12",      _("12% of All Levels"),
  "default", _("DEFAULT"),
}

function MISC_STUFF_HERETIC.begin_level(self)
  for _,opt in pairs(self.options) do
    local name  = assert(opt.name)
    local value = opt.value

    if opt.choices == STYLE_CHOICES then
      if value ~= "mixed" then
        STYLE[name] = value
      end

    else
      -- pistol_starts, or other YES/NO stuff
      if opt.name == "liquid_sinks" then
        PARAM[name] = value
      end
      if value ~= "no" then
        PARAM[name] = value
      end
    end
  end
end


OB_MODULES["misc_heretic"] =
{
  label = _("Miscellaneous"),

  game = "heretic",

  side = "left",
  priority = 103,

  hooks =
  {
    begin_level = MISC_STUFF_HERETIC.begin_level
  },

  options =
  {
    {
      name="pistol_starts",
      label=_("Wand Starts"),
      choices=MISC_STUFF_HERETIC.YES_NO,
      tooltip=_("Ensure every map can be completed from a wand start (ignore weapons obtained from earlier maps)")
    },
    {
      name="alt_starts",
      label=_("Alt-start Rooms"),
      choices=MISC_STUFF_HERETIC.YES_NO,
      tooltip=_("For Co-operative games, sometimes have players start in different rooms")
    },
--[[    {
      name = "foreshadowing_exit",
      label = _("Foreshadowing Exit")
      choices = MISC_STUFF_HERETIC.YES_NO
      tooltip = "Gets exit room theme to follow the theme of the next level, if different.",
      default = "yes",
      gap=1,
    },
]]
    { name="big_rooms",   label=_("Big Rooms"),      choices=STYLE_CHOICES },
    { name="big_outdoor_rooms", label=_("Big Outdoors"), choices=STYLE_CHOICES },
    {
      name="room_heights",
      label=_("Room Heights"),
      choices=MISC_STUFF_HERETIC.HEIGHT_CHOICES,
      tooltip=_("Determines if rooms should have a height limit or should exaggerate their height. " ..
      "Short means room areas strictly have at most 128 units of height, tall means rooms immediately have " ..
      "doubled heights. Normal is the default Oblige behavior."),
      default="normal",
      gap=1,
    },


    { name="parks",       label=_("Parks"),          choices=STYLE_CHOICES },
    {
      name="natural_parks",
      label=_("Natural Cliffs"),
      tooltip=_("Percentage of parks that use completely naturalistic walls."),
      choices=STYLE_CHOICES,
      default="none",
    },
    { name="park_detail",
      label=_("Park Detail"),
      tooltip=_("Reduces or increases the probability of park decorations such as trees on park rooms."),
      choices=STYLE_CHOICES,
      gap=1,
    },

    { name="windows",     label=_("Windows"),        choices=STYLE_CHOICES },
    {
      name="passable_windows",
      label=_("Passable Windows"),
      choices=MISC_STUFF_HERETIC.WINDOW_BLOCKING_CHOICES,
      tooltip=_("Sets the preferences for passability on certain windows. On Vistas Only means only windows " ..
                "that look out to vistas/map border scenics have a blocking line."),
      default="not_on_vistas",
    },
    {
      name="passable_railings",
      label=_("Passable Railings"),
      choices=MISC_STUFF_HERETIC.RAIL_BLOCKING_CHOICES,
      tooltip=_("Sets the passability of railing junctions between full impassability or the 3D midtex flag. " ..
            "Occasional means 3D midtex is only used on railings between areas the player is supposed to " ..
            "circumvent. Always means the inclusion of cages and scenic rails, allowing flying monsters to " ..
            "potentially escape.\n\nNote: 3D midtex lines currently *block* projectiles as well."),
      default="never",
      gap=1,
    },

    { name="symmetry",    label=_("Symmetry"),       choices=STYLE_CHOICES },
    { name="beams",       label=_("Beams"),          choices=STYLE_CHOICES,
      tooltip = "Allows the appearance of thin pillars to appear between the borders of different elevations.",
    },
    { name="fences",      label=_("Fences"),         choices=STYLE_CHOICES,
      tooltip = "Creates thick solid fences and fence posts between areas of varying height for outdoor rooms.",
    },
    { name="porches",     label=_("Porches\\Gazebos"),        choices=STYLE_CHOICES,
      tooltip = "Occasional outdoor areas with a lowered indoor-ish ceiling.",
    },
    { name="scenics",     label=_("Scenics"),          choices=STYLE_CHOICES,
      tooltip = "Controls the amount of fancy scenics visible at room bordering the maps.",
      gap = 1,
    },
    { name = "corner_style",
      label=_("Sink Style"),
      choices=MISC_STUFF_HERETIC.SINK_STYLE_CHOICES,
      tooltip = "Determines the style for corners with sunken " ..
                "ceilings and floors. Curved makes sink " ..
                "corners soft, while Sharp leaves the corners angular. " ..
                "Per Theme means choice is controlled by theme profile instead. " ..
                "Tech-ish maps favor sharp corners while hell-ish favor curved.",
      default = "themed",
    },
    {
      name = "liquid_sinks",
      label=_("Liquid Sinks"),
      choices=MISC_STUFF_HERETIC.LIQUID_SINK_OPTIONS,
      tooltip = "Enables or disables liquid sinks. Liquid sinks are walkable floors that " ..
                "are often converted into depressions with the level's liquid. " ..
                "May greatly inconvenience the player but default Oblige behavior is 'Yes'.",
      default = "yes",
      gap = 1,
    },

    { name="darkness",    label=_("Dark Outdoors"),  choices=STYLE_CHOICES },
    { name="brightness_offset",
      label=_("Brightness Offset"),
      choices=MISC_STUFF_HERETIC.LIGHT_CHOICES,
      tooltip = "Creates an extra brightness offset for rooms. Does not change the lighting palette for rooms.",
      default = "none",
    },
    { name="barrels",     label=_("Barrels"),        choices=STYLE_CHOICES, gap=1 },

    { name="doors",       label=_("Doors"),          choices=STYLE_CHOICES },
    { name="keys",        label=_("Keyed Doors"),    choices=STYLE_CHOICES },
--[[    { name="trikeys",     label=_("Triple-Keyed Doors"),          choices=STYLE_CHOICES,
      tooltip = "Controls the chance to get three key door whenever three keys are present.",
    },
]]
    { name="switches",    label=_("Switched Doors"), choices=STYLE_CHOICES, gap=1 },

--[[    {
      name="road_markings",
      label=_("Road Markings"),
      choices=MISC_STUFF_HERETIC.YES_NO,
      default = "yes",
      tooltip = _("Adds street markings to roads."),
    },
    {
      name="street_traffic",
      label=_("Street Traffic"),
      choices=STYLE_CHOICES,
      tooltip = _("If Street Mode is enabled, changes the density of prefabs such " ..
      "as cars, barriers, crates, and relevant items on the roads."),
      gap = 1,
    },

    {
      name="exit_signs",
      label=_("Exit Signs")
      choices=MISC_STUFF_HERETIC.YES_NO
      tooltip=_("Places exit signs by exiting room")
      default = "yes",
      gap=1,
    },
--]]
    {
      name="linear_start",
      label=_("Linear Start"),
      choices=MISC_STUFF_HERETIC.LINEAR_START_CHOICES,
      tooltip=_("Stops start rooms from having more than one external room connection. " ..
      "Can help reduce being overwhelmed by attacks from multiple directions " ..
      "when multiple neighboring rooms connect into the start room. Default means " ..
      "no control, and levels can have linear starts at random based on shape grammars as " ..
      "per original Oblige 7.7 behavior."),
      default = "default",
    },
    {
      name="dead_ends",
      label=_("Dead Ends"),
      choices=STYLE_CHOICES,
      tooltip=_("Cleans up and removes areas with staircases that lead to nowhere.\n" ..
      "NONE means all dead ends are removed.\n" ..
      "Heaps means all dead ends are preserved (Oblige default)."),
      default = "heaps",
      gap = 1,
    },

    {
      name="live_minimap",
      label=_("Live Growth Minimap"),
      choices=MISC_STUFF_HERETIC.LIVEMAP_CHOICES,
      tooltip=_("Shows more steps Oblige performs on rooms as they are grown on the GUI minimap. May take a hit on generation speed.")
    },

  },
}
