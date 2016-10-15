------------------------------------------------------------------------
--  PANEL: Environment
------------------------------------------------------------------------
--
--  Copyright (C) 2016 Andrew Apted
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

UI_ENVIRON = { }

UI_ENVIRON.CHOICES =
{
  "none",   _("NONE"),
  "rare",   _("Rare"),
  "few",    _("Few"),
  "less",   _("Less"),
  "some",   _("Some"),
  "more",   _("More"),
  "heaps",  _("Heaps"),
  "mixed",  _("Mix It Up"),
}

UI_ENVIRON.LIGHTINGS =
{
  "flat",    _("FLAT"),
  "lower",   _("Lower"),
  "normal",  _("Normal"),
  "higher",  _("Higher"),
}


OB_MODULES["ui_env"] =
{
  label = _("Environment")

  side = "left"
  priority = 103

  options =
  {
    { name="outdoors",    label=_("Outdoors"),   choices=UI_ENVIRON.CHOICES }
    { name="caves",       label=_("Caves"),      choices=UI_ENVIRON.CHOICES }
    { name="liquids",     label=_("Liquids"),    choices=UI_ENVIRON.CHOICES,  gap=1 }
     
    { name="steepness",   label=_("Steepness"),  choices=UI_ENVIRON.CHOICES }
    { name="lighting",    label=_("Lighting"),   choices=UI_ENVIRON.LIGHTINGS }
    { name="detail",      label=_("Detail"),     choices=UI_ENVIRON.LIGHTINGS }
  }
}

