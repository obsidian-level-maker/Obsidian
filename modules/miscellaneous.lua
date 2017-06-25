------------------------------------------------------------------------
--  MODULE: Miscellaneous Stuff
------------------------------------------------------------------------
--
--  Copyright (C) 2009      Enhas
--  Copyright (C) 2009-2017 Andrew Apted
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

MISC_STUFF = { }

MISC_STUFF.YES_NO =
{
  "no",  _("No"),
  "yes", _("Yes"),
}

MISC_STUFF.LIGHTINGS =
{
  "flat",    _("FLAT"),
  "lower",   _("Lower"),
  "normal",  _("Normal"),
  "higher",  _("Higher"),
}


MISC_STUFF.variety_tip = _(
    "Affects how many different monster types can "..
    "appear in each room.  "..
    "Setting this to NONE will make each level use a single monster type")


function MISC_STUFF.begin_level(self)
  each opt in self.options do
    local name  = assert(opt.name)
    local value = opt.value

    if opt.choices == STYLE_CHOICES then
      if value != "mixed" then
        STYLE[name] = value
      end

    else
      -- pistol_starts, or other YES/NO stuff

      if value != "no" then
        PARAM[name] = value
      end
    end
  end
end


OB_MODULES["misc"] =
{
  label = _("Miscellaneous")

  side = "left"
  priority = 70

  hooks =
  {
    begin_level = MISC_STUFF.begin_level
  }

  options =
  {
    {
      name="pistol_starts"
      label=_("Pistol Starts")
      choices=MISC_STUFF.YES_NO
      tooltip=_("Ensure every map can be completed from a pistol start (ignore weapons obtained from earlier maps)")
    }

    {
      name="alt_starts"
      label=_("Alt-start Rooms")
      choices=MISC_STUFF.YES_NO
      tooltip=_("For Co-operative games, sometimes have players start in different rooms")
      gap=1
    }

    { name="big_rooms",   label=_("Big Rooms"),      choices=STYLE_CHOICES }
    { name="parks",       label=_("Parks"),          choices=STYLE_CHOICES, gap=1 }

    { name="windows",     label=_("Windows"),        choices=STYLE_CHOICES }
    { name="symmetry",    label=_("Symmetry"),       choices=STYLE_CHOICES, gap=1 }

    { name="darkness",    label=_("Dark Outdoors"),  choices=STYLE_CHOICES }
    { name="mon_variety", label=_("Monster Variety"),choices=STYLE_CHOICES, tooltip=MISC_STUFF.variety_tip }
    { name="barrels",     label=_("Barrels"),        choices=STYLE_CHOICES, gap=1 }

    { name="doors",       label=_("Doors"),          choices=STYLE_CHOICES }
    { name="keys",        label=_("Keyed Doors"),    choices=STYLE_CHOICES }
    { name="switches",    label=_("Switched Doors"), choices=STYLE_CHOICES }

---- PLANNED (UNFINISHED) STUFF ----

--  { name="light_level",  label=_("Lighting"),   choices=MISC_STUFF.LIGHTINGS }
--  { name="detail_level", label=_("Detail"),     choices=MISC_STUFF.LIGHTINGS, gap=1 }

--  pictures    = { label=_("Pictures"),       choices=STYLE_CHOICES }
--  cycles      = { label=_("Multiple Paths"), choices=STYLE_CHOICES }
--  ex_floors   = { label=_("3D Floors"),      choices=STYLE_CHOICES }

--  porches     = { label=_("Porches"),        choices=STYLE_CHOICES }
--  lakes       = { label=_("Lakes"),          choices=STYLE_CHOICES }
  }
}

