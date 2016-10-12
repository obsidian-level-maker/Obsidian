------------------------------------------------------------------------
--  PANEL: Monsters
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

UI_MONS = { }

UI_MONS.CHOICES =
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


OB_MODULES["ui_mons"] =
{
  label = _("Monsters")
  priority = 102

  options =
  {
    -- FIXME : choices

    { name="mons",          label=_("Quantity"),  choices=UI_MONS.CHOICES }
    { name="strength",      label=_("Strength"),  choices=UI_MONS.CHOICES }
    { name="ramp_up",       label=_("Ramp Up"),   choices=UI_MONS.CHOICES }

    { name="bosses",        label=_("Bosses"),    choices=UI_MONS.CHOICES }
    { name="traps",         label=_("Traps"),     choices=UI_MONS.CHOICES }
    { name="cages",         label=_("Cages"),     choices=UI_MONS.CHOICES }
  }
}

