------------------------------------------------------------------------
--  MODULE: Epic Textures Pack Mod
------------------------------------------------------------------------
--
--  Copyright (C) 2019 Armaetus
--  Copyright (C) 2019-2020 MsrSgtShooterPerson
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
-------------------------------------------------------------------

-- Armaetus: I'm not renaming all these functions. If you wanna do it MSSP,
-- you are free to do it lol. Remove these lines when that is done, if done.
gui.import("zdoom_armaetus_materials.lua")
gui.import("zdoom_armaetus_themes.lua")

gui.import("zdoom_armaetus_doom1_materials.lua")
gui.import("zdoom_armaetus_doom1_themes.lua")

gui.import("zdoom_armaetus_epic_texturex_lump.lua")

ARMAETUS_EPIC_TEXTURES = { }

ARMAETUS_EPIC_TEXTURES.YES_NO =
{
  "yes", _("Yes"),
  "no",  _("No"),
}

ARMAETUS_EPIC_TEXTURES.SOUCEPORT_CHOICES =
{
  "zs",       _("ZScript"),
  "decorate", _("ACS-Decorate"),
  "no",       _("No"),
}

ARMAETUS_EPIC_TEXTURES.ENVIRONMENT_THEME_CHOICES =
{
  "random",    _("Random"),
  "episodic",  _("Episodic"),
  "mixed",     _("A Bit Mixed"),
  "snowish",   _("Snow-ish"),
  "desertish", _("Desert-ish"),
  "snow",      _("Always Snow"),
  "desert",    _("Always Desert"),
  "no",        _("No"),
}

ARMAETUS_EPIC_TEXTURES.TEMPLATES =
{
   ZS_TREES =
[[class FancyObligeTree : BigTree replaces BigTree
{

    States
    {
        Spawn:
            TRE2 A 0 NoDelay
            {
                StateLabel fstate;

                bool onGrass = false;
                bool onRock = false;
                //snow and sand flats are only available
                //via Epic Textures module.
                bool onSnow = false;
                bool onSand = false;
                bool onHellscape = false;
                bool unknownFlat = false;
                bool indoors = false;

                A_SetSize(10,-1,-1);

                Name onFlat = TexMan.GetName(floorpic);
                Name onCeil = TexMan.GetName(ceilingpic);
                switch(onFlat)
                {
                    case 'GRASS1':
                    case 'GRASS2':
                    case 'GROUND01':
                    case 'GROUND02':
                    case 'GROUND03':
                    case 'GROUND04':
                    case 'FLAT10':
                    case 'QFLAT07': //I think this is dirt?
                    case 'RROCK09':
                    case 'RROCK16':
                    case 'RROCK17':
                    case 'RROCK18':
                    case 'RROCK19':
                    case 'RROCK20':
                        onGrass = true;
                        break;
                    case 'SNOW1':
                    case 'SNOW5':
                    case 'SNOW6':
                    case 'SNOW7':
                    case 'SNOW8':
                    case 'SNOW10F':
                    case 'SNOW11F':
                    case 'SNOW12F':
                    case 'SNOW13F':
                    case 'SNOW14F':
                        onSnow = true;
                        break;
                    case 'SAND1':
                    case 'SAND2':
                    case 'SAND3':
                    case 'SAND4':
                    case 'SAND5':
                    case 'SAND6':
                    case 'SAND7':
                    case 'RROCK09': // Doubles as sand/rock
                        onSand = true;
                        break;
                    case 'RROCK01':
                    case 'RROCK02':
                    case 'RROCK05':
                    case 'RROCK06':
                    case 'RROCK07':
                    case 'RROCK08':
                    case 'FLOOR6_1':
                    case 'SFLR6_1':
                    case 'SFLR6_4':
                    case 'SKINFLT1':
                    case 'SLIME09':
                    case 'SLIME10':
                    case 'SLIME11':
                    case 'SLIME12':
                        onHellscape = true;
                        break;
                    default:
                        unknownFlat = true;
                }

                if(onGrass)
                {
                    if(random(1,100) <= 75) //Trees
                    {
                        switch(random(1,5))
                        {
                            case 1:
                                fstate = "OakTree";
                                break;
                            case 2:
                                fstate = "RedwoodTree";
                                break;
                            case 3:
                                fstate = "SomeThinTree";
                                break;
                            case 4:
                                fstate = "TapwaveTreeA";
                                break;
                            case 5:
                                fstate = "TapwaveTreeB";
                                break;
                        }
                    }
                    else //Bushes
                    {
                        switch(random(1,2))
                        {
                            case 1:
                                fstate = "ShrubA";
                                break;
                            case 2:
                                fstate = "ShrubB";
                                break;
                        }
                    }
                }

                if(onSnow)
                {
                    int index = 1;

                    if(random(1,4) >= 2)
                    {
                        index = random(10,14);
                    }else
                    {
                        index = random(1,9);
                    }

                    switch(index)
                    {
                        case 1:
                            fstate = "SnowTreeDeadA";
                            break;
                        case 2:
                            fstate = "SnowTreeKebab";
                            break;
                        case 3:
                            fstate = "SnowTreePloughed";
                            break;
                        case 4:
                            fstate = "SnowTreeDeadB";
                            break;
                        case 5:
                            fstate = "SnowTreeDeadC";
                            break;
                        case 6:
                            fstate = "SnowPineA";
                            break;
                        case 7:
                            fstate = "SnowPineB";
                            break;
                        case 8:
                            fstate = "SnowPineSmolA";
                            break;
                        case 9:
                            fstate = "SnowPineSmolB";
                            break;
                        case 10:
                            fstate = "CraneoPine1";
                            break;
                        case 11:
                            fstate = "CraneoPine2";
                            break;
                        case 12:
                            fstate = "CraneoPine3";
                            break;
                        case 13:
                            fstate = "CraneoPine4";
                            break;
                        case 14:
                            fstate = "CraneoPine5";
                            break;
                    }
                }

                if(onSand)
                {
                    switch(random(1,5))
                    {
                        case 1:
                            fstate = "PalmTree";
                            break;
                        case 2:
                            fstate = "DesertTreeA";
                            break;
                        case 3:
                            fstate = "DesertTreeB";
                            break;
                        case 4:
                            fstate = "ShrubA";
                            break;
                        case 5:
                            fstate = "ShrubB";
                            break;
                    }
                }

                if(onHellscape)
                {
                    switch(random(1,6))
                    {
                        case 1:
                            fstate = "CraneoEyeTreeA";
                            break;
                        case 2:
                            fstate = "CraneoEyeTreeB";
                            break;
                        case 3:
                            fstate = "CraneoEyeTreeC";
                            break;
                        case 4:
                            fstate = "CraneoWeirwoodTreeA";
                            break;
                        case 5:
                            fstate = "CraneoWeirwoodTreeB";
                            break;
                        case 6:
                            fstate = "CraneoWeirwoodTreeC";
                            break;
                    }
                }

                if(unknownFlat)
                {
                    switch(random(1,3))
                    {
                        case 1:
                            fstate = "CraneoDeadTreeA";
                            break;
                        case 2:
                            fstate = "CraneoDeadTreeB";
                            break;
                        case 3:
                            fstate = "CraneoDeadTreeC";
                            break;
                    }
                }

                if(onCeil != 'F_SKY1')
                {
                    scale.x *= 0.5; //For those occasional indoor planters
                    scale.y *= 0.5; //in urban theme.
                    switch(random(1,2))
                    {
                        case 1:
                            fstate = "ShrubA";
                            break;
                        case 2:
                            fstate = "ShrubB";
                            break;
                    }
                }

                //add a bit of random scaling jazz
                //CraneoPine# set is already 200ish height and doesn't need
                //adjustments
                double randomscale = frandom(0.8, 1.5);
                scale.x *= randomscale;
                scale.y *= randomscale;

                // 50% chance of flippin'
                scale.x *= randompick(-1,1);

                return ResolveState(fstate);
            }

        // temperate plants
        OakTree:
            OAK1 A 1;
            Loop;

        RedwoodTree:
            RED1 A 1;
            Loop;

        SomeThinTree:
            THN1 A 1;
            Loop;

        TapwaveTreeA:
            TWTR A 1;
            Loop;

        TapwaveTreeB:
            TWTR B 1;
            Loop;

        ShrubA:
            SHB1 A 1;
            Loop;

        ShrubB:
            SHB2 A 1;
            Loop;

        // snow world plants
        SnowTreeDeadA:
            XMAS A 1;
            Loop;

        SnowTreeKebab:
            XMAS B 1;
            Loop;

        SnowTreePloughed:
            XMAS C 1;
            Loop;

        SnowTreeDeadB:
            XMAS D 1;
            Loop;

        SnowTreeDeadC:
            XMAS E 1;
            Loop;

        SnowPineA:
            XMAS F 1;
            Loop;

        SnowPineB:
            XMAS G 1;
            Loop;

        SnowPineSmolA:
            XMAS H 1;
            Loop;

        SnowPineSmolB:
            XMAS I 1;
            Loop;

        CraneoPine1:
            XMAS J -1;
            Loop;

        CraneoPine2:
            XMAS K -1;
            Loop;

        CraneoPine3:
            XMAS L -1;
            Loop;

        CraneoPine4:
            XMAS M -1;
            Loop;

        CraneoPine5:
            XMAS N -1;
            Loop;

        // desert assets
        PalmTree:
            PLM1 A 1;
            Loop;

        DesertTreeA:
            DTR1 A 1;
            Loop;

        DesertTreeB:
            DTR2 A 1;
            Loop;

        // hell trees
        // eyeball trees
        CraneoEyeTreeA:
            OBET A 1;
            Loop;

        CraneoEyeTreeB:
            OBET B 1;
            Loop;

        CraneoEyeTreeC:
            OBET C 1;
            Loop;

        // weirwood trees
        CraneoWeirwoodTreeA:
            OBWT A 1;
            Loop;

        CraneoWeirwoodTreeB:
            OBWT B 1;
            Loop;

        CraneoWeirwoodTreeC:
            OBWT C 1;
            Loop;

        // sad, sad, sad dead trees very sad
        CraneoDeadTreeA:
            OBDT A 1;
            Loop;

        CraneoDeadTreeB:
            OBDT B 1;
            Loop;

        CraneoDeadTreeC:
            OBDT C 1;
            Loop;
    }
}

class FancyObligeTree2 : FancyObligeTree replaces TorchTree
{
}]],

  DEC_TREES =
[[
  actor FancyObligeTree replaces BigTree
{
    Radius 16
    Height 128
    ProjectilePassHeight -16
    +SOLID

    States
    {
        Spawn:
      TRE2 A 0
      TRE2 A 0 ACS_NamedExecuteAlways("IsMyAssGrass")
      TRE2 A 5
      Goto Decide

        Decide:
      TRE2 A 1
      TRE2 A 0 A_JumpIfInventory("AssIsGrass", 1, "OnGrass")
      TRE2 A 0 A_JumpIfInventory("AssIsSnow", 1, "OnSnow")
      TRE2 A 0 A_JumpIfInventory("AssIsSand", 1, "OnSand")
      TRE2 A 0 A_JumpIfInventory("AssIsHell", 1, "OnHellflat")
      TRE2 A 0 A_Jump(255, "OnUnknownFlat")

        OnGrass:
      TRE2 A 0 A_Jump(127, "Shrub1", "Shrub2")
      TRE2 A 0 A_Jump(255, "OakTree", "RedwoodTree", "SomeThinTree",
      "TapwaveTreeA", "TapwaveTreeB")

        OnSnow:
      TRE2 A 0 A_Jump(64, "SnowTreeDeadA", "SnowTreeKebab",
      "SnowTreePloughed", "SnowTreeDeadB", "SnowTreeDeadC",
      "SnowPineA", "SnowPineB", "SnowPineSmolA", "SnowPineSmolB")
      TRE2 A 0 A_Jump(255, "CraneoPine1", "CraneoPine2",
      "CraneoPine3", "CraneoPine4", "CraneoPine5")
      // Only Craneo's pine trees now get a height boost

        OnSand:
      TRE2 A 0 A_Jump(255, "PalmTree", "DesertTreeA", "DesertTreeB",
      "Shrub1", "Shrub2")

        OnHellflat:
      TRE2 A 0 A_Jump(255, "CraneoEyeTreeA", "CraneoEyeTreeB",
      "CraneoEyeTreeC", "CraneoWeirwoodTreeA", "CraneoWeirwoodTreeB",
      "CraneoWeirwoodTreeC")

        OnUnknownFlat:
      TRE2 A 0 A_Jump(255, "CraneoDeadTreeA",
      "CraneoDeadTreeB", "CraneoDeadTreeC")

        //temperate trees
        OakTree:
      OAK1 A -1

        RedwoodTree:
      RED1 A -1

        SomeThinTree:
      THN1 A -1

        TapwaveTreeA:
      TWTR A -1

        TapwaveTreeB:
      TWTR B -1

        Shrub1:
      SHB1 A -1

        Shrub2:
      SHB2 A -1

        //snow trees
        SnowTreeDeadA:
      XMAS A -1

        SnowTreeKebab:
      XMAS B -1

        SnowTreePloughed:
      XMAS C -1

        SnowTreeDeadB:
      XMAS D -1

        SnowTreeDeadC:
      XMAS E -1

        SnowPineA:
      XMAS F -1

        SnowPineB:
      XMAS G -1

        SnowPineSmolA:
      XMAS H -1

        SnowPineSmolB:
      XMAS I -1

        CraneoPine1:
      XMAS J -1

        CraneoPine2:
      XMAS K -1

        CraneoPine3:
      XMAS L -1

        CraneoPine4:
      XMAS M -1

        CraneoPine5:
      XMAS N -1

        //desert trees
        PalmTree:
      PLM1 A -1

        DesertTreeA:
      DTR1 A -1

        DesertTreeB:
      DTR2 A -1

        // hell trees
        // eyeball trees
        CraneoEyeTreeA:
      OBET A -1

        CraneoEyeTreeB:
      OBET B -1

        CraneoEyeTreeC:
      OBET C -1

        // weirwood trees
        CraneoWeirwoodTreeA:
      OBWT A -1

        CraneoWeirwoodTreeB:
      OBWT B -1

        CraneoWeirwoodTreeC:
      OBWT C -1

        // sad, sad, sad dead trees very sad
        CraneoDeadTreeA:
      OBDT A -1

        CraneoDeadTreeB:
      OBDT B -1

        CraneoDeadTreeC:
      OBDT C -1
    }
}

actor FancyObligeTreeAndBush : FancyObligeTree replaces TorchTree{}

actor AssIsGrass : Inventory
{
    Inventory.maxAmount 1
}

actor AssIsSnow : Inventory
{
    Inventory.maxAmount 1
}

actor AssIsSand : Inventory
{
    Inventory.maxAmount 1
}

actor AssIsHell : Inventory
{
    Inventory.maxAmount 1
}
]]
}

function ARMAETUS_EPIC_TEXTURES.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end

  ARMAETUS_EPIC_TEXTURES.put_new_materials()
  PARAM.epic_textures_activated = true
end

function ARMAETUS_EPIC_TEXTURES.decide_environment_themes()
  --------------------
  -- Outdoor Themes --
  --------------------
  -- Outdoor themes are essentially 'mutator' style inserts
  -- to replace the flats of outdoor rooms to match a specific
  -- theme - particularly snow and sand. Currently, there are three
  -- themes:
  --
  -- 1) Snow - emphasis on cold and snow, white textures.
  -- 2) Desert - emphasis on bright sand.
  -- 3) Temperate - technically not actually a theme, but a catch-all
  --                for the default circumstances of using ordinary
  --                grass, rock, etc. in temperate regions as is the
  --                norm for vanilla Doom-ish games.
  --
  -- Essentially, when "Temperate" is the selected theme, the
  -- environment theme code simply just doesn't run.

  if PARAM.environment_themes == "no" then return end

  -- pick a random environment
  if PARAM.environment_themes == "random" then
    for _,L in pairs(GAME.levels) do
      L.outdoor_theme = rand.pick({"temperate","snow","desert"})
    end
  end

  -- just like a bit mixed - every 2-6 levels, the theme will change
  if PARAM.environment_themes == "mixed" then
    local previous_theme
    local outdoor_theme_along

    for _,L in pairs(GAME.levels) do
      if L.id == 1 then
        L.outdoor_theme = rand.pick({"temperate","snow","desert"})
        previous_theme = L.outdoor_theme
        outdoor_theme_along = rand.irange(2,4)
      elseif L.id > 1 then
        -- continue the same theme until the countdown ends
        if outdoor_theme_along > 0 then
          L.outdoor_theme = previous_theme
          outdoor_theme_along = outdoor_theme_along - 1
        -- decide a new theme when the countdown ends
        -- logic goes that deserts cannot go to snow immediately
        -- and vice versa
        elseif outdoor_theme_along <= 0 then
          if previous_theme == "temperate" then
            L.outdoor_theme = rand.pick({"snow","desert"})
          else
            L.outdoor_theme = "temperate"
          end
          previous_theme = L.outdoor_theme
          outdoor_theme_along = rand.irange(2,4)
        end
      end
    end
  end

  -- -ish environment themes
  if PARAM.environment_themes == "snowish" then
    for _,L in pairs(GAME.levels) do
      L.outdoor_theme = rand.pick({"temperate","snow"})
    end
  elseif PARAM.environment_themes == "desertish" then
    for _,L in pairs(GAME.levels) do
      L.outdoor_theme = rand.pick({"temperate","desert"})
    end
  end

  -- absolutes
  if PARAM.environment_themes == "snow" then
    for _,L in pairs(GAME.levels) do
      L.outdoor_theme = "snow"
    end
  elseif PARAM.environment_themes == "desert" then
    for _,L in pairs(GAME.levels) do
      L.outdoor_theme = "desert"
    end
  end

  if PARAM.environment_themes == "episodic" then
    local prev_theme

    for _,E in pairs(GAME.episodes) do
      if not prev_theme then
        E.outdoor_theme = rand.pick({"temperate","desert","snow"})
        prev_theme = E.outdoor_theme
      else
        if prev_theme ~= "temperate" then
          E.outdoor_theme = "temperate"
          prev_theme = E.outdoor_theme
        else
          E.outdoor_theme = rand.pick({"snow","desert"})
          prev_theme = E.outdoor_theme
        end
      end
    end

    for _,L in pairs(GAME.levels) do
      L.outdoor_theme = L.episode.outdoor_theme
    end
  end

  gui.printf("\n--==| Environment Outdoor Themes |==--\n\n")
  for _,L in pairs(GAME.levels) do
    if L.outdoor_theme then
      gui.printf("Outdoor theme for " .. L.name .. ": " .. L.outdoor_theme .. "\n")
    end
  end
end

function ARMAETUS_EPIC_TEXTURES.generate_environment_themes()
  --------------------------------------
  -- Style Update for Custom Elements --
  --------------------------------------

  -- covers hallways only for now
  -- MSSP-TODO: revise this code to be more generic for future expansion
  if LEVEL.theme_name == "hell" then
    THEME.wide_halls.hellcata = 50 * style_sel("liquids", 0.3, 0.7, 1.2, 1.5)
                                  * style_sel("traps", 0.3, 0.7, 1.2, 1.5)
  elseif LEVEL.theme_name == "tech" or LEVEL.theme_name == "urban" then
    THEME.wide_halls.sewers = 50 * style_sel("liquids", 0.3, 0.7, 1.2, 1.5)
  end


  -- initialize default tables
  if not PARAM.default_environment_themes_init then
    -- Doom 2
    if OB_CONFIG.game == "doom2" then
      -- floors
      PARAM.def_tech_floors = GAME.ROOM_THEMES.tech_Outdoors_generic.floors
      PARAM.def_urban_floors = GAME.ROOM_THEMES.urban_Outdoors_generic.floors
      PARAM.def_hell_floors = GAME.ROOM_THEMES.hell_Outdoors_generic.floors
      -- naturals
      PARAM.def_tech_naturals = GAME.ROOM_THEMES.tech_Outdoors_generic.naturals
      PARAM.def_urban_naturals = GAME.ROOM_THEMES.urban_Outdoors_generic.naturals
      PARAM.def_hell_naturals = GAME.ROOM_THEMES.hell_Outdoors_generic.naturals

    -- Doom 1
    elseif OB_CONFIG.game == "doom1"
    or OB_CONFIG.game == "ultdoom" then
      -- floors
      PARAM.def_tech_floors = GAME.ROOM_THEMES.tech_Outdoors.floors
      PARAM.def_deimos_floors = GAME.ROOM_THEMES.deimos_Outdoors.floors
      PARAM.def_hell_floors = GAME.ROOM_THEMES.hell_Outdoors.floors
      PARAM.def_flesh_floors = GAME.ROOM_THEMES.flesh_Outdoors.floors
      -- naturals
      PARAM.def_tech_naturals = GAME.ROOM_THEMES.tech_Outdoors.naturals
      PARAM.def_deimos_naturals = GAME.ROOM_THEMES.deimos_Outdoors.naturals
      PARAM.def_hell_naturals = GAME.ROOM_THEMES.hell_Outdoors.naturals
      PARAM.def_flesh_naturals = GAME.ROOM_THEMES.flesh_Outdoors.naturals
    end

    PARAM.default_environment_themes_init = true
  end

  -- checking in on custom outdoors
  -- snow
  local snow_tech_floors = ARMAETUS_SNOW_OUTDOORS.tech.floors
  local snow_urban_floors = ARMAETUS_SNOW_OUTDOORS.urban.floors
  local snow_hell_floors = ARMAETUS_SNOW_OUTDOORS.hell.floors

  local snow_naturals = ARMAETUS_SNOW_OUTDOORS.naturals
  local snow_facades = ARMAETUS_SNOW_FACADE

  --sand
  local sand_tech_floors = ARMAETUS_DESERT_OUTDOORS.tech.floors
  local sand_urban_floors = ARMAETUS_DESERT_OUTDOORS.urban.floors
  local sand_hell_floors = ARMAETUS_DESERT_OUTDOORS.hell.floors

  local sand_naturals = ARMAETUS_DESERT_OUTDOORS.naturals
  local sand_facades = ARMAETUS_DESERT_FACADE

  if OB_CONFIG.game == "doom2" then
    if LEVEL.outdoor_theme == "snow" then
      GAME.ROOM_THEMES.tech_Outdoors_generic.floors = snow_tech_floors
      GAME.ROOM_THEMES.tech_Outdoors_generic.naturals = snow_naturals
      GAME.ROOM_THEMES.urban_Outdoors_generic.floors = snow_urban_floors
      GAME.ROOM_THEMES.urban_Outdoors_generic.naturals = snow_naturals
      GAME.ROOM_THEMES.hell_Outdoors_generic.floors = snow_hell_floors
      GAME.ROOM_THEMES.hell_Outdoors_generic.naturals = snow_naturals
    elseif LEVEL.outdoor_theme == "desert" then
      GAME.ROOM_THEMES.tech_Outdoors_generic.floors = sand_tech_floors
      GAME.ROOM_THEMES.tech_Outdoors_generic.naturals = sand_naturals
      GAME.ROOM_THEMES.urban_Outdoors_generic.floors = sand_urban_floors
      GAME.ROOM_THEMES.urban_Outdoors_generic.naturals = sand_naturals
      GAME.ROOM_THEMES.hell_Outdoors_generic.floors = sand_hell_floors
      GAME.ROOM_THEMES.hell_Outdoors_generic.naturals = sand_naturals
    elseif LEVEL.outdoor_theme == "temperate" then
      GAME.ROOM_THEMES.tech_Outdoors_generic.floors = PARAM.def_tech_floors
      GAME.ROOM_THEMES.tech_Outdoors_generic.naturals = PARAM.def_tech_naturals
      GAME.ROOM_THEMES.urban_Outdoors_generic.floors = PARAM.def_urban_floors
      GAME.ROOM_THEMES.urban_Outdoors_generic.naturals = PARAM.def_urban_naturals
      GAME.ROOM_THEMES.hell_Outdoors_generic.floors = PARAM.def_hell_floors
      GAME.ROOM_THEMES.hell_Outdoors_generic.naturals = PARAM.def_hell_naturals
    end
  -- MSSP-TODO: check cliff mats for Doom1
  elseif OB_CONFIG.game == "doom1"
  or OB_CONFIG.game == "ultdoom" then
    if LEVEL.outdoor_theme == "snow" then
      GAME.ROOM_THEMES.tech_Outdoors.floors = snow_floors
      GAME.ROOM_THEMES.tech_Outdoors.naturals = snow_naturals
      GAME.ROOM_THEMES.deimos_Outdoors.floors = snow_floors
      GAME.ROOM_THEMES.deimos_Outdoors.naturals = snow_naturals
      GAME.ROOM_THEMES.hell_Outdoors.floors = snow_floors
      GAME.ROOM_THEMES.hell_Outdoors.naturals = snow_naturals
      GAME.ROOM_THEMES.flesh_Outdoors.floors = snow_floors
      GAME.ROOM_THEMES.flesh_Outdoors.naturals = snow_naturals
    elseif LEVEL.outdoor_theme == "desert" then
      GAME.ROOM_THEMES.tech_Outdoors.floors = sand_floors
      GAME.ROOM_THEMES.tech_Outdoors.naturals = sand_naturals
      GAME.ROOM_THEMES.deimos_Outdoors.floors = sand_floors
      GAME.ROOM_THEMES.deimos_Outdoors.naturals = sand_naturals
      GAME.ROOM_THEMES.hell_Outdoors.floors = sand_floors
      GAME.ROOM_THEMES.hell_Outdoors.naturals = sand_naturals
      GAME.ROOM_THEMES.flesh_Outdoors.floors = sand_floors
      GAME.ROOM_THEMES.flesh_Outdoors.naturals = sand_naturals
    elseif LEVEL.outdoor_theme == "temperate" then
      GAME.ROOM_THEMES.tech_Outdoors.floors = PARAM.def_tech_floors
      GAME.ROOM_THEMES.tech_Outdoors.naturals = PARAM.def_tech_naturals
      GAME.ROOM_THEMES.deimos_Outdoors.floors = PARAM.def_deimos_floors
      GAME.ROOM_THEMES.deimos_Outdoors.naturals = PARAM.def_deimos_naturals
      GAME.ROOM_THEMES.hell_Outdoors.floors = PARAM.def_hell_naturals
      GAME.ROOM_THEMES.hell_Outdoors.naturals = PARAM.def_hell_naturals
      GAME.ROOM_THEMES.flesh_Outdoors.floors = PARAM.def_flesh_naturals
      GAME.ROOM_THEMES.flesh_Outdoors.naturals = PARAM.def_flesh_naturals
    end
  end
end

function ARMAETUS_EPIC_TEXTURES.table_insert(table1, table2)
  for x,y in pairs(table1) do
    table2[x] = y
  end
end

function ARMAETUS_EPIC_TEXTURES.put_new_materials()
  -- MSSP-TODO - redo all this code to just use a single deep merge table operation

  if OB_CONFIG.game == "doom2" or OB_CONFIG.game == "plutonia"
  or OB_CONFIG.game == "tnt" then

    -- remove old skybox tables
    GAME.THEMES["tech"].skyboxes = nil
    GAME.THEMES["urban"].skyboxes = nil
    GAME.THEMES["hell"].skyboxes = nil

    -- material definitions
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_MATERIALS,
      GAME.MATERIALS)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_LIQUID_DEFS,
      GAME.LIQUIDS)

    -- put the custom theme definitions in the themes table!!!
    -- LIQUIDZ
    if PARAM.custom_liquids ~= "no" then
      GAME.THEMES = table.deep_merge(GAME.THEMES, ARMAETUS_LIQUIDS, 2)
    end

    -- ROOM THEMES
    GAME.ROOM_THEMES = table.deep_merge(GAME.ROOM_THEMES, ARMAETUS_ROOM_THEMES, 2)

    -- NATURALS
    GAME.ROOM_THEMES = table.deep_merge(GAME.ROOM_THEMES, ARMAETUS_NATURALS, 2)

    -- definitions
    GAME.SINKS = table.deep_merge(GAME.SINKS, ARMAETUS_SINK_DEFS, 2)
    GAME.THEMES = table.deep_merge(GAME.THEMES, ARMAETUS_THEMES, 2)
  end

  if OB_CONFIG.game == "doom1" or OB_CONFIG.game == "ultdoom" then
    -- material definitions
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_MATERIALS,
      GAME.MATERIALS)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_LIQUID_MATS,
      GAME.LIQUIDS)

    -- put the custom theme definitions in the themes table!!!
    -- LIQUIDZ
    if PARAM.custom_liquids ~= "no" then
      GAME.THEMES = table.deep_merge(GAME.THEMES, ARMAETUS_DOOM1_LIQUIDS, 2)
    end

    GAME.THEMES = table.deep_merge(GAME.THEMES, ARMAETUS_DOOM1_THEMES, 2)

    -- ROOM THEMES
    GAME.ROOM_THEMES = table.deep_merge(GAME.ROOM_THEMES,
      ARMAETUS_DOOM1_ROOM_THEMES, 2)

    -- NATURALS
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_TECH_NATURALS,
      GAME.ROOM_THEMES.tech_Outdoors.naturals)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_DEIMOS_NATURALS,
      GAME.ROOM_THEMES.deimos_Outdoors.naturals)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_HELL_NATURALS,
      GAME.ROOM_THEMES.hell_Outdoors.naturals)
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_FLESH_NATURALS,
      GAME.ROOM_THEMES.flesh_Outdoors.naturals)

    -- SINKS
    ARMAETUS_EPIC_TEXTURES.table_insert(ARMAETUS_DOOM1_SINK_DEFS,
      GAME.SINKS)

    -- inserts for hallways
    GAME.THEMES.tech.wide_halls = ARMAETUS_TECH_WIDE_HALLS
    GAME.THEMES.deimos.wide_halls = ARMAETUS_TECH_WIDE_HALLS
    GAME.THEMES.hell.wide_halls = ARMAETUS_HELL_WIDE_HALLS
    GAME.THEMES.flesh.wide_halls = ARMAETUS_HELL_WIDE_HALLS
  end
end

function ARMAETUS_EPIC_TEXTURES.put_the_texture_wad_in()
  local wad_file = "games/doom/data/ObAddon_Textures.wad"
  if PARAM.include_package ~= "no" then
    gui.wad_transfer_lump(wad_file, "ANIMDEFS", "ANIMDEFS")
    gui.wad_transfer_lump(wad_file, "CREDITS", "CREDITS")
    gui.wad_merge_sections(wad_file)

    local dir = "games/doom/data/"
    -- wad_merge_sections currently does not support merging HI_START
    -- and HI_END... *sigh*
    gui.wad_add_binary_lump("HI_START",{})
    gui.wad_insert_file(dir .. "ARCD2.png", "ARCD2")
    gui.wad_insert_file(dir .. "ARCD3.png", "ARCD3")
    gui.wad_insert_file(dir .. "ARCD4.png", "ARCD4")
    gui.wad_insert_file(dir .. "ARCD5.png", "ARCD5")
    gui.wad_insert_file(dir .. "ARCD6.png", "ARCD6")
    gui.wad_insert_file(dir .. "ARCD7.png", "ARCD7")
    gui.wad_insert_file(dir .. "ARCD8.png", "ARCD8")
    gui.wad_insert_file(dir .. "ARCD9.png", "ARCD9")
    gui.wad_insert_file(dir .. "ARCD10.png", "ARCD10")
    gui.wad_insert_file(dir .. "ARCD11.png", "ARCD11")
    gui.wad_insert_file(dir .. "OBVNMCH1.png", "OBVNMCH1")
    gui.wad_insert_file(dir .. "OBVNMCH2.png", "OBVNMCH2")
    gui.wad_insert_file(dir .. "OBVNMCH3.png", "OBVNMCH3")
    gui.wad_insert_file(dir .. "OBVNMCH4.png", "OBVNMCH4")
    gui.wad_insert_file(dir .. "OBVNMCH5.png", "OBVNMCH5")
    gui.wad_insert_file(dir .. "ROAD1.png", "ROAD1")
    gui.wad_insert_file(dir .. "ROAD2.png", "ROAD2")
    gui.wad_insert_file(dir .. "ROAD3.png", "ROAD3")
    gui.wad_insert_file(dir .. "ROAD4.png", "ROAD4")
    gui.wad_insert_file(dir .. "CRATJOKE.png", "CRATJOKE")
    gui.wad_add_binary_lump("HI_END",{})
  end

  if PARAM.custom_trees ~= "no" then
    wad_file = "modules/zdoom_internal_scripts/ObAddon_trees.wad"
    gui.wad_merge_sections(wad_file)
  end

  if PARAM.include_brightmaps == "yes" then
    wad_file = "games/doom/data/ObAddon_Textures_Brightmaps.wad"
    gui.wad_merge_sections(wad_file)
  end
end
----------------------------------------------------------------

OB_MODULES["armaetus_epic_textures"] =
{
  label = _("ZDoom: Armaetus Texture Pack"),

  side = "left",
  priority = 70,

  engine = { zdoom=1, gzdoom=1, skulltag=1 },

  game = "doomish",

  hooks =
  {
    setup = ARMAETUS_EPIC_TEXTURES.setup,
    get_levels_after_themes = ARMAETUS_EPIC_TEXTURES.decide_environment_themes,
    begin_level = ARMAETUS_EPIC_TEXTURES.generate_environment_themes,
    level_layout_finished = ARMAETUS_EPIC_TEXTURES.create_environment_themes,
    all_done = ARMAETUS_EPIC_TEXTURES.put_the_texture_wad_in
  },

  tooltip = "If enabled, adds textures from Armaetus's Texture Pack, which also includes a few new custom texture exclusive prefabs.",

  options =
  {
    custom_liquids =
    {
      name = "custom_liquids",
      label = _("Custom Liquids"),
      choices = ARMAETUS_EPIC_TEXTURES.YES_NO,
      default = "yes",
      tooltip = "Adds new custom Textures liquid flats.",
      priority=4
    },

    custom_trees =
    {
      name = "custom_trees",
      label = _("Custom Trees"),
      choices = ARMAETUS_EPIC_TEXTURES.SOUCEPORT_CHOICES,
      default = "zs",
      tooltip =
        "Adds custom flat-depedendent tree sprites into the game. Currently only replaces " ..
        "trees on specific grass flats and will be expanded in the future to accomnodate " ..
        "custom Textures and more. If you are playing a mod that already does its own trees, " ..
        "it may be better to leave this off.",
      priority=3
    },

    environment_themes =
    {
      name = "environment_themes",
      label = _("Environment Theme"),
      choices = ARMAETUS_EPIC_TEXTURES.ENVIRONMENT_THEME_CHOICES,
      default = "random",
      tooltip =
        "// THIS FEATURE IS CURRENTLY UNDER CONSTRUCTION \\\\\n" ..
        "Influences outdoor environments with different textures such as " ..
        "desert sand or icey snow.",
      priority=2,
      gap=1
    },

    include_package =
    {
      name = "include_package",
      label = _("Merge Textures WAD"),
      choices = ARMAETUS_EPIC_TEXTURES.YES_NO,
      default = "yes",
      tooltip =
        "Allows the trimming down of resulting WAD by not merging the custom texture WAD.\n\n" ..
        "This will require you to extract and load up the WAD manually in your preferred sourceport installation.\n\n" ..
        "This is the preferrable option for multiplayer situations and server owners and have each client obtain a copy of the texture pack instead.\n",
      priority=1
    },

    include_brightmaps =
    {
      name = "include_brightmaps",
      label = _("Include Brightmaps"),
      choices = ARMAETUS_EPIC_TEXTURES.YES_NO,
      default = "yes",
      tooltip = "Allows merging Epic Textures brightmaps into the WAD. Does not include brightmaps for" ..
        " base resources from any of the games.",
      priority = 0
    }
  }
}
