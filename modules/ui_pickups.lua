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

UI_PICKUPS.HEALTH_CHOICES =
{
  "none",   _("NONE"),
  "scarce", _("Scarce"),
  "less",   _("Less"),
--TODO  "bit_less", _("Bit Less"),
  "normal", _("Normal"),
--TODO  "bit_more", _("Bit More"),
  "more",   _("More"),
  "heaps",  _("Heaps"),
}

UI_PICKUPS.ITEM_CHOICES =
{
  "none",   _("NONE"),
  "heaps",  _("Very Soon"),
  "more",   _("Sooner"),
  "normal", _("Normal"),
  "less",   _("Later"),
  "rare",   _("Very Late"),
}


OB_MODULES["ui_pickups"] =
{
  label = _("Pickups")

  side = "right"
  priority = 101

  options =
  {
    { name="health",     label=_("Health"),    choices=UI_PICKUPS.HEALTH_CHOICES }
    { name="ammo",       label=_("Ammo"),      choices=UI_PICKUPS.HEALTH_CHOICES,  gap=1 }

    { name="weapons",    label=_("Weapons"),   choices=UI_PICKUPS.ITEM_CHOICES }
    { name="items",      label=_("Items"),     choices=UI_PICKUPS.ITEM_CHOICES }

    { name="secrets",    label=_("Secrets"),   choices=STYLE_CHOICES }
  }
}

