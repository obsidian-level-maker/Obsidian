----------------------------------------------------------------
--  MODULE: ZDoom Story Tables
----------------------------------------------------------------
--
--  Copyright (C) 2020 MsrSgtShooterPerson
--  Copyright (C) 2020 Armaetus
--  Copyright (C) 2020 Tapwave
--  Copyright (C) 2020 Simon-v
--  Copyright (C) 2020 EpicTyphlosion
--  Copyright (C) 2020 Beed28,
--  Adapted for Heretic by Dashodanger
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

  _RAND_ENTITY_TECH = name of a computer or AI from the table below
Some keywords for parsing later on:

  _SPACE = creates a linebreak

  _RAND_DEMON = name of a demonic entity
               (based on the CASTLE entity names table)

  _RAND_ENGLISH_PLACE = name fetched directly from the Anglican
                        noun generator.

  _EVULZ = a rank title for a demonic entity based
           on the evil titles table below.

  _INSTALLATION = a corrupted facility (not used yet in Heretic)

  _RAND_CONTRIBUTOR = name of a random contributor
                      (actually based on the specific
                      contributors table under TITLE)

  _RAND_GAL
  _RAND_GUY
  _RAND_HUMAN = names for a mere mortals (there is no human name generator
               yet as of 2019-04-09)

  _CASTLE_LEVEL = name from the castle level generator

  _MCGUFFIN_MAGICAL = returns a name of a plot McGuffin from the McGuffins
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

* Corvus doesn't care about story. But we do, we can just keep saying
  things about things he ends up doing, so be creative.

* If you are using np++, hit ALT+4 (not ALT+F4!!!) to collapse groups
  down to the story chunk pieces. This will make it easier to navigate.
]]

ZDOOM_STORIES_HERETIC = { }

ZDOOM_STORIES_HERETIC.LIST =
{
  -- common stories
  i_challenge_you_to_a_duel = 100,
  found_this_weird_magical_mcguffin = 60,
  the_avenger = 40,

  -- rare stories
  deus_ex_machina = 6,
  knock_knock_joke = 2,
  oblige_history = 2,
}

ZDOOM_STORIES_HERETIC.STORIES =
{

  i_challenge_you_to_a_duel =
  {
    hooks =
    {
      -- the visage of fire
      [[A deep harrowing wail suddenly resounds through the halls.
      A visage of fire manifests before you and speaks in a monstrous tone:
      "Pitiful mortal. You think you can defeat me,
      _RAND_DEMON the Lord of _CASTLE_LEVEL?
      Come to me and meet your fate. I shall demonstrate
      the powers of the underworld to you."]],

      -- the wall shadow
      [[A strange shadow seems to creep up the walls before you.
      It shudders and shakes. A pair of searing red eyes open
      from the inky surface. It speaks:
      "I am _RAND_DEMON the King of _CASTLE_LEVEL.
      You have entered my realm. I shall deal with you accordingly.",
      The shadow fades away.]],

      -- I seeeee youuuuu
      [[You feel a crawl upon your skin. In the darkness, it feels as
      though a thousand eyes are suddenly looking upon you. A deep
      voice echoes through the chambers. "I see you, mortal. The guardians of
      _CASTLE_LEVEL await you. I, _RAND_DEMON the _EVULZ, will personally
      see to the sealing of your fate. We will meet soon."]],

      -- eye for an eye
      [["You!" a bellowing voice beckons. You cannot scry the source, but
      its speech continues. "You have scarred me before. You do not remember
      me, but soon you will. I am _RAND_DEMON the _EVULZ. I shall inflict
      pain on you as you had on me. I will tear you limb from limb.",
      You sense a powerful aura some distance away. You know what
      to do.]],

      -- the poisoner
      [[Dark viscera seems to extrude from the walls and flood the room. A porous appendage
      suddenly rises from the floor, forming the figure of a humanoid. It speaks
      in a distorted voice. "You are encroaching upon our nest, mortal. My brood
      do not take kindly to you. But I, _RAND_DEMON of _CASTLE_LEVEL, will
      greet you with glee. Come and enter." The figure dissolves back into the viscera.]]

    },

    conclusions =
    {

      -- the escape
      [[As a critical hit falls upon the demon's body, _RAND_DEMON
      stutters. "This is not how it ends, mortal! I will return
      and feast upon your soul!",
      _SPACE
      The creature quickly steps into a newly opened portal behind
      it, and dissipates.
      _RAND_DEMON escapes your grasp, but it is scarred forever.]],

      -- they are watching
      [[As _RAND_DEMON falls, its body explodes into a cloud of
      darkness, and slowly fades. An ethereal voice speaks.
      "You have returned me to the void, mortal. Your strength
      is admirable but remember: the Dark Lords are watching you.",
      The voice fades.]]

    },
  },

  deus_ex_machina =
  {
    hooks =
    {
      [[The situation seems to be growing hopeless. The veil between
      worlds has been sorely damaged. As more and more monsters pour
      through the rift, even a hero such as yourself must consider
      escape...]],

      [[Evil's grip upon this area seems to be tightening. Swarms
      of creatures rigorously continue their defense and it seems
      their numbers are unending. You decide to fight on, however
      bleak the circumstance.]],
    },
    conclusions =
    {
      [[Despite your great effort, the enemy has surrounded
      you entirely! Towering beasts march over the carcasses of the
      minions you have just felled. Suddenly, a bright opening
      in the skies appears.
      _SPACE
      It is _RAND_CONTRIBUTOR, one of the Contributors of ObAddon!
      Bolts of lightning ravage the area, searing every beast
      around you down to ashes. _RAND_CONTRIBUTOR waves at you
      and disappears again above the clouds...]],

      [[As you bring down the final foe, horrifying screams
      fill the room. As you turn back, an entire horde of fell beasts
      charges at you, but from the opposite direction suddenly comes
      an immense orb of light! The orb shoots beams into the belly of
      each creature turning them into nothing but clouds of dust.
      _SPACE
      It's _RAND_CONTRIBUTOR, one of the Contributors of ObAddon!
      "You'll need all the help you can get." _RAND_CONTRIBUTOR
      turns back and leaves, while gesturing at you to keep up
      the good fight.]]
    },
  },

  found_this_weird_magical_mcguffin =
  {
    hooks =
    {
      [[A crude altar, bloodied by countless sacrifices, stands before you.
      _MCGUFFIN_MAGICAL has been placed in its center...it looks like the
      creatures are using it as a catalyst to summon something far worse than
      themselves!
      Without hesitation, you take the evil relic and hope that you aren't too
      late to prevent catastrophe.]],

      [[You enter a study filled with various tomes and scrolls.
      Strange glyphs line the walls and you seem to hear a faint chanting in
      a language that you cannot understand. In the center of the room is a
      pedestal carrying _MCGUFFIN_MAGICAL! As you swipe the item and place it
      into your bag, the glpyhs fade into nothingness and the room becomes
      deathly silent. You are unsure of the relic's purpose, but decide that
      it is safer in your keeping.]]
    },

    conclusions =
    {
      -- pwn the boss with the McGuffin
      [[A great champion of the enemy shows itself before you. It seems that neither
      weapon nor spell can harm this foe...you quickly exhaust both your
      will and your reserves.
      _SPACE
      Out of desperation, you remove _MCGUFFIN_MAGICAL from your bag of holding.
      "No, what are you doing?!" It begins emitting a wave of light. Upon
      touching the evil creature, its body is incinerated and what little remains
      is sucked into the relic. The relic fades from your hands.]],

      -- close portal with McGuffin
      [[It seems that all of your foes were attempting to stop you from reaching
      this place. Ahead is an ancient portal from which all manner of foul creatures
      is splling through. A receptacle on the center seems to fit _MCGUFFIN_MAGICAL
      precisely. You lodge it into the receptacle and the portal collapses. Time to move on.]],

      -- demon threatens you for possession of McGuffin
      [[The final creature falls. A whispering voice rings through the air.
      "You have something that belongs to us....know that we will return
      to take it from your dead hands, mortal." The voice fades. It seems
      they were after _MCGUFFIN_MAGICAL. It's better off in your possession.]]
    },
  },

  the_avenger =
  {
    hooks =
    {
      -- the vengeful heretic
      [[You find a warrior slumped against the wall, battered and bloodied.
      His armor is torn from claws marks but he is still alive. "Hey, you!
      I don't have much time left! That creature, _RAND_DEMON did this to me.
      I want you to... to make that foul scum pay.",
      Life escapes the warrior's eyes.
      You raise a cairn of stones over the poor soul and swear
      vengeance upon _RAND_DEMON.]],

      -- hear my plea
      [[You hear a weak sobbing around the corner. You approach to see
      a horrible sight: a mass of townspeople butchered without mercy.
      Amongst the carnage is a raised hand. One of them is still alive.
      You approach.
      _SPACE
      "Please. Help... please help me... _RAND_DEMON killed everyone...",
      The woman's body is utterly crushed.
      She utters her last words and her hand falls to the ground. _RAND_DEMON will
      not see another sunrise...]],

      -- don't let them get away with this
      [[You are interrupted by a mage. He walks with a limp and his robes
      are strewn with blood. "A moment, hero." He backs to a wall, gripping his arm.
      "The Council, they made us summon _RAND_DEMON. It was an attempt to
      subjugate a demon for their own ends, but it escaped the ritual circle,
      killing everyone! I am the only one left. You have to take it down!",
      You feel anger, but lecturing the mage would not solve anything.
      You offer a potion but the mage refuses. "No, I'll pay the price for my
      folly...just take that creature down." You nod and leave.]],
    },

    conclusions =
    {
      -- STFU part 2,
      [[As _RAND_DEMON's body falls to the floor, you step over its chest.
      "Mortal! Your transgressions will not be forgo-",
      _SPACE
      You silence the creature by planting your staff right between its eyes.
      A gaping maw of blood, guts, and what was probably an eyeball
      lie were its face used to be. Vengeance is served. You make your exit.]],

      -- put a sock in it
      [[_RAND_DEMON curses you as its body crumbles. "No! This is not
      your victory, mortal! With the last of my power, I will-",
      _SPACE
      You stuff a nearby pod into its mouth. A blast from your wand
      detonates it, scattering blood and debris around the
      room. Vengeance has been achieved. You escape the area.]],

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

      [[It's _RAND_DEMON! Oh noes! ]],

      [[It's...._CASTLE_LEVEL?? How the fuck is this possible? ]],
    },
  },
}

-- TapWave-TODO:
-- Plz help proof-read! -MSSP
ZDOOM_STORIES_HERETIC.SECRET_TEXTS =
{

  heretic_secret =
  {
    [[You have found a secret area!
    It seems the enemy has barricaded itself
    within its confines, expecting safety.
    _SPACE
    You are about to prove them otherwise.]],

    [[You suddenly notice a hidden door. Behind it, you find dimly lit
    stairs, leading deep below the surface. Lighting a torch, you
    begin your descent. Several minutes later, you emerge from a
    tunnel into a vast labyrinth. The growls you hear in the
    distance leave no room for doubt.
    _SPACE
    You grin and ready your wand. It's time to clear this place out.]]
  },

}

ZDOOM_STORIES_HERETIC.EVIL_TITLES =
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

ZDOOM_STORIES_HERETIC.MCGUFFINS =
{
  -- McGuffins. Quintessential items in a story
  -- that characters work for or against, but
  -- the object's actual significance is almost always unclear
  magical =
  {
    ["an obsidian orb containing hellfire"]=5,
    ["an icon of miscreation"]=5,
    ["a desecrated totem"]=5,
    ["a baleful gem"]=5,
    ["a bloody hand"]=5,
    ["a cursed talisman"]=5,
    ["a dark crystal shard"]=5,
    ["a devil's horn"]=5,
    ["a skeletal torso"]=5,
    ["an unholy chalice"]=5,
    ["an ornate dagger"]=5,
    ["the Sword of Darkness"]=5,
    ["a blood imprinter"]=5,
    ["a brass bauble"]=5,
    ["a sinister looking ring"]=5,
    ["a small, sigil inscripted bust"]=5,
    ["an inscripted bust of Razorfist"]=5, --LMFAO
  },
}

--[[ZDOOM_STORIES_HERETIC.ENTITIES =
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
  },
},

ZDOOM_STORIES_HERETIC.INSTALLATIONS =
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
}]]

ZDOOM_STORIES_HERETIC.QUIT_MESSAGES =
{
  [[Let's be serious, are you really exiting already?]],
  [[There's always more where this comes from! ObAddon never forgets!]],
  [[Just leave. This is just more monsters and levels here. What a heap of shit.]], --Loosely based off "Extra" quit message
  [[Don't quit just yet, we're just wasting your time with this quit message!]],
  [[THIS IS A MESSAGE! Not intentionally left blank.]],
  [[Are you kidding me? Get the fuck out already.]],
  [[Come on already, there's plenty more to do in this generated mapset!]],
  [[The Randomly Generated Beast will come back for more, namely you.]],
  [[Why would you ever want to exit out of here?]],
  [[In a perfect world.. Oh wait, no there is no perfect world with sunshine and unicorn farts.]],
  [[Subscribe to... no, I am not going to do that here too.]],
  [[Oblige is love, Oblige is life.]],
  [[Are you sure you want to exit out of the game?]],
  [[Press Y to burn bridges, press N to maintain relations.]],
  [[Catch me if you can, I'm the quit message man!]], -- Gingerbread Man reference
  [[So, is this a joke? Are you staying or leaving?]],
  [[Oh, is that all? I guess I'll just throw more monsters at you when you return.]],
  [[Hold up, are you just going to leave like this?]],
  [[We're still going to be here, just go. It may not be as nice when you come back.]],
  [[_RAND_CONTRIBUTOR is disappointed in you. Hit N now or face retribution.]],
  [[He who is not bold enough to be stared at from across the abyss is not bold enough to stare into it himself.]], -- Silent Hill 2,
  [[In the end, there is only death, chaos and more death. And cookies.]],
  [[Remember, a good demon is a dead one. Make that happen!]],
  [[Heroes, press N. Wimps, press Y.]], -- Wolfenstein 3D
  [[_RAND_CONTRIBUTOR is not pleased.]],
  [[There's a lot of bullshit going on these days. Don't just add to the pile and quit like this.]],
  [[Meh, is that it? Am I supposed to appease you with something?]],
  [[There just isn't anything to keep you from hitting Y, is there?]],
  [[The will to survive is as long as you do not quit out of the game.]],
  [[Is this really what it has come to?]],
  [[RAND_CONTRIBUTOR has decided you are unworthy of your skills here.]],

  -- hardcore philosophy
  [[_RAND_CONTRIBUTOR wants to know you're quitting from an Oblige map. :( Unless you just finished it all. :D]],
  [[Never gonna give you up, never gonna let you down, never gonna run and leave you without a fresh new megawad.]],
  [[You can win Oblige, you just have to defeat a 64-bit permutation of maps and each variation per seed by changed setting to do so.]],
  [[A dimensional shambler is, indeed, waiting in your operating system. It was ObAddon all along.]],
  [[My map generator brings all the linedefs to the yard.]],
  [["You shouldn't stop playing Heretic." definitely said by Voltaire.]],
  [[Are you taking the blue pill?]],
  [[The prophet Nostradamus predicted the dead would rise when there is no more room in hell. He didn't predict Oblige would be generating new rooms.]],
  [[You probably noticed by now that every time quit messages show up, you're forced to agree with the statement when you quit by choosing 'yes'.]],
  [[Thanos needs two fingers to erase half the universe. Oblige builds a whole with only one.]],
  [[Oblige is the machine. ObAddon is the ghost in the machine.]], -- credits to FrozSoul!
  [[Oblige can generate more maps than you will ever speak words in your whole life.]],

  -- helpful // technical
  [[ObAddon is always improving. Stop by our Discord server, talk to the denizens and report bugs to us there!]],
  [[Visit https://caligari87.github.io/ObAddon/ for updates!]],
  [[If you're quitting because something might be broken, please supply screenshots and preferably your LOG file when reporting.]],
  [[ObAddon is for the adventurous. Are you? Join us and contribute ideas and works! ObAddon is a community project!]],
  [[Was this not big enough? Try jacking up the Max Level Size or Upper Bound in settings to Colossal, Gargantuan or Transcendent.]],
  [[If you are reporting an error and already closed OBLIGE, do NOT reopen the program as it will wipe the LOGS.TXT file clean! Open it via a text editor.]],
  [[Map sizes too big? Reduce the Map Size or Upper Bound size if using Mix It Up.]],
  [[Gargantuan or Transcendent maps looking like Minecraft Far Lands? Please keep Auto Detail on, not much else can be done about that, stupid Doom Engine limits.]],
  [[Too hard? Turn down Quantity and/or Strength. Same applies to too easy: Turn Quantity up.]],

  -- important facts
  [[By exiting, you are agreeing to subscribe to Cat Facts.]],
  [[Sewerage is important but HVAC systems is importanter.]],
  [[In 1998, the Undertaker threw Mankind off Hell in a Cell and plummeted 16ft. through an announcer's table.]],
  [[ObAddon enhances your problem-solving skills! Contribute now!]],
  [[Set the Y offset, again of both front and back side, to the negative of the subtraction of the ceiling height of the sector the pit and the floor height of the planes, or y-offset = -(pitceilingheight-planefloorheight). So, the ceiling height is 256 in both platforms and the pit and the platform's floor height is 0, so the sidedefs' Y-offsets must be -(256-0) = -256.]],
  [[To not die, keep your health points above zero.]], --Monika
  [[Having trouble with some of the maps of mapset as a whole? Git gud.]],

  -- other important facts, just facts no silly stuff
  [[This is an actual line of code in Oblige:\n `if not is_big(mon) then has_small = true end`]],
}
