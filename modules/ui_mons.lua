------------------------------------------------------------------------
--  PANEL: Monsters
------------------------------------------------------------------------
--
--  Copyright (C) 2016-2017 Andrew Apted
--  Copyright (C) 2019 Armaetus
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
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

UI_MONS = { }

UI_MONS.BOSSES =
{
  "none",   _("NONE"),
  "easier", _("Easier"),
  "medium", _("Average"),
  "harder", _("Harder"),
}

UI_MONS.TRAP_STYLE =
{
  "default",   _("DEFAULT"),
  "teleports", _("Teleports Only"),
  "closets",   _("Closets Only"),
  "20",        _("20% Closets - 80% Teleports"),
  "40",        _("40% Closets - 60% Teleports"),
  "60",        _("60% Closets - 40% Teleports"),
  "80",        _("80% Closets - 20% Teleports"),
}

UI_MONS.CAGE_STRENGTH =
{
  "weaker",    _("Weaker"),
  "easier",    _("Easier"),
  "default",   _("Average"),
  "tricky",    _("Tricky"),
  "treacherous", _("Treacherous"),
  "dangerous", _("Dangerous"),
  "deadly",    _("Deadly"),
  "lethal",    _("Lethal"),
  "crazy",     _("CRAZY"),
}

UI_MONS.SECRET_MONSTERS =
{
  "yesyes", _("Yes - Full Strength"),
  "yes",    _("Yes - Weak"),
  "no",     _("No"),
}

UI_MONS.MONSTER_KIND_JUMPSTART_CHOICES =
{
  "default", _("DEFAULT"),
  "harder", _("Harder"),
  "tougher", _("Tougher"),
  "fiercer", _("Fiercer"),
  "crazier", _("CRAZIER")
}

UI_MONS.BOSSREGULARS =
{
  "no",  _("Disabled"),
  "minor", _("Minor Bosses Only"),
  "nasty", _("Minor and Nasty Bosses Only"),
  "all", _("All Bosses"),
}

OB_MODULES["ui_mons"] =
{
  label = _("Monsters"),

  side = "right",
  priority = 105,
  engine = "!vanilla",

    "none",      _("[0] None"),
    "rarest",    _("[0.15] Trivial"),
    "rarer",     _("[0.35] Sporadic"),
    "rare",      _("[0.7] Meager"),
    "scarce",    _("[1.0] Easy"),
    "few",       _("[1.3] Modest"),
    "less",      _("[1.5] Bearable"),
    "normal",    _("[2.0] Rough"),
    "more",      _("[2.5] Strenuous"),
    "heaps",     _("[3.0] Formidable"),
    "legions",   _("[3.5] Harsh"),
    "insane",    _("[4.0] Painful"),
    "deranged",  _("[4.5] Unforgiving"),
    "nuts",      _("[5.0] Punishing"),
    "chaotic",   _("[5.5] Brutal"),
    "unhinged",  _("[6.0] Draconian"),
    "ludicrous", _("[6.66] Merciless"),

  options =
  {
    {
      name="float_mons",
      label=_("Quantity"),
      valuator = "slider",
      units = "",
      min = -0.10,
      max = 10.00,
      increment = .05,
      default = -0.10,
      nan = "-0.10:Mix It Up," ..
      "-0.05:Progressive," ..
      "0:None," ..
      "0.15:0.15 (Trivial)," ..
      "0.35:0.35 (Sporadic)," ..
      "0.7:0.7 (Meager)," ..
      "1.0:1.0 (Easy)," ..
      "1.3:1.3 (Modest)," ..
      "1.5:1.5 (Bearable)," ..
      "2.0:2.0 (Rough)," ..
      "2.5:2.5 (Strenuous)," ..
      "3.0:3.0 (Formidable)," ..
      "3.5:3.5 (Harsh)," ..
      "4.0:4.0 (Painful)," ..
      "4.5:4.5 (Unforgiving)," ..
      "5.0:5.0 (Punishing)," ..
      "5.5:5.5 (Brutal)," ..
      "6.0:6.0 (Draconian)," ..
      "6.65:6.66 (Merciless),",     
      tooltip="For reference: Oblige 7.x's default for normal is 1.0.\n\n" ..
              "Mix It Up: randomizes quantities based on the prefered selection " ..
              "under the Fine Tune options below.\n\n" ..
              "Progressive: creates a curve of increasing monster population " ..
              "also based on the Fine Tune options below.\n\n" ..
              "It does not matter if your Upper/Lower Bound selections are reversed. " ..
              "Progressive will pick the min VS max quantities selected.",
    },

    {
      name="float_mix_it_up_upper_range",
      label=_("Upper Bound"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 10.00,
      increment = .05,
      default = 10,
      nan = "",
      tooltip="If you have Mix It Up or Progressive selected, you can define the upper bound here. Otherwise, this option is simply ignored.",
    },

    {
      name="float_mix_it_up_lower_range",
      label=_("Lower Bound"),
      valuator = "slider",
      units = "",
      min = 0,
      max = 10.00,
      increment = .05,
      default = 0,
      nan = "",
      tooltip="If you have Mix It Up or Progressive selected, you can define the lower bound here. Otherwise, this option is simply ignored.",
      gap = 1,
    },

    {
      name="float_strength",
      label=_("Strength"),
      valuator = "slider",
      units = "",
      min = 0.55,
      max = 12,
      increment = .05,
      default = 1,
      nan = "0.55:0.55 (Weak),0.75:0.75 (Easier),1:1 (Average),1.3:1.3 (Harder),1.7:1.7 (Tough),2.5: 2.5 (Fierce),12:12 (CRAZY),",
    },

    {
      name="float_ramp_up",
      label=_("Ramp Up"),
      valuator = "slider",
      units = "",
      min = 0.45,
      max = 3,
      increment = .05,
      default = 1,
      nan = "0.45:Episodic,0.5:0.5 (Very Slow),0.75:0.75 (Slow),1:1 (Medium),1.5:1.5 (Fast),2:2 (Very Fast),3:3 (Extra Fast),",
      tooltip = "Rate at which monster strength increases as you progress through levels.",
      gap = 1,
    },
    
    { name="mon_variety", label=_("Monster Variety"),choices=STYLE_CHOICES,
      tooltip= "Affects how many different monster types can " ..
               "appear in each room.\n" ..
               "Setting this to NONE will make each level use a single monster type",
    },
    {
      name="mon_variety_jumpstart", label=_("Monster Variety Jumpstart"), 
      choices=UI_MONS.MONSTER_KIND_JUMPSTART_CHOICES,
      default = "default",
      tooltip = "Affects how many monster variations initially appear at the very first map.",
      gap = 1
    },

    { name="bosses",    label=_("Bosses"),    choices=UI_MONS.BOSSES },
    {
      name="bossesnormal",
      label=_("Bosses As Regulars"),
      choices=UI_MONS.BOSSREGULARS,
      default="no",
      tooltip="Normally Archviles/Barons/Cyberdemons and other big monsters are excluded from normal monster pool and only can appear as guard for important objective e.g. key. With this option enabled they are allowed to(rarely) spawn as a regular monster. \n\n WARNING: This CAN make maps much more difficult than normal.",
    },
    { name="traps",     label=_("Traps"),     choices=STYLE_CHOICES },
    {
      name="trap_style",
      label=_("Trap Style"),
      choices=UI_MONS.TRAP_STYLE,
      default="default",
      tooltip="This option selects between using only teleport or closet traps. DEFAULT means both are used.",
      gap = 1,
    },
    {
      name="trap_qty",
      label=_("Trap Monsters"),
      choices=UI_MONS.CAGE_STRENGTH,
      default="default",
      tooltip="Changes the quantity of ambushing monsters from traps.",
    },
    {
      name="cage_qty",
      label=_("Cage Monsters"),
      choices=UI_MONS.CAGE_STRENGTH,
      default="default",
      tooltip="Changes the quantity of monsters in cages.",
      gap=1,
    },
    { name="cages",     label=_("Cages"),     choices=STYLE_CHOICES,  gap=1 },

    {
      name="secret_monsters",
      label=_("Monsters in Secrets"),
      choices=UI_MONS.SECRET_MONSTERS,
      tooltip="I'm in your secret rooms, placing some monsters. Note: default is none.",
      default="no",
    },
    
    {
      name="bool_quiet_start",
      label=_("Quiet Start"),
      valuator = "button",
      default = 0,
      tooltip="Makes start rooms mostly safe - no enemies and all outlooking windows are removed. " ..
      "(windows are retained on Procedural Gotchas) Default Oblige behavior is 'no'.",
    },
  },
}
