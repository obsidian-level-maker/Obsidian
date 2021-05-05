---------------------------------------------------------------
--  MODULE: Doom Control
----------------------------------------------------------------
--
--  Copyright (C) 2009-2010 Andrew Apted
--  Copyright (C) 2020-2021 MsrSgtShooterPerson
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
----------------------------------------------------------------

CTL_DOOM = {}

CTL_DOOM.MON_CHOICES =
{
  "default", _("DEFAULT"),
  "none",    _("None at all"),
  "scarce",  _("Scarce"),
  "less",    _("Less"),
  "plenty",  _("Plenty"),
  "more",    _("More"),
  "heaps",   _("Heaps"),
  "insane",  _("INSANE"),
}

CTL_DOOM.MON_PROBS =
{
  none   = 0,
  scarce = 2,
  less   = 15,
  plenty = 50,
  more   = 120,
  heaps  = 300,
  insane = 2000,
}

CTL_DOOM.DENSITIES =
{
  none   = 0.1,
  scarce = 0.2,
  less   = 0.4,
  plenty = 0.7,
  more   = 1.2,
  heaps  = 3.3,
  insane = 9.9,
}


function CTL_DOOM.monster_setup(self)
  for name,opt in pairs(self.options) do
    local M = GAME.MONSTERS[name]

    if M and opt.value ~= "default" then
      M.prob    = CTL_DOOM.MON_PROBS[opt.value]
      M.density = CTL_DOOM.DENSITIES[opt.value]

      -- allow Spectres to be controlled individually
      M.replaces = nil

      -- loosen some of the normal restrictions
      M.skip_prob = nil
      M.crazy_prob = nil

      if M.prob > 40 then
        M.level = 1
        M.weap_min_damage = nil
      end

      if M.prob > 200 then
        M.boss_type = nil
      end
    end
  end -- for opt
end


OB_MODULES["doom_mon_control"] =
{
  label = _("Doom Monster Control"),

  game = "doomish",
  engine = "!vanilla",

  hooks =
  {
    setup = CTL_DOOM.monster_setup
  },

  options =
  {
    zombie   = { label=_("Zombieman"),      choices=CTL_DOOM.MON_CHOICES },
    shooter  = { label=_("Shotgun Guy"),    choices=CTL_DOOM.MON_CHOICES },
    gunner   = { label=_("Chaingunner"),    choices=CTL_DOOM.MON_CHOICES },
    ss_nazi  = { label=_("SS Nazi"),        choices=CTL_DOOM.MON_CHOICES },
    imp      = { label=_("Imp"),            choices=CTL_DOOM.MON_CHOICES },

    skull    = { label=_("Lost Soul"),      choices=CTL_DOOM.MON_CHOICES },
    demon    = { label=_("Demon"),          choices=CTL_DOOM.MON_CHOICES },
    spectre  = { label=_("Spectre"),        choices=CTL_DOOM.MON_CHOICES },
    pain     = { label=_("Pain Elemental"), choices=CTL_DOOM.MON_CHOICES },
    caco     = { label=_("Cacodemon"),      choices=CTL_DOOM.MON_CHOICES },
    knight   = { label=_("Hell Knight"),    choices=CTL_DOOM.MON_CHOICES },

    revenant = { label=_("Revenant"),       choices=CTL_DOOM.MON_CHOICES },
    mancubus = { label=_("Mancubus"),       choices=CTL_DOOM.MON_CHOICES },
    arach    = { label=_("Arachnotron"),    choices=CTL_DOOM.MON_CHOICES },
    vile     = { label=_("Arch-vile"),      choices=CTL_DOOM.MON_CHOICES },
    baron    = { label=_("Baron of Hell"),  choices=CTL_DOOM.MON_CHOICES },

    Cyberdemon  = { label=_("Cyberdemon"),   choices=CTL_DOOM.MON_CHOICES },
    Spiderdemon = { label=_("Spiderdemon"),  choices=CTL_DOOM.MON_CHOICES },
  },
}


----------------------------------------------------------------


CTL_DOOM.WEAPON_CHOICES =
{
  "default", _("DEFAULT"),
  "none",    _("None at all"),
  "scarce",  _("Scarce"),
  "less",    _("Less"),
  "plenty",  _("Plenty"),
  "more",    _("More"),
  "heaps",   _("Heaps"),
  "loveit",  _("I LOVE IT"),
}

CTL_DOOM.WEAPON_PROBS =
{
  none   = 0,
  scarce = 2,
  less   = 15,
  plenty = 50,
  more   = 120,
  heaps  = 300,
  loveit = 1000,
}

CTL_DOOM.WEAPON_PREFS =
{
  none   = 1,
  scarce = 10,
  less   = 25,
  plenty = 40,
  more   = 70,
  heaps  = 100,
  loveit = 170,
}

CTL_DOOM.WEAPON_PREF_CHOICES =
{
  "normal",  _("Normal"),
  "vanilla", _("Vanilla"),
  "none",    _("NONE"),
}


function CTL_DOOM.weapon_setup(self)
  for name,opt in pairs(self.options) do
    local W = GAME.WEAPONS[name]

    if W and opt.value ~= "default" then
      W.add_prob = CTL_DOOM.WEAPON_PROBS[opt.value]
      W.pref     = CTL_DOOM.WEAPON_PREFS[opt.value]

      -- loosen some of the normal restrictions
      W.level = 1
    end
  end -- for opt

  -- specific instructions for the weapon_pref choices
  PARAM.weapon_prefs = self.options.weapon_prefs.value

  if PARAM.weapon_prefs == "vanilla"
  or PARAM.weapon_prefs == "none" then
    for _,mon in pairs(GAME.MONSTERS) do
      mon.weapon_prefs = nil
    end
  end

  if PARAM.weapon_prefs == "vanilla" then
    GAME.MONSTERS["Cyberdemon"].weap_prefs = { bfg = 10.0 }
    GAME.MONSTERS["Spiderdemon"].weap_prefs = { bfg = 10.0 }
    GAME.MONSTERS["demon"].weap_prefs = { launch = 0.3 }
    GAME.MONSTERS["skull"].weap_prefs = { launch = 0.1 }
    GAME.MONSTERS["spectre"].weap_prefs = { launch = 0.3 }

    if OB_CONFIG.game == "doom2" then
      GAME.MONSTERS["pain"].weap_prefs = { launch = 0.1 }
    end
  end

end


OB_MODULES["doom_weapon_control"] =
{

  name = "doom_weapon_control",

  label = _("Doom Weapon Control"),

  game = "doomish",
  engine = "!vanilla",

  hooks =
  {
    setup = CTL_DOOM.weapon_setup
  },

  options =
  {
    shotty   = { label=_("Shotgun"),         choices=CTL_DOOM.WEAPON_CHOICES },
    super    = { label=_("Super Shotgun"),   choices=CTL_DOOM.WEAPON_CHOICES, gap = 1 },
    chain    = { label=_("Chaingun"),        choices=CTL_DOOM.WEAPON_CHOICES },
    launch   = { label=_("Rocket Launcher"), choices=CTL_DOOM.WEAPON_CHOICES },
    plasma   = { label=_("Plasma Rifle"),    choices=CTL_DOOM.WEAPON_CHOICES },
    bfg      = { label=_("BFG"),             choices=CTL_DOOM.WEAPON_CHOICES },

    weapon_prefs =
    {
      name="weapon_prefs",
      label=_("Weapon Preferences"),
      choices=CTL_DOOM.WEAPON_PREF_CHOICES,
      tooltip="Alters selection of weapons that are prefered to show up depending on enemy palette for a chosen map.\n\n" ..
      "Normal: Monsters have weapon preferences. Stronger weapons and ammo are more likely to appear directly with stronger enemies.\n\n" ..
      "Vanilla: Vanilla Oblige-style preferences. Reduces rocket launchers if the map has more pain elementals, lost souls, demons/specters " ..
      "while increases BFG's for cyberdemons and spider masterminds. No other weapon preferences.\n\n" ..
      "NONE: No preferences at all. For those who like to live life dangerously with lost souls and only rockets.",
      default="normal",
    },
  },
}


--

function CTL_DOOM.item_setup(self)

  for _,opt in pairs(self.options) do
        PARAM[opt.name] = gui.get_module_slider_value(self.name, opt.name) -- They are all sliders in this case
  end

  local function change_probz(name, info)
    if self.options[name] and PARAM[name] ~= -0.02 then
      local mult = PARAM[name]

      if info.add_prob then info.add_prob = info.add_prob * mult end
      if info.start_prob then info.start_prob = info.start_prob * mult end
      if info.crazy_prob then info.crazy_prob = info.crazy_prob * mult end
      if info.closet_prob then info.closet_prob = info.closet_prob * mult end
      if info.secret_prob then info.secret_prob = info.secret_prob * mult end
      if info.storage_prob then info.storage_prob = info.storage_prob * mult end
    end
  end

  for name, info in pairs(GAME.PICKUPS) do
    change_probz(name, info)
  end

  for name, info in pairs(GAME.NICE_ITEMS) do
    change_probz(name, info)
  end
end

OB_MODULES["doom_item_control"] =
{

  name = "doom_item_control",

  label = _("Doom Item Control"),

  game = "doomish",
  engine = "!vanilla",

  hooks =
  {
    get_levels = CTL_DOOM.item_setup
  },

  options =
  {
     float_potion=
     {
      label = _("Health Bonus"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },
     
     float_stimpack=
     {
      label = _("Stimpack"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },
     
     float_medikit=
     {
      label = _("Medikit"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },
     
     float_helmet=
     {
      label = _("Armor Bonus"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },     

    -- nice items
    
     float_green_armor=
     {
      label = _("Green Armor"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_blue_armor=
     {
      label = _("Blue Armor"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_soul=
     {
      label = _("Soulsphere"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_backpack=
     {
      label = _("Backpack"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_berserk=
     {
      label = _("Berserk Pack"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_invis=
     {
      label = _("Invisibility"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },
     
     float_invlu=
     {
      label = _("Invulnerability"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_allmap=
     {
      label = _("Map Computer"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_goggles=
     {
      label = _("Light Goggles"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_radsuit=
     {
      label = _("Radiation Suit"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_mega=
     {
      label = _("Megasphere"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

    -- ammo
    
     float_bullets=
     {
      label = _("Clips"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
      tooltip = "Yes, it's supposed to be called 'Magazine', get over it."
     },

     float_bullet_box=
     {
      label = _("Bullet Box"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_shells=
     {
      label = _("Shells"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_shell_box=
     {
      label = _("Shell Box"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_rocket=
     {
      label = _("Rocket"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_rocket_box=
     {
      label = _("Rocket Box"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_cells=
     {
      label = _("Cell"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     },

     float_cell_pack=
     {
      label = _("Cell Pack"),
      valuator = "slider",
      units = "",
      min = -.02,
      max = 10,
      increment = .02,
      default = -.02, 
      nan = "-.02:Default," ..
      "0:0 (None)," ..
      ".02:0.02 (Scarce)," ..
      ".14:0.14 (Less)," ..
      ".5:0.5 (Plenty)," ..
      "1.2:1.2 (More)," ..
      "3:3 (Heaps)," ..
      "10:10 (I LOVE IT),",
     }
  },
}
