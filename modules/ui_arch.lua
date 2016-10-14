------------------------------------------------------------------------
--  PANEL: Architecture
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

UI_ARCH = { }

UI_ARCH.CHOICES =
{
  "mixed",  _("Mix It Up"),
  "none",   _("NONE"),
  "rare",   _("Rare"),
  "few",    _("Few"),
  "less",   _("Less"),
  "some",   _("Some"),
  "more",   _("More"),
  "heaps",  _("Heaps"),
}


OB_MODULES["ui_arch"] =
{
  label = _("Architecture")

  side = "left"
  priority = 104

  options =
  {
    -- FIXME : size choices

    { name="size",          label=_("Size"),       choices=UI_ARCH.CHOICES,  gap=1 }
     
    { name="hallways",      label=_("Hallways"),   choices=UI_ARCH.CHOICES }
    { name="big_rooms",     label=_("Big Rooms"),  choices=UI_ARCH.CHOICES }
    { name="teleporters",   label=_("Teleports"),  choices=UI_ARCH.CHOICES }

--  keys        = { label=_("Keys"),     choices=UI_ARCH.CHOICES }
--  switches    = { label=_("Switches"), choices=UI_ARCH.CHOICES }
  }
}

