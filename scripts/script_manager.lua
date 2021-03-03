------------------------------------------------------------------------
--  SCRIPT MANAGER
------------------------------------------------------------------------
--
--  Oblige Level Maker // ObAddon
--
--  Copyright (C) 2019 MsrSgtShooterPerson
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
lumps from different ObAddon modules for better organization.

The goal is gather all lump data from various modules and create
the necessary includes/import lines for each, as well as merging
certain lumps if required such as the need for ZScript editor
numbers to be defined in a MAPINFO instead of within the script
file itself.
]]


function ScriptMan_assemble_acs_lump()
-- MSSP-TODO
end


function ScriptMan_assemble_mapinfo_lump()


  -- GAMEINFO stuff
  local mapinfo_lines = {
      "gameinfo\n",
      "{\n",
  }

  local eventhandler_lines = "addeventhandlers = "
  if PARAM.boss_gen and PARAM.boss_count ~= -1 then
    eventhandler_lines = eventhandler_lines .. '"BossGenerator_Handler"'
  end
  if PARAM.boss_gen and PARAM.boss_count ~= -1 and SCRIPTS.actor_name_script then
    eventhandler_lines = eventhandler_lines .. ", "
  end
  if SCRIPTS.actor_name_script then
    eventhandler_lines = eventhandler_lines .. '"bossNameHandler"'
  end
  if (PARAM.boss_gen and PARAM.boss_count ~= -1) or SCRIPTS.actor_name_script then
    eventhandler_lines = eventhandler_lines .. "\n"
    table.insert(mapinfo_lines, eventhandler_lines)
  end

  -- MAPINFO extras
  if PARAM.custom_quit_messages == "yes" then
    for _,line in pairs(PARAM.gameinfolump) do
      table.insert(mapinfo_lines,line)
    end
  end

  table.insert(mapinfo_lines, "\n}\n")

  local doomednum_lines = {
      "DoomedNums\n",
      "{\n",
  }
  if SCRIPTS.fauna_mapinfo then
    for _,line in pairs(SCRIPTS.fauna_mapinfo) do
      table.insert(doomednum_lines,line)
    end
  end
  if PARAM.marine_gen then
    for _,line in pairs(PARAM.MARINEMAPINFO) do
      table.insert(doomednum_lines,line)
    end
  end
  if #doomednum_lines > 2 then
    table.insert(doomednum_lines, "}\n")
    for _,line in pairs(doomednum_lines) do
      table.insert(mapinfo_lines,line)
    end
  end

  if PARAM.mapinfolump ~= nil then
    for _,line in pairs(PARAM.mapinfolump) do
      table.insert(mapinfo_lines,line)
    end
  end

  if #mapinfo_lines > 2 then
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

  if PARAM.boss_gen and PARAM.boss_count ~= -1 then
    zscript_lines = zscript_lines .. PARAM.BOSSSCRIPT .. "\n"
  end
  if PARAM.marine_gen then
    zscript_lines = zscript_lines .. PARAM.MARINESCRIPT .. "\n"
  end
  if PARAM.custom_trees == "zs" then
    zscript_lines = zscript_lines ..
    ARMAETUS_EPIC_TEXTURES.TEMPLATES.ZS_TREES .. "\n"
  end
  if SCRIPTS.actor_name_script then
    zscript_lines = zscript_lines .. SCRIPTS.actor_name_script .. "\n"
  end

  if SCRIPTS.fauna_zsc then
    zscript_lines = zscript_lines .. SCRIPTS.fauna_zsc .. "\n"
  end

  if zscript_lines ~= "" then
    zscript_lines = 'version "4.3"\n' .. zscript_lines
    add_script_lump("ZSCRIPT", zscript_lines)
  end
end


function ScriptMan_assemble_decorate_lump()
  local decorate_script_lines = ""

  if PARAM.custom_trees == "decorate" then
    decorate_script_lines = decorate_script_lines ..
    ARMAETUS_EPIC_TEXTURES.TEMPLATES.DEC_TREES .. "\n"
  end
  if PARAM.dynamic_lights == "yes" then
    if OB_CONFIG.game == "heretic" then
        decorate_script_lines = decorate_script_lines ..
        ZDOOM_SPECIALS_HERETIC.DYNAMIC_LIGHT_DECORATE .. "\n"
    else
        decorate_script_lines = decorate_script_lines ..
        ZDOOM_SPECIALS.DYNAMIC_LIGHT_DECORATE .. "\n"
    end
  end
  if SCRIPTS.hn_marker_decorate_lines then
    decorate_script_lines = decorate_script_lines ..
    SCRIPTS.hn_marker_decorate_lines .. "\n"
  end
  if PARAM.ambient_sounds then
    decorate_script_lines = decorate_script_lines ..
    SCRIPTS.SOUND_DEC .. "\n"
  end
  if SCRIPTS.tissue_doc then
    decorate_script_lines = decorate_script_lines ..
    SCRIPTS.tissue_doc .. "\n"
  end
  if SCRIPTS.fauna_dec then
    decorate_script_lines = decorate_script_lines ..
    SCRIPTS.fauna_dec .. "\n"
  end

  if decorate_script_lines ~= "" then
    add_script_lump("DECORATE", decorate_script_lines)
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

  if sndinfo_lines ~= "" then
    add_script_lump("SNDINFO", sndinfo_lines)
  end
end


function ScriptMan_assemble_gldefs_lump()
  local gldefs_lines = ""

  if PARAM.dynamic_lights == "yes" then
    if OB_CONFIG.game == "heretic" then
        gldefs_lines = gldefs_lines ..
        ZDOOM_SPECIALS_HERETIC.DYNAMIC_LIGHT_GLDEFS
    else
        gldefs_lines = gldefs_lines ..
        ZDOOM_SPECIALS.DYNAMIC_LIGHT_GLDEFS
    end
  end

  if PARAM.glowing_flats == "yes" then
    if OB_CONFIG.game == "heretic" then
        gldefs_lines = gldefs_lines ..
        ZDOOM_SPECIALS_HERETIC.GLOWING_FLATS_GLDEFS
    else
        gldefs_lines = gldefs_lines ..
        ZDOOM_SPECIALS.GLOWING_FLATS_GLDEFS
    end
  end

  if PARAM.include_brightmaps == "yes" then
    gldefs_lines = gldefs_lines ..
    EPIC_BRIGHTMAPS
  end

  if gldefs_lines ~= "" then
    add_script_lump("GLDEFS", gldefs_lines)
  end
end

function ScriptMan_assemble_language_lump()
  local language_lines = {
      "[enu default]\n",
  }

  if PARAM.boss_gen and PARAM.boss_count ~= -1 then
    for _,line in pairs(PARAM.BOSSLANG) do
      table.insert(language_lines,line)
    end
  end
  if PARAM.language_lump ~= nil then
    for _,line in pairs(PARAM.language_lump) do
      table.insert(language_lines,line)
    end
  end
  if PARAM.quit_messages == "yes" then
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

  if PARAM.epic_textures_activated then
    table.insert(textures_lump_lines, EPIC_TEXTUREX_LUMP)
    gui.wad_add_text_lump("TEXTURES", textures_lump_lines)
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
  ScriptMan_merge_acs_lumps()
end
