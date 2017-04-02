------------------------------------------------------------------------
--  PANEL: Monsters
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

UI_MONS = { }

UI_MONS.QUANTITIES =
{
	"none",   _("NONE"),
	"scarce", _("Scarce"),
	"less",   _("Less"),
	"normal", _("Normal"),
	"more",   _("More"),
	"heaps",  _("Hordes"),
	"nuts",   _("Nuts!"),
	"mixed",  _("Mix It Up"),
}

UI_MONS.STRENGTHS =
{
  "weak",   _("Weak"),
  "easier", _("Easier"),
  "medium", _("Normal"),
  "harder", _("Harder"),
  "tough",  _("Tough"),
  "crazy",  _("CRAZY"),
}

UI_MONS.BOSSES =
{
  "none",   _("NONE"),
  "easier", _("Easier"),
  "medium", _("Normal"),
  "harder", _("Harder"),
}

UI_MONS.RAMPS =
{
  "slow",    _("Slow"),
  "medium",  _("Medium"),
  "fast",    _("Fast"),
  "epi",     _("Episodic"),
}


OB_MODULES["ui_mons"] =
{
  label = _("Monsters")

  side = "right"
  priority = 102

  options =
  {
    { name="mons",      label=_("Quantity"),  choices=UI_MONS.QUANTITIES }
    { name="strength",  label=_("Strength"),  choices=UI_MONS.STRENGTHS }
    { name="ramp_up",   label=_("Ramp Up"),   choices=UI_MONS.RAMPS,  gap=1 }

    { name="bosses",    label=_("Bosses"),    choices=UI_MONS.BOSSES }
    { name="traps",     label=_("Traps"),     choices=STYLE_CHOICES }
    { name="cages",     label=_("Cages"),     choices=STYLE_CHOICES }
  }
}

