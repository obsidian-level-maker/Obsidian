------------------------------------------------------------------------
--  PANEL: Architecture
------------------------------------------------------------------------
--
--  Copyright (C) 2016-2017 Andrew Apted
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
------------------------------------------------------------------------

UI_ARCH = { }

UI_ARCH.SIZES =
{
  "epi",     _("Episodic"),
  "prog",    _("Progressive"),
  "mixed",   _("Mix It Up"),

  -- this is a separator (not a usable choice)
  "_",       "_",

  "small",   _("Small"),
  "regular", _("Regular"),
  "large",   _("Large"),
  "extreme", _("Extreme"),
}

OB_MODULES["ui_arch"] =
{
  label = _("Architecture")

  side = "left"
  priority = 104

  options =
  {
    { name="size",         label=_("Level Size"), choices=UI_ARCH.SIZES,  default="epi",  gap=1 }
     
    { name="outdoors",     label=_("Outdoors"),   choices=STYLE_CHOICES }
    { name="caves",        label=_("Caves"),      choices=STYLE_CHOICES }
    { name="liquids",      label=_("Liquids"),    choices=STYLE_CHOICES,  gap=1 }

    { name="hallways",     label=_("Hallways"),   choices=STYLE_CHOICES }
    { name="teleporters",  label=_("Teleports"),  choices=STYLE_CHOICES }
    { name="steepness",    label=_("Steepness"),  choices=STYLE_CHOICES }
  }
}

