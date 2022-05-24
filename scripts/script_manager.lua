------------------------------------------------------------------------
--  SCRIPT MANAGER
------------------------------------------------------------------------
--
--  // Obsidian //
--
--  Copyright (C) 2019-2022 MsrSgtShooterPerson
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


--[[
==========================
      SCRIPT MANAGER
==========================
The Script Manager is a catch-all for the creation of various
lumps from different Obsidian modules for better organization.

The goal is gather all lump data from various modules and create
the necessary includes/import lines for each, as well as merging
certain lumps if required such as the need for ZScript editor
numbers to be defined in a MAPINFO instead of within the script
file itself.
]]


function ScriptMan_combine_script(script, text)
  if script then
    script = script .. text
  else
    script = text
  end

  return script
end


function ScriptMan_assemble_acs_lump()
-- MSSP-TODO
end


function ScriptMan_assemble_mapinfo_lump()

  local mapinfo_lines

  if OB_CONFIG.engine == "zdoom" then
    -- GAMEINFO stuff
    mapinfo_lines = {
        "gameinfo\n",
        "{\n",
    }

    local eventhandler_lines = ""
    if SCRIPTS.zs_eventhandlers then
      eventhandler_lines = eventhandler_lines .. SCRIPTS.zs_eventhandlers
    end
    if PARAM.bool_boss_gen == 1 and PARAM.boss_count ~= -1 then
      eventhandler_lines = eventhandler_lines .. '"BossGenerator_Handler"'
    end
    eventhandler_lines = string.gsub(eventhandler_lines, ",$", "");

    if eventhandler_lines ~= "" then
      eventhandler_lines = "addeventhandlers = " .. eventhandler_lines
    end

    if SCRIPTS.zs_eventhandlers ~= "" then
      eventhandler_lines = eventhandler_lines .. "\n"
      table.insert(mapinfo_lines, eventhandler_lines)
    end

    -- MAPINFO extras
    if PARAM.bool_custom_quit_messages == 1 or PARAM.bool_heretic_quit_messages == 1 then
      for _,line in pairs(PARAM.gameinfolump) do
        table.insert(mapinfo_lines,line)
      end
    end

    table.insert(mapinfo_lines, "\n}\n")

    -- doomednums
    if SCRIPTS.doomednums then
      SCRIPTS.doomednums = "DoomedNums\n" ..
      "{\n" .. SCRIPTS.doomednums .. "}\n"
    end
    -- rest of map info lump
    table.insert(mapinfo_lines, SCRIPTS.doomednums)
    table.insert(mapinfo_lines, SCRIPTS.mapinfolump)
    if OB_CONFIG.game == "hexen" then
      for _,lev in pairs(GAME.levels) do
        local mapnum = tonumber(string.sub(lev.name, 4))
        mapline = "map " .. lev.name .. " \"" .. lev.description .. "\"\n{\n"
        for k, v in pairs(HEXEN.MAPINFO_MAPS) do
          if v == mapnum then
            mapline = mapline .. "warptrans = " .. k .. "\n"
            goto foundmap
          end
        end
        ::foundmap::
        mapline = mapline .. "levelnum = " .. mapnum .. "\n"
        mapline = mapline .. "cluster = 1\n"
        local sky = lev.theme.sky_mapinfo
        mapline = mapline .. "sky1 = \"" .. sky.sky_patch1 .. "\", " .. sky.sky_speed1 / 100 .. "\n"
        mapline = mapline .. "sky2 = \"" .. sky.sky_patch2 .. "\", " .. sky.sky_speed2 / 100 .. "\n"
        if sky.lightning_chance then
          if rand.odds(sky.lightning_chance) then
            mapline = mapline .. "lightning\n"
          end
        end
        if sky.doublesky then
          mapline = mapline .. "doublesky\n"
        end
        if sky.fadetable then
          mapline = mapline .. "fadetable = \"fogmap\"\n"
        end
        mapline = mapline .. "}\n\n"
        table.insert(mapinfo_lines, mapline)
      end
    end
  else
    if OB_CONFIG.game == "hexen" then
      mapinfo_lines = {}
      for _,lev in pairs(GAME.levels) do
        local mapnum = tonumber(string.sub(lev.name, 4))
        mapline = "map " .. mapnum .. " \"" .. lev.description .. "\"\n"
        for k, v in pairs(HEXEN.MAPINFO_MAPS) do
          if v == mapnum then
            mapline = mapline .. "warptrans " .. k .. "\n"
            goto foundmap
          end
        end
        ::foundmap::
        mapline = mapline .. "cluster 1\n"
        local sky = lev.theme.sky_mapinfo
        mapline = mapline .. "sky1 " .. sky.sky_patch1 .. " " .. sky.sky_speed1 .. "\n"
        mapline = mapline .. "sky2 " .. sky.sky_patch2 .. " " .. sky.sky_speed2 .. "\n"
        if sky.lightning_chance then
          if rand.odds(sky.lightning_chance) then
            mapline = mapline .. "lightning\n"
          end
        end
        if sky.doublesky then
          mapline = mapline .. "doublesky\n"
        end
        if sky.fadetable then
          mapline = mapline .. "fadetable fogmap\n"
        end
        mapline = mapline .. "\n"
        table.insert(mapinfo_lines, mapline)
      end
    end
  end
  if mapinfo_lines and (#mapinfo_lines > 2  or (OB_CONFIG.engine ~= "zdoom" and #mapinfo_lines > 0)) then
    gui.wad_add_text_lump("MAPINFO", mapinfo_lines)
  end
end

function ScriptMan_assemble_trnslate_lump()
  local trnslate_lines = ""

  if PARAM.MARINETRNSLATE then
    trnslate_lines = trnslate_lines .. PARAM.MARINETRNSLATE .. "\n"
  end

  if trnslate_lines ~= "" then
    add_script_lump("TRNSLATE", trnslate_lines)
  end
end


function ScriptMan_assemble_zscript_lump()
  local zscript_lines = ""

  if PARAM.bool_boss_gen == 1 and PARAM.boss_count ~= -1 then
    zscript_lines = zscript_lines .. PARAM.BOSSSCRIPT .. "\n"
  end

  if PARAM.custom_trees == "zs" then
    zscript_lines = zscript_lines ..
    ARMAETUS_EPIC_TEXTURES.TEMPLATES.ZS_TREES .. "\n"
  end

  if SCRIPTS.zscript then
    zscript_lines = zscript_lines .. SCRIPTS.zscript .. "\n"
  end

  if zscript_lines ~= "" then
    zscript_lines = 'version "4.3"\n' .. zscript_lines
    add_script_lump("ZSCRIPT", zscript_lines)
  end
end


function ScriptMan_assemble_decorate_lump()
  if PARAM.bool_dynamic_lights == 1 then -- TODO: Move these to respective modules.
    if OB_CONFIG.game == "heretic" then
        SCRIPTS.decorate = ScriptMan_combine_script(SCRIPTS.decorate, ZDOOM_SPECIALS_HERETIC.DYNAMIC_LIGHT_DECORATE)
    else
        SCRIPTS.decorate = ScriptMan_combine_script(SCRIPTS.decorate, ZDOOM_SPECIALS.DYNAMIC_LIGHT_DECORATE)
    end
  end

  if SCRIPTS.decorate then
    add_script_lump("DECORATE", SCRIPTS.decorate)
  end
end


function ScriptMan_assemble_sndinfo_lump()
  local sndinfo_lines = ""

  if PARAM.ambient_sounds then
    sndinfo_lines = sndinfo_lines ..
    SCRIPTS.SNDINFO .. "\n"
  end
  if SCRIPTS.fauna_SNDINFO then
    sndinfo_lines = sndinfo_lines ..
    SCRIPTS.fauna_SNDINFO .. "\n"
  end
  if SCRIPTS.soundinfo then
    sndinfo_lines = sndinfo_lines ..
    SCRIPTS.soundinfo .. "\n"
  end

  if sndinfo_lines ~= "" then
    add_script_lump("SNDINFO", sndinfo_lines)
  end
end


function ScriptMan_assemble_gldefs_lump()
  local gldefs_lines = ""

  if PARAM.bool_dynamic_lights == 1 then
    if OB_CONFIG.game == "heretic" then
      gldefs_lines = gldefs_lines ..
      ZDOOM_SPECIALS_HERETIC.DYNAMIC_LIGHT_GLDEFS
    else
      gldefs_lines = gldefs_lines ..
      ZDOOM_SPECIALS.DYNAMIC_LIGHT_GLDEFS
    end
  end

  if PARAM.bool_glowing_flats == 1 then
    if OB_CONFIG.game == "heretic" then
      gldefs_lines = gldefs_lines ..
      ZDOOM_SPECIALS_HERETIC.GLOWING_FLATS_GLDEFS
    else
      gldefs_lines = gldefs_lines ..
      ZDOOM_SPECIALS.GLOWING_FLATS_GLDEFS
    end
  end

  if PARAM.bool_include_brightmaps == 1 then
    gldefs_lines = gldefs_lines ..
    EPIC_BRIGHTMAPS
  end

  if PARAM.brightmaps then
    gldefs_lines = gldefs_lines ..
    PARAM.brightmaps
  end

  if gldefs_lines ~= "" then
    add_script_lump("GLDEFS", gldefs_lines)
  end
end

function ScriptMan_assemble_language_lump()
  local language_lines = {
      "[enu default]\n",
  }

  if PARAM.bool_boss_gen == 1 and PARAM.boss_count ~= -1 then
    for _,line in pairs(PARAM.BOSSLANG) do
      table.insert(language_lines,line)
    end
  end
  if PARAM.language_lump ~= nil then
    for _,line in pairs(PARAM.language_lump) do
      table.insert(language_lines,line)
    end
  end
  if PARAM.bool_quit_messages == 1 or PARAM.bool_heretic_quit_messages == 1 then
    for _,line in pairs(PARAM.quit_messagelump) do
      table.insert(language_lines,line)
    end
  end

  if #language_lines > 2 then
    gui.wad_add_text_lump("LANGUAGE", language_lines)
  end

end

function ScriptMan_assemble_acs_loader_lump()
  local acs_loader_lines = {}

  if PARAM.custom_trees == "decorate" then
    table.insert(acs_loader_lines, "ASSGRASS\n")
  end
  if SCRIPTS.tissue_doc then
    table.insert(acs_loader_lines, "COUNTTIS\n")
  end

  gui.wad_add_text_lump("LOADACS", acs_loader_lines)
end

function ScriptMan_merge_acs_lumps()
  gui.wad_add_binary_lump("A_START",{})

  if PARAM.custom_trees == "decorate" then
    gui.wad_insert_file("modules/zdoom_internal_scripts/ASSGRASS.lmp", "ASSGRASS")
  end
  if SCRIPTS.tissue_doc then
    gui.wad_insert_file("modules/zdoom_internal_scripts/COUNTTIS.lmp", "COUNTTIS")
  end

  gui.wad_add_binary_lump("A_END",{})
end

function ScriptMan_assemble_textures_lump()
  local textures_lump_lines = {}
  local animdefs_lump_lines = {}

  if PARAM.obsidian_resource_pack_active then
    table.insert(textures_lump_lines, EPIC_TEXTUREX_LUMP)
    gui.wad_add_text_lump("TEXTURES", textures_lump_lines)
  end

  if SCRIPTS.animdefs then
    table.insert(textures_lump_lines, EPIC_TEXTUREX_LUMP)
    gui.wad_add_text_lump("ANIMDEFS", {SCRIPTS.animdefs})
  end
end

function ScriptMan_assemble_terrain_lump()
  if SCRIPTS.terrain then
    gui.wad_add_text_lump("TERRAIN", {SCRIPTS.terrain})
  end
end

function ScriptMan_create_include_lump()
end


function ScriptMan_init()
  gui.printf("\n--==| Script Manager |==--\n\n")
  ScriptMan_assemble_zscript_lump()
  ScriptMan_assemble_decorate_lump()
  ScriptMan_assemble_gldefs_lump()
  ScriptMan_assemble_sndinfo_lump()
  ScriptMan_assemble_mapinfo_lump()
  ScriptMan_assemble_trnslate_lump()
  ScriptMan_assemble_language_lump()
  ScriptMan_assemble_acs_loader_lump()
  ScriptMan_assemble_textures_lump()
  ScriptMan_assemble_terrain_lump()
  ScriptMan_merge_acs_lumps()
end
