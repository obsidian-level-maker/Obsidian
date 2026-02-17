# THIS REPOSITORY IS CURRENTLY INACTIVE AND UNSUPPORTED
## OUR CURRENT PRIMARY REPOSITORY IS FOUND IN
https://github.com/GTD-Carthage/Obsidian-Content

# DISCORD SERVER FOR QUESTIONS, ADDONS, HELP, ETC
https://discord.gg/dfqCt9v

# OBSIDIAN
by the ObAddon Community.

## INTRODUCTION

OBSIDIAN is a random level generator for classic FPS titles.
The goal is to produce good levels which are fun to play.

Features of OBSIDIAN include:

* high quality levels, e.g. outdoor areas and caves!
* easy to use GUI interface (no messing with command lines)
* built-in node builder, so the levels are ready to play
* uses the LUA scripting language for easy customisation

## COMPATIBLE GAMES

* Doom 1 / The Ultimate Doom / Doom 2 / Final Doom  
  These are the primary target for Obsidian and have the highest level of support, with the most prefabs, modules, and available addons.
  New features are most likely to be implemented for these games first.
    
* Heretic  
  Moderate level of support, with some advanced modules and a handful of addons available.
  
* Chex Quest 3
  Basic level of support, with a handful of unique prefabs.
  
* HacX 1.2 
  Basic level of support.
  
* Harmony  
  Basic level of support.
  
* Hexen 
  Basic level of support. Game progression is linear and episodic, with no hubs present. The game will end after the last level generated. The Death Wyvern is absent from the monster table due to the    infeasibility of scripting and flight pathing with randomly generated layouts.
  
* Strife
  Basic level of support. Quests/multiple endings not yet implemented. Progression is linear and game will end after the last level generated.
  
* Wolfenstein 3D / Spear of Destiny
  Moderate level of support.
  
* Super Noah's Ark 3D  
  Basic level of support. 

## QUICK START GUIDE (Windows)

First, unpack the zip somewhere .  Make sure it is extracted with folders, and also make sure the OBSIDIAN.EXE file gets extracted too.

Double click on the OBSIDIAN icon to run it.  Select the game in the top left panel, and any other options which take your fancy. Then click the BUILD button in the top left panel, and pick a location in which to save your file.

OBSIDIAN will then build all the maps, showing a blueprint of each one as it goes, and if everything goes smoothly the output file (e.g. "TEST.WAD") will be created at the end.  Then you can play it using the normal method for playing mods with that game (e.g. for DOOM source ports: dragging-n-dropping the WAD file onto the source port's EXE is usually enough).

## QUICK START GUIDE (Linux/BSD/Haiku OS)

Please refer to COMPILING.md to build Obsidian for Linux/BSD/Haiku OS

## QUICK START GUIDE (Docker)

Build the image:

```bash
docker build -t obsidian-level-maker .
```

Generate a WAD with default settings:

```bash
docker run --rm -v ./output:/wads obsidian-level-maker
```

The generated level file will appear in the `./output` directory.

### Custom Output Filename

```bash
docker run --rm -v ./output:/wads obsidian-level-maker \
  --batch /wads/my-level.wad
```

### Verbose Output

```bash
docker run --rm -v ./output:/wads obsidian-level-maker \
  --batch /wads/my-level.wad --verbose
```

### Randomize All Settings

```bash
docker run --rm -v ./output:/wads obsidian-level-maker \
  --batch /wads/random.wad --randomize-all
```

### Using a Configuration File

Mount a directory containing a `CONFIG.txt` to `/config` and the container will pick it up automatically:

```bash
docker run --rm -v ./output:/wads -v ./my-config:/config:ro \
  obsidian-level-maker --batch /wads/custom.wad
```

Any `CONFIG.txt` or `OPTIONS.txt` placed in the mounted `/config` directory will be used. See [Configuration Files](#configuration-files) below for how to create and export a config.

### Helpful Commands

```bash
# Show all CLI options
docker run --rm obsidian-level-maker help

# Print configuration reference (all keys and values)
docker run --rm obsidian-level-maker printref

# Print configuration reference as JSON
docker run --rm obsidian-level-maker printref-json
```

### Docker Compose

A `docker-compose.yml` is included for convenience:

```bash
docker compose run --rm obsidian
```

## CONFIGURATION FILES

OBSIDIAN uses a plain-text `CONFIG.txt` file to store all level generation settings. The same file format is used by both the GUI and the CLI, so you can configure levels visually on your desktop and then use that config to generate levels headlessly in Docker or on a server.

### Exporting a Config from the GUI

1. Run OBSIDIAN on your desktop and adjust settings to your liking (game, engine, theme, architecture, combat, modules, etc.).
2. The GUI automatically saves your settings to `CONFIG.txt` in your home directory:
   - **Windows:** The OBSIDIAN install directory
   - **Linux:** `~/.local/share/Obsidian/CONFIG.txt`
   - **macOS:** `~/Library/Application Support/Obsidian/CONFIG.txt`
3. Copy that file to use with the CLI or Docker.

The GUI also has a **Config Manager** window (accessible from the menu) with dedicated Save, Load, Copy, and Paste buttons for working with config files. You can also extract a config from a previously generated WAD or PK3 file, since OBSIDIAN embeds the config used to create it.

### Config File Format

`CONFIG.txt` is a key-value text file. Lines starting with `--` are comments. The main sections are:

```
---- Game Settings ----
engine = idtech_1
game = doom2
port = zdoom
length = game
theme = original

---- Architecture ----
float_size = 36
outdoors = mixed
caves = mixed
liquids = mixed
hallways = mixed
steepness = mixed

---- Combat ----
float_mons = 1
float_strength = 1
bosses = medium
traps = mixed
cages = mixed

---- Pickups ----
health = normal
ammo = normal
weapons = normal

---- Other Modules ----
@compress_output = 1

@sky_generator = 1
  force_sky = sky_default

@music_swapper = 1
```

Module sections use `@module_name = 0|1` to enable or disable a module, with indented lines for that module's options.

### Using the Config with Docker

Once you have a `CONFIG.txt`, place it in a directory and mount it:

```bash
mkdir -p my-config
cp /path/to/CONFIG.txt my-config/

docker run --rm -v ./output:/wads -v ./my-config:/config:ro \
  obsidian-level-maker --batch /wads/my-level.wad
```

### Discovering All Available Settings

To see every tunable parameter with its valid values and defaults:

```bash
# Human-readable reference
docker run --rm obsidian-level-maker printref

# Machine-readable JSON reference
docker run --rm obsidian-level-maker printref-json
```

### Modifying Settings from the Command Line

You can update individual keys in a config file without the GUI using the `--update` flag:

```bash
# Set game to Doom 1
docker run --rm -v ./my-config:/home/obsidian \
  obsidian-level-maker --update c game doom1

# Set monster quantity
docker run --rm -v ./my-config:/home/obsidian \
  obsidian-level-maker --update c float_mons 1.5
```

The `--update` flag takes three arguments: section (`c` for config, `o` for options), key, and value. It writes the change to disk and exits.

## About This Repository

This is a community continuation of the OBLIGE Level Maker, originally created by Andrew Apted.

A brief summary of changes:

Improved internationalization support, including fixes for accented characters in Windows filepaths and an updated translation template

Russian translation file provided for the RU locale

GUI Customization and Theming added

Modified SLUMP level builder included for Vanilla Doom usage.

ZDBSP as the internal nodebuilder, replacing GLBSP.

UDMF map output for compatible engines.

64-bit seeds and random numbers.

Migrated from Lua to LuaJIT for improved build speeds.

Patch by Simon-v for searching for .pk3 addons in both the install and user's home directories (https://github.com/dashodanger/Oblige/pull/1)

Strings allowed for seed input (numbers with no other characters still processed as numbers).

New random number generator based on the xoshiro256 algorithm from fastPRNG (https://github.com/BrutPitt/fastPRNG).

Bugfixes as discovered.
