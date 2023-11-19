----------------------------------------------------------------
--  MODULE: ZDoom Story Tables
----------------------------------------------------------------
--
--  Copyright (C) 2022 MsrSgtShooterPerson
--  Copyright (C) 2022 Reisal
--  Copyright (C) 2022 Tapwave
--  Copyright (C) 2022 Simon-v
--  Copyright (C) 2022 EpicTyphlosion
--  Copyright (C) 2022 Beed28
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
-------------------------------------------------------------------

--[[

  _RAND_ENTITY = name of a computer or AI from the table below
Some keywords for parsing later on:

  _SPACE = creates a linebreak

  _RAND_ENEMY = name of a demonic entity
               (based on the GOTHIC entity names table)

  _RAND_ENGLISH_PLACE = name fetched directly from the Anglican
                        noun generator.

  _EVULZ = a rank title for a demonic entity based
           on the evil titles table below.

  _INSTALLATION = a facility corrupted by Hell's forces

  _RAND_CONTRIBUTOR = name of a random contributor
                      (actually based on the specific
                      contributors table under TITLE)

  _RAND_GAL
  _RAND_GUY
  _RAND_HUMAN = names for a mere mortals (there is no human name generator
               yet as of 2019-04-09)

  _GOTHIC_LEVEL = name from the gothic level generator

  _MCGUFFIN = returns a name of a plot McGuffin from the McGuffins
                   table below.

Notes and Tips:

* Hooks are the 'pull' of the story as per D&D terminology, a method
  of getting the characters' attention towards something. When writing
  hooks, make it as universal as possible i.e. the situation can start
  at any point of play.

* Conclusions are the resulting effect after a hook has been engaged.
  Conclusions can vary from positive, to negative, or even weird results.
  Be creative!

* For each story chunk under the STORIES table, there can be any number
  of hooks and conclusion per story.

* Hooks are placed at any point before the end of the episode
  but preferably at least in the first few maps of that episode.
  Conclusions are strictly placed at the end of each episode so
  it meshes with the climax of a boss battle or procedural gotcha.

* Don't make the stories too long! Remember, they have to fit the intermission
  screen. You can make it long enough to fill the whole screen and the
  Story Generator formatting code will try to fit the lines within
  the intermission screen as best as possible.

* Addendum: Also try to avoid extremely long words. The parser expects that
  lines will be 35 characters long to fit the constraints of the engine.
  Amount of lines is also limited.

* Doomguy doesn't care about story. But we do, we can just keep saying
  things about things he ends up doing, so be creative.

* If you are using np++, hit ALT+4 (not ALT+F4!!!) to collapse groups
  down to the story chunk pieces. This will make it easier to navigate.
]]

HACX.STORIES = { }

HACX.STORIES.LIST =
{
  -- common stories
  basic_story = 40,

  -- rare stories
  knock_knock_joke = 2,
  oblige_history = 2,
  nothing_here = 3,
  lorem_ipsum = 3,
  bootup_screen = 5,
}

HACX.STORIES.TEXT =
{
  basic_story =
  {
    level_theme = "URBAN",
    enemy_theme = "URBAN",

    hooks =
    {
      [[You arrive at _LEVEL in search of _RAND_ENEMY.]],
    },

    conclusions =
    {
      [[You killed _RAND_ENEMY! Good job! Now please help contribute
      more stories for this game so you don't have to keep reading this!]],
    },
  },

  -- Summarized OBLIGE history
  oblige_history =
  {
    hooks = {
      [[Once upon a time a man named Andrew Apted with a knack for
      programming developed a basic map generator in 2005, but it
      was crude and written only in C++. It is 2007 now and V2,
      of OBLIGE was released to the public with positive response
      from the Doom community.
      _SPACE
      V3 proved to be a big step over V2 in 2009, with a huge
      rewrite of the design, plus many new features over the
      previous version.]]
    },

    conclusions = {
      [[V4 and V5 have proven to be unwieldy and experimental
      designs in 2012 and 2013, prompting V6 which was combined
      the best parts of V3, V4 and V5 in 2015. 2016 soon comes
      and V7 arrives, boasting shape grammars and finally using
      prefabs from WAD files, opening up near infinite customization.
      _SPACE
      We thank you for this program, Andrew! ]]
    },
  },

  knock_knock_joke =
  {
    level_theme = "URBAN",
    enemy_theme = "URBAN",

    hooks = {
      [[Knock knock. Who's there?]],

      [[Wanna hear a joke?
      _SPACE
      Knock knock. Who's there?]],
    },

    conclusions = {
      [[ME! ME! ME! ME! ME! ME! HAHAHAHAHAAA!]],

      [[It's me, motherfuckers! lolololol ]],

      [[It's _RAND_CONTRIBUTOR! Hello! ]] ,

      [[It's _RAND_ENEMY! Oh noes! ]],

      [[It's...._LEVEL?? How the fuck is this possible? ]],

      [[Nobody's here, bitch. Move along.]],

      [[Just the wind, nothing's here.]],
    },
  },

  -- DOS bootup screen
  bootup_screen = {
    hooks = {
      [[
      P_Init: Checking cmd-line parameters...
      V_Init: Allocate screens.
      M_LoadDefaults: Load system defaults.
      Z_Init: Init zone memory allocation daemon.
      DPMI memory: 0xdb2000, 0x800000 allocated for zone
      W_Init: Init WADfiles.
      adding hacx.wad
      freeware version.
      M_Init: Init miscellaneous info.
      R_Init: Init HACX refresh daemon [........................] ]],
    },

    -- Error messages
    conclusions = {
      [[
        P_AddActivePlats: no more plats!
        Z_Malloc: failed on allocation of %i bytes
        R_FindPlane: no more visplanes
        R_FlatNumForName: %s not found
        W_CacheLumpNum: %i>= numlumps
        Savegame buffer overrun
        R_TextureNumForName: %s not found
        Killed by network driver
        P_SpecialThing: Unknown gettable thing
      ]],
     },
  },

  nothing_here = {
    hooks = {
      [[There is nothing here.
      _SPACE
      ...or is there?]],
    },

    conclusions = {
      [[I told you there's nothing here!
      _SPACE
      ...well, maybe just Andrew Apted's ghost.
      _SPACE
      lol]],
    },
  },

  -- Some information in conclusion is from https://generator.lorem-ipsum.info/_latin
  lorem_ipsum = {
    hooks = {
      [[Lorem ipsum dolor sit amet, commodo feugiat mei at, mollis lobortis eu eos.
      Eos quidam minimum constituam in, malis recusabo ad pri. Ut mei consul dolorum
      quaerendum. Eu quo luptatum theophrastus. Duo ut animal laoreet recusabo.
      _SPACE
      Voluptaria vituperata ne eos, cu cum stet dicit noster, ut saepe nemore consequuntur
      per. Te quo putant diceret vocibus, usu ex enim maluisset, quo ex aeterno sensibus
      efficiendi. Ut postea doming molestiae nam, mutat eripuit cum ea. Soleat tractatos
      disputationi no sed. Solum graecis nam in, soleat accusamus eu usu. Tota nostrud
      reprehendunt ad duo.]],
    },

    conclusions = {
      [[Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and
      printing a place of English to emphasise design elements over content. It's also
      called placeholder (or filler) text. It's a convenient tool for mock-ups. It
      helps to outline the visual elements of a document, presentation and such.
      _SPACE
      Lorem ipsum is mostly a part of Latin text by the classical author and
      philospher Cicero. It's words and letters have been changed by addition
      or removal, so to deliberately render its content nonsensical.]],
    },
  }
}

HACX.STORIES.EVIL_TITLES =
{
  -- as in titles for individuals i.e. Snowball the TERRIBLE.
  Abberant=5,
  Abhorrent=5,
  Abominable=5,
  Accursed=5,
  Acolyte=5,
  Adulator=5,
  Advisor=5,
  Aetherwalker=5,
  Aggressor=5,
  Agitator=5,
  Amputator=5,
  Anathema=5,
  Ancient=5,
  Annihilator=5,
  Antichrist=5,
  Aphotic=5,
  Argent=5,
  Armorer=5,
  Arrant=5,
  Ashen=5,
  Atrocious=5,
  Auger=5,
  Avaricious=5,
  Avulsor=5, -- See definition: "Avulsion",
  Axe=5,
  Baleful=5,
  Bandit=5,
  Banished=5, --
  Banisher=5, -- Don't ever let these two guys in a room
  Bannerlord=5,
  Barbarous=5,
  Beast=5,
  Beheader=5,
  Belligerent=5,
  Berserker=5,
  Betrayer=5,
  Bitter=5,
  Black=5,
  Blackguard=5,
  Blackheart=5,
  Blasphemer=5,
  Blinder=5,
  Blister=5,
  Bonesaw=5,
  Brander=5,
  Breaker=5,
  Brutal=5,
  Brute=5,
  Burned=5,
  Butcher=5,
  Caged=5,
  Calamity=5,
  Caliginous=5,
  Cannibal=5,
  Caster=5,
  Cenobite=5,
  Chained=5,
  Channeler=5,
  Charred=5,
  Chatterer=5,
  Claw=5,
  Clayborn=5,
  Cleromancer=5,
  Coldblooded=5,
  Condemned=5,
  Conjurer=5,
  Contagion=5,
  Corpulent=5,
  Corrosive=5,
  Corrupted=5,
  Corruptor=5,
  Count=5,
  Craven=5,
  Crowned=5,
  Crucifier=5,
  Cruel=5,
  Cursed=5,
  Curseweaver=5,
  Cybermind=5,
  Damned=5,
  Deathblade=5,
  Deathbringer=5,
  Deathly=5,
  Debaucher=5,
  Decaying=5,
  Deceiver=5,
  Defiler=5,
  Dementor=5,
  Demonhost=5,
  Depraved=5,
  Desanticified=5,
  Descendent=5,
  Despicable=5,
  Despoiler=5,
  Destructive=5,
  Devastator=5,
  Deviant=5,
  Devourer=5,
  Dire=5,
  Diseased=5,
  Disemboweler=5,
  Disgraced=5,
  Dishonored=5,
  Dismal=5,
  Dissolute=5,
  Distasteful=5,
  Dominator=5,
  Doombringer=5,
  Doomhunter=5,
  Dragon=5,
  Dragonhand=5,
  Dragonsoul=5,
  Dreadful=5,
  Earthshatterer=5,
  Elder=5,
  Eldritch=5,
  Empyrean=5,
  Enslaver=5,
  Eternal=5,
  Eternal=5,
  Evocator=5,
  Exanguinator=5,
  Execrable=5,
  Execrator=5,
  Executioner=5,
  Exemplar=5,
  Exile=5,
  Faceless=5,
  Faceripper=5,
  Faithless=5,
  Fallen=5,
  Fanatic=5,
  Feral=5,
  Fiend=5,
  Firebringer=5,
  Firestoker=5,
  Firewalker=5,
  Foul=5,
  Gatekeeper=5,
  Ghastly=5,
  Ghoulish=5,
  Gladiator=5,
  Glutton=5,
  Gorger=5,
  Graceless=5,
  Great=5,
  Greater=5,
  Grim=5,
  Grinder=5,
  Guardian=5,
  Hacker=5,
  Harbinger=5,
  Harvester=5,
  Hateful=5,
  Hedonist=5,
  Heinous=5,
  Hellborn=5,
  Hellbound=5,
  Hellforger=5,
  Hellhawk=5,
  Hellhound=5,
  Hellraiser=5,
  Hellspawn=5,
  Hexagramist=5,
  Hierophant=5,
  Hiveback=5,
  Honorless=5,
  Hornhead=5,
  Horrible=5,
  Howler=5,
  Humiliator=5,
  Hungering=5,
  Hunter=5,
  Iconoclast=5,
  Illusionist=5,
  Immovable=5,
  Impaler=5,
  Impious=5,
  Incontinent=5,
  Inculpator=5,
  Inexorable=5,
  Infectious=5,
  Infernal=5,
  Inquisitor=5,
  Insatiable=5,
  Insidious=5,
  Insipid=5,
  Insufferable=5, -- like a Karen in a supermarket
  Interrogator=5,
  Invader=5,
  Invocator=5,
  Ironjaw=5,
  Jailer=5,
  Jaw=5,
  Judge=5,
  Judicator=5,
  Keymaster=5,
  Kinslayer=5,
  Knifehand=5,
  Lacerator=5,
  Lasher=5,
  Lawbreaker=5,
  Legend=5,
  Lesser=5,
  Loathsome=5,
  Locust=5,
  Longtooth=5,
  Lurker=5,
  Machine=5,
  Mad=5,
  Maggot=5,
  Magi=5,
  Magmawalker=5,
  Malefactor=5,
  Malevolent=5,
  Malicious=5,
  Malificent=5,
  Malign=5,
  Malignant=5,
  Manhunter=5,
  Manslayer=5,
  Marauder=5,
  Mastermind=5,
  Merciless=5,
  Mesmer=5,
  Metalhead=5,
  Miasmic=5,
  Mindsplitter=5,
  Minion=5,
  Miscreated=5,
  Morningstar=5,
  Mountain=5, -- like Clegane the Mountain
  Mutilator=5,
  Necromancer=5,
  Necrotic=5,
  Nefarious=5,
  Nemesis=5,
  Nightbringer=5,
  Noxious=5,
  Oathbreaker=5,
  Oathless=5,
  Obscene=5,
  One=5,
  Oracle=5,
  Outcast=5,
  Overlord=5,
  Overpowerer=5,
  Overseer=5,
  Panderer=5,
  Perceptive=5,
  Perfidious=5,
  Perilous=5,
  Perjurer=5,
  Persecutor=5,
  Perverse=5,
  Pervert=5,
  Pestilent=5,
  Pillager=5,
  Plagued=5,
  Planeswalker=5,
  Plunderer=5,
  Poisoner=5,
  Preceptor=5,
  Primal=5,
  Prisoner=5,
  Profane=5,
  Provoker=5,
  Prowler=5,
  Psycho=5,
  Putrid=5,
  Ragemind=5,
  Raider=5,
  Rancorous=5,
  Rash=5,
  Ravager=5,
  Ravenous=5,
  Raver=5,
  Reaper=5,
  Reaver=5,
  Recreant=5,
  Rectifier=5,
  Red=5,
  Regent=5,
  Relentless=5,
  Remnant=5,
  Reprobate=5,
  Repugnant=5,
  Repulsive=5,
  Resented=5,
  Revelator=5,
  Revenger=5,
  Riftweaver=5;
  Ripper=5,
  Rook=5,
  Rotted=5,
  Rotten=5,
  Ruiner=5,
  Ruinous=5,
  Runecaster=5,
  Ruthless=5,
  Savage=5,
  Scarface=5,
  Schemer=5,
  Scout=5,
  Screamer=5,
  Scythe=5,
  Seeker=5,
  Seer=5,
  Senechal=5,
  Serpent=5,
  Shade=5,
  Shadow=5,
  Shameless=5,
  Sinister=5,
  Sinner=5,
  Skinflayer=5,
  Skull=5,
  Skullcrusher=5,
  Skullface=5,
  Slasher=5,
  Slaughterer=5,
  Slave=5,
  Slavemaster=5,
  Slayer=5,
  Sneak=5,
  Sorcerer=5,
  Souldrinker=5,
  Soultaker=5,
  Spike=5,
  Spiteful=5,
  Squalid=5,
  Stalker=5,
  Stoneskin=5,
  Stygian=5,
  Subversive=5,
  Sullied=5,
  Sunderer=5,
  Surgeon=5,
  Tainted=5,
  Taskmater=5,
  Tempest=5,
  Terrible=5,
  Terror=5,
  Thaumaturgist=5,
  Therianthropist=5,
  Theurgist=5,
  Thirsty=5,
  Thirteenth=5, --unluckiest guy in the world
  Thrall=5,
  Thunderhead=5,
  Tormentor=5,
  Torturer=5,
  Tower=5,
  Toxic=5,
  Trafficker=5,
  Trapper=5,
  Trickster=5,
  Triumphant=5,
  Tusk=5,
  Twilight=5,
  Twin=5,
  Typhonian=5,
  Tyrant=5,
  Unblessed=5;
  Undying=5,
  Unholy=5,
  Unrepentant=5,
  Unsanctified=5,
  Unveiled=5,
  Usurer=5,
  Usurper=5,
  Vengeful=5,
  Venom=5,
  Vicious=5,
  Vile=5,
  Virulent=5,
  Vitriolic=5,
  Vivisector=5,
  Voidbringer=5,
  Wall=5,
  Ward=5,
  Warden=5,
  Warlord=5,
  Warmonger=5,
  Watcher=5,
  Wicked=5,
  Wight=5,
  Wild=5,
  Wildling=5,
  Wraith=5,
  Wrath=5,
  Wretched=5,
  Zealot=5,
  Zealous=5,
  ["Armor of Satan"]=5,
  ["Armourer of Hell"]=5,
  ["Ascended of Hell"]=5,
  ["Astral Guardian"]=5,
  ["Bane of Life"]=5,
  ["Bane of Mortals"]=5,
  ["Bane of Nations"]=5,
  ["Baneful Vanguard"]=5,
  ["Bearer of Anguish"]=5,
  ["Black Grace"]=5,
  ["Black Sun"]=5,
  ["Blood Cleric"]=5,
  ["Blood Magician"]=5,
  ["Bone Breaker"]=5,
  ["Bone Collector"]=5,
  ["Bone Scraper"]=5,
  ["Bringer of Despair"]=5,
  ["Bringer of Doom"]=5,
  ["Bulwark of Cain"]=5,
  ["Candle Demon"]=5, --someone's gotta do it
  ["Cast of the Deluge"]=5,
  ["Champion of Hell"]=5,
  ["Chant of Death"]=5,
  ["Chosen of Death"]=5,
  ["Clawhammer"]=5, -- Silent Hill reference
  ["Conqueror of the Planes"]=5,
  ["Corpse-eater"]=5,
  ["Corpse-grinder"]=5,
  ["Dark Sacrifice"]=5,
  ["Dark Soul"]=5, --yes
  ["Dark Templar"]=5,
  ["Dark Wanderer"]=5,
  ["Demon Tamer"]=5,
  ["Descendant of Cerberon"]=5, --it's a reference to the Quake ][ song, not Cerberus
  ["Destroyer of Worlds"]=5,
  ["Devil Worshipper"]=5,
  ["Devil's Advocate"]=5,
  ["Dictator of Edicts"]=5,
  ["Dooting Skeletal"]=5,
  ["Dungeon Keeper"]=5,
  ["Dungeon Master"]=5,
  ["Eater of Souls"]=5,
  ["Ebony Centurion"]=5,
  ["Fallen Angel"]=5,
  ["Fallen Apostle"]=5,
  ["Fallen Saint"]=5,
  ["False Witness"]=5,
  ["Father of the Coven"]=5,
  ["First Sinner"]=5,
  ["Flesh-render"]=5,
  ["Folly of Man"]=5,
  ["Foul-spawn"]=5,
  ["Gift of Pandora"]=5,
  ["Gilded Claw"]=5,
  ["Grand Vizier"]=5,
  ["Gremlin Keeper"]=5,
  ["Hand of Darkness"]=5,
  ["Harvester of Souls"]=5,
  ["Head-Chopper"]=5,
  ["Herald of Winter"]=5,
  ["Ill-whisperer"]=5,
  ["Infector of Souls"]=5,
  ["Inflictor of Pain"]=5,
  ["Keeper of Shadows"]=5,
  ["King of Skulls"]=5,
  ["Lament Configurator"]=5,
  ["Legionnaire of Bones"]=5,
  ["Lich-king"]=5,
  ["Lie Weaver"]=5,
  ["Life-drinker"]=5,
  ["Living Siege Engine"]=5, --see "Siegebreaker Assault Beast",
  ["Lost Sinner"]=5, -- Dark Souls
  ["Lost Templar"]=5,
  ["Mad-eye"]=5,
  ["Man-catcher"]=5,
  ["Man-eater"]=5,
  ["Mark of Cain"]=5,
  ["Marquis of Snakes"]=5, -- my fiancee and I watched Conjuring lol
  ["Master of Crows"]=5,
  ["Master of Discord"]=5,
  ["Maw of Hell"]=5,
  ["Messenger of Omens"]=5,
  ["Mind Number"]=5,
  ["Monk of Depravity"]=5,
  ["Night's Reaper"]=5,
  ["Old Guard"]=5,
  ["Old One"]=5,
  ["Original Sin"]=5,
  ["Perpetual Night"]=5,
  ["Pit Fiend"]=5,
  ["Preacher of Flames"]=5,
  ["Prince of Darkness"]=5,
  ["Raid Leader"]=5,
  ["Saint of Blades"]=5,
  ["Scarlet Death"]=5,
  ["Scourge of Hell"]=5,
  ["Second Sinner"]=5,
  ["Shadow-Blade"]=5,
  ["Shield of the Beast"]=5,
  ["Siegebreaker Assault Beast"]=5, --from Diablo 3 and that I believe this is a stupid name
  ["Sigil of Midnight"]=5,
  ["Sinful Appeaser"]=5,
  ["Siren of War"]=5,
  ["Spear of the Infernals"]=5,
  ["Spine-ripper"]=5,
  ["Storm-bringer"]=5,
  ["Sun-blotter"]=5,
  ["Sword of the Underdark"]=5,
  ["Throne Defender"]=5,
  ["Twister of Souls"]=5,
  ["Vizier of Chaos"]=5,
  ["Whore of Babylon"]=5,
  ["Woe to Man"]=5,
  ["World Ender"]=5,
}

HACX.STORIES.MCGUFFINS =
{
  -- McGuffins. Quintessential items in a story
  -- that characters work for or against, but
  -- the object's actual significance is almost always unclear
  hellish =
  {
    ["an obsidian orb containing hellfire"]=5,
    ["an icon of miscreation"]=5,
    ["a desecrated totem"]=5,
    ["an adamantium skull"]=5,
    ["a baleful gem"]=5,
    ["a bloody hand"]=5,
    ["a cursed talisman"]=5,
    ["a dark crystal shard"]=5,
    ["a devil's horn"]=5,
    ["a skeletal torso"]=5,
    ["an unholy chalice"]=5,
    ["an ornate dagger"]=5,
    ["the Spear of Destiny"]=5, --because why not lol
    ["the Sword of Darkness"]=5,
    ["the Khronos Device"]=5,
    ["the Soul-x Agitator"]=5,
    ["a blood imprinter"]=5,
    ["a brass bauble"]=5,
    ["a vial of ectoplasm"]=5,
    ["the Mark of Kain"]=5,
    ["a bloody, tarnished Bible"]=5,
    ["the Necronomicon"]=5,
    ["a sinister looking ring"]=5,
    ["a small, sigil inscripted bust"]=5,
    ["a crude, Doomguyesque figure"]=5,
    ["an inscripted bust of Razorfist"]=5, --LMFAO
  },
  tech =
  {
    ["a tectonic transducer"]=5,
    ["a flux capacitor"]=5,
    ["a security matrix"]=5,
    ["a network card"]=5,
    ["an energy diode"]=5,
    ["various BFG components"]=5,
    ["a positron relay"]=5,
    ["a plasma inductor"]=5,
    ["a plasma relay"]=5,
    ["a quantum cipher"]=5,
    ["a dielectric coil"]=5,
    ["a disc reader"]=5,
    ["a card reader"]=5,
    ["a base station uplink"]=5,
    ["a flash drive"]=5,
    ["a hard token authenticator"]=5,
    ["a baseband modulator"]=5,
    ["a gravitronic amplifier"]=5,
    ["a quantum disrupter"]=5,
    ["a MAPINFO lump"]=5, -- getting meta here, huh?
    ["a coop server"]=5,
    ["a gray keycard"]=5,
    ["a hot-swap hard drive"]=5,
  },
}

HACX.STORIES.ENTITIES =
{
  tech =
  {
    ["GENESIS-9"]=5,
    ["LUMOS-1"]=5,
    SYNAPSE=5,
    ["CLOUD-10"]=5,
    ENIGMA=5,
    OMNI=5,
    ["AURA-3"]=5,
    SAINT=5,
    ["HELIX-11"]=5,
    APEX=5,
    PHOENIX=5,
    ["GUARDIAN-7"]=5,
    ["AURORA-1"]=5,
    ["ANGEL-76"]=5,
    CERBERUS=5,
    ["WITNESS-5"]=5,
    ["ANIMUS-2"]=5,
    ["KNIGHT-101"]=5,
    ["GHOST-2"]=5,
    ["WATCHER-34"]=5,
    ATOM=5,
    AETHER=5,
    ["WRATH-15"]=5,
    ["PARAGON-1"]=5,
    VOID=5,
    ["TERMINUS-9"]=5,
    TEMPEST=5,
    LUCID=5,
    ["EPOCH-21"]=5,
    SPECTER=5,
    ["PEGASUS-6"]=5,
    ["IMPULSE-3"]=5,
    OPTIX=5,
    ECHO=5,
    DELTA=5,
    OMEGA=5,
    ALPHA=5,
    GEO=5,
    ["FALCON-1"]=5,
    AEGIS=5,
    LYNX=5,
    ACHERON=5,
    ENOS=5,
    SIGIL=5,
    ["EAGLE-7"]=5,
    ["SPARROW-2"]=5,
    ONYX=5,
    NIMBUS=5,
    ASPECT=5,
    TERRA=5,
    FLUX=5,
    VALOR=5,
    ["VIRTUE-10"]=5,
    ["ODYSSEY-616"]=5,
    VERTEX=5,
    PROSPECT=5,
    ARIES=5,
    ["SPHINX-88"]=5,
    NEBULA=5,
    ["ZENITH-1X"]=5,
    ["FATHER-79"]=5, -- Antonym of ship AI in movie Alien in 1979, which was named "Mother". Homage!
    HEXUS=5,
    VEGA=5, -- Doom 2016,
    ICARUS=5, -- Deus Ex
    DAEDALUS=5, -- Deus Ex
    MORPHEUS=5, -- Deus Ex
    HELIOS=5, -- Deus Ex
    ["HAL-9000"]=5, -- 2001: A Space Oddyssey
    FROST=5, -- For a Breath I Tarry
    SOLCOM=5, -- For a Breath I Tarry
    DIVCOM=5, -- For a Breath I Tarry
    CEREBRO=5, -- X-Men
    COLOSSUS=5,
    ZERO=5,
    OMICRON=5,
    LAMBDA=5,
    TAU=5,
    UPSILON=5,
    THETA=5,
    IOTA=5,
  },
}

HACX.STORIES.INSTALLATIONS =
{
  ["administrative center"] = 5,
  ["arachnotron factory"] = 5,
  barracks = 5,
  ["command control"] = 5,
  ["communications center"] = 5,
  ["experimental weapons center"] = 5,
  ["foundry"] = 5, -- Doom 2016,
  ["high security laboratory"] = 5,
  hydroponics = 5, -- System Shock 2,
  ["power plant"] = 5,
  ["research laboratory"] = 5,
  ["testing facility"] = 5,
  ["waste processing plant"] = 5,
  ["weapons storage facility"] = 5,
  nest = 5,
}

HACX.STORIES.QUIT_MESSAGES =
{
  [[Let's be serious, are you really exiting already?]],
  [[There's always more where this comes from! Obsidian never forgets!]],
  [[You may be leaving but Hell's legions will never rest. You'll be back.]],
  [[Maybe you should hit Escape before I put this shotgun barrel where the sun don't shine.]],
  [[Just leave. This is just more monsters and levels here. What a heap of shit.]], --Loosely based off "Extra" quit message
  [[Don't quit just yet, we're just wasting your time with this quit message!]],
  [[THIS IS A MESSAGE! Not intentionally left blank.]],
  [[Are you kidding me? Get the fuck out already.]],
  [[Come on already, there's plenty more to do in this generated mapset!]],
  [[The Randomly Generated Beast will come back for more, namely you.]],
  [[Bricks, Tech Bases, Hellfire, we have it all!]],
  [[Why would you ever want to exit out of here?]],
  [[In a perfect world.. Oh wait, no there is no perfect world with sunshine and unicorn farts.]],
  [[Subscribe to... no, I am not going to do that here too.]],
  [[Obsidian is love, Obsidian is life.]],
  [[Are you sure you want to exit out of the game?]],
  [[Press Y to burn bridges, press N to maintain relations.]],
  [[When you return, a gang of Imps and Barons are going to take turns on your ass.]],
  [[Do you really wish to leave the world at the mercy of Hellspawn?]],
  [[Catch me if you can, I'm the quit message man!]], -- Gingerbread Man reference
  [[So, is this a joke? Are you staying or leaving?]],
  [[Oh, is that all? I guess I'll just throw more monsters at you when you return.]],
  [[The Icon of Sin will always be your source of misery.]],
  [[Hold up, are you just going to leave like this?]],
  [[We're still going to be here, just go. It may not be as nice when you come back.]],
  [[There's a special place in Hell for those that quit too soon.]],
  [[_RAND_CONTRIBUTOR and _RAND_ENEMY the _EVULZ thought that you'd be just as weak as anticipated to quit so soon.]],
  [[That's too bad, perhaps _RAND_ENEMY the _EVULZ should make you their bitch for considering quitting?]],
  [[_RAND_CONTRIBUTOR is disappointed in you. Hit N now or face retribution.]],
  [[He who is not bold enough to be stared at from across the abyss is not bold enough to stare into it himself.]], -- Silent Hill 2,
  [[Maybe you should be dumped off in _LEVEL, see how you fare.]],
  [[In the end, there is only death, chaos and more death. And cookies.]],
  [[Remember, a good demon is a dead one. Make that happen!]],
  [[Heroes, press N. Wimps, press Y.]], -- Wolfenstein 3D
  [[Go ahead, leave. Obsidian will be back with even more demons...]],
  [[_RAND_CONTRIBUTOR is not pleased.]],
  [[There's a lot of bullshit going on these days. Don't just add to the pile and quit like this.]],
  [[Meh, is that it? Am I supposed to appease you with something?]],
  [[There just isn't anything to keep you from hitting Y, is there?]],
  [[Obsidian demands the purging of more demons!]],
  [[The will to survive is as long as you do not quit out of the game.]],
  [[_RAND_ENEMY needs another hobby than to torture your dumb ass from quitting.]],
  [[Hey dipshit, we're not done hunting hellspawn! Turn your attention back to the game!]],
  [[Is this really what it has come to?]],
  [[That's right, abandon your fellow marines in a time of need...]],
  [[RAND_CONTRIBUTOR has decided you are unworthy of your skills here.]],
  [[Is that the way it's gonna be? Fine, now piss off.]],
  [[We don't have time for this quitting nonsense.]],
  [[I should have known better. There are better and more capable players that don't quit early..]],
  [[Ego bruised from losing? Too bad.]],
  [[There's too much bullshit and we don't need you to add to it.]],
  [[Go sit on a shotgun barrel and pull the trigger.]],
  [[By the time you read this message, you already lost.]],
  [[We insist you stay and play just a little bit longer.]],
  [[Quitters are not winners.]],
  [[If you don't love yourself, how the hell you gonna love somebody else?]],
  [[Chads press N, Virgins press Y.]],


  -- hardcore philosophy
  [[Are you quitting because you realized no matter how much hellspawn you mow down, Obsidian will just give you more?]],
  [[_RAND_CONTRIBUTOR wants to know you're quitting from an Obsidian map. :( Unless you just finished it all. :D]],
  [[The price of freedom is eternal vigilance. The price of Obsidian is eternal demonic invasions. And you're giving up?]],
  [[You wouldn't download a car, but you would quit a demonic invasion?]],
  [[Never gonna give you up, never gonna let you down, never gonna run and leave you without a fresh new megawad.]],
  [[At least when the demons slaughter anyone, it's regardless of gender, race, or creed.]],
  [[You can win Obsidian, you just have to defeat a 64-bit permutation of maps and each variation per seed by changed setting to do so.]],
  [[You want demons? We can give you more demons than there are stars in the observable universe.]],
  [[Don't worry about infinite hellspawn. Do what you love, and you'll never work a day in your life.]], -- I'm actually crediting this to HexaDoken
  [[A dimensional shambler is, indeed, waiting in your operating system. It was Obsidian all along.]],
  [[My map generator brings all the linedefs to the yard.]],
  [["You shouldn't stop playing HacX." definitely said by Voltaire.]],
  [[Are you taking the blue pill?]],
  [[The prophet Nostradamus predicted the dead would rise when there is no more room in hell. He didn't predict Obsidian would be generating new rooms.]],
  [[You probably noticed by now that every time quit messages show up, you're forced to agree with the statement when you quit by choosing 'yes'.]],
  [[Thanos needs two fingers to erase half the universe. Obsidian builds a whole with only one.]],
  [[Oblige is the machine. Obsidian is the ghost in the machine.]], -- credits to FrozSoul!
  [[Obsidian can generate more maps than you will ever speak words in your whole life.]],
  [[Poor you. Demons don't have a housing crisis. Obsidian provides free real estate for all of them.]],
  [[Karma's a bitch. Then you die. -Tina Belcher]],

  -- helpful // technical
  [[Obsidian is always improving. Stop by our Discord server, talk to the denizens and report bugs to us there!]],
  [[Visit https://github.com/GTD-Carthage/Obsidian-Content for updates!]],
  [[If you're quitting because something might be broken, please supply screenshots and preferably your LOG file when reporting.]],
  [[Obsidian is for the adventurous. Are you? Join us and contribute ideas and works! Obsidian is a community project!]],
  [[Was this not big enough? Try jacking up the Max Level Size or Upper Bound in settings to Colossal, Gargantuan or Transcendent.]],
  [[Map sizes too big? Reduce the Map Size or Upper Bound size if using Mix It Up.]],
  [[Gargantuan or Transcendent maps looking like Minecraft Far Lands? Please keep Auto Detail on if you're using binary format, otherwise use UDMF format which allows unlimited detail.]],
  [[Too hard? Turn down Quantity and/or Strength. Same applies to too easy: Turn Quantity up.]],

  -- important facts
  [[By exiting, you are agreeing to subscribe to Cat Facts.]],
  [[Sewerage is important but HVAC systems is importanter.]],
  [[In 1998, the Undertaker threw Mankind off Hell in a Cell and plummeted 16ft. through an announcer's table.]],
  [[Obsidian enhances your problem-solving skills! Contribute now!]],
  [[Set the Y offset, again of both front and back side, to the negative of the subtraction of the ceiling height of the sector the pit and the floor height of the planes, or y-offset = -(pitceilingheight-planefloorheight). So, the ceiling height is 256 in both platforms and the pit and the platform's floor height is 0, so the sidedefs' Y-offsets must be -(256-0) = -256.]],
  [[Cacos are red, their insides are blue. They wish to make a meal out of you.]],
  [[Having a boyfriend or girlfriend is important, but killings demons is importanter.]], -- Monika
  [[To not die, keep your health points above zero.]], --Monika
  [[Having trouble with some of the maps of mapset as a whole? Git gud.]],
  [[Bungee Gum possesses the properties of both rubber AND gum.]],

  -- other important facts, just facts no silly stuff
  [[Did you know Carmack and Hall in Sept 1990, produced a replica of Super Mario Bros 3's first level and using Romero's Dangerous Dave character in place of Mario?]],
  [[Despite having the same surname, Adrian and John Carmack are not related.]],
  [[It is predicted in about 30 to 50 million years, Phobos will crash into Mars due to tidal deceleration. At that point, Mars will probably have many smaller moons or a ring.]],
  [[Phobos is about 6,000 km (or about 3,700mi) from Mars's surface, compared to our moon's 384,402 km (or 238,856 mi)]],

  [[This is an actual line of code in Oblige:\n `if not is_big(mon) then has_small = true end`]],

  [[Some people want to watch the world segfault. -dashodanger, 2021]],
  [[Another satisfied customer. -dashodanger, 2022]],
  [[Sometimes, you're invited to play fruit basket turnover and you're the rice ball.]],

  -- Game related
  [[I was weak. That's why I needed you, needed someone to punish me for my sins. But that's all over now, I know the truth. Now it's time to end this.]], -- Silent Hill 2
  [[It's too soon to give up. This Craziness can't go on forever.]], -- Silent Hill 3
  [[The fear of blood tends to create fear for the flesh.]], -- Silent Hill
  [[...This is no time to be looking at a stupid quit message.]] -- Based on Silent Hill 2, in Brookhaven Hospital looking at a pin-up where "quit message" is "poster"
}
