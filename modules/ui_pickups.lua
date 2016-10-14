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
  "mixed",  _("Mix It Up"),
  "none",   _("NONE"),
  "rare",   _("Rare"),
  "few",    _("Few"),
  "less",   _("Less"),
  "some",   _("Some"),
  "more",   _("More"),
  "heaps",  _("Heaps"),
}


OB_MODULES["ui_pickups"] =
{
  label = _("Pickups")

  side = "right"
  priority = 101

  options =
  {
    -- FIXME : choices

    { name="health",     label=_("Health"),    choices=UI_PICKUPS.CHOICES }
    { name="ammo",       label=_("Ammo"),      choices=UI_PICKUPS.CHOICES,  gap=1 }

    { name="weapons",    label=_("Weapons"),   choices=UI_PICKUPS.CHOICES }
    { name="items",      label=_("Items"),     choices=UI_PICKUPS.CHOICES }
    { name="secrets",    label=_("Secrets"),   choices=UI_PICKUPS.CHOICES }
  }
}

