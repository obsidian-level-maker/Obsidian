------------------------------------------------------------------------
--  PANEL: Pickups
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

UI_PICKUPS = { }

UI_PICKUPS.CHOICES =
{
  "none",   _("NONE"),
  "scarce", _("Scarce"),
  "less",   _("Less"),
  "normal", _("Normal"),
  "more",   _("More"),
  "heaps",  _("Heaps"),

-- TODO:
-- "bit_less", _("Bit Less"),
-- "bit_more", _("Bit More"),
}

UI_PICKUPS.CHOICES2 =
{
	"none",   _("NONE"),
	"less",   _("Less"),
	"normal", _("Normal"),
	"more",   _("More"),
	"mixed",  _("Mix It Up"),
}


OB_MODULES["ui_pickups"] =
{
  label = _("Pickups")

  side = "right"
  priority = 101

  options =
  {
    { name="health",     label=_("Health"),    choices=UI_PICKUPS.CHOICES }
    { name="ammo",       label=_("Ammo"),      choices=UI_PICKUPS.CHOICES,  gap=1 }

    { name="weapons",    label=_("Weapons"),   choices=UI_PICKUPS.CHOICES2 }
    { name="items",      label=_("Items"),     choices=UI_PICKUPS.CHOICES2 }
    { name="secrets",    label=_("Secrets"),   choices=UI_PICKUPS.CHOICES }
  }
}

