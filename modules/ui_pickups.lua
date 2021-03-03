------------------------------------------------------------------------
--  PANEL: Pickups
------------------------------------------------------------------------
--
--  Copyright (C) 2016-2017 Andrew Apted
--  Copyright (C) 2020 MsrSgtShooterPerson
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

UI_PICKUPS = { }

UI_PICKUPS.HEALTH_CHOICES =
{
  "none",     _("NONE"),
  "scarce",   _("Scarce"),
  "less",     _("Less"),
  "bit_less", _("Bit Less"),
  "normal",   _("Normal"),
  "bit_more", _("Bit More"),
  "more",     _("More"),
  "heaps",    _("Heaps"),
}

UI_PICKUPS.WEAPON_CHOICES =
{
  "none",      _("NONE"),
  "very_soon", _("Very Soon"),
  "sooner",    _("Sooner"),
  "normal",    _("Normal"),
  "later",     _("Later"),
  "very_late", _("Very Late"),
}

UI_PICKUPS.ITEM_CHOICES =
{
  "none",   _("NONE"),
  "rare",   _("Rare"),
  "less",   _("Less"),
  "normal", _("Normal"),
  "more",   _("More"),
  "heaps",  _("Heaps"),
}

UI_PICKUPS.SECRET_ROOM_BONUS =
{
  "none", _("NONE"),
  "more", _("More"),
  "heaps", _("Heaps"),
  "heapser", _("Rich"),
  "heapsest", _("Resplendent")
}


OB_MODULES["ui_pickups"] =
{
  label = _("Pickups"),

  side = "right",
  priority = 101,

  options =
  {
    { name="health",     label=_("Health"),    choices=UI_PICKUPS.HEALTH_CHOICES },
    { name="ammo",       label=_("Ammo"),      choices=UI_PICKUPS.HEALTH_CHOICES,  gap=1 },

    { name="weapons",    label=_("Weapons"),   choices=UI_PICKUPS.WEAPON_CHOICES },
    { name="items",      label=_("Items"),     choices=UI_PICKUPS.ITEM_CHOICES },

    { name="secrets",    label=_("Secrets"),   choices=STYLE_CHOICES },
    { name="secrets_bonus",
      label=_("Secrets Bonus"),
      choices=UI_PICKUPS.SECRET_ROOM_BONUS,
      tooltip="Adds extra content to secret rooms. Larger rooms offer more content. Default is NONE.",
      default="none",
    },
  },
}
