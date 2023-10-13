------------------------------------------------------------------------
--  MAIN FILE / INTERFACE TO C++ code
------------------------------------------------------------------------
--
--  RandTrack : track generator for NFS1 (SE)
--
--  Copyright (C) 2014 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 3
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this software.  If not, please visit the following
--  web page: http://www.gnu.org/licenses/gpl.html
--
------------------------------------------------------------------------

gui.import("nfs/defs")

gui.import("nfs/track_open")
gui.import("nfs/track_closed")

gui.import("nfs/write")
gui.import("nfs/ai_driver")

gui.import("nfs/road_util")
gui.import("nfs/layout")
gui.import("nfs/scenery")


function collect_tracks_to_make()
  local list = {}

  for name, info in pairs(TRACK_FILES) do
    -- skip tracks which are not present in the original game
    if PREFS.game == "nfs1" and info.is_new then
      goto continue
    end

    -- ignore tracks which are not finished yet
    if not info.features then
      goto continue
    end

    -- apply the user setting
    if (PREFS.tracks == "open"   and info.kind == "closed") or
       (PREFS.tracks == "closed" and info.kind == "open")
    then
      goto continue
    end

    -- single track?  [ actually 3 tracks for Alpine/Coastline/City ]
    if string.match(PREFS.tracks, "^[A-Z]") and
       string.match(name, PREFS.tracks) == nil
    then
      goto continue
    end

    table.insert(list, name)
    ::continue::
  end

  -- assume user selected a track which is not usable
  if table.empty(list) then
    error("Track not available in original game")
  end

  table.sort(list)

  return list
end



function free_memory()
  TRACK = nil

  collectgarbage("collect")
end



function generate_cool_tracks()
  local list = collect_tracks_to_make()

  if table.empty(list) then
    gui.show_message("No tracks to build!")
    return
  end

  printf("\n====== Generating Tracks ======\n\n")

  printf("Settings :\n%s\n\n", table.tostr(PREFS))

  for _,name in pairs(list) do
    local info = TRACK_FILES[name]

    -- set progress bar
    local perc = (_index - 1) * 100 / #list

    gui.progress(perc, string.format("%d%% : %s", perc, info.name))

    gui.rand_seed(PREFS.seed, name)

    generate_a_track(info)

    local dest_file = PREFS.folder .. "/" .. info.track_file

    save_track(dest_file)

    free_memory()
  end

  gui.progress(100, "100%")

  printf("SUCCESS!\n")
end


------------------------------------------------------------------------


function collect_tracks_for_backup()
  local list = {}

  for name, info in pairs(TRACK_FILES) do
    -- skip tracks which are not present in the original game
    if PREFS.game == "nfs1" and info.is_new then
      goto continue
    end

    table.insert(list, info.track_file)
    ::continue::
  end

  table.sort(list)

  return list
end


function report_file(filename, msg)
  local ERROR_COL   = "@C88@."
  local SUCCESS_COL = "@C216@."

  if msg then
    gui.backup_report(false, ERROR_COL .. filename .. " : failed, " .. msg)
  else
    gui.backup_report(true, SUCCESS_COL .. filename .. " : success")
  end
end


function backup_orig_tracks()
  printf("Backing up game tracks...\n")

  local folder = assert(PREFS.folder)

  local file_list = collect_tracks_for_backup()

  for _,filename in pairs(file_list) do
    local source = folder .. "/" .. filename
    local dest   = folder .. "/RT_SAVE/" .. filename

    local msg = gui.file_copy(source, dest)

    report_file(filename, msg)
  end
end



function restore_orig_tracks(folder)
  printf("Restoring the game tracks...\n")

  local folder = assert(PREFS.folder)

  local file_list = collect_tracks_for_backup()

  for _,filename in pairs(file_list) do
    local source = folder .. "/RT_SAVE/" .. filename
    local dest   = folder .. "/" .. filename

    local msg = gui.file_copy(source, dest)

    report_file(filename, msg)
  end
end


------------------------------------------------------------------------


--
-- called by C++ code after loading the scripts (once only)
--
function scr_init()
  printf("Initializing scripts...\n")

  table.name_up(PIECES)
  table.name_up(FEATURES)
  table.name_up(EDGES)
end


--
-- called by C++ code for certain UI functions
--
function scr_action(act, param)
  if act == "build" then
    generate_cool_tracks()
  elseif act == "backup" then
    backup_orig_tracks()
  elseif act == "restore" then
    restore_orig_tracks()
  else
    error("Unknown scr_action: " .. tostring(act))
  end
end


--
-- called by C++ code when a script error occurs.
-- this reads the stack-trace and prints it to the console / log file.
--
function scr_traceback(msg)

  -- guard against very early errors
  if not gui or not printf then
    return msg
  end

  printf("\n")
  printf("****** ERROR OCCURRED ******\n\n")
  printf("Stack Trace:\n")

  local stack_limit = 40

  local function format_source(info)
    if not info.short_src or info.currentline <= 0 then
      return ""
    end

    local base_fn = string.match(info.short_src, "[^/]*$")
 
    return string.format("@ %s:%d", base_fn, info.currentline)
  end

  for i = 1,stack_limit do
    local info = debug.getinfo(i+1)
    if not info then break end

    if i == stack_limit then
      printf("(remaining stack trace omitted)\n")
      break;
    end

    if info.what == "Lua" then

      local func_name = "???"

      if info.namewhat and info.namewhat ~= "" then
        func_name = info.name or "???"
      else
        -- perform our own search of the global namespace,
        -- since the standard LUA code (5.1.2) will not check it
        -- for the topmost function (the one called by C code)
        for k,v in pairs(_G) do
          if v == info.func then
            func_name = k
            break;
          end
        end
      end

      printf("  %d: %s() %s\n", i, func_name, format_source(info))

    elseif info.what == "main" then

      printf("  %d: main body %s\n", i, format_source(info))

    elseif info.what == "tail" then

      printf("  %d: tail call\n", i)

    elseif info.what == "C" then

      if info.namewhat and info.namewhat ~= "" then
        printf("  %d: c-function %s()\n", i, info.name or "???")
      end
    end
  end

  return msg
end


--
-- called by C++ code to provide current settings (preferences)
--
function scr_preference(name, value)
  assert(name)
  assert(value)

  -- handle numeric values
  if type(PREFS[name]) == "number" then
    PREFS[name] = tonumber(value) or 0
  else
    PREFS[name] = value
  end
end

