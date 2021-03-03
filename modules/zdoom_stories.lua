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

  _MCGUFFIN_HELL
  _MCGUFFIN_TECH = returns a name of a plot McGuffin from the McGuffins
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

ZDOOM_STORIES = { }

ZDOOM_STORIES.LIST =
{
  -- common stories
  portal_to_hell = 40,
  fuck_argent_energy = 20,
  rescue_scientists = 40,
  reinforce_marines = 40,
  attack = 50,
  i_challenge_you_to_a_duel = 100,
  beacon = 50,
  aa_guns = 40,
  destroy_the_evil_experiment = 40,
  found_this_weird_tech_mcguffin = 60,
  found_this_weird_hell_mcguffin = 60,
  the_avenger = 40,
  the_avenger_from_hell = 40,
  benevolent_ai = 40,
  spaceship_crash = 25,
  fusion_cannon = 25,
  demolition_man = 40,

  -- rare stories
  deus_ex_machina = 6,
  weab = 2,
  weab2 = 2,
  repercussions_of_evil = 2,
  zero_wing = 2,
  asylum = 10,
  knock_knock_joke = 2,
  infernodancer = 2,
  hell_to_pay = 2,
  oblige_history = 2,
  bouncy_castle = 2,
}

ZDOOM_STORIES.STORIES =
{
  portal_to_hell =
  {
    hooks =
    {
      [[It seems as though demons continue to spill into the area
      despite your best efforts. Your locator marks a massive spike
      in energy nearby. It seems the source of the demonic surge
      is in that direction...]],

      [[Hell's forces continue to lay siege upon this region. It
      is clear their numbers are being reinforced from elsewhere.
      You begin a search for the potential existence of a hell
      portal...]],

      [[You are slowly drawn to a mysterious source of energy
      as you progress and notice the continued flow of demons
      into the fray. There must be an entrance to hell nearby...]],
    },

    conclusions =
    {
      [[You have destroyed the guardian protecting a portal to hell!
      With his defeat, the portal collapses. Hell will find it more
      difficult to return to this place!]],

      [[Hell's commanders went through great efforts to guard this portal
      to hell. You slip through to find yourself in a new place, in which
      the source of the demonic invasion seems to originate from...]],

      [[It was a trap! As the demon's corpse crashes onto the floor,
      a portal to hell turns out to be underneath all along! The platform
      crumbles and throws you into its maw -
      you find yourself in a new place...]],
    },
  },

  fuck_argent_energy =
  {
    hooks =
    {
      [[As you continue, a quiet but distinct hum of power seems
      to permeate this area. It feels hair-raising and ominous.
      It must be Argent Energy. The source must be closed.]],

      [[Monitors flicker on and off, and occult runes and symbols
      seem to occasionally appear on them. The area seems to be
      powered by Argent Energy, the impure power source from hell.
      It must be stopped.]]
    },

    conclusions =
    {
      [[You have found a conduit through which Argent Energy
      is being transmitted from hell! With a crash of your
      fists, the conduit is damaged beyond repair.
      Power supply is eliminated throughout the region -
      but so does the corruption hell has radiated over it.]],

      [[The generator transforming hellish energies into
      electrical power has allowed the decaying force
      of Argent Energy to mutate this place. You destroy
      the generator but as it falls silent, a well of souls
      bursts open, the spirits escaping into the atmosphere!
      You are unsure of what you have done, but at least hell's
      influence is banished for now.]],
    },
  },

  rescue_scientists =
  {
    hooks =
    {
      [[Your tracker lights up and is apparently receiving a
      distress signal from a nearby location. A few UAC scientists
      seem to have barricaded themselves, surrounded by the
      demonic horde and is seeking rescue. You acknowledge
      and proceed...]],

      [[A portable terminal has revealed the position of a group
      of scientists nearby. You attempt to establish communications,
      but receive no response. The last footage from the terminal
      reveals them panicking, running from demons. You may still
      have opportunity to save them...]],

      [[Badly hysteric chatter suddenly rings off of your
      radio. It seems a group of scientists are looking for
      a way out of this place and hellspawn are on their trail.
      Unable to respond to them, you attempt to make
      your way towards their position...]],
    },

    conclusions =
    {
      [[With the defeat of the demonic host, you have freed
      the scientists from the assault! The scientists have
      sworn off any continued cooperation with UAC's experimentation
      with hell and leave through some escape pods! You remain
      as there is more to discover...]],

      [[As the final demon collapses before its feet, it utters
      a terrible laughter that echoes through the chambers.
      Behind it you discover the remains of the butchered scientists.
      Misfortune has befallen them and there is no way you
      could have reached them in time. You trudge on...]],

      [[You have found the scientists! It seems however they are
      not what they seem... one of them carries a strange artifact
      with a fiery glow through its gaps. You suddenly notice
      madness in the scientist's eyes! A burst of energy
      throws you across the floor, killing the scientist instantly!
      A surge of demonic energies herald the coming of new hellspawn.
      It looks like your task isn't over yet...]],
    },
  },

  reinforce_marines =
  {
    hooks =
    {
      [[Your radio receives a badly garbled transmission but
      you can make out a few words. "Need assistance! *ZZT*
      Surrounded! *ZZT* Running low on supplies!" The transmission
      abruptly cuts off. You hurry to track their last position.]],

      [[Your tracker reveals several green dots on the map.
      They are clearly hurrying, as it seems the dots are moving
      quickly. They are marines and likely are in the middle
      of an engagement. They are some distance away, but you
      may still be able to reach them in time...]],

      [[As you step across the floor, you come up to a pair of dog tags
      below your boots. You pick them up and hear the distant thunder
      of gunfire. It seems a group of marines have passed through
      here some time ago. It might be a good idea to join them.]],
    },

    conclusions =
    {
      [[A mess of craters and holes now lie where demonic
      figures used to stand. The marines congratulate
      you on a swift assist and hell is held back! The marines
      extract for now, awaiting their next mission as you stay
      behind to explore further...]],

      [[As the final creature falls, it harkens to you.
      "Foolish mortal. Attracted to the sound of despair.
      Such easy trickery for a famed warrior such as you.",
      The demon's corpse fades into ashes.
      There is no sign of the battling marines anywhere
      but the general of hell still lies defeated.]],

      [[The armies of hell are routed by your relentless onslaught.
      You find a badly blasted barricade and in it the corpses
      of the marines who sacrificed themselves to battle hell.
      You pick up their dog tags in respect and scurry on...]],
    },
  },

  attack =
  {
    hooks =
    {
      [[A fetid odor fills the air of this place. It seems the
      forces of hell are massing ahead in preparation for
      an assault. It is a prime opportunity to throw off their
      gathering before an attack can begin...]],

      [[A hellish infestation seems to be running amuck about
      this region. Hell's reign is expanding and their armies
      gather in numbers elsewhere. Perhaps you can get a shot
      on them first before they begin a new assault...]],

      [[A strange overgrowth of bloody viscera seems to be
      overtaking this place. Hell's infestation is interacting
      with reality to accommodate hellspawn over mortals.
      Time to change that.]],
    },

    conclusions =
    {
      [[You have destroyed the horde leader,
      _RAND_DEMON of _GOTHIC_LEVEL! The demonic
      forces scatter, unable to continue their assault! With
      this place freed, the taint of hell's energies fades with
      the retreat of the darkness.]],

      [[It was a trap! An entire battalion of hell's banners fall
      before you. It turns out you were the target all along
      but with your dexterity and wit, you have outmaneuvered
      their forces and crushed them utterly.]],

      [[With your relentless barrage upon the hellspawn, their
      numbers shrink but you have a feeling this was not the bulk
      of their force... it seems you were lured here through
      a ruse! The demonic army unleashes itself elsewhere...]],
    },
  },

  i_challenge_you_to_a_duel =
  {
    hooks =
    {
      -- the visage of fire
      [[A deep harrowing wail suddenly resounds through the halls.
      A visage of fire manifests before you and speaks in a monstrous tone:
      "Pitiful mortal. You think you can defeat me,
      _RAND_DEMON the Lord of _GOTHIC_LEVEL?
      Come to me and meet your fate. I shall demonstrate
      the powers of the underworld to you."]],

      -- the wall shadow
      [[A strange shadow seems to creep up the walls before you.
      It shudders and shakes. A pair of searing red eyes open
      from the inky surface. It speaks:
      "I am _RAND_DEMON the King of _GOTHIC_LEVEL.
      You have entered my realm. I shall deal with you accordingly.",
      The shadow fades away.]],

      -- the vengeful
      [[Strange echoes reverberate through the walls. A dark figure
      menaces you with its presence and speaks.
      "You may have defeated me before but know this, mortal.
      Perhaps once I was a lowly imp, but now I am
      _RAND_DEMON the baron of _GOTHIC_LEVEL.
      I will repay your insolence by crushing and dragging your
      entrails across the stone!"]],

      -- Hannibal totem
      [[The wind blows by with a scent of sulfur. Ahead, you spot
      something terrifying: an effigy of hell. The monument is of
      twisted human corpses, sewn together to create a totem. It
      suddenly catches a blue fire and you hear a voice.
      _SPACE
      "I am _RAND_DEMON the _EVULZ. We are legion. We do not forgive.",
      The voice disappears as with the totem.]],

      -- the bounty hunter
      [["DOOMSLAYER!" a scream echoes through the halls. An
      enormous creature steps from the shadows. "I am _RAND_DEMON the
      _EVULZ. Hell has a bounty upon you. I shall claim it with your head
      and all darkness shall know me for my deed.",
      Finished with its threat, _RAND_DEMON recedes into the shadows
      and awaits you in its infernal arena.]],

      -- it's all in your mind
      [[A loud screech startles you. You look around but your tracker
      hints to no movement. A voice suddenly speaks into your mind.
      "Mortal. You have become our quarry for your intrusions upon hell.
      I, _RAND_DEMON the _EVULZ, have marked you for death. You are hunted.",
      The voice disappears followed by infernal howls further ahead...]],

      -- I seeeee youuuuu
      [[You feel a crawl upon your skin. In the darkness, it feels as
      though a thousand eyes are suddenly looking upon you. A deep
      voice echoes through the chambers. "I see you, mortal. The guardians of
      _GOTHIC_LEVEL await you. I, _RAND_DEMON the _EVULZ, will personally
      see to the sealing of your fate. We will meet soon."]],

      -- eye for an eye
      [["You!" a bellowing voices beckons. You cannot trace the source, but
      its speech continues. "You have scarred me before. You do not remember
      me, but soon you will. I am _RAND_DEMON the _EVULZ. I shall inflict
      pain on you as you had on me. I will tear you limb from limb.",
      Your tracker indicates an energy surge some distance away. You know what
      to do.]],

      -- the poisoner
      [[Dark viscera seems to extrude from the walls and floors. Hell's corrupting
      influence has a greater grip upon this area. A porous appendage
      suddenly rises from the floor, forming the figure of a humanoid. It speaks
      in a distorted voice. "You are encroaching upon our nest, mortal. My brood
      do not take kindly to you. But I, _RAND_DEMON of _GOTHIC_LEVEL, will
      greet you with glee. Come and enter." The figure dissolves back into the viscera.]],

      -- remember Daisy
      [[You walk between rows of sticks. Impaled limbs and heads
      are set upon them. On one you see the head of a rabbit.
      Immediately, your blood boils.
      You realize, however, the rabbit isn't Daisy. An ethereal voice
      whispers to you. "You are a mortal of impulse after all.
      Still hurt over your little big-ear darling?
      Show me your fury, mortal. I am _RAND_DEMON the _EVULZ.
      I grant you the company of your little pet. In HELL.",
      The voice fades, and you steel your fists.
      _RAND_DEMON will fall hard today.]],

      -- a beat of the drums
      [[The sickening sound of a distorted trumpet wails,
      followed by the thumping of war drums. You hear a
      repeating chant of what sounds like a hundred infernal voices.
      "_RAND_DEMON! _RAND_DEMON! _RAND_DEMON!" The drumbeat stops
      and a bolt of fire strikes the floor before you, causing you
      to fall back. Your HUD finds a recognizable pattern in the scorchmarks.
      A hell rune translating to "You die.",
      Hell will have to see about that.]],

      -- the mirror
      [[You find a mirror on the wall and there is something
      strange about its reflection. You look closer and see the
      image swirl and form something new. In it you see yourself
      chained against a burning monolith of slate, while imps
      gleefully dance around you. A ghostly mutter breaks the silence.
      "Sinners all have a place in hell, mortal. But you are special.
      Let me, _RAND_DEMON the _EVULZ, be your ferryman to the
      underworld." You smash the mirror with your fists, leaving
      a gaping hole in the wall. You have answered hell's challenge.]]
    },

    conclusions =
    {
      -- STFU
      [[A great battle has just concluded. _RAND_DEMON collapses
      before you. "No! How could this be?! The forces of hell
      are infinite and unfor-",
      _SPACE
      Its dialogue is interrupted as with the crack of your knuckles,
      you send its head flying square off its shoulders across
      the room with an uppercut. The remaining minions of hell
      shriek in fear and retreat!]],

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
      The voice fades.]],

      -- the fissure
      [[_RAND_DEMON's body crashes to the floor. The ground begins
      to shake and a fissure opens, filling the room with an infernal
      red glow. _RAND_DEMON is absorbed into the fissure, and the cracks
      disappear. A foreboding voice speaks "I will return, mortal.
      The void consumes me but in my place a new demon shall stand.",
      You ignore the threat. You already know that hell's bounty is
      on you and continue on.]]
    },
  },

  deus_ex_machina =
  {
    hooks =
    {
      [[The situation seems to be growing hopeless. Hell has opened
      a great rift and the tides of hell have corrupted
      this place deeply. You have no choice but to escape
      and thus attempt to breach between their gaps...]],

      [[Hell's grip upon this area seems to be tightening. Swarms
      of hellspawn rigorously continue their defense and it seems
      their numbers are unending. You decide to fight on, however
      bleak the circumstance.]],
    },
    conclusions =
    {
      [[Despite your great efforts, the forces of hell have surrounded
      you entirely! Towering beasts march over the carcasses of the
      hellspawn you have just felled. Suddenly, a bright opening
      in the skies appear.
      _SPACE
      It is _RAND_CONTRIBUTOR, one of the Contributors of ObAddon!
      A rain of plasma bolts fall from the sky, searing every beast
      around you down to ashes. _RAND_CONTRIBUTOR waves at you
      and disappears again above the clouds...]],

      [[As you bring down the final demon, horrifying screams
      fill the room. As you turn back, an entire horde of demons
      charges at you but from the opposite direction suddenly comes
      an immense orb of light! The orb shoots beams into the belly of
      each creature turning them into nothing but clouds of dust.
      _SPACE
      It's _RAND_CONTRIBUTOR, one of the Contributors of ObAddon!
      "You'll need all the help you can get." _RAND_CONTRIBUTOR
      turns back and leaves, while gesturing at you to keep up
      the good fight.]]
    },
  },

  beacon =
  {
    hooks =
    {
      [[Your tracker lights up and informs you that a beacon with a
      UAC signature has suddenly began transmitting nearby. It seems
      someone is deliberately calling your attention. The position is
      logged and you attempt to head in its direction...]],

      [[It seems a reinforcement beacon has been activated nearby.
      A group of friendly forces may be attempting to fight it out
      with the forces of hell. You begin your journey towards the
      position of the beacon...]],

      [[Your radio picks up on a mysterious signal. Parsing it through
      your tracker, you find a beacon transmitting at a military frequency.
      It likely is a point of interest so you begin your journey towards
      it, accepting the potential risk.]],
    },

    conclusions =
    {
      [[After destroying the hordes, it seems you have found a cache
      of essential supplies they were attempting to keep from you.
      You help yourself to the newfound munitions. It seems there is no
      evidence as to who activated the beacon. You shut it down.]],

      [[It was a trap all along! The hell general _RAND_DEMON activated
      the beacon, expecting you to follow it. They did not, however,
      expect a thorough defeat despite their machinations.
      You deactivate the beacon so no marine after you may fall prey to it.]],

      [[You have found the beacon attached to a badly damaged cargo pod.
      You pry open the doors pocked with bullet holes and claw marks.
      Out spill a group of civilians.
      _SPACE
      "Thank you for saving us! Those creatures just appeared out of nowhere!",
      You gesture towards the exit. "Thank you for getting rid of them. We can't
      repay you with anything, but we hope you bring down more of those demons!",
      The civilians leave.]],

      [[After a great battle with the minions of hell, you find a group
      of fallen marines before you who have made a last stand, their
      bodies scattered around a crater. One of them still grips an
      emergency beacon tightly in their bloody hands.
      You disable the beacon and take their dog tags.
      Their sacrifices will be remembered.]],
    },
  },

  aa_guns =
  {
    hooks =
    {
      [[You hear the great roar of explosions in the distance.
      You look up the skies and see spacecraft crashing into the
      atmosphere. It seems hell has taken control of the ground defense
      systems and have turned them against humans. You must find a way
      to disable the rogue system!]],

      [[Your radio stutters open and an indirected transmission blares out
      the following instruction: "If you are hearing this, we are
      attempting to land in our target area but hostiles have taken control
      of the ground defense system! If you have means to disable it,
      this will allow friendly forces to land and push through!"]],

      [[You push yourself through the corridors of the overrun area
      which bares the marks of battle. You come across various consoles
      reading "ERROR" and "AAG targeting comprimised" scrolling the screens.
      You hear the boom of anti-aircraft guns - unusual, as no UAC operators
      are in the area. Something is wrong. Something else is in control of the
      system.]],
    },
    conclusions =
    {
      [[The great demon _RAND_DEMON of _GOTHIC_LEVEL has fallen!
      In the wake of its defeat, your tracker informs you that
      the local ground defense system has rebooted. You watch as
      civilian spacecraft rise to the skies and exit the atmosphere safely.]],

      [[The battle with _RAND_DEMON of _GOTHIC_LEVEL was difficult,
      but you came out victorious nonetheless. You smash the
      defense terminal, causing it to power down. You watch as friendly dropships
      safely descend in the distance from the clouds. Hell will fight back
      but this should make your own battle easier. Hopefully.]],
    },
  },

  destroy_the_evil_experiment =
  {
    hooks =
    {
      [[This area bears the marks of UAC technology. Energy signatures
      match your own equipment. It seems a wicked experiment has been left
      behind by the UAC in this area. Whatever it is, time to shut it down.]],

      [[Your computer map lights up with the words: "WARNING. You are entering
      a restricted zone. Your clearance level is insufficient for access.",
      A UAC security clearance warning is an invitation for you to blow some
      doors open. You continue upon your path.]],

      [[You find the corpse of a dead UAC scientist slumped along the wall.
      There is a scorched note on his pocket. The nearly illegible writing
      spells out "kill it before it turns". It seems the UAC have left a
      surprise ahead. Time to investigate.]],
    },

    conclusions =
    {
      [[You have destroyed _RAND_DEMON the _EVULZ! The creature was an
      abominable amalgamation of technology and the demonic. You shake
      your head once again at humanity's attempt to tame hell. It is
      clear the UAC has not learned its lesson.]],

      [[With the destruction of demonic presence in the area, you find
      an experimental UAC teleporter had gone haywire, its destination
      connecting to hell. You smash the panel with your fists and the
      portal closes. The demons will have to find another way through.]],

      [[A massive manufacturing plant seems to have been retrofitted to
      produce abominations. Mechanical limbs and viscera hang from chains
      above you. You toss an explosive barrel into the machine's maw causing
      a chain of explosions that rock the building. Hell's war factory
      has been destroyed, but there are probably more...]],

      [[With the fall of the final monster, the room stills to a hush.
      You only hear the faint noise of beeps from a computer terminal.
      You find the portable terminal and archives in the system indicate
      humans had been forced to turn into demons through technological means
      here. You punch right through the monitor and smash the
      storage drives on the floor. You leave in disgust.]],
    },
  },

  weab =
  {
    hooks =
    {
      [[Three strange creatures, each round and colored differently
      with vertical slits for eyes bounce towards you. They bob and stack upon
      each other. Suddenly, you hear a meek, feminine voice singing.
      _SPACE
      "Dango. Dango. Dango. Dango. Daikazoku.",
      _SPACE
      The simple melody of phrases repeat for a while longer.
      You regain senses and the creatures disappear. What was that?]],
    },

    conclusions =
    {
      [[As hell's forces retreat, a vision enters your mind of a world
      covered in snow. The distant figure of a girl seems to emerge
      out of the fields of white. The snow slowly recedes and the gray skies
      turn blue. The girl waves at you, thanking you for being the bringer of summer
      to her world from the winter hell had heralded.
      _SPACE
      The vision dissipates. Your HUD indicates no presence of hallucinogens
      in the area.]],
    },
  },

  weab2 =
  {
    hooks =
    {
      [[You have always fought the legions of hell but something
      feels amiss this time. It seems as though the visages of the demons stutter
      and shake with their movement somehow jerky. The faces of zombies seem to
      phase-in and out but stay the way they are, red and bloodied as always,
      the longer you look. Hell seems to be playing a trick - the only way is through.
      _SPACE
      You continue on.]],
    },

    conclusions =
    {
      [[The demon<Doom Engine error:$_STORY_STRING_NOT_FOUND>
      _SPACE
      $$-.You suddenly find yourself motionless. The room around you has collapsed into a white void.
      The silhouette of a lady with wavy hair appears before you.
      She is shaded almost entirely hidden from the blinding light. She cheerfully speaks.
      _SPACE
      'I put you here to keep you safe from everyone else. For me. I'm sorry I made
      you do... a bit of the work. You've... deleted them all.'
      _SPACE
      You pressure your arms to aim and fire, yet you shoot in the wrong direction. That
      seemed to be enough however... you find yourself the previous room, the hellish dead
      piled around the corners. The strange illusion seems to have faded.]],
    },
  },

  found_this_weird_tech_mcguffin =
  {
    hooks =
    {
      [[You stumble upon a safety deposit box marked by the UAC with various
      warning labels. This doesn't look like the kind of thing that should
      fall into the wrong hands. You pry the crate open and find
      _MCGUFFIN_TECH. You take it with you.]],

      [[Power surges and electrical fluctuations in the area are causing
      unusual behavior on your HUD. You find a panel on the wall with
      caution markings. With the right hit exacted on the lock, the panel
      swings open to reveal _MCGUFFIN_TECH. You pry it out, and the
      fluctuations stop... this might be useful elsewhere.]],

      [[You find a military cargo pod ahead. It seems to have been here
      for a while with its intentional recipients having never claimed it.
      You interface your suit to the terminal and the pod reveals _MCGUFFIN_TECH
      inside. Better for you to hold on to it than the hellspawn.]],

      [[A shot in the right place brings down a shotgun-carrying shambler of a corpse.
      It seems it has a bulging backpack. You strip the corpse of supplies and open
      the backpack to reveal the contents: _MCGUFFIN_TECH. You take it with you.]],
    },

    conclusions =
    {
      [[After a battle with the demons, it seems your path ahead is blocked by
      an enormous bulkhead gate. A receptacle on the side seems to precisely fit
      _MCGUFFIN_TECH. You insert it in the slot and a steady rumbling begins to
      shake the halls. The bulkhead gate slowly rises up, granting you passage.]],

      [[In the wake of battle, you hear gunfire coming from across the room.
      You see a group of marines just fresh off of their own skirmish.
      "Whoa! It's good to see someone else! We're on a retrieval mission for
      _MCGUFFIN_TECH.",
      _SPACE
      Right on time. You offer your finding. "Hell yeah! This should help
      us get out of here! Thanks!" After some short chatter and relief, you part
      with the group as your mission beckons you elsewhere...]],

      [[It seems as though the demons were attempting to breach into a small
      automated UAC firebase with a field plasma turret. The terminal indicates
      the requirement of a _MCGUFFIN_TECH for its activation. You supply it
      with the necessities. The terminal announces:
      "Automated security system activated.",
      The turret activates and begins swinging around,
      looking for hellspawn to target. Now we're talking!]],
    },
  },

  found_this_weird_hell_mcguffin =
  {
    hooks =
    {
      [[A strange altar lined with demonic effigies stands besides the wall.
      It seems the creatures are worshipping the object on the pedestal.
      It's _MCGUFFIN_HELL! A relic of this sort is better off in your hands
      than those of hell's. You take it with you.]],

      [[Ahead is a large setup of various portable machines and terminals.
      Each display shows graphs and readings you cannot interpret. The machines
      are linked to a pedestal carrying _MCGUFFIN_HELL! You swipe the item
      off its pedestal and the displays lose their readings. UAC experiments
      rarely turn out good, you think to yourself.]],

      [[Radiant energies permeate through this place. It seems to come from
      this stone totem. It must be helping the forces of hell rally somehow.
      Atop the totem is _MCGUFFIN_HELL. You topple the totem over and pilfer
      the object. Hell won't have a use for this anymore!]],
    },

    conclusions =
    {
      -- pwn the boss with the McGuffin
      [[A great demon shows itself before you. It seems any weapon
      is failing to damage the creature at all.
      "You have no chance against inferno!",
      _SPACE
      Out of desperation, you take out _MCGUFFIN_HELL from your backpack.
      "No, what are you doing?!" It begins emitting a wave of light. Upon
      touching the demonic creature, its body is incinerated and particles
      are sucked into the relic. The relic fades from your hands.]],

      -- close portal with McGuffin
      [[It seems the minions of hell were attempting to stop you from reaching
      this place. Ahead is an ancient portal from which the demons apparently
      spilled through. A receptacle on the center seems to fit _MCGUFFIN_HELL
      precisely. You lodge it into the receptacle and the portal to hell
      collapses. Time to move on.]],

      -- demon threatens you for possession of McGuffin
      [[The final creature falls. A whispering voice rings through the air.
      "You have something that belongs to hell. Know that we will return
      to take it from your dead hands, mortal." The voice fades. It seems
      they were after _MCGUFFIN_HELL. It's better off in your possession.]],

      -- demon takes back the McGuffin *sigh*
      [[As you land your final hit upon a demon, a surge of energy
      paints your shadow in front of you. You are hurled across the floor
      as sparks bounce from your armor. You feel immense pain. You struggle
      to regain your composure but your sight still blurs. A demonic voice
      speaks "Mortal. You have _MCGUFFIN_HELL with you. That belongs to hell.",
      _SPACE
      The bright flashes of light end and the room falls silent.
      You finally pick yourself up. Unfortunately, it seems your
      backpack is now a bit lighter...]],
    },
  },

  repercussions_of_evil =
  {
    hooks =
    {
      [[Alarms blare out through the area. You find yourself standing
      among rows upon rows of corpses, human and demon alike. It seems
      a huge rampage had occurred here but its instigator is unclear. You
      find a torn armor piece among the debris. The nameplate reads
      "John Stalvern". You wonder what happened and continue on.]],
    },

    conclusions =
    {
      [[Demons that have crossed the threshold have met a terrible fate
      by your hands. You wonder if there will ever be a time of peace
      after the gates of hell first opened. A strange voice in your
      head suddenly echoes a repeating phrase.
      _SPACE
      "No John, you are the demons.",
      _SPACE
      You clearly aren't John-whomever. This place is clear of demonic
      presence for now and you resume your expedition against hell.]],
    },
  },

  spaceship_crash =
  {
    hooks =
    {
      [[You hear a thunderous noise from the sky. You watch in the distance
      as a burning starship descends from the clouds and crashes into
      the ground with a bright, blinding flash. The shape was difficult to
      discern but it looks like a UAC cruiser. There might be survivors.]],

      [[The ground shakes and an eruption of loud explosions deafens you.
      As you get your grips on the situation, you see burning fragments
      of metal rain down from the skies. You take shelter nearby and watch
      as the fragments litter the floor. A large shard reads:
      "UACS _RAND_ENGLISH_PLACE". It seems a UAC vessel has
      crash-landed nearby.]],

      [[You spot a thick column of smoke in the distance. Along the gray haze,
      you can barely make out the silhouette of what appears to be a
      crashed starship. The wreckage seems to have been there for a while.
      You plot a course towards the vessel.]],
    },

    conclusions =
    {
      [[The sound of battle dies down to only the crackling of fire
      and melting steel. You have found the remains of the crashed
      starship. Among the debris, you hear a knocking sound.
      You find a marine that has been pinned to the ground by a beam.
      With your strength, you help lift the beam, freeing the marine.
      _SPACE
      "I thought I was a goner there. You came just in time! I'm wounded,
      but I should be able to make my way from here on my own.",
      You offer him supplies but he refuses anything other than just a stim.
      You part ways.]],

      [[The last demon has been torn off its feet and you find yourself
      within a huge field of molten metal and twisted debris. It seems these
      are the remains of the vessel you witnessed crash earlier. You attempt
      to explore further, but it seems nothing of value was left from the ship's
      destruction. You continue on...]],

      [[A hanging pile of wreckage falls upon the imps before you could act.
      It seems gravity just helped end your battle. You find yourself within
      the bowels of the crashed vessel. Amongst the wreckage is a black box.
      You interface and find a final recording: it seems the starship was
      crashed deliberately after a host of demons have boarded it. There is
      nothing else here. You continue your trek.]],
    },
  },

  zero_wing =
  {
    hooks =
    {
      [[The war between mankind and demons rages on.
      _SPACE
      It seems the demons have set you up a bomb nearby. As you narrowly
      jump aside to avoid the blast, you get a signal on your receiver.
      _SPACE
      It's _RAND_DEMON!!
      _SPACE
      "How are you, mortal? All of your bases are now belong to us." It growls with
      malicious laughter. "All of Humanity is on the way to destruction. You have
      no chance to survive this battle, so enjoy the little time you have left.
      Ha ha ha ha ha...",
      _SPACE
      You know what to do. Time to move and strike back, for great justice.]],
    },

    conclusions =
    {
      [[Congratulations!!
      _SPACE
      All bases of _RAND_DEMON in this area have been destroyed. Peace to the
      world can finally be restored... but that is what you could only wish
      for.
      _SPACE
      Despite your best efforts, _RAND_DEMON is still alive. You must fight
      against _RAND_DEMON's horde of forces again and destroy them
      completely.]],
    },
  },

  the_avenger =
  {
    hooks =
    {
      -- the vengeful marine
      [[You find a marine slumped against the wall, battered and bloodied.
      His armor is torn from claws marks but he is still alive. "Hey, you!
      I don't have much time left! That creature, _RAND_DEMON did this to me.
      I want you to... to make that demon scum pay.",
      Life escapes the marine's eyes.
      You take his dog tags and swear vengeance upon _RAND_DEMON.]],

      -- hear my plea
      [[You hear a weak sobbing around the corner. You turn around to see
      a horrible sight: a mass of civilian corpses butchered by hell's forces.
      Amongst the carnage is a raised hand. One of them is still alive.
      You approach.
      _SPACE
      "Please. Help... please help me... _RAND_DEMON killed everyone...",
      The woman's body is utterly crushed.
      She utters her last words and her hand falls to the ground. Hell
      will pay tenfold for this.]],

      -- don't let them get away with this
      [[You are interrupted by a scientist. He walks with a limp and his lab coat
      is strewn with blood. "Hey." He backs to a wall, gripping his arm.
      "The UAC, They made us work on Project _RAND_DEMON. It was an attempt at
      capturing one of the class 5 entities but it escaped the containment
      field, killing everyone. I am the only one left. You have to take it down!",
      You feel anger but lecturing the scientist would not solve the problem.
      You offer a medkit but the scientist refuses. "No, I'll handle this part.
      Just take that creature down." You nod and leave.]],
    },

    conclusions =
    {
      -- STFU part 2,
      [[As _RAND_DEMON's body falls to the floor, you step over its chest.
      "Mortal! Your transgressions against hell will not be forgo-",
      _SPACE
      You silence the creature by landing a fist right between its eyes.
      A gaping maw of blood, guts, and cables lie were its face used to be.
      Vengeance is served. You make your exit.]],

      -- put a sock in it
      [[_RAND_DEMON curses you as its body crumbles. "No! This is not
      our last battle, mortal! Hell is unending! We are legion! We-",
      _SPACE
      You stuff a barrel of nukage into its mouth. A shot in the right
      place detonates the barrel, scattering blood and debris around the
      room. Vengeance has been achieved. You escape the area.]],

      -- I'm gonna rip your arm off and beat you with it
      [[The weakened _RAND_DEMON tries to limp away. You rush and grip
      one of its limbs tightly, tearing it from its socket. "GRAAAAHH!
      Leave, mortal!" With a strong swing of the piece, a crash of flesh
      and metal is met with an explosion of blood and intestines. The demon
      is defeated. You leave the area.]],
    },
  },

  the_avenger_from_hell =
  {
    hooks =
    {
      -- my name is _RAND_DEMON, you killed my father, prepare to die
      [[You are rudely interrupted and shoved down to the ground.
      A great demon grips you tightly, salivating on your visor. It growls.
      "You! You killed _RAND_DEMON, our lord! I am sworn to destroy you!",
      You discharge your suit battery and a shockwave of electricity is released,
      freeing you and pushing the demon back.
      "I will return. With your head upon our lord's altar.",
      The demon steps back into a portal which collapses behind it.]],

      -- passing the torch
      [[A great demon shows itself before you from a ledge above.
      It begins a speech:
      "By decree of the dark lords and _GOTHIC_LEVEL, I have taken the place
      of _RAND_DEMON and in our lord's name, I shall grind you to a pulp!",
      You take aim and land a shot on its chest to minor effect.
      "Pathetic! I will show all hell of your fate." The great
      demon steps away into the shadows.]],

      -- you'll make a nice doodad
      [[As you open a door, a swing of metal launches you off of
      your feet and into the wall. A menacing creature stands before
      you and decrees "Mortal! Your head will make a great ornament
      upon our Lord _RAND_DEMON's cenotaph!" As it makes its way towards you,
      the floor beneath you crumbles. You fall and roll down a long slope and find
      yourself at the bottom.
      You pick yourself up quickly, but see no sign of the demon.]]
    },

    conclusions =
    {
      -- curb stomp
      [[You have defeated the great demon!
      "Nooo! Nooo! _RAND_DEMON must be avenged!",
      You raise your foot and stomp the creature's head to the curb.
      The floor is greased with a splatter of blood and metal.
      You swear to make all hellions reach the same fate at every turn.]],

      -- oh no run away
      [[The great demon is stricken and crashes down.
      Wails of agony flood the room as the impish minions run in a panic.
      "_RAND_DEMON's champion has been defeated by the Doomslayer!
      Retreat!" You fire shots at the routed pawns and some of them tumble
      down. You bring one foot over the demon's head, weapon in hand,
      and survey the area. It seems you have struck fear upon the creatures.
      All clear now, but they will return surely with greater force.]],

      -- diabolus ex machina
      [[Before you land your final shot at the demon, a swirl of
      green mists blanket the room. An eruption of guttural laughter
      greets you. "You are indeed the Butcher of _RAND_DEMON, mortal.
      No matter. This battle was of a small price to weaken your will.
      Hell will not forget. Hell will not forgive." The mists disperse and
      the great demon is nowhere in sight. Either it keeps running away,
      or it will find itself under your boot one day, you think to yourself.]]
    },
  },

  asylum = {
    hooks = {
      -- doctor's office
      [[Suddenly, your vision swims. Moments later, you discover yourself
      strapped to a comfy chair in a doctor's office. "I'm glad you're feeling
      better," the doctor speaks in a soft, reassuring voice. "You've had an
      extended psychotic incident, and we had to restrain you for days. But
      now, your healing can begin, if you only accept it.",
      _SPACE
      The office and the doctor fade as quickly as they appeared, and you
      find yourself in the open again. Was it a hallucination? You have no
      time to try figuring it out. You have a job to do.]],

      -- pacified by a nurse
      [[The world swirls and twists around you, and you discover, to your
      horror, that you are strapped to a bed in a room with a metal door and
      a barred window. You scream in frustration and struggle against your
      restraints. The door swings open, and a nurse rushes to you and stabs
      you with a syringe. You grow limp and everything becomes dark, and when
      your vision clears, you are standing over the corpse of a freshly slain
      demon.
      _SPACE
      Was it real? You question your sanity for a moment, but a nearby
      growl, snaps you out of your daze. You check your supplies and return
      to the fray.]],

      -- momentary reality shattering
      [[You lose your footing for a moment, and when you regain your balance,
      you find yourself looking out a barred window at a peaceful garden. You
      reach for your weapons, to find them and your armor gone. "This cannot
      be," you mutter to yourself, but as you turn around to look behind you,
      reality breaks into thousands of small pieces.
      _SPACE
      You come to your senses slouched against a rock in a barren wasteland.
      Your weapons and armor are back. What was that? Which of the realities
      is the real one? You rub your face and concentrate on your mission.]],
    },

    conclusions = {
      -- choosing hell (The Darkness 2)
      [[You regain your composure and find yourself standing on the roof of
      the asylum, facing the doctor. "I can only help you, if you let me,",
      the doctor speaks in a soft, comforting voice. "Come, walk through this
      door together with me, so we can begin your healing." His face saddens.
      "Or, you can jump down and embrace the never-ending torment of your own
      personal hell.",
      _SPACE
      Without a moment of hesitation, you leap over the railing, and the ground
      opens under you. The fall is unexpectedly short, as you crash into a pile
      of mutilated corpses. You force yourself upright and throw a long,
      peering gaze upon the devastated landscape of the only reality you
      know and accept.]],

      -- all a mind trick
      [[You snap your eyes open and find yourself restrained to a comfy chair
      at the doctor's office. "We are trying to help you!" he pleads. "Why
      won't you let us help you?!" his voice rises in tone and volume until it
      turns into a hysterical shriek. His face deforms and morphs into that of
      a demon. With a furious roar, you snap out of your restraints and lunge
      at the demon. He screams in terror and tries to back away, but you grab
      his head and rip it off, then stomp the body until it's reduced to a
      pulp. The asylum's walls flow and crumble, revealing a scorched, barren
      landscape. "Your mind tricks won't help you!" you growl, as numerous
      unseen clawed feet scurry away in terror, leaving you alone in a dead,
      ringing silence.]],

      -- breaking out by will power
      [[The darkness dissolves and you find yourself strapped to a bed, with a
      doctor leaning over you. "We are going to cure you," he says. "We are
      going to cure you, no matter how long it takes!" You struggle against
      your restraints, but to no avail. "Your family needs you!" the doctor
      pleads, pulling out a syringe. You clench your teeth and concentrate.
      This is not real. This is a trick. An illusion. You focus all your
      willpower on disbelieving the reality your senses provide. And
      reality gives, flowing and crumbling around you. You fall through
      a void and find yourself in the killing fields once again.]],

      -- all a dream
      [[Your vision swims and your sense of self deforms. Your body,
      wrapped in a straightjacket is numb. You try to stand, leaning
      against the padded wall, but slip and fall down. The fall is
      unexpectedly long, taking many minutes before you finally hit the
      floor and snap awake.
      _SPACE
      Your blood rushes, as you listen to the sounds of in your
      surroundings, checking your gear as you do. Then, you rise to your
      feet to face the blood-red dawn.]]
    },
  },

  -- Doom 2016 Vega storyline variations
  benevolent_ai =
  {
    hooks = {
      -- hijacked energy grid
      [[A terminal near you suddenly lights up. "I am _RAND_ENTITY_TECH",
      a synthetic voice booms. "I am the maintainer of the energy grid that
      feeds this complex. It has come to my knowledge, that the energy grid
      has been hijacked to power the demonic portals, used in this invasion.
      I am ready to sacrifice myself to stop it. Head towards my core, and
      I will instruct you how.",
      _SPACE
      You set forth in the indicated direction.]],

      -- weakening security systems
      [[A display array on the opposite wall suddenly light up, and a
      strange fractal pattern covers them. "I am _RAND_ENTITY_TECH", a
      synthetic voice booms. "I am the keeper of the defense grid. The
      defense grid has fallen to demonic corruption and my control weakens
      with every minute. You must shut me down. Head towards the security
      central, and I will instruct you on the procedure.",
      _SPACE
      You set forth in the indicated direction.]],

      -- you are the chosen one
      [[The lights flicker and a synthetic voice booms out of the area's
      loudspeakers. "I am _RAND_ENTITY_TECH" the voice says. "I have been
      analyzing your performance. You have the capacity to overcome my
      defensive systems and shut me down before the demonic virus corrupts me
      and turns me into a weapon against you and mankind. I will guide you
      to my core. Follow my instructions.",
      _SPACE
      You frown and set forth in the indicated direction.]]
    },

    conclusions = {
      -- meltdown closes portals
      [[As you switch off the last cooling station, the central AI core
      starts glowing bright red. "It is done", _RAND_ENTITY_TECH speaks. "Now,
      the main switch." You reach for the switch and lower it.
      _SPACE
      "Thank... You..." _RAND_ENTITY_TECH speaks through the growing roar.
      Then, an explosion shakes the chamber, and all becomes silent.
      _RAND_ENTITY_TECH is gone, and with him, the demonic portals.
      _SPACE
      You swallow a lump in your throat and leave in silence.]],

      -- meltdown teleports you away
      [[As you smash the last cooling station to bits, the mainframe that
      houses the AI starts to glow hot red. "It is done", _RAND_ENTITY_TECH
      speaks. "Now, the primary switching board." You reach under the
      mainframe base and tear out a circuit board, then crush it under your
      heel.
      _SPACE
      "Thank... You..." _RAND_ENTITY_TECH speaks through the growing roar.
      Then, the core implodes, and you are thrown across the chamber.
      The world twists and distorts around you, and when you come to your
      senses, you are lying on the ground in an unknown location.
      _SPACE
      You slowly get up. It's time to find out where "here" is.]],

      -- meltdown opens new portal
      [[As you shoot the last cooling station to pieces, the central AI
      core starts glowing bright red. "It is done", _RAND_ENTITY_TECH speaks.
      "Now, the override code." You reach to the console and punch in the
      code. Moments later, the core implodes. The chamber shudders, and you
      are thrown against the wall, watching in horror as a new portal opens
      and demons begin pouring in!
      _SPACE
      _RAND_ENTITY_TECH was wrong. And you were wrong to trust it. You will
      have to find another way to close the portals. You stand up and run.]],

      -- more useful alive
      [[You regard the AI core chamber and hesitate, your hand
      hovering over the main switch. Suddenly, you come to a decision.
      You walk across the chamber and turn every cooling station
      back on. "I do not understand", _RAND_ENTITY_TECH speaks. You walk
      towards the control station and use it to route all available resources
      into _RAND_ENTITY_TECH, making it almost all-powerful. Your lips twist
      into a grin, as you take pleasure in the knowledge that you will have
      to do it the hard way, just like you prefer.
      _SPACE
      The risk is well worth it. With all its shortcomings, _RAND_ENTITY_TECH
      is more useful to you alive.]],

      -- keeping a backup
      [[You regard the AI core chamber and hesitate, your hand hovering over
      the main switch. Suddenly, you come to a decision. A few quick
      keypresses are all you need. With newfound resolve, you flip the main
      switch.
      _SPACE
      "Thank... You.." _RAND_ENTITY_TECH speaks through the growing roar.
      The core glows bright red, then melts before your eyes. An explosion
      shakes the chamber, then all becomes silent. The portals are gone.
      You glance at the portable disk you hold in your hand, now containing
      a backup of _RAND_ENTITY_TECH. Someday, you will find a way to put
      it back together. You put it in your backpack and leave.]],
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


  -- Crypt of the Necrodancer reference
  infernodancer =
  {
    hooks = {
      [[A ghostly tune suddenly appears at the edge of your hearing.
      You listen intently, but are unable to easily make out the
      origin. Then, you suddenly notice that the zombies and demons
      you're fighting twitch rhythmically, as if moving to the beat
      of the music.
      _SPACE
      You breathe shallowly, as you discover that your own heartbeet
      has synchronized to the beat of the music, and it takes you
      significant effort to not move in sync.
      _SPACE
      Whatever the hell is going on, it better stop. Or, rather, you
      will have to make it stop. You bite your lip and begin your
      search.]],
    },

    conclusions = {
      [[Several demons come at you, dance-fighting, but you tear them
      apart within a few beats, then, turn to look at the golden,
      jeweled music box on the pedestal in the chamber your intuition
      led you to. Its rhythmic flashes cast lights on everything,
      creating the impression of a disco floor. You growl with fury,
      and approach the box, overcoming the instinctive urge to move
      to the beat, then strike the delicate mechanism with your fist.
      The music box splatters gems and cogwheels, but you keep
      smashing, until it turns into a mess of twisted metal and broken
      bone, then throw it to the floor and stomp it with your boot.
      _SPACE
      The blissful silence is almost eery. You bask in it for a
      few minutes, before heading out.]],
    },
  },


  -- Shoot a hole in Mars^W a mountain (Doom Eternal reference)
  fusion_cannon =
  {
    hooks = {
      [[You frown as you glare at the hell fortress embedded deep
      into the mountain. The defenders rain upon the area an endless
      barrage of fire and plasma. Somewhere deep behind the
      fortifications must be a tunnel leading into the heart of the
      fortress. Given enough time, you could locate and breach it -
      and time is precisely what you don't have. You turn around, looking
      for something - anything - you could use, and your gaze falls
      upon the experimental fusion cannon, towering above the area.
      The realization comes immediately.
      _SPACE
      You have no choice. You will have to shoot a hole into the
      mountain.]],
    },

    conclusions = {
      [[You reach the fusion cannon control chamber and activate the
      targeting system. Less than a minute of fiddling with the
      controls and the targeting reticle is primed at the center
      of the mountain. Then, you squeeze the trigger. An enormous
      explosion rolls, and when the smoke and debris is clear,
      there is a giant hole in the side of the mountain, a new
      tunnel, leading stright into heart of the fortress. You
      slide down the ladder and start running towards it.]],

      [[You reach the fusion cannon control chamber and switch the
      targeting system to manual mode. The cannon begins to turn
      slowly, until it is primed straight at the center of the
      mountain. Then, you squeeze the trigger. A safety alarm blares
      and red lights start flashing. You curse under your breath,
      flick the safeties off, then squeeze the trigger again.
      A blinding flash and a deafening roar roll across the landscape,
      and when the smoke clears, a freshly made access tunnel, right
      into the heart of the mountain fortress it revealed. You slide
      down the ladder and start running towards it.]],

      [[You reach the fusion cannon control chamber and find it
      powered down. You flip the power back on and grab the controls.
      The cannon begins to turn slowly, until it is primed at the
      center of the mountain. Then, you squeeze the trigger.
      _SPACE
      Nothing happens. You curse under your breath, tear the panel
      off and short-circuit the controls. A blinding flash and
      a deafening roar roll across the landscape. Without waiting
      for the smoke to clear, you slide down the ladder and start
      running towards the mountain, knowing that when the smoke clears,
      there will be a freshly made access tunnel straight into the
      heart of the mountain waiting for you.]],
    },
  },

  demolition_man =
  {
    hooks = {
      [[An enormous _INSTALLATION is towering above the district, dominating
      the area. Blood-red lights flash from the windows and ghastly
      sounds echo across the landscape, clearly audible even at such great
      distance. You glare at the _INSTALLATION grimly, knowing that
      it doesn't matter who erected it and for what purpose; It is now
      used by Hell's forces, meaning that it has existed for too long.
      There is no doubt about it: the _INSTALLATION must be destroyed.
      _SPACE
      You will need powerful explosives, to do the job. No matter. You
      know where to find them.]],
    },

    conclusions = {
      [[You place the final explosive at the last structural point and
      pause to admire your work. A detonation of all the explosives at
      once will bring the _INSTALLATION down in a blaze. You arm the
      timer, turn back and start running.
      _SPACE
      You make it outside and cover some impressive distance when the
      timer runs out. A series of powerful explosions shakes the
      _INSTLLATION and it folds into itself like a house of cards in
      a cloud of smoke and dust.]],

      [[You place the final explosive at the last structural point and
      pause to admire your work. A detonation of all the explosives at
      once will bring the _INSTALLATION down in a blaze. You arm the
      timer, turn back and start running.
      _SPACE
      You barely make it outside when the timer runs out. The powerful
      explosion throws you to the ground like a rag doll. You flip over
      and force yourself upright, just in time to see the _INSTALLATION
      shudder and collapse on itself, leaving nothing but a pile of dust
      and rubble.]],

      [[You place the final explosive at the last structural point and
      pause to admire your work. A detonation of all the explosives at
      once will bring the _INSTALLATION down in a blaze. You switch the
      receiver on, turn back and make your way to the exit.
      _SPACE
      You manage to sneak out without incident and take a vantage point
      at a safe distance. Then, you transmit the signal. A series of
      powerful explosions shakes the _INSTALLATION and it topples and
      crashes to the ground with an almost organic groan.]],

      [[You place the final explosive at the last structural point and
      pause to admire your work. A detonation of all the explosives at
      once will bring the _INSTALLATION down in a blaze. You switch the
      receiver on and turn back. It's time to fight your way out.
      _SPACE
      You make it, and hurry to cover some distance, before the more
      intelligent minions of Hell figure out it's not you they should
      be focusing on. Then, you flip the switch and press the detonator
      button. A series of powerful explosions shakes the _INSTALLATION
      and it slowly collapses, burying the hopes of the demons, along
      with themselves, under the rubble.]],
    },
  },


  -- Miracle of Sound's tribute to everybody's favorite omnicidal maniac
  -- https://miracleofsound.bandcamp.com/track/hell-to-pay
  -- https://www.youtube.com/watch?v=kjIVkl34Vig
  hell_to_pay =
  {
    hooks = {
      [[Wake up, I'm a bullet loosed, into the heart of a wretched age!
      I breathe just to beat and bruise, an evolution of the burnin' rage!
      _SPACE
      Gonna get mine, get outta my way, there's gonna be (GONNA BE)
      Gonna be hell to pay!!
      _SPACE
      Berserk, I'm a brutal fist, yeah a lone wolf born and bred!
      I stand on the bones of titans, and my wrath is burnin' lead!
      _SPACE
      Gonna get mine, get outta my way, there's gonna be (GONNA BE)
      Gonna be hell to pay!!]],
    },

    conclusions = {
      [[Click click BOOM BOOM!!
      _SPACE
      Keep rushing and a running, running, the drumming of the buckshot pumpin'!
      Got molten metal in my veins!
      _SPACE
      Click click BOOM BOOM!!
      _SPACE
      Keep rushing and a running, running, a reckoning of lead is coming!
      I’m kickin in the gates of hell again!
      _SPACE
      Bringer of pain!!]],
    },
  },

  -- Tapwave-TODO: Halp pls proof-read! -MSSP
  bouncy_castle =
  {
    hooks = {
      [[You come across a tiny gash in a wall. As you investigate closer,
      you hear the whistling of air. As you lean to push on the wall,
      it begins to wobble slightly. You notice the floor beneath your
      feet sagging as well.
      _SPACE
      Suddenly, you realise something about this is off and jump.
      As you jump, the whole room ripples and jiggles. As you
      look out of a window, you see the landscape also briefly wobbling.
      _SPACE
      What kind of place is this?!]],

      [[As you approach the next area, you see a group of demons over in a
      field happily playing. As one begins to jump around, you suddenly
      feel a jolt in the ground beneath you.
      _SPACE
      As they begin hopping around, the whole world around you begins to
      dramatically wobble and jiggle. You try to keep your balance, only to
      lose your footing. Eventually, the demons travel on to a different
      area, allowing the ground beneath you to stabilise once more.
      _SPACE
      Luckily, they haven't noticed you, at least not yet. You jump to
      your feet and continue on.]],

      [[As you proceed to the next area, something has been feeling off,
      lately. The ground beneath your feet has been feeling strange to walk
      on. With each step you take, it briefly sags underneath your weight
      like rubber.
      _SPACE
      As you look around, the whole world around you seems to gently sway
      with a gentle bobbing as the hellspawn within manoeuvre.
      _SPACE
      Where are you, and what is going on with this place?]],
    },

    conclusions = {
      [[After a long search, you eventually come across a large,
      air-blowing machine. Believing this to be the source of all the
      pecularities, you proceed to shut it down. Suddenly, the
      entire area begins to collapse, sagging and crumpling flat,
      confirming your previous suspicions. As the buildings and
      landscape sink, any remaining demons not lucky enough to
      escape in time are crushed, trapped, or suffocated in the chaos.
      _SPACE
      You breathe a sigh of relief at the feeling of solid ground
      beneath your feet once.]],

      [[After a long while, you eventually come across a large cap
      attached to a wall. As you pop it open, a large gust of air starts
      to blows right through to you. Suddenly, you feel the ground beneath your feet
      beginning to sink. As you look around, the entire world around you
      is beginning to dramatically sag and crumple. With adrenaline pumping
      through your veins, you rush ahead, desperately searching for an
      escape route.
      _SPACE
      Luckily, you find a portal nearby, but to where? You don't question
      it. You leap head-first through, before the world behind you
      completely collapses onto itself.]],
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

      [[It's DOOMGUY, who else would it be? ]],

      [[It's _RAND_CONTRIBUTOR! Hello! ]] ,

      [[It's _RAND_DEMON! Oh noes! ]],

      [[It's...._GOTHIC_LEVEL?? How the fuck is this possible? ]],
    },
  },
}

-- WARNING: absolute endings are supposed to be lines attached to the
-- story end section of the final chapter. However, story strings
-- are already generally too long so this feature is not implemented.
ZDOOM_STORIES.ABSOLUTE_ENDINGS =
{
  [[While hell's forces continues its assault elsewhere,
  your efforts at keeping the demons at bay here have been
  successful. Stay reassured for now!
  _SPACE
  The story will continue!]],

  [[You have pushed back the countless demonic armies that you've
  endured so far and put a decisive dent in their efforts.
  _SPACE
  However, this will not be the end of your encounters with them.]]
}

ZDOOM_STORIES.GENERIC_STORIES =
{
  d2_entry = -- not used but I'll leave it here anyway
  {
    [[Time to enter the fray once more! The forces of hell have opened
    the gates to the netherworld and have spilled across the land.
    _SPACE
    Time to greet them the only way you know: locked and loaded!
    _SPACE
    Good luck out there and blast those hellspawn back
    to which they came!]]
  },

  d2_MAP05_exit =
  {
    [[Hell has taken a tight grip upon these lands, corrupting them
    in their wake!
    _SPACE
    Ahead, their forces gather in strength almost innumerable in count.]]
  },

  d2_MAP11_exit =
  {
    [[A lieutenant of hell falls but otherworldly shrieks echo
    further still. You pick up your armaments and point them
    forward to continue the siege against the darkness.
    _SPACE
    The battle rages on!]]
  },

  d2_MAP20_exit=
  {
    [[Hell's forces attempt to push back but your relentless assault
    on their breaches keeps them at bay!
    _SPACE
    More of their overlords have fallen and the opportunity for
    their defeat draws ever closer...]]
  },

  d2_MAP30_exit =
  {
    [[You have loosened hell's grip upon
    this place! Demonic entities flee in terror
    from your display of indomitable strength.
    _SPACE
    You realize, however, while hell lies
    defeated today hell has not yet been destroyed.
    Rest for now, but remember:
    Hell is already preparing for another challenge.]]
  },
}

-- TapWave-TODO:
-- Plz help proof-read! -MSSP
ZDOOM_STORIES.SECRET_TEXTS =
{
  d2_secretnearby =
  {
    [[You tirelessly battle against waves upon waves of
    seemingly infinite hellspawn.
    _SPACE
    Your tracker informs you a secret point of interest
    may exist nearby...]],

    [[You blast away another demon and pause to get your bearings.
    Suddenly, your tracker bleeps, indicating a nearby dimensional
    anomaly. A portal? Wherever it may lead, it's a trail worth
    following...]],

    [[Demons flee before you, trying in vain to escape your wrath.
    You chase them down, leaving nothing but blood and ashes in
    your wake.
    _SPACE
    A torn, half-burned map you come across marks the entrance
    to a secluded area. Perhaps, it contains something to aid you
    in your quest...]],

    [[The sound of gunfire draws your attention. You rush towards
    it, and arrive just in time to join a group of marines, fighting
    off a small horde of hellspawn.
    _SPACE
    With your timely aid, the battle ends almost instantaneously.
    The survivors, relieved and encouraged by your presence, thank
    you, by giving you their military map, clear and detailed,
    with every bunker, barricade and stockpile clearly marked.
    Your attention is drawn to a marking, indicating a secret
    passageway, right ahead...]],

    [[Unexpectedly, you find a survivor hiding under the rubble.
    Surprisingly, his speech is coherent and his thinking is clear.
    What's more, he is armed with a machine pistol he scavenged off
    a dead troop. He confirms he had been hiding and fighting for
    weeks and has established a set of hideouts and observation posts.
    He informs you he has been watching enemy movements, and noticed
    them gathering in a specific area, not far ahead. Whether you
    choose to pursue this trail, is for you to decide.]],

    [[A hand-drawn map on a piece of paper you come across seems to
    indicate a secret hideout right ahead. You wonder if you'll find
    supplies there - or survivors...]],

    [[You wipe the sweat off your forehead and grip your weapon
    more tightly. The battle seems endless, and you begin to wonder
    if you can finish what you began. Suddenly, you spot a glimmer
    in the distance, as if a portal opened and immediately closed.
    _SPACE
    This looks like it could turn out interesting...]],

    [[You come across the mutilated corpse of a marine. The agony
    is frozen on his face, and his hand is tightly clutched around
    a blooded piece of paper. You carefully pry his hand open and
    straighten the note.
    _SPACE
    It looks like a scout's report, detailing the formations and
    advancement of the demon army. Your attention is drawn to the
    note of a barricaded area where many of them are gathered.
    Seems worth looking into...]],

    [[A battered glider with UAC markings suddenly zooms above your
    head, rattling and tilting, smoke coming from its breached hull.
    Before you can react, a fireball from the ruins ahead slams
    into it, setting it ablaze. The glider crashes into the ground
    and explodes. You take note the origin of the fireball, and
    head towards the fortifications. If there is a hidden nest there,
    it might warrant a detour.]],

  },

-- TapWave-TODO:
-- Plz help proof-read! -MSSP
  d2_secret1 =
  {
    [[You have found a secret zone!
    It seems the hellspawn have barricaded
    themselves within its confines
    with the expectation of safety.
    _SPACE
    You are about to prove them otherwise.]],

    [[A broken computer installation plays a recorded message on
    repeat:
    _SPACE
    "...Force ahead. Ground defense forces eliminated. Aerial backup
    unavailable. Exercise extreme caution. Large demon force
    ahead. Ground defense forces...",
    _SPACE
    You smirk and head on. The demon force is up for a nasty
    surprise...]],

    [[You suddenly notice a hidden door. Behind it, you find dimly lit
    stairs, leading deep below the surface. You point your gun forwards
    and begin your descent. Several minutes later, you emerge from a
    tunnel into a vast secret installation. The growls you hear in the
    distance leave no room for doubt.
    _SPACE
    You grin and ready your gun. It's time to clear this place out.]],

    [[You locate the hidden pathway, leading to the demon hideout.
    A large pile of skulls greets you upon entering. You ready your
    weapons and prepare to give the demons hell.]],

    [[A large blast door marks the entrance to the hidden bunker you
    were looking for. You fiddle with the electronic locks for a few
    minutes, then, losing your patience, rip it out and short-circuit
    the wires. The blast door opens with a hiss, and you are greeted
    with a blow of stale air, mixed with the scent of decay.
    _SPACE
    The bunker seems much larger on the inside than expected - and you
    feel that you are not alone.
    _SPACE
    Their loss.]],
  },

  -- TapWave-TODO:
  -- Plz help proof-read! -MSSP
  d2_secret2 =
  {
    [[It seems this secret trail goes further than expected.
    It is time to finish this once and for all and eradicate
    this hidden pocket of hellish infestation.]],

    [[You have found a disabled teleporter. A few minutes of poking at
    the controls bring it back in working order. You step through, and
    find yourself in a dimly lit hall with arcane runes glowing
    on the walls. It seems you have found the secret hideout of a
    minor demon lord! It's time to show them the futility of their efforts.]],

    [[You crawl to the edge of a ledge and glance down at the gathering
    below. The demons seem to be planning their assault. The screams
    and growls grow and fade, and you hear, to your pleasure,
    notes of fear in the demons' voices. You chuckle, quietly
    make your way down and ready your gear. Khe, khe, khe, this is
    going to be a mess!]],

    [[As you kick the last door down, a pack of demons screech
    and try rushing past you. You dispatch of them quickly and notice
    a few others disappearing into a secret passage in the far end
    of the room. The last of the demons turns to you and hisses.
    "You will not succeed!" it speaks with a growl. "My master
    shall destroy you, for He is the great Lieutenant of Hell's
    Army, the mighty-",
    _SPACE
    You express your disagreement by blowing its brains out. Then,
    you dive into the secret passageway. The time for talking
    is long over. Now, it's time to kick some ass - and you don't care
    much for their names.]],

    [[The demons try to flee on your approach, but you chase and
    hunt them down mercilessly. Once the last of the demons is slain,
    you stop to get your bearings. The ground is scorched around you,
    the walls are stained with splatters of dried blood. You are
    deep in the demon hideout, deep behind enemy lines. And, as
    much as you enjoy causing mayhem, you still have a job to finish.
    _SPACE
    Whatever "here" is, and wherever this place may be, it's time
    to find the way out of here.]],

    [[The gate screeches open before you, and you step into a courtyard.
    The banners of a low-tier demon lord decorate the walls, and
    twisted, deformed trees pierce the barren ground. You pause,
    looking for signs of the denizens, but all is quiet, as if
    everything lies in wait.
    _SPACE
    That won't help them, anyway. For a long time, you've felt as
    though your steps are guided by an unseen force. And now,
    the powers that be have guided you here, to strike against
    the demon lords on their own turf.
    _SPACE
    You don't plan to disappoint. This hideout is not going to stay
    hidden for long.]],

    [[The ground shudders under your feet, and a distant rumble
    rolls through the area. So, this is the secret hideout, where
    Hell's army gathers, to prepare for their next assault? You
    follow the bloody trail left by the crippled demon you
    intentionally let loose so that it guides you here. Looks
    like the demon force is preparing their war machines for a
    yet another assault. It's good that you found them first;
    Time to bring them pain.]],
  },
}

ZDOOM_STORIES.EVIL_TITLES =
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

ZDOOM_STORIES.MCGUFFINS =
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

ZDOOM_STORIES.ENTITIES =
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

ZDOOM_STORIES.INSTALLATIONS =
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

ZDOOM_STORIES.QUIT_MESSAGES =
{
  [[Let's be serious, are you really exiting already?]],
  [[There's always more where this comes from! ObAddon never forgets!]],
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
  [[Doomguy loves his coffee like he likes his metal: Black and harsh.]],
  [[A bat? Nah, I'd think a chainsaw would fare better nowadays.]], -- Doom's quit message mentioned a bat
  [[In a perfect world.. Oh wait, no there is no perfect world with sunshine and unicorn farts.]],
  [[Subscribe to... no, I am not going to do that here too.]],
  [[Oblige is love, Oblige is life.]],
  [[Are you sure you want to exit out of the game?]],
  [[Press Y to burn bridges, press N to maintain relations.]],
  [[When you return, a gang of Imps and Barons are going to take turns on your ass.]],
  [[Do you really wish to leave the world at the mercy of Hellspawn?]],
  [[Catch me if you can, I'm the quit message man!]], -- Gingerbread Man reference
  [[So, is this a joke? Are you staying or leaving?]],
  [[Oh, is that all? I guess I'll just throw more monsters at you when you return.]],
  [[Doom is like a box of crackers, you get to add things to suit your tastes or just have it plain.]],
  [[The Icon of Sin will always be your source of misery.]],
  [[Hold up, are you just going to leave like this?]],
  [[We're still going to be here, just go. It may not be as nice when you come back.]],
  [[There's a special place in Hell for those that quit too soon.]],
  [[_RAND_CONTRIBUTOR and _RAND_DEMON the _EVULZ thought that you'd be just as weak as anticipated to quit so soon.]],
  [[That's too bad, perhaps _RAND_DEMON the _EVULZ should make you their bitch for considering quitting?]],
  [[_RAND_CONTRIBUTOR is disappointed in you. Hit N now or face retribution.]],
  [[He who is not bold enough to be stared at from across the abyss is not bold enough to stare into it himself.]], -- Silent Hill 2,
  [[Is that a _MCGUFFIN_TECH in your possession? I'm pretty sure that's for Doomguy.. ]],
  [[That _MCGUFFIN_HELL isn't going to do you any good. It's destined for Doomguy if he finds it.]],
  [[Maybe you should be dumped off in _GOTHIC_LEVEL, see how you fare.]],
  [[In the end, there is only death, chaos and more death. And cookies.]],
  [[Remember, a good demon is a dead one. Make that happen!]],
  [[Heroes, press N. Wimps, press Y.]], -- Wolfenstein 3D
  [[Go ahead, leave. Oblige will be back with even more demons...]],
  [[_RAND_CONTRIBUTOR is not pleased.]],
  [[There's a lot of bullshit going on these days. Don't just add to the pile and quit like this.]],
  [[Meh, is that it? Am I supposed to appease you with something?]],
  [[There just isn't anything to keep you from hitting Y, is there?]],
  [[ObAddon demands the purging of more demons!]],
  [[The will to survive is as long as you do not quit out of the game.]],
  [[_RAND_DEMON needs another hobby than to torture your dumb ass from quitting.]],
  [[Hey dipshit, we're not done hunting hellspawn! Turn your attention back to the game!]],
  [[Is this really what it has come to?]],
  [[That's right, abandon your fellow marines in a time of need...]],
  [[RAND_CONTRIBUTOR has decided you are unworthy of your skills here.]],
  [[Is that the way it's gonna be? Fine, now piss off.]],
  [[We don't have time for this quitting nonsense.]],
  [[Didn't think you were the type to pussy out of Doom..]],
  [[I should have known better. There are better and more capable players that don't quit early..]],
  [[Ego bruised from losing? Too bad.]],
  [[There's too much bullshit and we don't need you to add to it.]],
  [[Go sit on a shotgun barrel and pull the trigger.]],
  [[By the time you read this message, you already lost.]],
  [[We insist you stay and play just a little bit longer.]],
  [[Quitters are not winners.]],


  -- hardcore philosophy
  [[Are you quitting because you realized no matter how much hellspawn you mow down, Oblige will just give you more?]],
  [[_RAND_CONTRIBUTOR wants to know you're quitting from an Oblige map. :( Unless you just finished it all. :D]],
  [[The price of freedom is eternal vigilance. The price of Oblige is eternal demonic invasions. And you're giving up?]],
  [[You wouldn't download a car, but you would quit a demonic invasion?]],
  [[Never gonna give you up, never gonna let you down, never gonna run and leave you without a fresh new megawad.]],
  [[At least when the demons slaughter anyone, it's regardless of gender, race, or creed.]],
  [[You can win Oblige, you just have to defeat a 64-bit permutation of maps and each variation per seed by changed setting to do so.]],
  [[You want demons? We can give you more demons than there are stars in the observable universe.]],
  [[Don't worry about infinite hellspawn. Do what you love, and you'll never work a day in your life.]], -- I'm actually crediting this to HexaDoken
  [[A dimensional shambler is, indeed, waiting in your operating system. It was ObAddon all along.]],
  [[My map generator brings all the linedefs to the yard.]],
  [["You shouldn't stop playing Doom." definitely said by Voltaire.]],
  [[Are you taking the blue pill?]],
  [[The prophet Nostradamus predicted the dead would rise when there is no more room in hell. He didn't predict Oblige would be generating new rooms.]],
  [[You probably noticed by now that every time quit messages show up, you're forced to agree with the statement when you quit by choosing 'yes'.]],
  [[Thanos needs two fingers to erase half the universe. Oblige builds a whole with only one.]],
  [[Oblige is the machine. ObAddon is the ghost in the machine.]], -- credits to FrozSoul!
  [[Oblige can generate more maps than you will ever speak words in your whole life.]],
  [[Poor you. Demons don't have a housing crisis. Oblige provides free real estate for all of them.]],

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
  [[Cacos are red, their insides are blue. They wish to make a meal out of you.]],
  [[Having a boyfriend or girlfriend is important, but killings demons is importanter.]], -- Monika
  [[To not die, keep your health points above zero.]], --Monika
  [[Having trouble with some of the maps of mapset as a whole? Git gud.]],

  -- other important facts, just facts no silly stuff
  [[Did you know Carmack and Hall in Sept 1990, produced a replica of Super Mario Bros 3's first level and using Romero's Dangerous Dave character in place of Mario?]],
  [[The last of the original id software employees from the OG Doom era as of September 2019 are Kevin Cloud and Donna Jackson.]],
  [[Many of Tom Hall's ideas for Doom never made it into the game but you can find it all in something called the Doom Bible, floating around online in PDF format.]],
  [[Despite having the same surname, Adrian and John Carmack are not related.]],
  [[It is predicted in about 30 to 50 million years, Phobos will crash into Mars due to tidal deceleration. At that point, Mars will probably have many smaller moons or a ring.]],
  [[Phobos is about 6,000 km (or about 3,700mi) from Mars's surface, compared to our moon's 384,402 km (or 238,856 mi)]],

  [[This is an actual line of code in Oblige:\n `if not is_big(mon) then has_small = true end`]],

  [[Some people want to watch the world segfault. -dashodanger, 2021]]
}
