------------------------------------------------------------------------
--  Name Generator
------------------------------------------------------------------------
--
--  Oblige Level Maker // ObAddon
--
--  Copyright (C) 2008-2018 Andrew Apted
--  Copyright (C) 2008-2009 Jon Vail
--  Copyright (C)      2009 Enhas
--  Copyright (C) 2010-2021 Armaetus
--  Copyright (C) 2021 MsrSgtShooterPerson
--  Copyright (C) 2020 EpicTyphlosion
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
--
--  Thanks to Jon Vail (a.k.a JohnnyRancid/40oz) who contributed
--  many of the complete level names and lots of cool words.
--
--  Thanks to Enhas and Chris for their additions.
--
------------------------------------------------------------------------

namelib = {}


namelib.NAMES =
{
  COMMON =
  {
    -- these words and patterns are shared by all themes

    -- FIXME...

    lexicon =
    {
      x =
      {
        -- a new table... for suffixes! -MSSP
        ["Annihilated"]=10,
        ["Avenged"]=10,
        ["Breaks Loose"]=10,
        ["Destroyed"]=10,
        ["Gone Bad"]=10,
        ["Reboot"]=10,
        ["Redux"]=10,
        ["Revisited"]=10,
        ["the Way ObAddon Did"]=10,
        [": The Return"]=10,
        ["is Back"]=10,

        -- these from Frozsoul
        [": The Next Generation"]=10

      },

      -- Why not some level names common in all themes?
      -- Also, how do we keep 'Common' theme full names
      -- from not being in more than one theme?
      -- -Armaetus, 12/30/20,

      -- Another side note, please keep future definitions
      -- in alphabetical order for those who add more to this
      -- besides me lol
      -- Armaetus, 2/6/21,

      s =
      {
        ["A Walk on Thin Ice"]=10,
        ["Alternative Means"]=10,
        ["Annihilation"]=10,
        ["Armaetus Loves Naming"]=10, -- Bahaha!
        ["Ascent into Madness"]=10,
        ["Backstabbed"]=10,
        ["Black Skies"]=10,
        ["Blown to Bits"]=10,
        ["Choirs of Progress"]=10,
        ["Compromised"]=10,
        ["Complete Breakdown"]=10,
        ["Concrete Retribution"]=10,
        ["Converging Hex Sequence"]=10,
        ["Dead Men's Choir"]=10,
        ["Duality of Entropy"]=10,
        ["Dulling of the Senses"]=10,
        ["Empty Echo"]=10,
        ["Fading into Obscurity"]=10,
        ["Finding The Path"]=10,
        ["Final Suffering"]=10,
        ["Fire With Fire"]=10,
        ["Fueling the Flames"]=10,
        ["Genocidal Delusions"]=10,
        ["Go Fuck Yourself"]=10, -- Sunlust MAP29.
        ["Headshot"]=10,
        ["Into the Fog"]=10,
        ["Liquid Violence"]=10,
        ["Lost in Apathy"]=10,
        ["Memories from the Surface"]=10,
        ["Negative Inverted Sphere"]=10,
        ["Never Forgive, Never Forget"]=10,
        ["Never Give Up"]=10,
        ["Nothing But Lies"]=10,
        ["Nowhere"]=10,
        ["No Violence, No Progress"]=10,
        ["Out of Touch"]=10,
        ["Parallel Tribulation"]=10,
        ["Passing Through"]=10,
        ["Plausable Fear"]=10,
        ["Revelations of Doom"]=10, -- Also a Hellhammer song title
        ["Spiraling Uncertainity"]=10,
        ["The Fourth Dimension"]=10, -- Hypocrisy song and album title
        ["The Marine Element"]=10,
        ["The Unknown"]=10,
        ["Through the Looking Glass"]=10,
        ["Where Demons Roam"]=10,
        ["Within the Mirror"]=10,
        ["Woeful Unknown"]=10,
        ["Zero Null"]=10,

        -- Single word descriptions, typically work (IE Fear for E4M9)
        -- Usually adjectives or verbs, mostly negative.
        ["Absolution"]=10,
        ["Agony"]=10,
        ["Anguish"]=10,
        ["Atonement"]=10,
        ["Betrayal"]=10,
        ["Chaos"]=10,
        ["Contempt"]=10,
        ["Cowardice"]=10,
        ["Deconstruction"]=10,
        ["Dehumanized"]=10,
        ["Despair"]=10,
        ["Desperation"]=10,
        ["Dismay"]=10,
        ["Doubt"]=10,
        ["Drained"]=10,
        ["Dread"]=10,
        ["Envy"]=10,
        ["Evil"]=10,
        ["Fear"]=10, -- Why not?
        ["Fury"]=10,
        ["Guilt"]=10,
        ["Hatred"]=10,
        ["Misery"]=10,
        ["Nihility"]=10,
        ["Numb"]=10,
        ["Pain"]=10,
        ["Possession"]=10,
        ["Purity"]=10,
        ["Redemption"]=10,
        ["Resentment"]=10,
        ["Revulsion"]=10,
        ["Seclusion"]=10,
        ["Spite"]=10,
        ["Terror"]=10,
        ["Turmoil"]=10,
        ["Wasted"]=10,
        ["Woe"]=10,
        ["Wrath"]=10
      },

      v =
      {
        ["Curse of the"]=10,

        -- these from flyingdeath
        ["Enter the"]=10,
        ["Welcome to the"]=10,
        ["Escape the"]=10,
        ["Flight from the"]=5,
        ["Journey to the"]=10,
        ["Assault on the"]=15,
        ["Death Awaits in the"]=5,
        ["Oh God Not Another"]=5,
        ["Yet Another"]=5,
        ["Just Another"]=5,
        ["Hell in the"]=5,

        -- these by Armaetus
        ["Fear the"]=10,
        ["Beware the"]=10,
        ["Bane of the"]=10,
        ["Scourge of the"]=10,
        ["Ordeal of the"]=10,
        ["Calamity in the"]=10,
        ["Misdeed by the"]=10,
        ["Dread the"]=10,
        ["Shun the"]=10,
        ["Plague of the"]=10,
        ["Pain from the"]=10,
        ["Death in the"]=10,
        ["Oh Dear Not Another"]=10,
        ["Chaos in the"]=10,

        ["It's Totally Another"]=10,
        ["Adventure to the"]=10,
        ["A Jaunt to the"]=10,

        -- More annoyed types by Armaetus
        ["Just stop with the"]=5,
        ["Fuck off with the"]=5,
        ["No, not another"]=5,
        ["Great, it's another"]=5,
        ["Great, another"]=5,
        ["Enough with the"]=5,
        ["Meh, another"]=5,
        ["Come on, another"]=5,
        ["Eh, it's just a"]=5,
        ["Oh, it's another"]=5,
        ["Why another"]=5,
        ["Piss off with the"]=5,
        ["Wait, why another"]=5,
        ["Good lord, another"]=5,

        -- 2021 additions!
        ["Really, another"]=5,
        ["Wow, another"]=5,

        -- these by MSSP
        ["Battle for the"]=15,
        ["Battle through the"]=10,
        ["Into the"]=10,
        ["Operation"]=10,
        ["Mission"]=7,
        ["Objective:"]=7,
        ["Counterattack in the"]=7,
        ["Ambush in the"]=7,
        ["Get to da"]=3, -- CHOPPAH!!!
        ["War of the"]=10,
        ["Return to"]=10,
        ["Return to the"]=10,

        ["Raze the"]=8,

        -- these by Frozsoul
        ["Revenge of the"]=10,

        -- command-like prefixes, some by Dante
        ["Attack the"]=10,
        ["Destroy the"]=10,
        --["Shut Down the"]=15,
        --["Patrol the"]=15,
        ["Secure the"]=10
        --["Clear this"]=5,
        --["Defend this"]=10,

        -- ^^^ Some of these sound pretty decent
        -- so I enabled them. Things like shutting down
        -- patrolling, defending, etc. are too explicit.
        -- MSSP
      }
    },

    divisors =
    {
      a = 10,   --\
      b = 10,   -- adjectives
      h = 10,   --/

      n = 50,   -- noun: Base, Station, City (etc)
      m = 3,    -- monster name: Demon, Imp, Mummy (etc)
      e = 3,    -- evil being: Satan (etc)

      t = 1,    -- article: The XX
      v = 20,   -- phrase before a noun: Curse of the XX
      x = 20,   -- phrase AFTER a noun: XX the Way ObAddon Did
      r = 40,

      s = 1000  -- single complete names
    }
  },
  -- end of 'COMMON' theme


  --------------------------------------------------

  TECH =
  {
    patterns =
    {
      ["%a %n"]    = 65,
      ["%b %n"]    = 65,
      ["%a %b %n"] = 33,

      ["%t %a %n"]    = 17,
      ["%t %b %n"]    = 17,
      ["%t %a %b %n"] = 5,

      ["%a %n %x"]    = 17,
      ["%b %n %x"]    = 17,
      ["%a %b %n %x"] = 5,

      ["%v %n"]    = 24,
      ["%v %a %n"] = 24,
      ["%v %b %n"] = 24,

      -- numericals
      ["%a %n NOUNSERIAL"] = 26,
      ["%b %n NOUNSERIAL"] = 26,
      ["%a %b %n NOUNSERIAL"] = 18,

--[[
      ["%r the %n"] = 12,
      ["%r the %a %n"] = 12,
      ["%r the %b %n"] = 12,
--]]

      ["%s"] = 25
    },

    lexicon =
    {
      t =
      {
        The=50
      },

      r =
      {
        Find = 10,
        Activate = 10,
        Reactivate = 20,
        Deactivate = 20,
        ["Turn on"] = 5,
        ["Turn off"] = 5
      },

      a =
      {
        -- size
        --+ large
        Universal=20, Colossal=20, Prodigious=3,
        Vast=10, Large=4, Massive=7, Gigantic=10,
        --+ small
        Secluded=10, Confined=5, Restricted=3,
        Cramped=5, Narrow=5, Tiny=5, Microscopic=3,

        -- location
        --+ generic
        Subterrestrial=10, Sub_terra=5,
        Aethereal=10, Hypogean=5,
        --+ solar system objects
        Mars=10, Saturn=10, Jupiter=10, Venus=10,
        Europa=5, Ganymede=5, Dione=5, Io=5,
        Callisto=5, Hyperion=5, Vesta=5, Pluto=5,
        Titan=3, Ceres=3, Eris=3, Charon=3,

        Experimental=3, Covert=20,

        --+ directions
        Northern=3, Southern=3, Eastern=3, Western=3,
        Upper=10, Lower=10, Central=15,
        Inner=10, Outer=10, Innermost=3, Outermost=3,
        Exterior=10, Subsidiary=3,
        Interior=5, Internal=10,
        --+ relative position
        Adjacent=5, Adjoining=5, Neighboring=5,
        Inland=5, Outland=5,
        --+ cardinality
        Preliminary=3, Ultimate=3,
        Auxiliary=10, Primary=20,
        Prime=5, Secondary=7, Tertiary=7,
        Backup=5, Alternate=5, Ancillary=5,
        Reserve=5, Support=7,

        -- inert conditions
        Inactive=10, Unsound=10, Eternal=5,
        Advanced=10, Interlock=5, Symbiotic=3,
        Inert=4, Dormant=10,

        -- bad conditions
        Destructive=20, Unstable=10, Devastated=3,
        Lost=20, Defective=10, Haggard=15, Failed=10,
        Ravished=10, Inanimate=3, Ruptured=3,
        Polluted=10, Putrid=5, Faulty=5,
        Troublesome=10, Obsolete=15, Abandoned=15,
        Occult=10,

        -- stuff you might say when you see something cool
        Fantastic=3, Incredible=3, Amazing=3,
        Wondrous=3, Awesome=3,

        -- infestation
        Monstrous=10, Fatal=10, Invaded=3, Overtaken=3,
        Abberant=10, Internecine=10, Noxious=10, Subnormal=10,
        Infested=20, Anomalous=5, Ghostly=10, Lurid=3,
        Subverted=15, Corrupted=7, Contaminated=5, Degraded=7,
        Congested=10, Swarming=10, Pestilential=5, Nefarious=10,

        -- descriptive: negative
        Extreme=20, Depraved=10, Unnatural=10, Messianic=3,
        Dark=20, Treacherous=10, Frigid=3,
        Deconditioned=10, Dismal=5, Dreaded=5, Cold=10,
        Perverted=5, Doomed=10,

        -- descriptive: techy
        Cybernetic=5, Focused=5, Plasmatic=5,

        -- ObAddon contributor names
        NOUNMEMBERS = 50,

        -- special tag for the name generator
        NOUNGENEXOTIC = 400,
        NOUNGENANGLICAN = 400
      },

      b =
      {
        -- purpose
        --+ administrative
        Control=10, Management=5, Foundation=5,
        --+ science
        Research=10, Development=5, ["Rogue A.I."]=5,
        --+ military
        Military=10, Security=5, Defense=5,
        Aegis=3, Stockade=3, ["Planetary Defense"]=5,
        --+ manufacturing
        Manufacturing=3, Maintenance=3,
        Industrial=3, Engineering=5,
        Processing=10, Refueling=5, Supply=15,
        Construction=5, Assembly=5,
        --+ residential
        Refuge=5, Pods=5,

        -- utility
        --+ storage
        Support=5, Holding=5, Loading=5,
        Quarantine=5, Shipment=5, Staging=5,
        --+ manufacturing
        Testing=5, Authorization=5, Administration=5,
        Synthesis=5, Unification=3,
        --+ waste
        Drainage=5, Disposal=5, Dumping=3, Disperser=5,
        --+ resources
        Pumping=4, Irrigation=3,
        Cooling=5, Coolant=5, Hydroponics=5,
        --+ infrastructure
        Mobilization=3, Transfer=3,
        Distribution=5, Trafficking=5,
        --+ military
        Operations=5, Training=5, Treatment=5,
        Security=5,
        --+ IT
        Communications=5, Programming=5, Comms=5,
        Singularity=3, Infosec=3,

        -- descriptive: location
        Main=20, Entrance=10, Provisional=3,
        Planetary=3, Interstellar=7, Lunar=10,

        -- mythical/astronomical
        Atlas=3, Promethus=2, Cronus=3,
        Hyperion=2, Icarus=2, Echo=2,
        Morpheus=2, Eos=2, Orion=2,
        Tiephron=2, Psion=3, Titan=3,

        -- special alphabets
        Alpha=10, Beta=5, Gamma=10,
        Delta=10, Omega=5, Sigma=5,
        Epsilon=3, Zeta=5, Lambda=3,
        Theta=5, Omicron=3, Tau=3,

        -- materials / substances
        Power=20, Energy=15,
        Fuel=5, Rocket=3, Missile=5,
        Blast=15, Oil=3, Nuclear=15,
        Nukage=10, Plutonium=10, Toxin=10,
        Chemical=15, Slige=10, Waste=10, Stibine=3,
        Steel=5, Fluid=3, Iron=3, Slime=7,
        Bromine=3, Phosphine=3, Petrochemical=3,
        Cadmium=3, Halogen=3, Mercury=3,
        Hydro=3, Steam=5, Carbon=5,
        Radiation=5, Sludge=3, Particle=3,
        Composite=15, Synthetic=5,

        -- manufactured products
        CPU=5, Freight=5, Wares=3,
        Cargo=10, Weapons=10, Computer=10,
        Electronics=5, Robotic=5, Laser=5,
        Munitions=5, Armament=5,

        -- mechanical
        Mining=15, Fusion=15, Thermal=10,
        Infrared=10, Pressure=5, Counteraction=3,
        Pneumatic=3,

        -- electronic structures
        Data=10, Tesla=5, Quantum=5,

        Parallax=5, Ultraviolet=5,
        Radioactivity=5, Toxicity=3,
        Electrical=5, Diffusion=3,
        Worm_hole=5, Black_hole=5, Teleport=3,
        Hybrid=5, Cryogenic=5, Cryo_=2,
        Photonic=3, Bio_=2,

        -- some even odder materials! -MSSP
        Chromium=3, Plasma=10, Ion=8,
        Dilithium=7, Verteron=5, --nerd
        Deuterium=5, Antimatter=5, Isotope=3,
        Syngas=5, Flux=10, Rubidium=3, Magmatic=3,
        Silicone=5, Hadron=5,

        -- can't get enough weird sci-fi buzzwords -MSSP
        Axioinic=3, Gravimetric=5,
        Graviton=5, Nitrogen=5, Hyperwave=7,
        Magnetic=5, Nanosphere=5, Nanobrane=3,
        Geodesic=7, Biaxial=5, Phased=5,
        Metatronic=5, Vacuum=5, Superluminal=5,
        Temporal=5, Sonic=5, Optic=3,
        Damping=5, Hydraulic=7, Spooling=5,
        Bespoke=2, Gravwell=5, ["Gravity Field"]=5,

        -- mechanical processes -MSSP
        Filtration=5, Pneumatic=5, Catalytic=3,
        Pyrolytic=5, Construction=5, Fabrication=5,
        Production=10, Repair=10, Pyrolosis=3, Combustion=5,
        Sedimentation=5, Drilling=5,

        -- mathematical shapes/structures
        Toroidal=5, Solenoid=5, Helical=5,
        Parabolic=5, Polyform=5, Auxetic=3,
        Biconcave=3, Hyperboloid=3, Convex=5,
        Octant=5, Polytopic=3,

        -- elementary particles! -MSSP
        Lepton=3, Muon=3, Hadron=5,
        Quark=5, Boson=5, Neutrino=5,
        Electron=7,

        Baryonic=5, Mesonic=5,

        ["I/O"]=5,
      },

      n =
      {
        -- MSSP-TODO: sort these names into better categories!!!
        -- military places
        Hangar=5, Outpost=10, Beacon=3,
        Bunker=7, Facility=10, Pillbox=1,
        Headquarters=2, Silos=7, Base=30,
        Command=10,

        -- utility places
        Generator=12, Plant=15, Grid=5,
        Substation=10, Dam=5, Core=5,
        Reactor=10, Turbine=3,

        -- storage-y places
        Warehouse=10, Depot=10, Storage=5,
        Storehouse=5, Gateway=5, Point=2,
        Depositry=3,

        -- science-y places
        Lab=15, Laboratory=5, Observatory=3,
        Station=15, Tower=5, Relay=5,
        Satellite=10, Colony=15, Project=5,
        Experiment=3, Network=5, System=15,

        -- industrial places
        Refinery=15, Factory=10, Foundry=3,
        Workshop=7, Works=2, Forge=8,
        ["Flaring Towers"]=5,

        -- infrastructural places
        Platform=5, Port=3, Hub=10,
        Nexus=3, Infrastructure=5,
        Tributary=5, Channel=5, Tunnels=10,
        Shaft=3,

        -- general places
        Compound=15, Dock=3, Bay=5,
        Complex=15, Center=15, Installation=5,
        Area=15, Site=10, Zone=10,
        Chamber=5, Quarters=5, Section=3,
        Post=3, Annex=5, Terminal=10,
        Quadrant=5, Sector=5, Adjunct=3,

        -- weird ones
        Dilemma=3,
        Situation=2, Crisis=2, Emergency=2,
        Anomaly=10, Portal=7, Apparatus=10,
        Dimension=3, Paradox=3, Vortex=5,
        Enigma=5, Artifact=1, Quagmire=1,
        Catalyst=2,

        -- MSSP adds
        -- shapes
        Dome=7, Quadrangle=3, Rotunda=2,
        Circle=10, Triangle=3, Ring=5,
        Oval=2,

        Basin=5, Arm=5,

        -- storage-ish words -MSSP
        Armory=10, Yard=7, Depository=8,
        Terminus=10, Pool=5, Arsenal=8,
        Magazine=5, Range=5, Cache=10,
        Munitions=8, Repository=8, Archive=5,
        Reserve=7,

        -- military stuff -MSSP
        Casern=5, ["F.O.B."]=7, ["Fire Base"]=10,
        Garrison=10, Logistics=10, Containment=7,
        Berths=5, Housing=5,

        -- machine/electronic parts -MSSP
        -- and weird science-y buzzwords
        -- and also car parts
        Device=5, Machine=5, Couplings=5,

        Oscillator=5, Magnetron=5, Emulsifier=5,
        Alternator=5, Induction=5, Stabilizer=5,
        Processor=10, Suspension=5, Conduit=5,
        Synthesizer=3, Mainframe=10, Modulator=5,
        Converter=4, Inverter=4, Array=5,
        Manifold=5, Regulator=5, Inhibitor=7,
        Pulser=3, Nacelles=3, Filament=3,
        Scrambler=3, Emitter=5, Capacitor=10,
        Compressor=7, Condenser=7, Matrix=10,
        Feed=8, Refractory=6, Deflector=5,
        Junction=7, Analyser=7, Reciprocator=5,
        Collector=3, Centrifuge=7, Splitter=5,
        Scrubber=5, Injector=7, Accelerator=10,
        Infuser=5, Collider=10, Energizer=5,
        Transducer=5, Bearing=3, Incubation=5,
        Coil=10, Gearbox=5, Radiator=5,
        Caliper=3, Rotor=5, Shield=10,
        Synchronizer=5, Conditioner=3, Distillery=5,
        Transistor=3, Diode=3, Boiler=3,
        Compositor=5, Sorter=5, Cultivator=3,
        Engine=7, Solderer=3, Primer=5,
        Conductor=5, Integrator=5,
        Salvager=5, Recycler=5, Culler=4,

        Framework=5, Compartment=5,

        -- IT security objects
        Firewall=5, Servers=5, Encoder=5,
        Decrypter=5, Cipher=5, Datacenter=5,
      },

      s =
      {
        -- single complete level names

        ["A Losing Battle"]=10,
        ["A Stray Marine"]=10,
        ["Advance Guard Delta"]=10,
        ["Alien Carnage"]=10,
        ["Alpha Labs"]=10,
        ["Aspects of the Vile"]=10,
        ["Assault"]=10,
        ["Backbone Breakage"]=10,
        ["Baryogenesis"]=10,
        ["Battlezone"]=10,
        ["Beleaguered Unit"]=10,
        ["Beyond Fear"]=10,
        ["Blackbody Radiation"]=10,
        ["Blackdamp"]=10,
        ["Black Sky"]=10,
        ["Blast Chamber"]=10,
        ["Blood Red Aurora"]=10,
        ["Bombardment"]=10,
        ["Bombing Sessions"]=10,
        ["Breakdown"]=10,
        ["Burnout"]=10,
        ["Butt End of Space"]=10,
        ["Call to Arms"]=10,
        ["Capture and Kill"]=10,
        ["Carnage Command"]=10,
        ["Catch The Bullet"]=10,
        ["Cathode Ray Sunshine"]=10, --Dark Tranquility song
        ["Clawhammer"]=10, -- Silent Hill
        ["Close Quarters"]=10,
        ["Close Call"]=10,
        ["Code Black"]=10,
        ["Code Blue"]=10,
        ["Code Orange"]=10,
        ["Code Red"]=10,
        ["Code Yellow"]=10,
        ["Collapsys"]=10,
        ["Cold Science"]=10,
        ["Cold Reception"]=10,
        ["Collision Course"]=10,
        ["Congestion Collapse"]=10,
        ["Dachronix"]=10,
        ["Dead Sun Aeon"]=10,
        ["Debris of Aircraft"]=10,
        ["Deconstruction Site"]=10,
        ["Deep Into The Code"]=10,
        ["Defcon Six"]=10,
        ["Defragmentation Factor"]=10,
        ["Deja Vu"]=10,
        ["Delta Labs"]=10,
        ["Denial Measures"]=10,
        ["Dissolution Factor Red"]=10, -- Dark Tranquility
        ["Distortica"]=10,
        ["Domino Effect"]=10,
        ["Don't Give Up Yet"]=10,
        ["Downfall"]=10,
        ["Eclipse"]=10,
        ["Ectopia"]=10,
        ["Electrical Overload"]=10,
        ["Emergency Situation"]=10,
        ["Evacuation Step One"]=10,
        ["Excessive Force"]=10,
        ["Eye for an Eye"]=10,
        ["Fallback of Humanity"]=10,
        ["Fear of the Dark"]=10,
        ["Final Resistance"]=10,
        ["Fire Vat"]=10,
        ["Genocidal Genesis"]=10,
        ["Graveyard Orbit"]=10,
        ["Heavy Armed Assault"]=10,
        ["Hellclone"]=10,
        ["Hellspawn Spectrum"]=10,
        ["Helix"]=10,
        ["Horrific Signal"]=10,
        ["Hypernova"]=10,
        ["Ignition!"]=10,
        ["In Extremis"]=10,
        ["Insanity's Crescendo"]=10, -- Dark Tranquility
        ["Interstellar Overdrive"]=10,
        ["Judgement Day"]=10,
        ["Know No Boundries"]=10,
        ["Launchpad"]=10,
        ["Lockdown"]=10,
        ["Losing Ground"]=10,
        ["Lurkers"]=10,
        ["Mayday"]=10,
        ["Motornerve"]=10,
        ["Negative Reinforcement"]=10,
        ["Natas Legenda"]=10,
        ["Neon Rapture"]=10,
        ["Nether Novas"]=10,
        ["Network Collapse"]=10,
        ["Neural Butchery"]=10,
        ["Nuclear Imperator"]=10,
        ["On Sanity's Edge"]=10,
        ["One Shot, One Kill"]=10,
        ["Oscillator"]=10,
        ["Outnumbered"]=10,
        ["Out of Control"]=10,
        ["Panic Attack"]=10,
        ["Paying Ohmage"]=10,
        ["Point Blank"]=10,
        ["Power Surge"]=10,
        ["Power Pulse"]=10,
        ["Pressure Point"]=10,
        ["Price of Warfare"]=10,
        ["Propulsion"]=10,
        ["Retribution Dawns"]=10,
        ["Revolution"]=10,
        ["Shock-Drop"]=10,
        ["Shotguns and Rockets"]=10,
        ["Sickbay"]=10,
        ["Skylab"]=10,
        ["Solar Plexus"]=10,
        ["Space Debris"]=10,
        ["Steadfast Extermination"]=10,
        ["Steel Forgery"]=10,
        ["Strike Zone"]=10,
        ["Supernova"]=10,
        ["Systemic Purge"]=10,
        ["Tactical Retreat"]=10,
        ["Terminal Velocity"]=10,
        ["Terminus"]=10,
        ["The Broken Ones"]=10,
        ["The Disruption"]=10,
        ["The Supercharger"]=10,
        ["This Is Not a Drill"]=10,
        ["Too Close For Comfort"]=10,
        ["Turboshaft"]=10,
        ["Unwanted Attention"]=10,
        ["Wait for It"]=10,
        ["Waste Management"]=10,
        ["Wires and Bloodcells"]=10,

        ["Atomic Fortress"]=10,
        ["Artificial Apathy"]=10,
        ["Blast Radius"]=10,
        ["Celestial Crimes"]=10, -- 1349, I think?
        ["Excessive Exposure"]=10,
        ["False Discharge"]=10,
        ["Galaxy on Fire"]=10,
        ["Gravity Well"]=10,
        ["Higher Voltage"]=10,
        ["Hello Dynamo"]=10,
        ["Hunger for Weapons"]=10,
        ["In a Future World"]=10,
        ["Input-Output"]=10,
        ["Interstellar Starport"]=10,
        ["Nebula Checkpoint"]=10,
        ["No Escape!"]=10,
        ["No Solutions"]=10,
        ["No Time To Waste"]=10,
        ["No Way Through"]=10,
        ["Nothing Works"]=10,
        ["Quantum Distortion"]=10,
        ["System Overload"]=10,
        ["Tech Center"]=10,
        ["The Delusion Machine"]=10,
        ["The Emerald Parallax"]=10,
        ["The Mental Abyss"]=10,
        ["The Muon Collective"]=10,
        ["Transportation H.Q."]=10,
        ["Warp Factor 666"]=10,

        -- Armaetus adds new names
        ["Administrative Sub-Section"]=10,
        ["Administrative Complex"]=10,
        ["Air Defense Systems"]=10,
        ["Alpha Complex"]=10,
        ["Area Ops"]=10,
        ["Artifact Storage"]=10,
        ["Backup Generating Station"]=10,
        ["Beware the Storm Eye"]=10, -- Doom 64,
        ["Blasted"]=10,
        ["Cloud Computing"]=10,
        ["Communications Complex"]=10,
        ["Communications Tower"]=10,
        ["Control Center"]=10,
        ["Core Computer Control"]=10,
        ["Crucible Complex"]=10,
        ["Data Center Alpha"]=10,
        ["Data Center Beta"]=10,
        ["Data Center Delta"]=10,
        ["Data Center Gamma"]=10,
        ["Dirty Computers"]=10,
        ["Distribution and Shipping"]=10,
        ["Drilling and Killing"]=10,
        ["Electric Dreams"]=10, -- This one thought up by MSSP
        ["Emergency Comms Center"]=10,
        ["Endothermic Fission Engine"]=10, -- Demios
        ["Excavation Zone"]=10,
        ["Excess Ammunition"]=10,
        ["Expended Shells"]=10,
        ["Expiration Date"]=10,
        ["Fission Chip Production"]=10, -- Demios
        ["Gateway Diabolique"]=10,
        ["Heavy Equipment Zone"]=10,
        ["Hellborne Singularity"]=10,
        ["Hellspawn Quarantine Lab"]=10,
        ["Hydroponics"]=10,
        ["Limited Options"]=10,
        ["Main Solar Array"]=10, -- Demios
        ["Mindfuck"]=10,
        ["Monorail Facility Transport"]=10,
        ["Mostly Destructive"]=10,
        ["Munitions Replication Center"]=10, -- Demios
        ["Nuclear Missile Banks"]=10, -- Demios
        ["Painkiller"]=10,
        ["Power Station 1A"]=10,
        ["Power Station 2A"]=10,
        ["Power Station 3A"]=10,
        ["Primary Transport Hub"]=10,
        ["Progressive Collapse"]=10,
        ["Raw Materials Handling"]=10,
        ["Raw Materials Processing"]=10,
        ["Raw Materials Storage"]=10,
        ["Reinforced Storage Vats"]=10, -- Demios
        ["Research & Development"]=10,
        ["Satellite Launch Complex"]=10,
        ["Secondary Transport Hub"]=10,
        ["Stars From The Sky"]=10,
        ["Suck On This"]=10,
        ["Teleportation Research"]=10,
        ["Titan Central Center"]=10,
        ["Tech Innovation Labs"]=10,
        ["Technophile"]=10,
        ["Total Absolution"]=10, -- Doom 64,
        ["UAC Primary Base Subsystems"]=10,
        ["Upper Dig Site"]=10,
        ["VEGA Secondary Coupling"]=10,
        ["VEGA Tertiary Coupling"]=10,
        ["Warehouse 64"]=10,
        ["When Tech Giants Fall"]=10,
        ["Wicked Thy Demon Comes"]=10,

        -- MSSP adds more names too
        ["2 Imps 1 Shotgun"]=10, -- retxirT
        ["3 Keys 1 Doomguy"]=10, -- there's a '3 guys 1 hammer' thing out there apparently
        ["Bad Optics"]=10, -- retxirT
        ["Engineering Gone Bad"]=10, -- Demios, also based on Romero's "Tech Gone Bad",
        ["Short-Circuit"]=10, -- Demios

        -- Frozsoul
        ["As the Doomworld Turns"]=10,
        ["Come Get Some!"]=10,
        ["I'm All Out of Bubble Gum"]=10,
        ["It's A Doomworld After All"]=10,
        ["Locked and Loaded"]=10,
        ["Much Obliged"]=10,
        ["Taking It To The Next Level"]=10,

        -- E.T.
        ["To the Limit"]=10,
        ["Munitions Warehouse"]=10,
        ["Demonic Starport"]=10,

        -- Armaetus adds even more names, 2020 edition
        ["Ammunition Dump"]=10,
        ["Compromised UAC Fortification"]=10,
        ["Fragmented Forces"]=10,
        ["Turning Point"]=10,

        -- Armaetus names, 2021 edition
        ["A Moonlit Sky of Terror"]=10,
        ["A Simple Solution"]=10,
        ["Among the Stars"]=10,
        ["Blue Screen of Death"]=10,
        ["Broken Terminal"]=10,
        ["Deconstruction"]=10,
        ["Devoid of Power"]=10,
        ["End Transmission"]=10,
        ["Exposure to Space"]=10,
        ["Factor of Zero"]=10,
        ["Fall of Technology"]=10,
        ["Hexadecimal Destruction"]=10,
        ["Manifest"]=10,
        ["Quantum Dissolution"]=10,
        ["Shut It Down"]=10,
        ["Space Debris"]=10,
        ["Terminal Resistance"]=10,
        ["The Rubicon"]=10,
        ["The Warzone Within"]=10,
        ["Time and Space"]=10,
        ["Timepiece"]=10,
        ["When Entropy Declines"]=10,
        ["Wires and Hard Drives"]=10,

        -- OwO what's this? More names?
        ["A Crushing Halt"]=10,
        ["Corporate Annihilation"]=10,
        ["Data Degeneration"]=10,
        ["Digital Flametongue"]=10,
        ["Orbitdancer"]=10,
        ["Powder Burns"]=10, -- Bolt Thrower
        ["The Particle Storm"]=10 -- Mostly Dark Tranquility, "Into the Particle Storm" won't fit, I think?
      }
    }
  },
  -- end of 'TECH' theme


  --------------------------------------------------

  GOTHIC =
  {
    patterns =
    {
      -- lexicon legend:
      -- %e = Entity
      -- %a = Adjectives
      -- %n = Places
      -- %h = Explicit description (e.g. I am Satan, "Arena of <Satan>")
      -- %o = Implicit description (e.g. I am Satanic, "Arena of <the Satanic>")
      -- %v = Prefixed phrase (as per COMMON table e.g. "<Scoruge of the> Arena)

      ["%a %n"] = 60,
      ["%t %a %n"] = 20,

      ["%a %n %x"] = 20,
      ["%t %a %n %x"] = 8,

      ["%n of %h"] = 26,
      ["%a %n of %h"] = 10,
      ["%a %n of the %o"] = 10,

      ["%e's %n"]       = 10,
      ["%e's %a %n"]    = 8,
      ["%e's %n of %h"] = 6,
      ["%e's %n of the %o"] = 6,

      ["%v %n"]    = 25,
      ["%v %a %n"] = 25,

      ["%s"] = 25,

      ["Killing for %e"] = 3,
      ["Killing in %e's name"] = 3,
      ["Dying for %e"] = 3,
      ["Dying in %e's name"] = 3,
      ["Unworthy for %e"] = 3,
      ["%e's Bitch"] = 2,
    },

    lexicon =
    {
      t =
      {
        The=50,
      },

      e =
      {
        Romero=1, -- the Icon of Sin

        -- Judeo-Christian literature evil stuff (includes Ars Goetia)
        Satan=10, ["The Devil"]=7, Lucifer=7, Amon=3, Agares=3,
        Malthus=3, Beelzebub=3, Moloch=3,
        Xezbeth=3, Botis=2, Sitri=2, Mammon=3, Saleos=3,
        Haborym=3, Raum=2, Forcas=3,
        Ipos=3, Xezbeth=3, Abaddon=3, Phenex=2,
        Baal=3, Berith=3, -- isn't this like the same guy, just his first and last name?
        Haagenti=3, Caim=2, Seir=3, Nybbas=2,
        Astaroth=2, Leviathan=1,
        Pithius=3, Lempo=3, Kasdeya=3,

        -- OMG THEY'RE FRENCH?!
        Balber=3, Carreau=3, Carnivean=3,
        Oeillet=3, Rosier=2, Luvart=2,
        Verrier=2, Olivier=2, Verrine=3,
        -- They sound so undemonic you could almost
        -- believe they're names of beautiful French
        -- people sitting in a cafe while having
        -- some cheese and wine

        Dante=5,

        Ahazu=3, --Wikipedia
        Abezithibou=2, Abyzou=2, Agaliarept=2,
        Asmodeus=3, Azazel=3, Balam=3,
        Baphomet=3, Barbas=3, Barbatos=3,
        Belial=3, Beleth=3, Bifrons=1,
        Caim=2, Corson=2, Crocell=2, Dantalion=3,
        Demogorgon=3, Eisheth=3, Focalor=3, Foras=3,
        Forneus=3, Gaap=3, Gaderel=2, Gamigin=2,
        Gremory=3, Gusion=1, Legion=5, Lilith=5,
        Malphas=3, Marax=3, Marchosias=3, Merihem=3,
        Murmur=3, Naamah=3, Naberius=3, Orias=3,
        Orobas=2, Ose=2, Paimon=3, Penemue=3,
        Pruflas=3, Rahab=3, Renove=2, Sabnock=3,
        Samael=3, Sitri=2, Soneillon=3,
        Salpsan=3, Shedim=3, Stolas=3, Surgat=3,
        Tannin=3, Ukobach=3, Valac=3, Vapula=3,
        Valac=2, Vepar=3, Zagan=3, Zepar=3, Ziminar=3,

        Titivullus=3, Belphegor=3,

        Korah=3,

        -- Native American stuff
        Dzoavits=2, Wendigo=3, Vucub=3, Wechuge=2,

        -- Greek stuff
        Abraxas=3, Chimera=5, Minotaur=5, Pandora=1, Minos=2,
        Cerberus=5, Typhon=3, Echidna=3, Arachne=3, Medusa=3,
        Atropos=3, Thanatos=3, Nyx=2, Sthenno=3,

        -- Roman evil stuff
        Hades=3, Orcus=3, Mefitis=3, Morta=3,
        Mors=3, Nox=2, Vediovus=3, Tuchulcha=3,
        Vanth=3,

        -- Nordic stuff
        Loki=3, Hel=3, Skadi=3, Aegir=3, Ran=3,
        Ymir=3, Fenrir=3, Jormungand=3, Nidhogg=3,
        Skoll=2, Hati=2, Surt=2, Garm=3,

        -- Egyptian stuff
        Ammit=3, Apep=3, Kek=2, Set=3, Shezmu=3,
        Anti=2, Anzus=2, Apophis=3,

        -- Germanic stuff
        Mephisto=3, Faust=3, Bilwis=2,

        -- Polish stuff
        Boruta=3,

        -- Arabic stuff
        Jinn=2, Deccal=3, Iblis=3, Ifrit=3, Dajjal=3,
        Azar=3, Firawn=3, Haman=3, Jault=3, Samiri=3,

        -- Slavic stuff
        Rusalka=3, Chernevog=3, Jeretik=3, Vila=3,

        -- Indonesian stuff
        Barong=2, Pocong=2, Pontianak=2, Rangda=2,
        Suanggi=2, Toyol=2,

        -- Iranian stuff
        Astovidatu=3, Indra=3, Vaya=3, Zarich=3,

        -- Filipino!
        Batibat=2, Danag=2,

        -- Here come the Lovecraftians!
        Ktulu=2, Dagon=3, Nyarlathotep=2,

        -- civilizations that don't even exist anymore
        -- evil stuff (Sumerians, Akkadians etc.)
        Erishkigal=3, Utukku=3, Namtar=2, Lamashtu=2,
        Ninurta=3, ["Ardat Lili"]=2, Asag=2,

        -- Diablo games
        Diablo=7, Andariel=3, Duriel=3, Belial=3,
        Azmodan=3, Rakanoth=3, Inarius=3, Izual=3,
        Adria=1, ["Tal Rasha"]=2,

        -- comics, TV
        Helgor=3, Eligos=3,

        -- Dungeons and Dragons / Pathfinder
        -- note: a lot of these names are probably borrowed
        -- from elsewhere (i.e. real world cultures) so they
        -- should be sorted into there instead...
        Yeenoghlu=3, Adimarchus=3, Lolth=3,
        Gresil=2, Jubilex=3, Kerzit=2, Caasimolar=3,

        -- Warhammer 40k
        Nurgle=2, Khorne=2, Tzeentch=2, Slaanesh=2,

        --==| couldn't figure it out |==--
        --+ totally no clue
        Ceren=2, Dozod=2, Kalrac=2, Quenna=3,

        Draco=2, -- it's Latin for dragon but I don't know anything else more specific
        Ouroboros=5, -- actually sort of a neutral symbol

        -- Hexen?
        Vuradi=2,

        --+ Are these book authors? They don't seem to be the 'demonic' sort.
        Oltion=2, Orgel=2,

        --+ Is this supposed to be Balrog from LotR or a variant from other media?
        Balrok=3,

        -- Chaos Lords
        -- See: https://en.wikipedia.org/wiki/Law_and_Chaos
        Arioch=3, Mabelode=3, Urleh=3, Xiombarg=3,

        -- Demonology A-Z names, see: https://hellhorror.com/demon-names-list-A/
        Abatu=3, Abdiel=3, Abduxuel=3, Abezethibou=3, Adramelech=3, Angrboda=3, Apollyon=3,
        Asakku=3, Atazoth=3, Flauros=3, Glasyalabolas=3, Jezebeth=3, Merihim=3, Morax=3,
        Nicor=3, Nybbas=3, Nysrogh=3, Onoskelis=3, Philatanus=3, Sonneillon=3, Sorath=4,
        Thamuz=3, Valafar=3, Verdelet=3,


        -- ObAddon contributor names
        NOUNMEMBERS = 90,

        NOUNGENEXOTIC = 700
      },

      a =
      {
        -- size
        Monumental=5, Colossal=10, Sprawling=5, Massive=5,
        Small=3, Endless=10, Gigantic=5, Mighty=5, Enormous=5,
        Giant=3, Great=3, Elephantine=3, Grand=3, Gargantuan=5,
        Imposing=5, Monstrous=5, Prodigious=3, Maximum=5,

        -- generic scales?
        Raw=2, Sheer=10,

        -- location
        Underground=10, Subterranean=5,
        Cloaked=3, Hermetic=3,
        Occult=10, Surreptious=15,
        Inner=15, Abysmal=10, Deepest=15,
        Concealed=7, Clandestine=5, Outer=5,
        Outlying=5,

        -- age
        Elder=15, Ancient=15, Eternal=5,
        Eldritch=7, Archaic=7,

        -- color
        Black=5, Gray=5, Red=5, Crimson=5,
        Ochre=5, Ashen=5,

        -- dirty
        Foul=10, Defiled=10, Ravished=5, Murky=3,
        Begrimed=5, Filthy=5, Sloven=5,
        Stagnant=7, Rancid=10, Rotten=15, Festering=5,
        Fractured=5, Entombed=5, Vile=15,
        Revolting=10, Putrid=5, Skinned=3,
        Fallen=10, Stinking=1, Grungy=3,
        Smoky=5, Flagrant=20, Aching=5,
        Acrid=5, Fetid=2,

        -- contents
        --+ guts n stuff
        Blood=20, Bloody=5, Blood_filled=3,
        Blood_stained=2, Blood_soaked=3,
        Bleeding=3,
        --+ fire and brimstone
        Burning=20, Burnt=5, Scorching=5,
        Melting=5, Red_Hot=5,
        Lava=5, Lava_filled=3, Magma=5,
        Monstrous=15, Monster=5, Zombie=10,
        Demonic=15, Demon=5, Ghoulish=5,
        Haunted=10, Ghostly=15, Ghastly=5,
        Cyberdemon=5, Necromancers=5, Mastermind=5,
        --+ monarchs
        Queens=5, Princes=5, Arch_Duke=5,
        Dukes=5, Kings=5, Royal=5, Squire=4,
        Baron=5, Knights=7,
        --+ pagans
        Wizard=5, Warlock=2, Wiccan=3,
        Heathen=3,
        --+ dirty poor guys
        Rat_infested=5, Downtrodden=3,
        Slime=5,

        -- descriptive
        Nebulous=5,
        Oppressive=5,

        Gothic=7, Orphic=3,

        -- scary-wary
        Ominous=20, Terrifying=5, Gruesome=10,
        Gloomy=5, Awful=10, Execrable=10, Uncanny=15,
        Horrible=10, Horrendous=10, Screaming=3,
        Dismal=10, Dank=5, Frightful=5,
        Dreaded=15, Nightmare=5, Dolor=5,

        -- authority
        Sovereign=7, Triumph=2,

        -- danger/fatalism
        Brutal=20, Grisly=15, Tortuous=10,
        Disastrous=2, Ill_fated=10, Frail=3,
        Fatal=10, Final=5, Terminal=2, Painful=5,
        Deadly=3,

        -- magical (neutral)
        Mystic=7, Mystical=2, Magical=2, Magic=2,
        Arcane=5, Esoteric=5, Abstruse=3,

        -- bad personal qualities
        Cruel=5, Crass=2, Sullen=10, Bitter=7,
        Uncivilised=2, Vexatious=5, Perverse=5,
        Morbid=10, Loathsome=5, Vulgar=5,
        Wretched=3, Caustic=5, Shameful=5,

        -- neutral personal qualities (hey, I'm a quiet guy -MSSP)
        Silent=5, Enigmatic=5, Shameless=3,
        Godless=5, God_forsaken=7, Ungodly=3, -- does putting this here
        Sacreligious=5, Unspiritual=2,        -- reveal too much about
                                              -- my own opinions? -MSSP

        -- good personal qualities (why though?)
        Poignant=3,

        -- explicitly very evil
        Evil=30, Unholy=20, Wicked=15,
        Abhorrent=3, Abominable=5, Bestial=5,
        Direful=2, Execrated=2, Hexed=3,
        Immoral=5, Impure=5, Utmost=5,
        Merciless=7, Pestilent=5, Profane=5,
        Vicious=10, Violent=10, Desecrated=5,
        Accursed=5, Malodorous=5, Despicable=2,
        Heinous=5, Mephitic=2, Peccant=5,
        Sordid=2, Grievous=2, Ferine=2, Sinful=5,
        Unblessed=3, Unsanctified=2, Despoiled=3,

        Immortal=3,

        -- abandonment/disrepair/negligence
        Detested=5, Ruined=5, Barren=5, Feeble=3, Dilapidated=5,
        Flimsy=3, Corroded=5, Derelict=5, Frail=3, Crumbling=4,
        Decrepid=3, Desolate=10, Forgotten=10, Rickety=5, Dusty=3,
        Decaying=3,

        -- holy
        Ceremonial=5, Liturgical=5, Solemn=5, Deistic=5, Sanctified=5,
        Divine=5, Devout=5, Sacerdotal=5, Sacred=5, Spiritual=5,
        Clerical=5, Hallowed=5, Cherished=5, Revered=5, Venerable=5,
        Angelic=5, Consecrated=5, Enshrined=5, Numinous=5,

        -- material
        Adamantine=5, Bronze=5, Copper=5,
        Rocky=5, Stone=5, Masonic=5,
        Iron=5, Steel=5, Hellforged=5,
        Obsidian=5, Mythril=5,
        Rusted=5, Guilded=5, God_Forged=3
      },

      n =
      { -- MSSP-TODO: this area needs some more sorting (merge categories)
        -- places
        --+ burials
        Crypt=20, Tomb=15, Graveyard=10,
        Cloister=5, Sepulcher=7, Hecatomb=3,
        Catacombs=10,
        --+ neutral underground
        Pit=10, Cavern=10, Cave=5, Chasm=5, Ravine=5,
        Lair=15, Den=7, Abyss=5, Gulch=5, Gorge=5,
        --+ neutral aboveground
        Wasteland=15, Town=5, Ghetto=2, City=5,
        Well=5, Realm=10, Domain=10, Gulf=5,
        Hive=5, Abode=15, Township=7, Hamlet=7,
        Municipality=7, Community=5,
        --+ terrain
        Valley=10, River=5, Lowland=5, Plain=5, Vale=5,
        Coulee=5, Gully=5, Channel=5,
        --+ temples
        Grotto=15, Chapel=10, Church=7,
        Mosque=5, Cathedral=5, Tabernacle=3,
        Palace=5, Citadel=5, Abbey=5,
        --+ building sections
        Hall=7, Rooms=3, Chamber=10,

        -- terrain
        Mountains=2, Swaths=2, Crags=3, Shores=5,

        -- generic locations (not necessarily religious
        -- in nature nor exclusive to hell)
        Tower=3, Gate=3, Village=3, Sanctuary=3,
        Prison=3, Sanctum=10, Arena=3, Spire=10,
        Demesne=5, Canton=5, Settlement=5, Dominion=5,
        Province=5, Protectorate=5,

        -- weird ones
        Communion=5, Monolith=5, Crucible=5,
        Excruciation=1, Abnormality=1,
        Hallucination=1, Teracculus=2,
        Ceremony=3, Threshold=3,
        Ache=2, Apocalypse=1, Resurrection=5,
        Absolution=5, Crux=5, Culmination=5,
        Sacrament=5, Plight=5, Liturgy=5,
        Choir=5,

        -- Shadiversity approved castle parts -MSSP
        Ramparts=8, Keep=10, Gatehouse=8,
        Bailey=5, Barbican=5, Well=10,
        Motte=4, Battlements=10, Ward=7,
        Turrets=3, Oubliette=3, Stockades=3,
        Bartizan=3, Brattice=3, Postern=3,
        Cistern=3,

        -- temples of sorts
        Temple=20,
        Basillica=3, Chapel=10, Monastery=10,
        Abbey=10, Monastery=10, Friary=3,
        Priorate=5, Lamasery=3, Convent=10,
        Hermitage=5, Ziggurat=10, Bethel=3,
        Parish=3, Sacellum=3,

        --+ parts of temples
        ---+ (based on Greek architecture)
        Cella=3, Terastyle=2, Hexastyle=2,
        Dipteral=3, Anta=3, Tholos=3,
        Peripteral=3, Hypostyle=2,

        ---+ (based on old Jewish stuff)
        Soreg=2, Hekhal=2, Debir=1,

        -- modern-ish church bits
        Baptistery=3, Ciborium=3, Nave=3,
        Clerestory=3, Transept=5, Scriptorium=7,
        Synagogue=10, Belfries=2, Pulpitum=3,
        Dais=3, Feretory=5, Maqsurah=3,
        Peripteral=3, Chantry=3, Font=2,
        Sacristy=3, Narthex=5, Altar=7,
        Shrine=10,

        Plumbery=2,

        Monstrance=3, Reliquary=10,

        --+ stuff priests own
        Parsonage=3, Vicarage=3, Rectory=3,
        Clege=3, Presbytery=3, Benefice=3,
        Manse=3,

        --+ groups of priests
        Clergy=1, Cardinalate=2, Conclave=3,
        Pastorate=2, Rabbinate=2, Canonry=3,
        Deaconry=3, Order=3,

        --+ districts of church/religious offices
        Diocese=3, Episcopate=3, Prelacy=3,
        Bishopric=3, Curacy=3, Chancellery=5,

        -- deady stuff
        Mausoleum=15, Undercroft=5, Entombment=5,
        Morgue=5, Labyrinth=5, Dungeon=10,
        Cenotaph=5, Vault=10, Culverts=5,

        Domicile=5,
        Library=15,

        -- medieval architecture
        Collonade=5, Aisles=5, Ambulatory=3,
        Apse=3, Arcade=10, Courts=5,
        Billet=5, Hoarding=5, Loggia=3,
        Oriel=3, Pier=5, Triforium=3,
        Jetty=2, Pylon=5,

        -- generic architectural stuff
        Banister=5, Gallery=5,
        Parapet=5, Terraces=5, Banquette=2,
        Balcony=3, Cusp=3, Portal=5,
        Tribune=7, Vestibule=10, Atrium=10,
        Monitor=5, Niche=10, Oculus=5,
        Solar=5, Cellars=10, Alcoves=3,

        -- other synonyms for arena
        Gridiron=3, Hippodrome=3, Pit=3,
        Grounds=3, Stade=3, Strand=3,
        Coliseum=3,

        -- synyonyms for slaughterhouse
        Abattoir=3, Butchery=3,

        -- shapes
        Dome=10, Quadrangle=3, Rotunda=2,
        Circle=10, Triangle=3, Ring=5,
        Oval=2,

        Pavillion=5, Monument=10, Garth=3,
        Minaret=3,

        -- nest
        Nest=10, Aerie=5, Haunt=3,

        -- prison
        Durance=5, Captivity=3, Confinement=3,
        Isolation=3, Duress=3, Remand=2, Thralldom=2,
        Immuration=3, Bastille=2, Brig=3,
        Sty=3, Antechamber=3, Hold=3
      },

      h = -- explicit descriptions i.e. "Arena of Death",
      {
        -- fire and brimstone
        Hell=10, Fire=10, Flames=10,
        Darkness=10, Limbo=3, Souls=10, Shadows=10,

        -- violence
        Carnage=10, Gore=5, Rapine=10, Liquidation=7,
        Destruction=5, Doom=15, Butchery=10,
        Flesh=10, Corpses=10, Bones=10, Havoc=10,
        Viscera=5, Skulls=10, Bloodshed=10, Warfare=5,

        -- disaster
        Tragedy=10, Famine=10, Chaos=15, Struggle=10,

        -- religious discord, that kind of fun stuff
        Iconoclasm=10, Defection=10,
        Blasphemy=10, Paganism=10,
        Schism=10, Sectarianism=10, Sin=10, Mayhem=10,
        Strain=5, Supplication=5, Witchcraft=5,
        Heresy=10,

        -- definitely bad things
        Fallacy=10, Deception=10, Infidelity=10,
        Suffering=5, Torment=10, Torture=10,
        Treachery=5, Lunacy=5, Woe=5,

        -- emotions and physical pain
        Horror=10, Terror=10, Death=15,
        Sorrow=10, Hate=10, Misery=10,
        Pain=15, Fear=5, Trauma=10,
        Agony=10, Anguish=10,

        -- negative emotions made manifest
        Whispers=5, Tears=3, Screams=5,

        Dread=5, Fate=5, Locusts=2, Erebus=5, Lethe=2,
        Reckoning=5, Minos=3, Hades=7, Acheron=5,
        Leviathan=5, Baphomet=5, Devils=10
      },

      o = -- implicit objects e.g. "Arena of the Doomed",
      {
        -- entities
        --+ alive people
        Denizens=10, Emissary=10, Seer=10,
        Wretched=10, Vicar=10,
        --+ dead people
        Dead=10, Fallen=10, Possessed=10,
        Undead=10,
        --+ bad folk
        Betrayers=10, Corpsegrinder=10, Destroyer=10,
        Necromancer=10, Sinner=10, Wicked=10,
        Witches=10, Unmaker=10,
        --+ ir/religious figures
        Acolyte=10, Apostates=10, Missionary=10,
        Priest=10, Prophets=10, Neophyte=10, Oracle=10,
        Saints=10, Zealots=10,
        --+ creatures
        Beast=10, Behemoth=10, Minions=10,

        -- personal qualities
        --+ outright evil
        Abhorrent=10, Barbaric=10, Deplorable=10,
        Depraved=10, Diabolical=10, Ghastly=10, Impure=10,
        Insidious=10, Infernal=10, Malevolent=10,
        Malicious=10, Nefarious=10, Ruthless=10,
        Sinister=10,
        --+ negative
        Angry=10, Belligerent=10,
        Baneful=10, Crooked=10, Decayed=10,
        Deceitful=10, Deceptive=10, Dishonored=10,
        Disobedient=10, Dreadful=10, Dreary=10,
        Dying=10, Enraged=10, Gloomy=10,
        Grotesque=10, Foul=10,
        Grisly=10, Gruesome=10, Gullible=10,
        Hateful=10, Hideous=10, Insane=10,
        Knavish=10, Loathsome=10,
        Obscene=10, Savage=10, Sick=10,
        Spiteful=10, Ugly=10, Vicious=10,
        Vile=10,
        --+ neutral
        Cunning=10, Unheard=10, Unknown=10,

        -- weird
        Absurd=10,

        -- age
        Ancient=10, Archaic=10,

        -- damage states
        Blackened=10, Bleak=10, Bleeding=10,
        Corroded=10, Corrosive=10, Deformed=10,
        Dismal=10, Exposed=10, Gutted=7, Exenterated=5,
        Ruined=10, Collapsed=5, Decimated=5,

        -- tainted
        Chaotic=10, Corrupt=10, Defiled=10,
        Noxious=10, Poisoned=10, Putrid=10,
        Repulsive=10, Rotten=10, Tainted=10,

        -- abandoned
        Condemned=10, Damned=10, Decaying=10,
        Desolate=10, Dissolute=10, Forgotten=10,
        Forsaken=10,

        -- things that cause anxiety
        Failures=10,

        -- danger
        Hazardous=10, Parlous=10, Perilous=10,
        Treacherous=10
      },

      s =
      {
        -- single complete level names

        ["Absent Savior"]=10,
        ["Absolution Neglect"]=10,
        ["Addicted to Sin"]=10,
        ["All is Lost"]=10,
        ["Alone Walking"]=10,
        ["Ankle Deep in Blood"]=10,
        ["Angelus Mortis"]=10,
        ["Ashes to Ashes"]=10,
        ["Architect of Troubled Sleep"]=10,
        ["Atrocitic Hunt"]=10,
        ["Atrophy of the Soul"]=10,
        ["A Dream of Death"]=10,
        ["A Putrid Serenity"]=10,
        ["Aura of Filth"]=10,
        ["A Vile Peace"]=10,
        ["Awaiting Evil"]=10,
        ["Bad Blood"]=10,
        ["Baptised in Parasites"]=10,
        ["Bathed in Viscera"]=10,
        ["Bearer of Pain"]=10,
        ["Beyond Death"]=10,
        ["Beyond Fate"]=10,
        ["Beyond the Apocalypse"]=10,
        ["Black Moon"]=10,
        ["Blazing Flames of War"]=10,
        ["Bled Dry"]=10,
        ["Blinded by Fear"]=10,
        ["Blood Clot"]=10,
        ["Bloodless Unreality"]=10,
        ["Bloodstains"]=10,
        ["Blood for Blood"]=10,
        ["Blood Red Shadows"]=10,
        ["Blood Throne"]=10,
        ["Blood Vanity"]=10,
        ["Bloody Mist"]=10,
        ["Body and Soul"]=10,
        ["Bonded by Blood"]=10,
        ["Born/Dead"]=10,
        ["Born in the Flames"]=10,
        ["Birthplace of Fate"]=10,
        ["Brotherhood of Ruin"]=10,
        ["Buried Alive"]=10,
        ["Burning Sea"]=10,
        ["Cato's Escort"]=10,
        ["Centromere"]=10,
        ["Charred Flesh"]=10,
        ["Cocoon of Filth"]=10,
        ["Cold Comfort"]=10,
        ["Collection of Corpses"]=10,
        ["Compelled to Kill"]=10,
        ["Cocytus"]=10,
        ["Corpsehaven"]=10,
        ["Corrupted"]=10,
        ["Creeping Brutality"]=10,
        ["Cries of Pain"]=10,
        ["Crimson Tears"]=10,
        ["Crown of Snakes"]=10,
        ["Crucifix of the Damned"] = 10,
        ["Cynicism of Vitality"]=10,
        ["Dare to Dream"]=10,
        ["Dark Citadel"]=10,
        ["Dark Crusade"]=10,
        ["Dark Echo"]=10,
        ["Dark Light"]=10,
        ["Darkness Ensues"]=10,
        ["Dead Inside"]=10,
        ["Dead Traditions"]=10,
        ["Dead Words Speak"]=10,
        ["Deadly Intentions"]=10,
        ["Death Cycle"]=10,
        ["Death Grate"]=10,
        ["Death Spawn"]=10,
        ["Death's Gratification"]=10,
        ["Deathstay"]=10,
        ["Defective Decay"]=10,
        ["Demon's Gate"]=10,
        ["Depths of Hatred"]=10,
        ["Desquamation"]=10,
        ["Destroyer of Worlds"]=10,
        ["Diamortal"]=10,
        ["Disdain and Anguish"]=10,
        ["Disease"]=10,
        ["Dissidence Volta"]=10,
        ["Dithyamb of Sadism"]=10,
        ["Dogma Destroyed"]=10,
        ["Dreaming in Red"]=10,
        ["Drowning the Light"]=10,
        ["Durance of Hate"]=10,
        ["Echos of the Dead"]=10,
        ["Elderworld"]=10,
        ["Embraced by Lucifer"]=10,
        ["Emissary of Pain"]=10,
        ["Empty Life"]=10,
        ["End of Everything"]=10,
        ["End of the Line"]=10,
        ["Essence of Black"]=10,
        ["Etherworld"]=10,
        ["Evil Oath"]=10,
        ["Extinction of Mankind"]=10,
        ["Exuviated Offscouring"]=10,
        ["Ezra's Influence"]=10,
        ["Falling Sky"]=10,
        ["False Promises"]=10,
        ["Fear Catalyst"]=10,
        ["Feed of Decay"]=10,
        ["Feign Sympathy"]=10,
        ["Fenchurch"]=10,
        ["Fields of Gluttony"]=10,
        ["Final Revelation"]=10,
        ["Food for the Demons"]=10,
        ["Freeze Mentality"]=10,
        ["From the Deeps"]=10,
        ["Frost and Fire"]=10,
        ["Fucked by Fire"]=10,
        ["Funeral of the Gods"]=10,
        ["Ghost Trail"]=10,
        ["Gore Galore"]=10,
        ["Gottesmord"]=10,
        ["Guttural Breath"]=10,
        ["Half Light"]=10,
        ["Hell Arrives"]=10,
        ["Hell's Churn"]=10,
        ["Hellfire"]=10,
        ["Helpless"]=10,
        ["Herald of Demons"]=10,
        ["Hope is Dead"]=10,
        ["Hopeless Despair"]=10,
        ["Human Compost"]=10,
        ["Human Insecticide"]=10,
        ["Human Landfill"]=10,
        ["Human Trafficking"]=10,
        ["Hunted"]=10,
        ["Incinerated Cross"]=10,
        ["Infected Grave"]=10,
        ["Iniquity Inferior"]=10,
        ["Insolent Terror"]=10,
        ["Internal Darkness"]=10,
        ["I Stand Defiant"]=10,
        ["Lava Love"]=10,
        ["Left Hand Path"]=10,
        ["Legion"]=10,
        ["Lifecode Sin"]=10,
        ["Locust Hide"]=10,
        ["Lord of Destruction"]=10,
        ["Lost in Oblivion"]=10,
        ["Lychgate"]=10,
        ["Made in Hell"]=10,
        ["Mandatory Suicide"]=10,
        ["Manifest Destination"]=10,
        ["Marbellum"]=10,
        ["Meltdown"]=10,
        ["Menzobarranzen"]=10,
        ["Myth of Progress"]=10,
        ["Necessary Death"]=10,
        ["Necromancide"]=10,
        ["Necropolis"]=10,
        ["Necrosis"]=10,
        ["Nihilist Nexus"]=10,
        ["Nomen Luni"]=10,
        ["Nothing Lasts Forever"]=10,
        ["Obsidian Fragments"]=10,
        ["Octarena"]=10,
        ["Opus Satani"]=10,
        ["Origin of Nausea"]=10,
        ["Pain Eternal"]=10,
        ["Panzer Pentagram"]=10,
        ["Paranoia"]=10,
        ["Parasitic Skies"]=10,
        ["Path of a Fallen Angel"]=10,
        ["Pazuzu's Run"]=10,
        ["Pentadrome"]=10,
        ["Perdition's Massacre"]=10,
        ["Perished in Pain"]=10,
        ["Perversitas Sancta"]=10,
        ["Portal of No Return"]=10,
        ["Post Combustion"]=10,
        ["Punishment Defined"]=10,
        ["Purgation in Molten Metal"]=10,
        ["Purgatorio"]=10,
        ["Razorfist"]=10,
        ["Realm of Souls"]=10,
        ["Red Dream"]=10,
        ["Reduced to Dust"]=10,
        ["Retribution Dawns"]=10,
        ["Return to Hell"]=10,
        ["Ripped Intestines"]=10,
        ["Running Scared"]=10,
        ["Sado-Masochistic"]=10,
        ["Saint Scream"]=10,
        ["Sacred Utopia"]=10,
        ["Sanity's Edge"]=10,
        ["Scourge of Humanity"]=10,
        ["Sculptor of Flesh"]=10,
        ["Sphacelus"]=10,
        ["Satan's Disgust"]=10,
        ["Satanic Propaganda"]=10,
        ["Satanic Supremacy"]=10,
        ["Sawn in Half"]=10,
        ["Seven Deadly Sins"]=10,
        ["Severe Burns"]=10,
        ["Shallow Grave"]=10,
        ["Shambled Dimension"]=10,
        ["Shannara"]=10,
        ["Sheol"]=10,
        ["Sign of Evil"]=10,
        ["Sinners Bleed"]=10,
        ["Sins of Allegiance"]=10,
        ["Sins of the Fallen"]=10,
        ["Shadow Keep"]=10,
        ["Skinfeast"]=10,
        ["Skin Graft"]=10,
        ["Skullbog"]=10,
        ["Slow Death"]=10,
        ["Soulburn"]=10,
        ["Soul Scars"]=10,
        ["Spheres of Madness"]=10, -- Song by Decapitated, a Polish death metal band
        ["Spiritual Madness"]=10,
        ["Stained Tombs"]=10,
        ["Stripped of Flesh"]=10,
        ["Stygiophobia"]=10,
        ["Sympathy Denied"]=10,
        ["The Bleeding"]=10, -- Doom 64,
        ["The Heretic's Touch"]=10,
        ["The Rotted Foul"]=10,
        ["Time and Dust"]=10,
        ["Terminal Filth"]=10,
        ["The Ecomium of Terror"]=10,
        ["The Sun Never Rises"]=10,
        ["The Yawning Abyss"]=10,
        ["Thinning the Horde"]=10,
        ["Tomb of Souls"]=10,
        ["Trialed in Flames"]=10,
        ["Trivial Anguish"]=10,
        ["Twisted Beyond Reason"]=10,
        ["Tyranny"]=10,
        ["Unhealing Wounds"]=10,
        ["Vertigone"]=10,
        ["Vomitorium"]=10,
        ["Weaving Darkness"]=10,
        ["Well of Souls"]=10,
        ["What Color is Death?"]=10,
        ["Where No Light Is"]=10,
        ["Where Shadows Live"]=10,
        ["Wrapped in Barbwire"]=10,
        ["Ziggurat"]=10,
        ["Zoweseandek"]=10,

        ["Divine Intoxication"]=10,
        ["Dying for It"]=10,
        ["Infernal Directorate"]=10,
        ["Glutton for Punishment"]=10,
        ["Gore Soup"]=10,
        ["Kill Thy Neighbor"]=10,
        ["Murderous Intent"]=10,
        ["No Sanctuary"]=10,
        ["Out for Revenge"]=10,
        ["Rampage!"]=10,
        ["Rip in Reality"]=10,
        ["Reaper Unleashed"]=10,
        ["Searching for Sanity"]=10,
        ["Slice 'em Twice!"]=10,
        ["Sorrowful Faction"]=10,
        ["Taste the Blade"]=10,
        ["Traces of Evil"]=10,
        ["Twists and Turns"]=10,
        ["Voices in the Blood"]=10,
        ["Welcome to the Coalface"]=10,
        ["You Can't Handle the Noose"]=10,

        -- Armaetus adds new names
        ["Segmentus Infernus"]=10,
        ["Voidborne"]=10,

        -- Armaetus adds even more names, 2020 Edition
        ["Apocalyptic Prophecy"]=10,
        ["Artwork of Affliction"]=10,
        ["Blood Red Sunshine"]=10,
        ["Chaotic Malfeasance"]=10,
        ["Compulsive Psychosis"]=10, -- Hypocrisy song, melodic death metal
        ["Crushed Will"]=10,
        ["Death and Dreaming"]=10,
        ["Dessicated and Devoured"]=10,
        ["Destruction of Free Will"]=10,
        ["Hellsower"]=10,
        ["Hellwave Catalyst"]=10,
        ["Honor of the Demons"]=10,
        ["Human Cattle"]=10,
        ["Human Hunting Grounds"]=10,
        ["Left Limbless"]=10,
        ["Musings of a Demon"]=10,
        ["Nocturnal Devotion"]=10,
        ["Obelisk of Timelessness"]=10,
        ["Only Death Matters Here"]=10,
        ["Oscuridad y Muerte"]=10, -- Darkness and Death. Please fix if incorrect.
        ["Profundis Inferni Convivae"]=10, -- Depths of Hell. Please confirm.
        ["Processed and Discarded"]=10,
        ["Pure Blasphemy"]=10,
        ["Sanguine Plataeu"]=10,
        ["Shattered Reality"]=10,
        ["Tribute to the Dark Ones"]=10,
        ["Unto the Unhallowed Abyss"]=10,
        ["Wretched Mortal Form"]=10,

        -- 2020 end of year additions
        ["A Harrowing Journey"]=10,
        ["Anchors of Cruelty"]=10,
        ["Barbequed Viscera"]=10,
        ["Crispy Fried Epidermis"]=10,
        ["Fissure of Blood"]=10,
        ["Hell's Fortune"]=10,
        ["Pure Peril"]=10,
        ["Simply Macabre"]=10,
        ["Towers in the Fog"]=10,
        ["Weaving of the Artery"]=10,

        -- 2021 naming conventions from Armaerus
        ["Abstractus Diabolis"]=10,
        ["Agonizer Mortus"]=10,
        ["Ash in the Eyes"]=10,
        ["Blood Fountain"]=10,
        ["Blood Overload"]=10,
        ["Bodies for Sale"]=10,
        ["Bodily Assimilation"]=10,
        ["Chains of Suffering"]=10,
        ["Death's Gratification"]=10,
        ["Devil's Dilemma"]=10,
        ["Divine Abjuration"]=10,
        ["Doors To Nowhere"]=10,
        ["Dominus Infernum"]=10,
        ["Drizzled With Phlegm"]=10,
        ["Emporium of Skulls"]=10,
        ["Fearful Whispers"]=10,
        ["Fueled by Tears"]=10,
        ["Funeral Monolith"]=10,
        ["Goat Worship"]=10,
        ["Human Barbeque"]=10, -- Nod to Evilution
        ["Human Garbage"]=10,
        ["Intestinal Jumprope"]=10,
        ["Killing Time, Killing You"]=10,
        ["Lunacy of Mankind"]=10,
        ["Melted from Within"]=10,
        ["More Than Hate"]=10,
        ["Nazarene's Scripture"]=10,
        ["Organ Slushie"]=10,
        ["Out of the Frying Pan"]=10,
        ["Sermons of Sin"]=10,
        ["Smoke and Misery"]=10,
        ["Spectral Anomalies"]=10,
        ["Tasty Human Giblets"]=10,
        ["The Beauty in Impalement"]=10,
        ["The Bitter Times"]=10,
        ["The Grey of Winter"]=10,
        ["The Hexvoid"]=10,
        ["The Invocation of Fear"]=10,
        ["Visions of Misery"]=10,
        ["Void"]=10,
        ["Windfall of Delerium"]=10,
        ["Winds of Dusk"]=10,
        ["Withered and Forgotten"]=10
      }
    }
  },
  -- end of 'GOTHIC' theme


  --------------------------------------------------

  URBAN =
  {
    patterns =
    {
      -- lexicon legend:
      -- %e = Entity
      -- %a = Adjectives
      -- %n = Places
      -- %h = Explicit description (e.g. I am Satan, "Arena of <Satan>")
      -- %o = Implicit description (e.g. I am Satanic, "Arena of <the Satanic>")
      -- %v = Prefixed phrase (as per COMMON table e.g. "<Scourge of the> Arena)
      -- %r = Road suffix (St., Street, Road, Rd., etc.)

         ["%a %n"] = 60,
      ["%t %a %n"] = 15,
      ["%t NOUNGENANGLICAN %n"] = 20,
      ["%t NOUNGENEXOTIC %n"] = 7,

      [   "%n of %h"] = 15,
      ["%t %n of %h"] = 8,
      ["%a %n of %h"] = 6,

      [   "%n of the %o"] = 15,
      ["%t %n of the %o"] = 8,
      ["%a %n of the %o"] = 6,

      ["%v %n"]    = 25,
      ["%v %a %n"] = 25,

      ["%a %n %x"] = 20,
      ["%n of the %o %x"] = 3,
      ["%v %n %x"] = 5,
      ["%v %a %n %x"] = 5,

      ["%s"] = 25,

      -- Types of roads, useful when Streets Mode
      -- kicks in.
      ["NOUNGENANGLICAN %r"] = 25,
      ["NOUNNUMBER NOUNGENANGLICAN %r"] = 40,

      ["NOUNGENEXOTIC %r"] = 13,
      ["NOUNNUMBER NOUNGENEXOTIC %r"] = 20,

      -- ObAddon contributor names
      ["NOUNMEMBERS %n"] = 5,

      ["NOUNGENANGLICAN %n"] = 35,
      ["NOUNGENEXOTIC %n"] = 10,
    },

    lexicon =
    {
      t =
      {
        The=50
      },

      r =
      {
        ["St."] = 7,
        ["Rd."] = 7,
        ["Ave."] = 7,
        ["Dr."] = 4,
        ["Pl."] = 4,
        ["Ln."] = 4,
        Street = 3,
        Road = 3,
        Avenue = 3,
        Drive = 2,
        Place = 2,
        Lane = 2
      },

      a =
      {
        -- generics,
        General=5, Generics=7,

        -- size
        Plethoric=7, Sprawling=10, Unending=7,
        Serpentine=10, Hulking=3, Giant=2, Vast=7,
        Monstrous=3, Colossal=4, Towering=3,

        --+ supernatural
        Arcane=5, Hidden=5, Ethereal=5, Nether_=5,
        Esoteric=5,

        --+ directional
        Upper=5, Lower=10,
        Northern=10, Southern=10, Eastern=10, Western=10,
        Northeast=5, Northwest=5, Southeast=5, Southwest=5,
        Inner=5, Innermost=3, Outer=5, Outermost=3,
        Focal=5, Central=5,

        --+ distance/inaccessibility
        Furthest=5, Isolated=10, Remote=5, Obscure=10,
        Lost=5,
        Cordoned=5, Quarantined=5, Sequestered=5,
        Confined=5, Secluded=5, Sealed=3,
        Restricted=5, Blocked=3, Segregated=3,
        Adjacent=5, Adjoining=5, Neighboring=5,
        Inland=5, Outland=5,

        --+ time
        Old=10, Ancient=20, Eternal=7, Archaic=7, Aged=5,
        Timeworn=5,

        --+ state of repair/damage
        Decrepid=20, Lost=10, Forgotten=10, Battered=5,
        Ravished=10, Barren=20, Deadly=5, Rickety=5,
        Flooded=5, Bombarded=2, Corrosive=2, Unsteady=3,
        Ruined=3, Charred=10, Neglected=5, Decaying=5,
        Deteriorated=5, Dilapidated=10, Frail=3, Flimsy=2,
        Wrecked=7,

        --+ decay
        Decayed=5, Putrid=5, Noxious=5,
        Stagnant=10, Rancid=5, Rotten=3,
        Sunken=3, Toxic=2, Polluted=10, Mephitic=5,
        Infected=10, Infested=10, Infective=5,
        Contaminated=10, Fetid=5, Festering=5,

        --+ weather
        Windy=10, Hazy=3, Foggy=5, Misty=10,
        Cloudy=5, Gray=5, Brackish=5, Overcast=10,
        Humid=5, Torrid=5, Tropic=2,

        --+ city
        Urban=10, Metropolitan=10, Cosmopolitan=3,
        Civic=3, Communal=5, Municipal=3,
        Capital=5, Commercial=5, Trading=5,
        Company=5, Administrative=5,

        --+ supernatural/evil
        Occult=5, Distraught=5, Malevolent=5,
        Corrupted=15, Corrupt=15, Fateful=5,
        Monster=15, Demonic=3, Demon=15,
        Frightening=10, Creepy=5, Ominous=15,
        Haunted=20, Menacing=15,
        Cursed=20, Wretched=15, Bewitched=5,
        Forbidden=20, Sinister=10, Mysterious=10,
        Profligate=5, Depraved=5, Incorrigible=3,
        Wanton=3, Dissolute=3,

        --+ wilderness
        Wild=5, Savage=10, Untamed=3,
        Unexplored=7, Teeming=3, Lush=3,
        Lupine=2,

        --+ military/criminal possession
        Invaded=5, Besieged=10, Swarmed=5,
        Overtaken=5, Stolen=3, Blockaded=3,

        --+ illumination
        Dark=20, Darkest=7, Dismal=10, Cimmerian=3,
        Murky=5, Dim=5, Aphotic=5, Caliginous=5,
        Tenebrous=5, Gloomy=5,

        --+ abandonment
        Bleak=20, Abandoned=15, Forsaken=10,
        Deserted=5, Vacated=5, Forgotten=12,
        Derelict=15, Desolate=5, Forlorn=3,
        Bereft=3, Stranded=2, Vacant=15, Empty=7,
        Dead=15,

        --+ aesthetic
        Horrible=10, Exotic=5, Dreadful=10,

        --+ temperature
        Cold=7, Bitter=3, Frigid=5, Icy=3,
        Algid=5, Polar=5, Gelid=3, Frozen=3,
        Boreal=3, Hot=7, Chilly=3, Tepid=4,
        Snowy=3, Wintry=5, Brisk=5, Mild=3,
        Cool=5,

        --+ emotion
        Lonely=2, Desperate=2, Ugly=2,

        --+ populated congestion
        Crowded=3, Cramped=3, Congested=5,
        Huddled=3, Compact=5, Crammed=2,

        --+ level of danger
        Catastrophic=5, Perilous=15, Hostile=10,
        Dangerous=10, Precarious=5, Treacherous=5,
        Formidable=3, Unsafe=5,

        Unknown=5, Living=3,
        Slaughter=5, Murder=5, Killing=5,
        Whispering=10,
      },

      n =
      {
        -- castle and castle parts
        Castle=20, Citadel=10,
        Keep=3, Slough=3, Temple=3,
        Gate=10, Prison=15, Dens=5,
        Coliseum=2, Courtyard=10, Court=10,

        -- territories
        City=20, Town=20, Village=10,
        World=5, Country=10, Zone=10,
        Square=5, Kingdom=15,
        District=10, Precinct=10,
        Dominion=10, Domain=3, Trail=10,
        Region=10, Territory=5, Path=5,
        Province=10, Jurisdiction=10,
        Township=10, Municipality=7, Borough=7,

        -- adventure
        Trek=5, Venture=5,
        Voyage=7, Odyssey=2,

        -- watery
        Harbor=10, Reserve=3, Ward=3,
        Seabed=5, Embankment=3,
        Oasis=2, Waterways=5,

        -- dirt
        Soil=10, Scum=5,
        Remnants=10, Remains=5, Debris=5,
        Refuse=5, Dust=5, Dirt=3,

        -- destruction
        Siege=5, Assault=5, Attack=5, Ambush=5,
        Onslaught=5, Stampede=5, Encounter=5,
        Conflict=5,

        -- generic flatlands
        Lands=10, Fields=10, Footprints=5,
        Warrens=5, Outskirts=10, Lots=5,
        Acreage=2, Block=10, Plots=5,
        Tracts=3,

        -- generic structures/locations
        Towers=10, Quarters=10, Division=3,
        Hub=5, Polestar=2, Post=5, Complex=15,
        Campus=5, Compound=10, Venue=2,
        Annex=5, Hallways=20, Halls=5, Corridors=7,
        Promenade=5, Cubicles=5, Wing=5,
        Building=20, Superstructure=10,
        Substructure=10, Compartment=5,

        -- pathways
        Alleys=10, Backstreets=5, Lane=5,
        Streets=10, Roads=5, Walk=3,
        Passage=5, Avenues=3, Outlets=5,
        Crossroads=5, Boulevards=3, Parkway=5,
        Route=5, Thoroughfare=3, Access=5,
        Drive=3, Junction=2, Course=5,
        Bypass=2, Gap=5, Concourse=8,
        Crossing=5, Exchange=5, Channels=5,

        -- military
        Barracks=5, Depot=3, Outpost=5,
        Fortress=20, Fort=5, Stronghold=5,
        Camp=3, Berths=5, Garage=5,

        -- weird ones
        Echo=1, Dream=1, Nightmare=1, Bliss=1,

        -- industrial
        Mines=10, Quarry=5, Docks=10,
        Warehouse=10, Port=10, Mineshaft=5,
        Firm=5, Workrooms=2, Works=3,
        Factory=10, Forge=3, Foundry=3,
        Mint=3, Sweatshops=5, Mill=10,

        -- commercial -MSSP
        Mall=10, Strip=7, Market=8,
        Mart=5, Bazaar=10, Bodega=5,
        Souk=8, Fair=10, Stores=5,
        Showrooms=5, Emporium=7,
        Groceries=3, Stadium=5, Shops=5,
        Agora=1, Marketplace=10, Offices=5,
        Agency=3, Department=5, Bureau=3,
        Suites=2, Workstation=7,

        -- civic -MSSP
        Hospital=5, Park=5, Commons=10,
        Gardens=15, Plaza=10, Embassy=5,
        Sewers=10, Asylum=10, Forum=5,
        Assembly=5, Authority=5, Services=3,
        Institution=5,

        -- residential
        Condominium=10, Condo=5, Chateau=2,
        Projects=10, Housing=5, Coop=3,
        Hive=5, Cooperative=5, Tenements=5,
        Domicile=3, Habitations=3, Abode=5,
        Settlement=7, Suburbs=10, Residences=5,
        Shelter=10, Board=5, Bunk=3, Habitat=2,
        Palace=15, Neighborhood=3, Environs=2,
        Barrio=2, House=20, Mansion=10, Manor=10,
        Estate=2, Slums=15, Refuge=5, Sanctuary=5,
        Dwelling=3, Lofts=8,

        -- architectural
        Roofs=10, Piazza=5, Portico=5, Loggia=3,
        Galleria=5, Arcade=5,

        -- battleground
        Battlefront=5, Battlezone=5, Warzone=5,
        Battlegrounds=7, Front=5, Impasse=5,
        Standoff=5, Deadlock=5, Stalemate=5,
        Quandary=5, Quagmire=3, Imbroglio=5
      },

      h = -- explicit descriptors (e.g. "Arena of Doom")
      {
        -- feels
        --+ negative
        Doom=20, Gloom=15, Despair=10, Sorrow=15,
        Horror=20, Terror=10, Death=10, Dolor=5,
        Pain=15, Fear=7, Hate=5, Desolation=3,
        Misery=10, Turmoil=5, Decay=5,
        Insanity=5, Helplessness=2, Misfortune=5,
        Voiceless=5,
        --+ positive
        Solace=10, Reparation=3, Consolation=3,
        Assuagement=3,

        -- descriptions of danger
        Danger=10, Peril=10,
        --+ elemental danger
        Acid=5, Flames=5, Lava=3,

        -- states of destruction
        Ruin=10,

        -- bodily objects
        Bone=7, Blood=10, Claws=10,
        Gore=7, Skulls=10, Tears=10,

        -- time
        Dusk=5, Twilight=5, Midnight=5, Dawn=5, Daybreak=5, Sunrise=5,
        Nightfall=5, Sundown=5, Eventide=5, Sunset=5,

        -- delusions
        Dreams=2, Delirium=2, Delusion=2,
        Doubt=5, Illusions=2, Bliss=2,

        -- bad acts
        Sabotage=5, Destruction=5,

        -- material
        Bronze=5, Iron=5, Steel=7,
        Titanium=3, Aluminum=3,

        -- residents
        --+ ethereal things
        Demigods=3, Ghosts=15, Gods=10, Spirits=5,
        Spectres=5, Banshees=5, Phantoms=5,
        Evil=5, Ghouls=5, Demons=5, Souls=5,

        ["Hell Priests"]=3, -- Doom Eternal

        --+ fantasy creatures
        Ogres=5, Gargoyles=3,
        --+ people
        Addicts=3, Creeps=3, Fools=1,
        Menace=15, Denizens=7, Murderers=3,
        Pirates=3, Vagrants=7, Junkies=3,
        Madmen=2, Mortals=10, Drifters=4,
        --+ explicitly religious people
        Martyrs=5, Prophets=5, Zealots=3, Fanatics=3,
        Believers=3, Disciples=3,
        --+ animals
        Crows=5, Prey=5,
        Vermin=5, Vultures=5,
        Spiders=2, Snakes=5,

        -- creepy furniture
        Mirrors=5, Stakes=3
      },

      o = -- implicit descriptors (e.g. "Arena of the Doomed")
      {
        -- abandoned
        Abandoned=5, Doomed=5, Damned=5,
        Forgotten=5, Forsaken=5, Lost=5,

        -- weird
        Bizarre=5, Unreal=5, Strange=5,

        -- damage
        Decayed=5,

        -- dirt
        Filthy=5, Slime=5,

        -- illusion
        Mirage=5,

        -- creatures and people
        --+ wild
        Pests=5, Vermin=5,
        --+ paranormal
        Ghosts=4, Phantasm=10, Poltergeist=10,
        Wraith=10, Undead=5, Risen=5,
        --+ occupational
        Butcher=5, Executor=5, Fiend=5,
        Slayer=5,

        -- states of being
        ---+ victimized
        Afflicted=5, Desperate=5, Diseased=5,
        Estranged=5, Faceless=5, Homeless=5,
        Misbegotten=5, Missing=5, Hunted=5,
        Sick=5, Sightless=5, Unwell=5,
        Quarantined=5,
        ---+ craycray
        Deranged=5, Disturbed=3, Hysteric=5,
        Insane=5, Mad=7,
        ---+ pretty much dead
        Dead=5, Deceased=5, Fallen=5,
        ---+ good
        Bold=5, Brave=5, Dauntless=5,
        Interpid=3, Savior=5,
        ---+ neutral
        Adamant=5, Feral=5, Untamed=5,
        Vicarious=5, Wild=5, Stray=5,
        ---+ evil
        Lawless=5, Unforgiving=5,

        -- groups
        Conclave=5, Sovereign=5, Kinship=5,
        Brotherhood=5, Sisterhood=5, Guild=5,
        Union=5, Fellowship=5,

        -- age and time
        Ancients=5, Eternal=5, Night=10
      },

      s =
      {
        -- single complete level names

        ["Abandonment"]=10,
        ["Afterhours"]=10,
        ["Aftermath"]=10,
        ["All is Lost"]=10,
        ["Apocalyptic Visions"]=10,
        ["Archipelago"]=10,
        ["Armed to the Teeth"]=10,
        ["Arson Anthem"]=10,
        ["Atomized"]=10,
        ["Awaiting Death"]=10,
        ["A Monster Too Many"]=10,
        ["Bad Company"]=10,
        ["Behind Enemy Lines"]=10,
        ["Black and Grey"]=10,
        ["Bleak"]=10,
        ["Blind Salvation"]=10,
        ["Blizzard of Glass"]=10,
        ["Blood Red Shadows"]=10,
        ["Bullets and Fireballs"]=10,
        ["Burndown"]=10,
        ["Burnout"]=10,
        ["Business District"]=10,
        ["Cacophobia"]=10,
        ["Carnival Bizarre"]=10,
        ["Chaos and Confusion"]=10,
        ["Cisterne"]=10,
        ["Cloak of Midnight"]=10,
        ["Cold Comfort"]=10,
        ["Cold Sweat"]=10,
        ["Countdown to Death"]=10,
        ["Course of Decadence"]=10,
        ["Cross Attack"]=10,
        ["Crumbled Nations"]=10,
        ["Crystalline Chaos"]=10,
        ["Darkness at Noon"]=10,
        ["Dark Apparition"]=10,
        ["Dark City"]=10,
        ["Dark Horizon"]=10,
        ["Darkened Waters"]=10,
        ["Dead End"]=10,
        ["Deadfall"]=10,
        ["Deadlock"]=10,
        ["Deadly Visions"]=10,
        ["Dead Silent"]=10,
        ["Dead Zone"]=10,
        ["Demons On The Prey"]=10,
        ["Destroy All Humans"]=10,
        ["Devil's Rejects"]=10,
        ["Doomed Society"]=10,
        ["Dropoff"]=10,
        ["Earth Scum"]=10,
        ["Eight Floors Above"]=10,
        ["Endoomed"]=10,
        ["Enter Combat"]=10,
        ["Evil or Dead"]=10,
        ["Fading to Black"]=10,
        ["Fallen into Shadows"]=10,
        ["Famine"]=10,
        ["Fatal Doom"]=10,
        ["Fight to the End"]=10,
        ["Fimbul Winter"]=10,
        ["Forebearer of Grievance"]=10,
        ["Forgotten"]=10,
        ["Foul Ruin"]=10,
        ["God's Little Acre"]=10,
        ["Graveflower"]=10,
        ["Graveyard Shift"]=10,
        ["Gray Skies"]=10,
        ["Greek Fire"]=10,
        ["Hellbrigade"]=10,
        ["Hell's Kitchen"]=10,
        ["Hell's Triumph"]=10,
        ["Hidden Screams"]=10,
        ["Hiding the Secrets"]=10,
        ["House of a Thousand Deaths"]=10,
        ["Human Debris"]=10,
        ["In Remembrance"]=10,
        ["In Solitary Ruin"]=10,
        ["In the Final Hour"]=10,
        ["Irradiated"]=10,
        ["Jailbird"]=10,
        ["Judgement Day"]=10,
        ["Kitchen Ace"]=10,
        ["Left in the Cold"]=10,
        ["Library of the Lost"]=10,
        ["Lights Out!"]=10,
        ["Long Gone"]=10,
        ["Lucid Illusion"]=10,
        ["Lucifer in Starlight"]=10,
        ["Lunatic Fringe"]=10,
        ["Mayhem"]=10,
        ["March of the Zombies"]=10,
        ["Nightfall"]=10,
        ["Night Stalkers"]=10,
        ["Night Terrors"]=10,
        ["No Guts No Glory"]=10,
        ["No Rest No Peace"]=10,
        ["Nothing's There"]=10,
        ["On the Hunt"]=10,
        ["One Too Many"]=10,
        ["Open Wound"]=10,
        ["Organized Chaos"]=10,
        ["Overtime"]=10,
        ["Patron of Antipathy"]=10,
        ["Population One"]=10,
        ["Poison Society"]=10,
        ["Polygraph"]=10,
        ["Pinciple of War"]=10,
        ["Pitch Black"]=10,
        ["Primetime Killing"]=10,
        ["Punctured"]=10,
        ["Quietus"]=10,
        ["Riddled by Gunfire"]=10,
        ["R.I.P Humanity"]=10,
        ["Red Valhalla"]=10,
        ["Realm of Chaos"]=10,
        ["Remains of Humanity"]=10,
        ["Retribution"]=10,
        ["Roadkill"]=10,
        ["Roctagon"]=10,
        ["Rotten Roots"]=10,
        ["Running of the Bulls"]=10,
        ["Sanctuary"]=10,
        ["Set the World on Fire"]=10,
        ["Shellshock"]=10,
        ["Shadowland"]=10,
        ["Silent Might"]=10,
        ["Sin City"]=10,
        ["Solitude"]=10,
        ["Stakeout"]=10,
        ["Stille Nacht"]=10,
        ["Stonegate"]=10,
        ["Subjugated"]=10,
        ["Suspense"]=10,
        ["Terminal Fear"]=10,
        ["Ten Degrees of Fate"]=10,
        ["Terrorville"]=10,
        ["The Blackest Day"]=10,
        ["The Bones of Many"]=10,
        ["The Fading Light"]=10,
        ["The Fire Still Burns"]=10,
        ["The Guns Fall Silent"]=10,
        ["The Hook"]=10,
        ["The Silenced Lamasery"]=10,
        ["The Sun No Longer Rises"]=10,
        ["The Trial"]=10,
        ["The Winds Speak None"]=10,
        ["This is The End"]=10,
        ["Tombstone"]=10,
        ["Under Ruins"]=10,
        ["Unleashed Aggression"]=10,
        ["Urban Horror"]=10,
        ["Valley of the Dead"]=10,
        ["Viscera"]=10,
        ["Voice of the Voiceless"]=10,
        ["Walk of Faith"]=10,
        ["Warzone"]=10,
        ["Watch it Burn"]=10,
        ["Watch your Step"]=10,
        ["When the Candle Fades"]=10,
        ["Where Marines Dare"]=10,
        ["Witch Parade"]=10,
        ["Xenophobia"]=10,

        ["Ambushed!"]=10,
        ["Bullet Hole"]=10,
        ["Civil Disobedience"]=10,
        ["Disestablishment"]=10,
        ["Eaten by the Furniture"]=10,
        ["Escape is Futile"]=10,
        ["Fight That!"]=10,
        ["Forboding Signs"]=10,
        ["Mindless Architecture"]=10,
        ["Mow 'em Down!"]=10,
        ["Nobody's Home"]=10,
        ["No Comfort"]=10,
        ["Out of Luck"]=10,
        ["Passing Away"]=10,
        ["Route to Death"]=10,
        ["Stream of Unconsciousness"]=10,
        ["Struggle No More"]=10,
        ["Today You Die!"]=10,
        ["Ups and Downs"]=10,
        ["You Don't Belong Here"]=10,

        -- Armaetus adds more names
        ["A Destructive Path"]=10,
        ["A Doomsday Scenario"]=10,
        ["Administrative Errors"]=10,
        ["Black Hole"]=10,
        ["Charred To The Bone"]=10,
        ["Chaos Unfolds"]=10,
        ["Crosses and Pikes Abound"]=10,
        ["Deny the Narrative"]=10,
        ["Diamond of Chaos"]=10,
        ["Hell in Your Lap"]=10,
        ["Industrial Architecture"]=10,
        ["Forever Wandering"]=10,
        ["Manor of Glass"]=10,
        ["Multi Paths, Multi Deaths"]=10,
        ["Nothing But A Husk"]=10,
        ["Nuclear Annihilation"]=10,
        ["Null and Void"]=10,
        ["Scrounge"]=10,
        ["Stand Your Ground"]=10,
        ["Steel Scraps"]=10,
        ["The Mysteries of Octothorp"]=10, -- Come on crowbars82, come and finish your mod lol
        ["The No Go Zone"]=10,
        ["The Twisted Abode"]=10,
        ["Planetary Destruction"]=10,

        -- MSSP adds more names as well
        ["Damned Demon Destruction"]=10, -- Demios

        -- Doom Eternal stuff. Would these be better under Hell?
        ["Ardur"]=10,
        ["Kher Lodur"]=10,
        ["Neras"]=10,
        ["Taras Nabad"]=10,

        -- Armaetus adds more names, 2020 edition
        ["A Hobo's Paradise"]=10,
        ["Bombardment"]=10,
        ["Everlasting Ashstorm"]=10,
        ["Expenditure of Munitions"]=10,
        ["Fixation on Survival"]=10,
        ["Howling Corridors"]=10,
        ["The Smell of Plasma"]=10,
        ["Vertical Drop"]=10,

        -- 2021 naming convention by Armaetus
        ["A Clouded Sun"]=10,
        ["A Fate No Worse"]=10,
        ["Abandoned"]=10,
        ["Among the Abyss"]=10,
        ["Art of Urban Decay"]=10,
        ["Ashen Grip"]=10, -- Elder Scrolls Online stuff
        ["Beyond the Mist"]=10,
        ["Beyond Survival"]=10,
        ["Blazing Skyscrapers"]=10,
        ["Blessed Twilight"]=10,
        ["Blood Among the Soot"]=10,
        ["Contemporary Silence"]=10,
        ["Cold, Icy Winds"]=10,
        ["Corporatis Infernus"]=10,
        ["Crawling Through Glass"]=10,
        ["Criteria of a Bum"]=10,
        ["Decay of Sunlight"]=10,
        ["Desolation Deluxe"]=10,
        ["Dumpsters and Demons"]=10,
        ["Dwelling in the Shroud"]=10,
        ["End of Seasons"]=10,
        ["Fading Sun"]=10,
        ["Firestorm"]=10,
        ["Frontier of Dust"]=10,
        ["Hymn of Solitude"]=10,
        ["Letting it all Go"]=10,
        ["Long Forgotten"]=10,
        ["Lurking Death"]=10,
        ["Monoliths of Ruin"]=10,
        ["No Go Zone"]=10,
        ["No Peace Here"]=10,
        ["No Return"]=10,
        ["Rain"]=10,
        ["Retirement of Man"]=10,
        ["Ruined"]=10,
        ["Shadows Among Us"]=10,
        ["The Sawtooth Smile"]=10,
        ["The Scent of Ash"]=10,
        ["This Graveyard Earth"]=10,
        ["Unspoken Stars"]=10,
        ["Urban Megalths"]=10,
        ["When All Hope is Lost"]=10,
        ["Wicked Corridors"]=10
      }
    }
  },
  -- end of 'URBAN' theme

  CASTLE =
  {
    patterns =
    {
      -- lexicon legend:
      -- %e = Entity
      -- %a = Adjectives
      -- %n = Places
      -- %h = Explicit description (e.g. I am Satan, "Arena of <Satan>")
      -- %o = Implicit description (e.g. I am Satanic, "Arena of <the Satanic>")
      -- %v = Prefixed phrase (as per COMMON table e.g. "<Scourge of the> Arena)
      -- %r = Road suffix (St., Street, Road, Rd., etc.)

         ["%a %n"] = 60,
      ["%t %a %n"] = 15,
      ["%t NOUNGENANGLICAN %n"] = 20,
      ["%t NOUNGENEXOTIC %n"] = 7,

      [   "%n of %h"] = 15,
      ["%t %n of %h"] = 8,
      ["%a %n of %h"] = 6,

      [   "%n of the %o"] = 15,
      ["%t %n of the %o"] = 8,
      ["%a %n of the %o"] = 6,

      ["%v %n"]    = 25,
      ["%v %a %n"] = 25,

      ["%a %n %x"] = 20,
      ["%n of the %o %x"] = 3,
      ["%v %n %x"] = 5,
      ["%v %a %n %x"] = 5,

      ["%s"] = 25,

      -- Types of roads, useful when Streets Mode
      -- kicks in.
      ["NOUNGENANGLICAN %r"] = 25,
      ["NOUNNUMBER NOUNGENANGLICAN %r"] = 40,

      ["NOUNGENEXOTIC %r"] = 13,
      ["NOUNNUMBER NOUNGENEXOTIC %r"] = 20,

      -- ObAddon contributor names
      ["NOUNMEMBERS %n"] = 5,

      ["NOUNGENANGLICAN %n"] = 35,
      ["NOUNGENEXOTIC %n"] = 10
    },

    lexicon =
    {
      t =
      {
        The=50
      },

      e =
      {

        -- Here come the Lovecraftians!
        Ktulu=2, Dagon=3, Nyarlathotep=2,

        -- civilizations that don't even exist anymore
        -- evil stuff (Sumerians, Akkadians etc.)
        Erishkigal=3, Utukku=3, Namtar=2, Lamashtu=2,
        Ninurta=3, ["Ardat Lili"]=2, Asag=2,

        -- Dungeons and Dragons / Pathfinder
        -- note: a lot of these names are probably borrowed
        -- from elsewhere (i.e. real world cultures) so they
        -- should be sorted into there instead...
        Yeenoghlu=3, Adimarchus=3, Lolth=3,
        Gresil=2, Jubilex=3, Kerzit=2, Caasimolar=3,

        --==| couldn't figure it out |==--
        --+ totally no clue
        Ceren=2, Dozod=2, Kalrac=2, Quenna=3,

        Draco=2, -- it's Latin for dragon but I don't know anything else more specific
        Ouroboros=5, -- actually sort of a neutral symbol

        -- Hexen?
        Vuradi=2,

        --+ Are these book authors? They don't seem to be the 'demonic' sort.
        Oltion=2, Orgel=2,

        --+ Is this supposed to be Balrog from LotR or a variant from other media?
        Balrok=3,

        -- Chaos Lords
        -- See: https://en.wikipedia.org/wiki/Law_and_Chaos
        Arioch=3, Mabelode=3, Urleh=3, Xiombarg=3,

        -- Demonology A-Z names, see: https://hellhorror.com/demon-names-list-A/
        Abatu=3, Abdiel=3, Abduxuel=3, Abezethibou=3, Adramelech=3, Angrboda=3, Apollyon=3,
        Asakku=3, Atazoth=3, Flauros=3, Glasyalabolas=3, Jezebeth=3, Merihim=3, Morax=3,
        Nicor=3, Nybbas=3, Nysrogh=3, Onoskelis=3, Philatanus=3, Sonneillon=3, Sorath=4,
        Thamuz=3, Valafar=3, Verdelet=3,


        -- ObAddon contributor names
        NOUNMEMBERS = 90,

        NOUNGENEXOTIC = 700
      },

      r =
      {
        Path=50
      },

      a =
      {
        Magical=50,
        Mystical=50
      },

      n =
      {
        Castle=20, Citadel=10,
        Keep=3, Slough=3, Temple=3,
        Gate=10, Prison=15, Dens=5,
        Coliseum=2, Courtyard=10, Court=10
      },

      h = -- explicit descriptors (e.g. "Arena of Doom")
      {
        Blasphemy=50,
        Evil=50
      },

      o = -- implicit descriptors (e.g. "Arena of the Doomed")
      {
        Eternal=50,
        Baleful=50,
        Consumed=50,
        Corrupted=50,
        Diabolic=50,
        Eternal=50,
        Ruined=50,
        Shattered=50,
        Unhallowed=50
      },

      s =
      {
        -- single complete level names
        ["Castle of Incomplete Heretic Support"]=10
      }
    }
  },
  -- end of 'CASTLE' theme

  --------------------------------------------------

  BOSS =
  {
    patterns =
    {
      ["%s"] = 10,
    },

    lexicon =
    {
      s =
      {
        ["Angelic Exodus"]=10,
        ["Arena of Terror"]=10,
        ["Bad Neighbors"]=10,
        ["Barrier"]=10,
        ["Barons' Rhapsody"]=10,
        ["Battle Royale"]=10,
        ["Blast Through"]=10,
        ["Bleed on Me"]=10,
        ["Blessed Are the Quick"]=10,
        ["Bloodbath"]=10,
        ["Border Crossing"]=10,
        ["Boss Cage"]=10,
        ["Brick Wall"]=10,
        ["Captured"]=10,
        ["Caughtyard"]=10,
        ["Checkmate"]=10,
        ["Close Combat"]=10,
        ["Coliseum"]=10,
        ["Coronary Bypass"]=10,
        ["Creepshow"]=10,
        ["Cyberstomp"]=10,
        ["Death Sentence"]=10,
        ["Deicide Ultra"]=10,
        ["Deliverance"]=10,
        ["Die Hard"]=10,
        ["Divider"]=10,
        ["Dog Eat Dog"]=10,
        ["Do or Die"]=10,
        ["End of Days"]=10,
        ["Execution"]=10,
        ["Eye for an Eye"]=10,
        ["Fatality"]=10,
        ["Fate"]=10,
        ["Final Fight"]=10,
        ["Fire Amok"]=10,
        ["Gateway"]=10,
        ["Gladiator"]=10,
        ["Ground Zero"]=10,
        ["Guardian"]=10,
        ["Hail of Bullets"]=10,
        ["Halted in Your Tracks"]=10,
        ["Hard Attack"]=10,
        ["Hardball"]=10,
        ["Hellmouth"]=10,
        ["Into The Ground"]=10,
        ["I Expect You to Die"]=10,
        ["Kill Frenzy"]=10,
        ["Killswitch"]=10,
        ["Kingdom Come"]=10,
        ["Knockout"]=10,
        ["Lion's Den"]=10,
        ["Lucid"]=10,
        ["Melee!"]=10,
        ["Mission Improbable"]=10,
        ["Moving Target"]=10,
        ["Murderplay"]=10,
        ["Nightmare Without End"]=10,
        ["Nemesis"]=10,
        ["No Exit!"]=10,
        ["No Sweat"]=10,
        ["Nowhere to Go"]=10,
        ["Not So Simple"]=10,
        ["Nucleus"]=10,
        ["Open Fire"]=10,
        ["Panic Room"]=10,
        ["Perfect Conflict"]=10,
        ["Playground"]=10,
        ["Proving Grounds"]=10,
        ["Punchline"]=10,
        ["Razor's Edge"]=10,
        ["Recess"]=10,
        ["Rip and Tear"]=10,
        ["Roadblock"]=10,
        ["Screamin' Marines"]=10,
        ["Showdown"]=10,
        ["Showtime!"]=10,
        ["Shoot First Ask Later"]=10,
        ["Sinister"]=10,
        ["Sink or Swim"]=10,
        ["Six Feet Under"]=10,
        ["Slaughterfest"]=10,
        ["SNAFU"]=10,
        ["Soul Trap"]=10,
        ["Stop Fight Go"]=10,
        ["Sudden Death"]=10,
        ["The Hunt"]=10,
        ["The New Fury"]=10,
        ["The Purge"]=10,
        ["The Second Coming"]=10,
        ["The Trap"]=10,
        ["There Can Be No Victory"]=10,
        ["Total Doom"]=10,
        ["Trapped"]=10,
        ["Trial by Fire"]=10,
        ["Trial of Mankind"]=10,
        ["Trouble in Paradise"]=10,
        ["Unmaker"]=10,
        ["Unwelcome"]=10,
        ["Victory Zero"]=10,
        ["Welcome to Thy Doom"]=10,
        ["What Color is Death?"]=10,
        ["You May Not Pass!"]=10,

        -- MSSP adds names

        ["1995"]=10,
        ["Above and Beyond"]=10,
        ["Absolute Terror Field"]=10,
        ["Ace of Spades"]=10,
        ["Appointment in Samarra"]=10,
        ["Armaggeddon"]=10,
        ["A Study In Red"]=10,
        ["Back in Black"]=10,
        ["Bad Blood"]=10,
        ["Bad News"]=10,
        ["Bellum Infinitus"]=10,
        ["Bone Hurting Juice"]=10,
        ["Big Guts"]=10,
        ["Bloodlust"]=10,
        ["Bring It"]=10,
        ["Bring Out Your Dead"]=10,
        ["Catch-22"]=10,
        ["Dance with the Devils"]=10,
        ["Darwin Awards"]=10,
        ["Damnation"]=10,
        ["Danger Zone"]=10,
        ["Dead Reckoning"]=10,
        ["Diabolus Ex"]=10,
        ["Don't Stop Me Now"]=10,
        ["Doom Eternal"]=10,
        ["Do Panic"]=10,
        ["Do You Want To Live Forever?"]=10,
        ["Endgame"]=10,
        ["Exterminatus"]=10,
        ["Fear No Evil"]=10,
        ["Forlorn Hope"]=10,
        ["FUBAR"]=10,
        ["Fucking Run"]=10,
        ["Future Imperfect"]=10,
        ["Get Psyched!"]=10,
        ["Gotcha!"]=10,
        ["Greased"]=10,
        ["Gratuitous Combat Scenario"]=10,
        ["Hardboiled"]=10,
        ["Hardcore"]=10,
        ["Heavy Metal Mayhem"]=10,
        ["He Comes"]=10,
        ["Hellraiser"]=10,
        ["Here Comes the Night Train"]=10,
        ["Hold Your Ground"]=10,
        ["Highway to Hell"]=10,
        ["High Water"]=10,
        ["Iron Maiden"]=10,
        ["I Don't Feel So Good"]=10,
        ["I Ii II L"]=10,
        ["Judgement"]=10,
        ["Killing Fields"]=10,
        ["Max Pain"]=10,
        ["Meatgrinder"]=10,
        ["Nine Inch Nails"]=10,
        ["No Chance in Hell"]=10,
        ["No Rest For The Wicked"]=10,
        ["No Man's Land"]=10,
        ["No One Escapes"]=10,
        ["No Place for a Hero"]=10,
        ["No Surrender"]=10,
        ["Objective: Survive"]=10,
        ["One Doomed Marine"]=10,
        ["Oof!"]=10,
        ["On Your Knees"]=10,
        ["Ouch!"]=10,
        ["Ouch Oof Owie"]=10,
        ["Owie!"]=10,
        ["Painkiller"]=10,
        ["Pressure"]=10,
        ["Rains of Castamere"]=10,
        ["Realm of the Mad God"]=10,
        ["Red Alert"]=10,
        ["Resistance is Futile"]=10,
        ["Run"]=10,
        ["Running with Scissors"]=10,
        ["Seven Trumpets Sounding"]=10,
        ["Surrounded!"]=10,
        ["Standoff"]=10,
        ["Stranglehold"]=10,
        ["Suicide Mission"]=10,
        ["Tears in the Rain"]=10,
        ["Time to Kill"]=10,
        ["Tip of the Spear"]=10,
        ["The Fate of All Things"]=10,
        ["The Game Is On"]=10,
        ["The Part Where He Gets You"]=10,
        ["The Sentinel's Playground"]=10,
        ["The Throne of Skulls"]=10,
        ["The Tribute"]=10,
        ["The World Burns"]=10,
        ["Trauma Conga Line"]=10,
        ["Wild Hunt"]=10,
        ["You Are Already Dead"]=10,
        ["You'll Float Too"]=10,
        ["You'll See"]=10,
        ["Zone of Alienation"]=10,

        -- Armaetus adds names too
        ["A Friend to Upheaval"]=10,
        ["Burned and Shut In"]=10,
        ["Circumscribed by Hell"]=10,
        ["Destiny"]=10,
        ["Diagnosis Death"]=10,
        ["Disruption of Worlds"]=10,
        ["Doom"]=10, -- Yeah lol, it's a word to use
        ["From Every Direction"]=10,
        ["Hellish Blockade"]=10,
        ["In a Snag"]=10,
        ["Karma's a Bitch"]=10,
        ["Kill or Be Killed"]=10,
        ["Knocked Down a Peg"]=10,
        ["Mental Collapse"]=10,
        ["Obstruction"]=10,
        ["One Man's Ordeal"]=10,
        ["Only Way Through"]=10,
        ["Sirens Blaring"]=10,
        ["Subjugation"]=10,
        ["Toll Booth From Hell"]=10,
        ["The Kismet of Marines"]=10, -- https://www.dictionary.com/browse/kismet
        ["The Oppressors"]=10,
        ["The Slow Painful Crush"]=10,
        ["Unwanted Termination"]=10,
        ["Wheel of Misfortune"]=10,
        ["Zero Calm Here"]=10,

        ["Sentinel Prime"]=10, -- Doom Eternal

        -- 2021 additions
        ["A Bit Too Simple"]=10,
        ["Dead End"]=10,
        ["Much Too Simple"]=10
      }
    }
  },
  -- end of 'BOSS' theme

  --------------------------------------------------

  PSYCHO =
  {
    patterns =
    {
      ["%s"] = 10,
    },

    lexicon =
    {
      s =
      {
        -- soap operas, lol
        ["All My Children"]=10,
        ["Another World"]=10,
        ["A World Apart"]=10,
        ["Beast Benders"]=10,
        ["Days of our Lives"]=10,
        ["Dynasty"]=10,
        ["Faraway Hill"]=10,
        ["Falcon Crest"]=10,
        ["Guiding Light"]=10,
        ["Happy Days"]=10,
        ["Malibu Shoes"]=10,
        ["Melrose Place"]=10,
        ["One Life to Live"]=10,
        ["Passions"]=10,
        ["Paper Dolls"]=10,

        -- foods
        ["Alphabet Soup"]=10,
        ["Banana Split"]=10,
        ["Bland Cereal"]=10,
        ["Broccoli!"]=10,
        ["Candyland"]=10,
        ["Chow Mein"]=10,
        ["Chocolate Mountain"]=10,
        ["Cooking Your Testicles"]=10,
        ["Fried Chicken"]=10,
        ["Fruity Tooty"]=10,
        ["General Tso's Chicken"]=10,
        ["Gorilla Biscuit"]=10,
        ["Gingerbread Men"]=10,
        ["Kitten Pie"]=10,
        ["Liver and Onions"]=10,
        ["Marmalade Trees"]=10,
        ["Moldy Bread"]=10,
        ["Mushroom Kingdom"]=10,
        ["Oreos"]=10,
        ["Raspberry Cheesecake"]=10,
        ["Salad Melody"]=10,
        ["Seedless Watermelon"]=10,
        ["Sour Patch Kids"]=10,
        ["Sushi Wooshy"]=10,
        ["Swedish Meatballs"]=10,
        ["Tasty Morsel"]=10,
        ["The Brownie Institute"]=10,
        ["Valleys of Cream"]=10,
        ["Wurst to Wear"]=10,

        -- others
        ["99 Cents"]=10,
        ["100 Ways to Fry"]=10,
        ["All Your Base"]=10,
        ["Anthem for Doom"]=10,
        ["Axis of Evil"]=10, --Sodom "Axis of Evil" track
        ["Andrew's Jumpy Castle"]=10,
        ["A Wibbly Wobbly Hell"]=10,
        ["Baron's Hideout"]=10,
        ["Bait the Hook"]=10,
        ["Beginning of the Line"]=10,
        ["Balls"]=10,
        ["Behave Yourself"]=10,
        ["Bling Bling"]=10,
        ["Bill vs Steve"]=10,
        ["Binary Blob World Order"]=10,
        ["Bitch Lasanga"]=10, --lol Pewdiepie
        ["Blimey Teddy"]=10,
        ["BOHICA"]=10, --Military slang acronym "Bend over, here it comes again",
        ["Bork Bork Bork"]=10,
        ["Cats Rule Here"]=10,
        ["Catapult!"]=10,
        ["Ceiling Spikes"]=10,
        ["Cool Breeze"]=10,
        ["Cyberdemon's Clubhouse"]=10,
        ["Code Pink"]=10,
        ["Coffee Planet"]=10,
        ["Chasing Eagles"]=10,
        ["Clockwork"]=10,
        ["Copyright Violation"]=10,
        ["Construct More Pylons"]=10,
        ["Cronky Blonky"]=10,
        ["Culture War 101"]=10,
        ["Dat"]=10,
        ["Dat's Some Trippy Shit"]=10,
        ["Disco Inferno"]=10,
        ["Don't Feed the Demons"]=10,
        ["Doomworld's Memo"]=10,
        ["Dancing Letters"]=10,
        ["Demonitized"]=10,
        ["Dregs"]=10,
        ["Dragon Rainbow"]=10,
        ["Drawing Arrows"]=10, --Against Nature song
        ["Dunked"]=10,
        ["Dysfunctional Doomguy"]=10,
        ["Essel's Fort -TM-"]=10, --esselfortium, a Doomworld regular and moderator
        ["E for Effort"]=10,
        ["Enter With Drag On"]=10,
        ["Eye Sore"]=10,
        ["ERROR: No Level Name."]=10,
        ["Family Time"]=10,
        ["Far Out!"]=10,
        ["Fatal Error"]=10,
        ["Fishing Expedition"]=10,
        ["Flipping the Linedef"]=10, --retxirT
        ["FOOBAR"]=10,
        ["Foobie Bletch"]=10,
        ["Froody Hoody Froo"]=10,
        ["Fraggle's Sock"]=10, --Fraggle, Doomworld moderator and author of Chocolate Doom
        ["Game Settings"]=10,
        ["Geronimo"]=10,
        ["Get Woke, Go Broke"]=10, --TheQuartering
        ["Glass Horizon"]=10,
        ["Go Boom Boom"]=10,
        ["Grandstander"]=10,
        ["Guts"]=10,
        ["Havering Hovercrafts"]=10,
        ["Hello Sailor!"]=10,
        ["Hello There"]=10,
        ["Hole In Your Head"]=10, --Vaguely close to Nine Inch Nails
        ["Holy Smokes"]=10, --Suzzy Roche
        ["Homeboy"]=10,
        ["Howdy Doody"]=10,
        ["Hawaiian Shirt"]=10,
        ["Heard of Cows?"]=10,
        ["I See Dead People"]=10, --Movie: The Sixth Sense (1999)
        ["Idiots Preferred"]=10,
        ["Inflating Dwarfs"]=10, --Based on a song by band named Against Nature
        ["-Insert Map Name Here-"]=10,
        ["Inverted Autumn"]=10,
        ["It's Over 9000!"]=10, --DBZ meme
        ["Ka Ching!"]=10,
        ["Kate's Blanket"]=10,
        ["LazyTown"]=10, -- RIP Robbie Rotten :(
        ["Lame Level"]=10,
        ["Level in the Pubic Domain"]=10,
        ["Like Wow Man"]=10,
        ["Linedef Burning"]=10,
        ["Linguica's Big Block"]=10, --Doomworld co-founder and administrator
        ["Linux Land"]=10,
        ["LOLWUT"]=10,
        ["Magnitude 10"]=10,
        ["Massive WTF"]=10,
        ["Map of No Return"]=10,
        ["Mind Blower"]=10,
        ["Meme Review"]=10, --Pewdiepie
        ["Money Machine"]=10,
        ["Mixed and Measured"]=10,
        ["Make Oblige Great Again"]=10, --A play on Donald Trump's "Make America Great Again" slogan
        ["Monkeys To Infinity"]=10,
        ["Moonwalk"]=10, --Michael Jackson
        ["Munchies"]=10,
        ["Night Terrors"]=10,
        ["No Clue"]=10,
        ["Nobody Hears You"]=10,
        ["Not A Clown World"]=10,
        ["Note To Self"]=10,
        ["Oh Noes!"]=10,
        ["Omega-Kappa-Beta Outpost"]=10,
        ["One Step at A Time"]=10,
        ["Ooomph!"]=10,
        ["Over the Rainbow"]=10,
        ["Paper Cut"]=10,
        ["Picasso's Abode"]=10,
        ["Pirate Spaceship"]=10,
        ["Poppy Seed Grinder"]=10,
        ["Powered By GitHub"]=10,
        ["Press ALT + F4 for God Mode!"]=10,
        ["Press SPACE to Format C:"]=10,
        ["Pukage"]=10,
        ["Puppy Containment"]=10,
        ["Pure Bliss"]=10,
        ["Purple Haze"]=10, --Jimi Hendrix
        ["Rainstorm Incoming"]=10,
        ["Raise The Flag"]=10,
        ["Resurrection"]=10,
        ["Retinal Overload"]=10,
        ["Robbie Rotten's Skeleton Closet"]=10, --LazyTown
        ["Roast 'Em & Toast 'Em"]=10,
        ["Safety Zone"]=10,
        ["Shrouded in Fuzz"]=10,
        ["Shenanigans"]=10,
        ["Shonky Parts"]=10,
        ["Silly Hall"]=10,
        ["SNAFU"]=10,
        ["Soylent Green"]=10,
        ["Snakes and Ladders"]=10, --A well known children's tabletop game
        ["Stash that Trash!"]=10,
        ["Spoon Clank"]=10, --Styxhexenhammer666,
        ["Sonata in Z Major"]=10,
        ["Subscribe to Pewdiepie"]=10, --The old Pewdiepie/T-Series "War",
        ["Super Hero"]=10,
        ["Technicolor Dazzle"]=10,
        ["That Guy Next Door"]=10,
        ["The Bums of the Future"]=10,
        ["The Perfect Map"]=10,
        ["The Prefabricator"]=10,
        ["Them Bones"]=10, --Alice in Chains
        ["Tim's Beanie Buffet"]=10, --Timcast/Tim Pool
        ["This is Not a Hangar Remake"]=10,
        ["Touch Me Not"]=10,
        ["Twitty Twatty Twee"]=10, --Twitter?
        ["No more visplanes!"]=10,
        ["Wolfgang Blues"]=10,
        ["Welcome to 7-11"]=10,
        ["Wet Behind the Ears"]=10,
        ["What??"]=10,
        ["Wheat Field"]=10,
        ["Where is Armaetus?"]=10, --I'm right here!!
        ["Where's the Lamb Sauce?"]=10, --Gordon Ramsay
        ["Yet Another Rewrite"]=10,
        ["You Are Over The Sidedef Limit!"]=10,
        ["You Be Gangsta"]=10,
        ["You Will Oblige"]=10,
        ["You'll Shoot Your Eye Out"]=10,
        ["Yloh Elbib"]=10,
        ["Zone of a Billion Deaths"]=10,

        -- MSSP adds names
        ["404 Not Found"]=10,
        ["Deleting System32"]=10,
        ["Device is not Responding"]=10,
        ["Hard Fault"]=10,
        ["Invalid String Value"]=10,
        ["LEV.description"]=10,
        ["Memory Dump"]=10,
        ["Please Reinstall Drivers"]=10,
        ["You Have 23 Infections!!!"]=10,
        ["Your System Is Below Requirements"]=10,

        -- Armaetus adds errors too
        ["Access is Denied"]=10, --ERROR_INVALID_ACCESS
        ["Data Error"]=10, --ERROR_CRC
        ["Network Access is Denied"]=10, --ERROR_NETWORK_ACCESS_DENIED
        ["The Data is Invalid"]=10,  --ERROR_INVALID_DATA
        ["The Device is Not Ready"]=10, --ERROR_NOT_READY
        ["The Environment is Incorrect"]=10, --ERROR_BAD_ENVIRONMENT
        ["The Media is Write Protected"]=10, --ERROR_WRITE_PROTECTED
        ["The Printer is Out of Paper"]=10, --ERROR_OUT_OF_PAPER

        -- Linux..
        ["Block Device Required"]=10, --ENOTBLK
        ["Broken Pipe"]=10, --EPIPE
        ["Inappropriate IOCTL for Device"]=10, --ENOTTY
        ["Invalid Cross-Device Link"]=10, --EXDEV
        ["Link Number Out of Range"]=10, --ELNRNG
        ["No Such Process"]=10, --ESRCH
        ["Protocol Driver Not Attached"]=10, --EUNATCH
        ["Text File Busy"]=10, --ETXTBSY

        ["1000-Degree Knives"]=10,
        ["Bad Unboxing"]=10,
        ["Chocolate Rain"]=10, --Tay Zonday
        ["Drink More Water"]=10,
        ["EA Sports. It's In The Game"]=10,
        ["Hey Sup Beautiful Bastards"]=10, --if we're really doing popular YouTubers
        ["It's Just a Prank, Bro!"]=10, --had to
        ["It's Just a Social Experiment"]=10,
        ["Nobody Got Time For That"]=10,
        ["VGCG"]=10,
        ["You Wouldn't Steal a Car"]=10,
        ["Papa Bless"]=10,

        -- literature (or derived/deviated from them)
        ["Brave New World"]=10,
        ["Caught in the Rye"]=10,
        ["Silence of the Lambs"]=10,
        ["The Dragon Tattoo"]=10,
        ["The Raven"]=10,

        -- Bands or songs (generally or sort of psychedelic)
        ["Here Comes The Rooster"]=10, --Alice in Chains
        ["Here Comes The Sun"]=10,
        ["Good Times Bad Times"]=10,
        ["White Rabbit"]=10,
        ["Tame Impala"]=10,

        -- Doom Eternal
        ["Doomslayer's House of Doom"]=10,
        ["Hell Priests Come to Town"]=10,
        ["VEGA Says Hello"]=10,

        -- Some really weird shit
        -- (See https://www.doomworld.com/forum/topic/62633-doom-human-body-allegory/ )
        ["Agonize Echo Muladhara"]=10,
        ["Animating Force"]=10,
        ["Ankar Left Hand Path Cat"]=10,
        ["Base Tail Bone Chakra"]=10,
        ["Blue Heap Monster Corpse"]=10,
        ["Blue Light Begin Glow"]=10,
        ["Break Mutter"]=10,
        ["Bury Cloth"]=10,
        ["Brain Spring Leak"]=10,
        ["Climb Dog Head Eskimo"]=10,
        ["Cyber Daemon Iron Shoe"]=10,
        ["Daemon Annunaki Messenger"]=10,
        ["Deck Chair Nose Buy"]=10,
        ["Dragon Perfect Prana"]=10,
        ["Heart Chakra"]=10,
        ["Human Body Allegory"]=10,
        ["Infinite Chakra"]=10,
        ["Jumbo Jet Bury Cloth"]=10,
        ["Magnum Opus Allegory"]=10,
        ["Peace Flow Water Quaint"]=10,
        ["Reptoid Hiss Game Wrong"]=10,
        ["Rat Right Hand Path"]=10,
        ["Ruin Daemon Spit Skull"]=10,
        ["Skin Live Learn Speak"]=10,
        ["Step Transport Hear"]=10,
        ["Time Lie Quiet Town"]=10,
        ["Time Vacation Burst"]=10,
        ["Universe Vibration"]=10,
        ["Vertabre Kundalini Enlightenment"]=10,
        ["Vibrate Spirit"]=10,

        -- Armaetus adds even more, 2020 edition
        ["123 WAD Street"]=10,
        ["Goatwave Hornstorm"]=10,
        ["Hallowed Chipmunks"]=10,
        ["K"]=10,
        ["Locust Masqurade"]=10,
        ["Super Shotgun Smoothie"]=10,

        -- Yet more shit, added as end of 2020 stuff!
        -- From the Doom level name generator:
        -- http://www.teamhellspawn.com/exl/name_gen/
        ["A Weather Thinker"]=10,
        ["Acid Wizards"]=10,
        ["Burned Goat"]=10,
        ["Carmack's Castle"]=10,
        ["Combining Question"]=10,
        ["Consumed UAC Project"]=10,
        ["Courtyard of Opiophobia"]=10,
        ["Dirty Mancubus"]=10,
        ["Empty Masters"]=10,
        ["Fiery Biosphere"]=10,
        ["Flesh Massacred"]=10,
        ["For No Woeful Angels"]=10,
        ["Haunted Furnace"]=10,
        ["Hurt Settlement"]=10,
        ["Hurting Exodus"]=10,
        ["Inside the Rift"]=10,
        ["Invisible Fate"]=10,
        ["Losing the Problem"]=10,
        ["Lost Point"]=10,
        ["Making Every Question"]=10,
        ["No Supply Demon"]=10,
        ["Ocean"]=10,
        ["Shambling Plant"]=10,
        ["The Knife Path"]=10,
        ["The Novice Experiment"]=10,
        ["Wronging Point"]=10,
        ["Void Moons"]=10,
      }
    }
  },
  -- end of 'PSYCHO' theme


  --------------------------------------------------

   -- lexicon legend:
   -- %s = Full episode names
   -- %k = Body parts
   -- %p = Location
   -- %q = Residential area / Adverbs
   -- %a = Adjective
   -- %j = Abstract / Objects
   -- %c = Contributor name

  EPISODE =
  {
    patterns =
    {
      -- places
      ["%p of %j"] = 30,
      ["The %p of %j"] = 30,
      ["The %a %p"] = 40,
      ["A %a %p/s"] = 40,
      ["%j %q"] = 20,
      ["Gateway to %j"] = 5,
      ["%p/s of No Return"] = 5,

      -- homages to Episode 1,
      ["%k-Deep in %j"] = 10,
      ["%k-Deep in the %j"] = 5,
      ["%k-High in %j"] = 5,
      ["Drowning in %j"] = 10,
      ["Wading through the %j"] = 5,
      ["Endless %j"] = 10,

      ["Wading through the %j"] = 5,

      -- using the noun generator
      ["The %p of NOUNGENEXOTIC"] = 25,
      ["Attack on NOUNGENANGLICAN"] = 12,
      ["Assault on NOUNGENANGLICAN"] = 12,

      -- complete names
      ["%s"] = 100,

      -- contributors and their shenanigans

      -- Armaetus's additions
      ["%a %q"] = 10,
      ["%a %j"] = 10,
      ["Dead Base: %a"] = 5,
      ["%j and %j"] = 5,
      ["Silence: %a %j"] = 5,
      ["Crystal %p"] = 5,
      ["Hellfire: %j"] = 5,
      ["Portal to %j"] = 5,
      ["%j for the %p"] = 5,
      ["The %p: %j"] = 5,
      ["Discovery of NOUNGENEXOTIC"] = 5,
      ["Discovery of NOUNGENANGLICAN"] = 5,
      ["Breakdown: %j"] = 5,
      ["Burnout: %a %j"] = 5,
      ["Crushed: %j"] = 5,
      ["Overdose: %a"] = 5,
      ["Undone by %j"] = 4,
      ["Below the %p"] = 4,
      ["%j: Downfall"] = 4,
      ["Death by %j"] = 4,
      ["Unholy %p"] = 4,
      ["Shores: The %a %p"] = 4,
      ["Going to NOUNGENEXOTIC"] = 4,
      ["Going to NOUNGENANGLICAN"] = 4,
      ["Vacation at NOUNGENEXOTIC"] = 3,
      ["Vacation at NOUNGENANGLICAN"] = 3,
      ["%cs Warzone"] = 3,
      ["%cs %p"] = 3,
      ["%p of %c"] = 2,
      ["%c is Missing"] = 2,
      ["%c did What?"] = 2,

       -- 2021 additions..
       ["%a Fate"]=5,
       ["Death's %p"]=5,
       ["Devolution: %j"]=5,
       ["Fueled by %j"]=5,
       ["Meltdown: %j"]=5,
       ["Nullified: %a"]=5,
       ["The %a Agenda"]=5,

      -- E.T.'s additions
      ["%p of the %a %j"]=4,
      ["%p of %a %j"]=4,
      ["%p of %j"]=4
    },

    lexicon =
    {
      p = -- places
      {
        -- arbitrary locations
        Axis = 10,
        Area = 10,
        Center = 10,
        Circle = 10,
        Edge = 10,
        Frontier = 10,
        Point = 10,
        Region = 10,
        Sector = 10,
        Zone = 10,

        -- geopolitical
        Colony = 5,
        Commune = 3,
        ["City-state"] = 3,
        Dominion = 10,
        Duchy = 5,
        Emirate = 3,
        Empire = 5,
        ["Free State"] = 3,
        Kingdom = 7,
        Principality = 3,
        Hegemony = 10,

        -- medieval
        Citadel = 15,
        Fortress = 10,
        Palace = 7,
        Spire = 5,
        Towers = 15,
        Well = 8,
        Vaults = 10,

        -- modern
        Arcology = 5,
        City = 15,
        District = 10,
        Ghetto = 5,
        House = 5,
        Metropolis = 10,
        Road = 8,
        Town = 8,
        Trail = 8,

        -- huge locations
        Boundary = 10,
        Dimension = 20,
        Domain = 10,
        Plane = 10,
        Planet = 5,
        Realm = 10,
        World = 10,
        Territory = 5,

        -- terrain
        Atoll = 7,
        Badlands = 10,
        Barrens = 10,
        Bay = 10,
        Cape = 7,
        Channel = 7,
        Cliffs = 10,
        Coast = 10,
        Crater = 10,
        Crags = 10,
        Delta = 5,
        Desert = 10,
        Fens = 7,
        Forest = 7,
        Fields = 10,
        Glaciers = 7,
        Gorge = 7,
        Grassland = 7,
        Gulf = 10,
        Hills = 10,
        Inlet = 7,
        Isthmus = 7,
        Lagoon = 7,
        Lake = 7,
        Lands = 15,
        Lowland = 10,
        Mountains = 10,
        Mire = 10,
        Moors = 10,
        Ocean = 7,
        Promontory = 8,
        Ravine = 10,
        Rift = 15,
        Ridge = 10,
        River = 10,
        Peninsula = 10,
        Plains = 10,
        Plateau = 7,
        Sea = 7,
        Shores = 25,
        Steppe = 7,
        Strait = 7,
        Tundra = 10,
        Wasteland = 20,
        Vale = 10,
        Valley = 10,
        Veins = 7,

        -- dead/underground
        Burrows = 7,
        Catacombs = 7,
        Cavern = 10,
        Chasm = 10,
        Crypt = 5,
        Dungeons = 10,
        Hollow = 10,
        Maze = 10,
        Labyrinth = 7,
        Pits = 10,
        Warrens = 10,
        Underworld = 10,

        -- tech
        Base = 10,
        Complex = 10,
        Facility = 5,
        Installation = 5,
        Outpost = 7,
        Redoubt = 7,
        Quarters = 5,
        Station = 10,

        Cradle = 10,
        Skies = 10,

        -- trapped places
        Entanglement = 5,
        Maze = 10,
        Labyrinth = 10,
        Quagmire = 7,
        Snare = 7,
        Trap = 8,
        Web = 7,

        -- time
        Dawn = 7,
        Day = 7,
        Dusk = 10,
        Eventide = 5,
        Midnight = 10,
        Night = 10,

        -- religious
        Abyss = 10,
        Basilica = 10,
        Cathedral = 10,
        Limbo = 10,
        Inferno = 10,
        Purgatory = 10,

        -- architectural spots
        Aisles = 10,
        Edifice = 10,
        Firmament = 10,
        Pillar = 10,
        Vestibule = 10,
        Walls = 10
      },

      q = -- adverbs?
      {
        City = 5,
        Town = 20,
        Zone = 20,
        Central = 20,

        ["All Around"] = 10,
        ["Awaits Thee"] = 5,
        ["Galore"] = 10,

        -- stuff MSSP adds
        ["Eternal"] = 10,
        ["Raining Down"] = 5
      },

      a = -- adjectives
      {
        -- elements
        Blazing = 15,
        Cold = 20,
        Frozen = 20,
        Fiery = 20,
        Elemental = 20,
        Icy = 15,
        Molten = 15,

        -- lighting
        Bright = 15,
        Dark = 20,
        Lambent = 15,
        Lightless = 10,
        Lucid = 10,
        Luminous = 10,
        Radiant = 8,
        Shadowed = 15,
        Tenebrous = 10,

        -- color
        Black = 10,
        Blue = 10,
        Red = 10,
        Gray = 10,
        Green = 10,
        White = 10,
        Yellow = 10,
        ["Fire-blue"] = 10, -- of course

        -- material
        Adamantine = 10,
        Crystal = 7,
        Copper = 10,
        Iron = 10,
        Obsidian = 10,
        Rocky = 7,
        Stone = 7,

        Ebony = 10,
        Ivory = 10,

        -- huge scales and measures
        Abyssal = 10,
        Ancient = 10,
        Archaic = 10,
        Bottomless = 10,
        Colossal = 10,
        Eternal = 10,
        Gargantuan = 10,
        Giant = 10,
        Prodigious = 10,
        Soaring = 10,
        Massive = 10,
        Towering = 10,
        Titanic = 10,
        Transcendent = 10,
        Infinite = 10,
        Vast = 10,

        -- bad personal qualities
        Avaricious = 5,
        Creepy = 10,
        Cruel = 10,
        Depraved = 5,
        Despicable = 10,
        Insane = 10,
        Lonely = 20,
        Malignant = 10,
        Merciless = 10,
        Menacing = 20,
        Morose = 10,
        Mortal = 10, -- lol
        Nefarious = 5,
        Hateful = 5,
        Savage = 20,
        Somber = 10,
        Strange = 10,
        Sinister = 10,
        Sinful = 5,
        Wicked = 15,
        Venal = 5,
        Vicious = 10,

        -- hellspawn qualities
        Aberrant = 10,
        Accursed = 10,
        Contaminated = 10,
        Corrupted = 10,
        Deathly = 20,
        Demonic = 10,
        Dreadful = 10,
        Doomed = 8,
        Eldritch = 5,
        Evil = 10,
        Grotesque = 10,
        Haunted = 5,
        Hideous = 10,
        Immortal = 10,
        Impure = 10,
        Infested = 10,
        Macabre = 10,
        Monstrous = 10,
        Tortured = 10,
        Twisted = 10,
        Unclean = 7,
        Unholy = 10,
        Wretched = 10,

        Forbidden = 10,
        Profane = 10,

        -- decay
        Burned = 8,
        Corroded = 10,
        Crumbled = 10,
        Decayed = 10,
        Feculent = 10,
        Fetid = 10,
        Foul = 10,
        Gloomy = 10,
        Murky = 8,
        Noxious = 8,
        Rancid = 10,
        Rotten = 10,
        Sordid = 10,
        Squalid = 10,
        Tainted = 10,
        Tarred = 7,
        Torn = 10,
        Vile = 10,

        -- abandonment/wrecked
        Abandoned = 10,
        Apocalyptic = 10,
        Blasted = 10,
        Bleak = 10,
        Broken = 10,
        Decrepid = 10,
        Derelict = 10,
        Deserted = 10,
        Desolate = 10,
        Faded = 5,
        Forlorn = 10,
        Forsaken = 15,
        Isolated = 10,
        Ruined = 7,
        Shattered = 10,
        Solitary = 8,

        Wanton = 10,
        Godless = 5,
        Nameless = 5,

        -- finale
        Absolute = 5,
        Final = 10,
        Terminal = 5,
        Ultimate = 10
      },

      k = -- body parts (because Doom 1 Episode 1)
      {
        Knee = 30,
        Neck = 20,
        Waist = 10,
        Chest = 3,
        Thigh = 3
      },

      j = -- objects
      {
        -- battle
        Battle = 10,
        War = 10,

        -- blood and guts
        Corpses = 20,
        Bodies = 20,
        Bones = 10,
        Blood = 20,
        Dead = 7,
        Demise = 5,
        Entrails = 7,
        Ichor = 8,
        Gore = 20,
        Gibs = 10,
        Viscera = 10,

        -- destructive acts
        Annihilation = 10,
        Betrayal = 5,
        Carnage = 20,
        Collusion = 10,
        Chaos = 15,
        Death = 15,
        Deceit = 10,
        Deception = 10,
        Destruction = 10,
        Devastation = 10,
        Extermination = 10,
        Extinction = 10,
        Genocide = 5,
        Ruin = 10,
        Slaughter = 10,
        Treachery = 7,
        Trickery = 7,

        -- disease
        Affliction = 7,
        Atrophy = 7,
        Pestilence = 10,
        Scourge = 10,

        -- disaster
        Adversity = 10,
        Calamity = 10,
        Cataclysm = 10,
        Catastrophe = 10,
        Tremors = 10,
        Tribulation = 10,
        Quake = 7,
        Woe = 7,

        -- pollution
        Ash = 8,
        Filth = 10,
        Grime = 8,
        Mush = 5,
        Nukage = 10,
        Slime = 10,
        Sludge = 10,
        Slush = 5,
        Smog = 10,
        Soot = 10,

        -- creatures and mystical entities
        Beasts = 10,
        Devils = 10,
        Demons = 10,
        Imps = 10,
        Monsters = 10,
        Souls = 10,
        Zombies = 10,

        -- feels
        Agony = 10,
        Anger = 5,
        Despair = 10,
        Doom = 5,
        Fear = 10,
        Grief = 5,
        Horror = 20,
        Madness = 10,
        Misery = 10,
        Pain = 10,
        Terror = 10,

        Nightmares = 10,
        Illusion = 10,

        -- elements
        Darkness = 10,
        Fire = 10,
        Flames = 10,
        Frost = 10,
        Lava = 10,
        Magma = 10,
        Poison = 10
      },

      s = -- single whole names
      {
        ["A Price To Pay"] = 10,
        ["Aftershock"] = 10,
        ["Bad Dream"] = 10,
        ["Defenders of Hell"] = 10,
        ["Entombed"] = 10,
        ["Halloween"] = 10,
        ["Limbo"] = 10,
        ["Origin of Venom"] = 10,
        ["Sealed Fate"] = 10,
        ["Warbringer"] = 10,

        ["A Storm Cometh"] = 10,
        ["Battlefield"] = 10,
        ["Bestial Experiment"] = 10,
        ["Beyond Earth"] = 10,
        ["Breeding Chambers"] = 10,
        ["Code Red"] = 10,
        ["Hell Breaks Loose"] = 10,
        ["The Treason Well"] = 10,
        ["Under an Alien Sky"] = 10,

        ["As The World Burns"] = 10,
        ["Deadly Harvest"] = 10,
        ["Desperate Measures"] = 10,
        ["Everlasting Night"] = 10,
        ["Left for Dead"] = 10,
        ["New Beginning"] = 10,
        ["Oblivion Upon Us"] = 10,
        ["The Healer Stalks"] = 10,
        ["When Ashes Rise"] = 10,

        ["Abandon all Hope"] = 10,
        ["Chaos Rising"] = 10,
        ["Ex Nihilo"] = 10,
        ["Genesis of Genocide"] = 10,
        ["The Devil's Emissary"] = 10,
        ["The Howling Void"] = 10,
        ["Torturous Existence"] = 10,
        ["Pulse of Depravity"] = 10,
        ["Say Thy Prayers!"] = 10,
        ["Vengeance Denied"] = 10,

        ["The Lost Base"] = 10,
        ["Hell's Playground"] = 10,
        ["Crimson Reprieve"] = 10,
        ["Souls of the Damned"] = 10,
        ["In the Face of Armageddon"] = 10,
        ["Highway to Hell"] = 10,
        ["Time to Bleed"] = 10,

        ["Into the Shadows"] = 10,
        ["And Now You Die"] = 10,
        ["Halls of Lamentation"] = 10,
        ["Intruder Alert"] = 10,
        ["Security Breach"] = 10,
        ["Arena From Hell"] = 10,

        -- these by Chris (mostly)
        ["Radio Silence"] = 10,
        ["Liquidation"] = 10,
        ["Return to Hell"] = 10,
        ["A Chilling Discovery"] = 10,
        ["Human Stagnation"] = 10,
        ["Thou Art Doomed"] = 10,
        ["Fathomless Abyss"] = 10,
        ["Insecurity"] = 10,
        ["Pathos 666"] = 10,
        ["Toxic Grievance"] = 10,
        ["Hell's Injustice"] = 10,
        ["Gate to Nowhere"] = 10,
        ["Of Horns And Blood"] = 10,
        ["Disadvantaged"] = 10,
        ["Silent Hell"] = 10,
        ["Ghosts of Tei Tenga"] = 10,
        ["End of Everything"] = 10,
        ["Ashes And Plasma"] = 10,
        ["A New Kind of Army"] = 10,
        ["Post-Human Paradox"] = 10,
        ["Neverending Twilight"] = 10,
        ["Tower of Limbs"] = 10,
        ["Burial in Space"] = 10,
        ["The Sons of Mars"] = 10,
        ["Parallel Absolution"] = 10,
        ["A Clockwork Death"] = 10,
        ["Dolor Extremus"] = 10,
        ["Spiritus Malus"] = 10,

        -- homages to DOOM 1 Episodes
        ["Explosion"] = 3,
        ["Enter the Flames"] = 3,
        ["Burning in Hell"] = 3,
        ["Blazing Shores"] = 3,
        ["Lakes of Fire"] = 3,
        ["Hellfires"] = 3,

        ["Thy Soul Devoured"] = 5,
        ["Thy Shrivelled Mind"] = 5,
        ["Thou Shalt Die"] = 5,
        ["Consumed by Flames"] = 3,

        -- MSSP adds some more names
        ["Dead Rising"] = 10,
        ["A Minute to Midnight"] = 10,
        ["Maelstrom of Chaos"] = 10,
        ["Shadows Fall"] = 10,
        ["Mortally Challenged"] = 10, -- actually coined by Terry Pratchett
        ["Stormbreak"] = 10,
        ["Firewinds"] = 10,
        ["The Kiss of Death"] = 10,
        ["Murder Without Sin"] = 10,

        ["A Night Full of Terrors"] = 10,
        ["The Throne of Fire"] = 10,
        ["Fire and Blood"] = 10,
        ["Remembrance"] = 10,
        ["What Is Dead May Never Die"] = 10, -- see, even great authors can do a
        ["All Men Must Die"] = 10,           -- "people die when they are killed",
        ["The Dance of Demons"] = 10,
        ["The Gift of Death"] = 10,

        ["The Lord of Terror"] = 10,
        ["Soulreaver"] = 10,
        ["Trail of Tears"] = 10,
        ["The Curse of Undeath"] = 10,
        ["Hell's Foundry"] = 10,
        ["Angels Fall First"] = 10,
        ["Fresh Meat"] = 10,
        ["Demonic Invasion in Progress"] = 10,
        ["The Hammer Falls"] = 10,
        ["Egress"] = 10,
        ["The Culling"] = 10,
        ["Eye of the Storm"] = 10,
        ["Hallowed Ground"] = 10,

        -- mythical underworlds (including from D&D)
        ["The Vestibule of Hell"] = 10,
        ["River of Acheron"] = 10,
        ["Caves of Avernus"] = 10,
        ["Planes of Asphodel"] = 10,
        ["The Wastes of Cania"] = 10,
        ["Cocytus"] = 10,
        ["The City of Dis"] = 10,
        ["The Void of Erebus"] = 10,
        ["Vale of Gehennom"] = 10,
        ["Maze of Maladomini"] = 10,
        ["Spires of Malbolge"] = 10,
        ["Pools of Minauros"] = 10,
        ["The Rift of Nessus"] = 10,
        ["The Void of Lethe"] = 10,
        ["Pits of Phlegethos"] = 10,
        ["Stygian Abyss"] = 10,
        ["Gates of Tartarus"] = 10,

        ["No Mercy"] = 10, -- yes, these are L4D campaign names
        ["Crash Course"] = 10,
        ["Death Toll"] = 10,
        ["Dead Air"] = 10,
        ["Blood Harvest"] = 10,
        ["The Sacrifice"] = 10,
        ["The Last Stand"] = 10,

        ["Dead Center"] = 10, -- yes, now L4D2,
        ["The Passing"] = 10,
        ["Dark Carnival"] = 10,
        ["Swamp Fever"] = 10,
        ["Hard Rain"] = 10,
        ["The Parish"] = 10,

        -- Max Payne
        ["A Cold Day in Hell"] = 10,
        ["A Bit Closer to Heaven"] = 10,

        ["Blood Veins of Phobos"] = 10,
        ["Playing it Bogart"] = 10,
        ["Let Guns do the Talking"] = 10,
        ["Fear That Gives Men Wings"] = 10,
        ["Ragna Rock"] = 10,
        ["Pain and Suffering"] = 10,
        ["Rats and Oily Water"] = 10,
        ["Take me to Cold Steel"] = 10,
        ["The Deep Six"] = 10,
        ["In The Land of the Blind"] = 10,
        ["Hidden Truths"] = 10,
        ["Byzantine Power Game"] = 10,

        ["Forget Being Subtle"] = 10,
        ["Stepping on Toes"] = 10,
        ["A Few Bullets Back"] = 10,
        ["In The Crossfire"] = 10,

        ["Riding Shotgun"] = 10,
        ["Ice Hard and Slick"] = 10,
        ["Straight from a Bad Dream"] = 10,

        -- 2021 stuff..
        ["Absolution"]=10, -- Doom 64,
        ["Beyond Eternity"]=10,
        ["Beyond Serenity"]=10,
        ["Damaged"]=10,
        ["Dead Shining Star"]=10,  -- A V:28 song title
        ["Eerie Delights"]=10,
        ["Forcing Your Way"]=10, -- Nod to Final Fantasy
        ["Hope Dies Here"]=10,
        ["Mephisto"]=10,
        ["Ouroboros"]=10,
        ["Peace of Mind"]=10,
        ["Regret"]=10,
        ["Seclusion"]=10,
        ["Shades of Gray"]=10,
        ["Shoot to Kill"]=10,
        ["Shutdown"]=10,
        ["Stygian Outlook"]=10,
        ["Submission"]=10,
        ["The Culling Fields"]=10,
        ["Tranquility"]=10,
        ["Unleash The Energy"]=10, -- Also V:28 (See: https://www.metal-archives.com/bands/V%3A28/16470 )
        ["Whispers from the Void"]=10,

        -- WAD title stuff
        ["Crossing Acheron"]=5,
        ["Cyberdreams"]=5
      },

      c = -- oh boy, here we go again...
      {
        NOUNMEMBERS = 10
      }
    }
  },
  -- end of 'EPISODE' theme


  --------------------------------------------------

  TITLE =
  {
    patterns =
    {
      -- <adj> <place>  e.g. dark dimension
      ["%a %p"] = 50, -- Descriptive Place
      ["The %a %p"] = 45, -- The Descriptive Place
      ["Into the %a %p"] = 10, -- Into the Descriptive Place

      -- <adj> <thing>  e.g. eternal gore
      ["%a %d"] = 50, -- Descriptive Object

      ["%d Forever"]  = 5,
      ["%d Always"]  = 5,
      ["Not enough %d"] = 7,
      ["%d Revealed"] = 5,

      -- <place> of <desc>  e.g. city of souls
      ["%p of %d"] = 50, -- Place of Object
      ["%d in the %p"] = 25, -- Object in the Place
      ["%d at the %p"] = 25, -- Ojbect at the Place

      ["The %e of %d"] = 30, -- The Entity of Object
      ["%e in the %p"] = 30, -- Entity in the Place

      -- <place> of the <entity>  e.g. realm of the devil
      ["%p of the %e"] = 50, -- Place of the Entity
      ["The %p of the %e"] = 30, -- The Place of the Entity
      ["The %d of the %e"] = 30, -- The Abstract Object of the Entity
      ["The %a %d of the %a %e"] = 40, -- The Descriptive Object of the Descriptive Entity
      ["The %a %p of the %a %e"] = 40, -- The Descriptive Place of the Descriptive Entity

      -- miscellaneous
      ["Beyond the %p"] = 8,
      ["Journey to the %p"] = 6,

      ["The %e Cometh"] = 5,
      ["The %e will Rise"] = 5,
      ["The %e must Die"] = 5,
      ["Fight the %e"] = 5,
      ["Age of the %e"] = 5,
      ["Back to the %a %p"] = 5,

      -- MSSP adds grammar rules

      ["Assault on the %a %p"] = 8, -- Assault on the Descriptive Place
      ["Destroy the %a %p"] = 8, -- Destroy the Descriptive Place
      ["Attack of the %a %e"] = 8, -- Attack of the Descriptive Entity
      ["Return of the %e"] = 8, -- Return of the Entity
      ["A WAD full of %d"] = 5, -- A WAD Full of Abstract Objects
      ["Return of the %e"] = 8,-- Return of the Entity
      ["Some very %a %p"] = 8, -- Some very Descriptive Place
      ["Zone of %d"] = 8, -- Zone of Abstract Object
      ["The %e WAD"] = 5, -- The Entity WAD
      ["Showdown with the %e"] = 7,
      ["They are %a"] = 7,
      ["Call of %d"] = 8,
      ["The %e and the %e"] = 10,
      ["The %e VS the %e"] = 7,
      ["The %d Within"] = 5,
      ["%a and %a"] = 8,
      ["Escape from the %a %e"] = 10,
      ["The %e The %e and The %d"] = 8,

      ["%c did this"] = 3,
      ["The %a %p of %c"] = 3,

      -- Simply located lexicon location (So you don't need to scroll up and down if you forget)
      -- If we want to be be more specific, we could just add more lexicons, like I did with %m below.
      -- %a = Adjective
      -- %p = Place
      -- %c = Contributor name
      -- %d = Abstract / Abstract-like
      -- %e = Entities
      -- %m = Material / Metal alloy

      -- Armaetus adds more grammar rules
      ["Doom: %d on Earth"] = 10,
      ["Doomguy VS the %e"] = 10, -- Doomguy VS the [Entity]
      ["Doomguy and the %e"] = 10, -- Doomguy and the [Entity]
      ["Vacation in the %d %p"] = 10,  -- Vacation in the [Description] [Place]
      ["Evil Unleashed: %a %d"] = 10,
      ["%c's %d"] = 4, -- [Name]'s Abstract Object
      ["%c's %a %p"] = 4, -- [Name]'s [Adjective] [Place]
      ["%c's %p"] = 4, -- [Name]'s [Place]
      ["Dirty Deeds for the %e"] = 7, -- Dirty Deeds for the [Entity]
      ["The %e Attacks the %d %p"] = 7, -- The [Entity] Attacks the [Adjective] [Place]
      ["Is %c %a?"] = 2, -- Is [Name] Adjective?
      ["%c Is NOT %a!"] = 2,
      ["%c's Playhouse"] = 3, -- [Name]'s Playhouse
      ["%c's Warzone"] = 3, -- [Name]'s Warzone
      ["%d: the %a %p"] = 7,
      ["Death: %a %p"] = 7,
      ["The %p: Our %d"] = 7,
      ["Chaos: %a %p"] = 5,
      ["Complete %d"] = 5,
      ["Total %d"] = 5,
      ["Treachery: The %d"] = 5,
      ["Reborn: The %d"]=5,
      ["Quietus: Complete %d"] = 4,
      ["Is %c By The %a %p?"] = 3,
      ["%a Death and %d"] = 5,
      ["This WAD has %d"] = 5, -- This WAD has Abstract Objects
      ["%c's %a WAD"] = 3, -- [Name]'s [Adjective] WAD
      ["%c's WAD"] = 3,
      ["%c's Fun Zone"] = 3,
      ["Did %c Do This?"] = 3,
      ["The %e Lurks Within"] = 5, -- The [Entity] Lurks Within
      ["The %e Lurks Below"] = 5,
      ["%e Knows You"] = 4,
      ["Destruction of the %d %p"] = 5, -- Destruction of the [Adjective] [Place]
      ["%a Black Metal"] = 5, -- [Adjective] Black Metal
      ["%a Doom Metal"] = 5, -- [Adjective] Doom Metal
      ["Doomguy's Vacation with %c"] = 5, -- Doomguy's Vacation with [Name]
      ["Sin City: The %a %p"] = 5,
      ["Sin City: The %d"] = 5,
      ["Ruination: %a %p"] = 3,
      ["The %a %p of %m"] = 5,
      ["Dead Base: The %d"] = 5,
      ["Demise of the %e"] = 4,
      ["%m and %c"]=4,
      ["The %e's Fun %a %p"] = 4,
      ["The %m %p"] = 4,
      ["As The %e Gather"] = 4,
      ["Insane %a %d"] = 4,
      ["Plenty of %d"] = 4,
      ["Hell's %a Division: %d"] = 4,
      ["%a Sorcery"] = 3,
      ["%a Witchcraft"] = 3,
      ["%a Hellcraft"] = 3,
      ["%d! Oh My Oh My"] = 3,
      ["%c and Doomguy in the Same Room"] = 3,
      ["Is %c %a?"]=3
    },

    lexicon =
    {
      a = --adjectives
      {
        -- elemental
        Burning = 10,
        Blazing = 15,
        Blistering = 10,
        Cold = 10,
        Dry = 10,
        Earthen = 10,
        Fiery = 10,
        Frozen  = 10,
        Poisonous = 10,
        Smothering = 10,
        Shocking = 10,

        -- grit
        Festering = 5,
        Fecund = 5,
        Fetid = 5,
        Filthy = 5,
        Foul  = 5,
        Gory = 10,
        Grisly = 15,
        Infested = 10,
        Lacerating = 10,

        -- size
        Endless = 20,
        Extreme = 10,
        Infinite = 10,

        -- emotion
        Acrimonious = 10,
        Anguished = 5,
        Baleful = 10,
        Cruel = 10,
        Dejected = 5,
        Dolorous = 5,
        Forlorn = 15,
        Grievious = 15,
        Grim = 15,
        Lonely = 10,
        Malevolent = 10,
        Maleficent = 5,
        Malignant = 7,
        Melancholic = 5,
        Menacing = 20,
        Morbid = 20,
        Nefarious = 15,
        Raging = 10,
        Savage = 30,
        Sonorous = 10,
        Sordid = 5,
        Sullen = 5,
        Spiteful = 5,
        Tragic = 5,
        Virulent = 10,
        Vindictive = 7,
        Vitriolic = 10,
        Woeful = 10,

        -- destroyed or decay
        Abandoned = 10,
        Annihilated = 10,
        Astray = 10,
        Banished = 10,
        Bleak = 10,
        Broken = 10,
        Deserted = 10,
        Desolate = 15,
        Forgotten = 10,
        Forsaken = 10,
        Lonely = 10,
        Lost  = 10,
        Neglected = 10,
        Oppressive = 10,
        Ravaged = 10,
        Shunned = 10,
        Splintered = 10,
        Wrecked = 10,

        -- weird
        Multifarious = 5,
        Weird = 10,
        Strange = 10,
        Surreal = 7,

        -- evilz
        Blasphemous = 15,
        Corrupt = 15,
        Chaotic = 15,
        Cursed = 10,
        Demonic = 15,
        Deplorable = 15,
        Disgraceful = 10,
        Evil = 15,
        Feral = 10,
        Ghastly = 10,
        Ghoulish  = 10,
        Godless = 10,
        Gruesome = 15,
        Harrowing = 10,
        Haunted = 10,
        Hellish = 10,
        Malicious = 10,
        Malevolent = 10,
        Monstrous = 15,
        Profane = 15,
        Sacreligious = 15,
        Sinful  = 15,
        Tortured = 10,
        Unholy = 10,
        Visceral = 15,
        Vile    = 5,
        Violent = 10,
        Wicked  = 10,
        Wretched = 15,

        -- danger
        Ailing = 5,
        Deathly = 20,
        Doomed = 10,
        Fatal = 10,
        Macabre = 10,

        -- holy
        Blessed = 7,
        Divine = 10,
        Hallowed = 10,
        Righteous = 10,
        Sanctimonious = 10,

        -- asthetic
        Appalling = 15,
        Dark = 20,
        Dreadful = 20,
        Eerie = 10,
        Hidden = 10,
        Lurid = 10,
        Terrifying = 20,

        -- celestial
        Astral = 5,
        Cosmic = 5,
        Lunar = 10,
        Solar = 10,
        Stellar = 10,

        Lit = 8
      },

      p = -- places
      {
        -- civilian places
        City = 15,
        Carnival = 10,
        Causeway = 5,
        Complex = 10,
        Concourse = 10,
        Crossing = 5,
        Durance = 10,
        Gateway = 10,
        Ghetto = 5,
        Halls = 10,
        House = 10,
        Hub = 10,
        Streets = 5,
        Towers = 15,
        Prison = 10,
        Ward = 10,

        -- generic locations/navigational
        Beacon = 10,
        Center = 5,
        Path = 10,
        Waypoint = 10,
        Ways = 10,

        -- beautification
        Garden = 10,
        Mazes = 10,
        Ruins = 10,
        Tree = 10,

        -- holy sites
        Basilica = 5,
        Citadel = 15,
        Chapel = 10,
        Chambers = 10,
        Oracle = 10,
        Tabernacle = 5,
        Temple = 15,

        -- medieval?
        Domain = 10,
        Den = 5,
        Fiefdom = 5,
        Kingdom = 10,
        Lair = 5,
        Stronghold = 5,
        Pits = 10,

        -- celestial/extraterrestrial
        -- this one is sorted by size?
        World = 15,
        Planet = 15,
        Territories = 10,
        Realm = 15,
        Dimension = 10,
        Plane = 10,
        Netherworld = 10,

        -- natural landscapes
        Acres = 10,
        Barrows = 15,
        Caverns = 15,
        Canyon = 15,
        Coast = 10,
        Climb = 15,
        Crevice = 10,
        Fields = 10,
        Hills = 10,
        Highlands = 10,
        Island = 15,
        Land = 10,
        Mountains = 10,
        Moor = 15,
        Paradise = 10,
        Pass = 15,
        Peak = 10,
        Plateau = 15,
        Pinnacle = 15,
        Ridge = 10,
        River = 10,
        Sands = 10,
        Shores = 20,
        Span = 10,
        Steppe = 10,
        Strand = 10,
        Valley = 20,
        Vale = 20,
        Wastes = 10,
        Zenith = 10,

        -- burials
        Burial = 10,
        Catacombs = 10,
        Crypt = 15,
        Dungeons = 10,
        Hollows = 10,
        Mausoleum = 10,
        Mortuary = 10,
        Necropolis = 10,
        Ossuary = 10,
        Polyandrium = 10,
        Tomb = 15,
        Vault = 10,

        Firmament = 10,
        Gallows = 8,

        -- deep, deep underground
        Abyss = 10,
        Perdition = 10,
        Purgatory = 10,
        Inferno = 10,
        Underworld = 10,

        -- military
        Base = 10,
        Battlefront = 10,
        Containment = 10,
        Facility = 10,
        Outpost = 10,

        -- times
        Day = 10,
        Dawn = 15,
        Evening = 10,
        Meridian = 10,
        Noon = 10,
        Night = 30,
        Twilight = 10,

        -- scales of time
        Eternity = 10,
        Millenium = 10,
        Century = 10,
        Decade = 10,
        Eon = 10,  -- 100k x 365d. 365k yr
        Aeon = 10, -- 1m x 365d. 3.65m yr / 1B yrs / Could also represent an indefinite amount of time too
        Indiction = 7, -- 15 year cycle
        Epoch = 7, -- 7.3m yrs
        Megannum = 7, -- 1m years


        -- seasons/weather
        Rain = 15,
        Winter = 15,
        Storms = 15,
        Blizzard = 15,
        Snow     = 10,
        Ashfall  = 10,
        Drought  = 10,
        Wildfire = 10,
        Sandstorm = 10,
        Tornadoes = 10,
        Wind   = 10,
        Avalanche = 8,
        Mist   = 8,
        Fog    = 8,
        Autumn = 8,
        Fall   = 8,
        Summer = 8,
        Thundersnow = 8
      },

      -- these are quite abstract
      d = -- treated a bit like objects
      {
        -- gibs
        Blood = 20,
        Viscera = 10,
        Slime = 5,
        Sludge = 5,

        -- words transfered from places
        -- because these aren't places at all
        -- needs to be categorized
        Feast = 10,
        Harvest = 10,
        Knowledge = 10,
        Labours = 10,
        Life = 8,
        Lore = 10,
        March = 10,
        Portrait = 10,
        Remembrance = 10,
        Watch = 10,

        -- emotions/feels
        Abuse = 10, -- "Abused" makes no sense in some aspects
        Apathy = 5,
        Anguish = 10,
        Agony = 20,
        Bereavement = 10,
        Bleakness = 5,
        Chaos = 10,
        Contempt = 5,
        Cruelty = 10,
        Doom = 10,
        Defilement = 15,
        Despair = 10,
        Dismay = 10,
        Dread = 15,
        Dreariness = 20,
        Fear = 20,
        Fury = 10,
        Grief = 5,
        Hate = 10,
        Incompetence = 15,
        Ineptitude = 10,
        Lividness = 10,
        Madness = 10,
        Misery = 10,
        Obstinance = 10,
        Pain = 10,
        Rage = 10,
        Revulsion = 5,
        Scorn = 10,
        Spite = 15,
        Silence = 20,
        Tactility = 5,
        Terror = 20,
        Torment = 15,
        Wrath = 10,
        Vengeance = 20,
        Violence = 15, -- "Violent" doesn't make sense
        Withdrawal = 10, -- Most title additions of using "Withdrawn" wouldn't make sense

        -- occult
        Ceremony = 10,
        Cult = 10,
        Horror = 10,
        Idolatry = 10,
        Magic = 15,
        Magik = 10,
        Ritual = 10, -- Could also be religious
        Shadows = 10,

        Death = 20, -- This really is an all-around word
        Flames = 20,

        -- religious
        Belief = 10,
        Choir = 10,
        Conviction = 10,
        Deliverance = 10,
        Doctrine = 10,
        Dogma = 10,
        Faith = 10,
        Hell = 10, -- Fits better here
        Icons = 10, -- as in religious icons
        Souls = 10, -- Frequently mentioned in religious texts as well, namely Judeo-Christian
        Tenets = 10, -- Also occult

        -- states of mind, states in mind
        Bliss = 10,
        Dreams = 20,
        Chaos = 10,
        Nightmares = 20,
        Insanity = 10,
        Transience = 10,

        -- story devices
        Bane = 10,
        Legends = 10,
        Genesis = 10,
        Heroes = 10,
        Imagination = 7,
        Myths = 10,
        Origins = 10,
        Saga = 10,
        Tales = 7,
        Villains = 10,

        -- states of matter
        Conception = 10,
        Creation = 10,
        Destruction = 10,
        Disintegration = 10,
        Extinction = 10,
        Formation = 10,
        Nascency = 10,
        Subjugation = 10,
        Undoing = 10,

        -- military
        Battle = 10,
        Campaign = 10,
        Duty = 10,
        Orders = 10,
        Siege = 10,
        Skirmishes = 10,
        War = 10,

        -- uhh
        Bondage = 10,
        Inflation = 10,
        Voraciousness = 10,
        Transmogrification = 10,

        -- acts of evil
        Desecration = 10,
        Despoilment = 10,
        Marauding = 10,
        Pillage = 10,
        Plunder = 10,
        Raid = 10,
        Ransack = 10,
        Slaughter = 10,

        -- encounter
        Accostment = 7,
        Approach = 7,
        Confrontation = 10,
        Contact = 10,
        Encounter = 10,
        Rendezvous = 8,
        Meeting = 10,

        -- kinds of speech (sometimes bad)
        Casuistry = 8,
        Chant = 10,
        Chorus = 10,
        Decree = 10,
        Declarations = 10,
        Edicts = 10,
        Mandate = 10,
        Paragolism = 10,
        Sophistry = 10,

        -- cups of metaphorical substrate
        Canon = 8,
        Dogma = 10,
        Maxims = 8,
        Piety = 8,
        Precepts = 10,
        Tenets = 10,

        -- secret organizations
        Cabal = 10,
        Circle = 10,
        Creed = 10, -- Also religious
        League = 8,
        Order = 10,
        Sect = 8,

        -- state crimes
        Collusion = 10,
        Conspiracy = 10,
        Heresy = 10,-- In WH 40k it is if you're not Chaos
        Machinations = 10,
        Ruse = 10,
        Subterfurge = 10,
        Treason = 10,

        -- curses
        Affliction = 10,
        Anathema = 10,
        Bane = 10,
        Calamity = 8,
        Curse = 10,
        Pestilence = 8,
        Scourge = 10,
        Trouble = 8,
        Tribulation = 10,
        Vexation = 8
      },

      e = -- entities
      {
        -- DOOOOM!!!
        ["Arch-Vile"] = 7,
        Cyberdemon = 15,
        Doomhunter = 5, -- Doom Eternal
        ["Doom Slayer"] = 3, -- DOOM/Doom Eternal
        ["Hell Noble"] = 7, -- Also known as a Baron, I guess
        ["Hell Priest"]=7, -- Doom Eternal
        ["Lost Souls"] = 7,
        Marine = 15,
        Mastermind = 15,

        -- religion
        Adept = 10,
        Antichrist = 10,
        Archangel = 10,
        Beast = 20,
        Crusaders = 10,
        Demons = 20,
        Defiler = 20,
        Denouncer = 10,
        Devil = 20,
        Dissenter = 20,
        Gods  = 20,
        Heretic = 20,
        Hellspawn = 20,
        Idolater = 20, -- An idol worshipper
        Infidel = 20,
        ["Left Behind"] = 10,
        Martyr = 10,
        Nephilim = 10,
        Pagans = 10,
        Prophet = 10,
        Saint = 10,
        Seraph = 10,
        Sinner = 15,
        Shaman = 10,
        Wicked = 20,
        Wretched = 20,

        -- fantasy/magical
        Aliens = 10,
        Ancients = 15,
        Anima = 7,
        Bastards = 15,
        Banshee = 7,
        Cerberus = 10,
        Chimera = 10,
        Cyclops = 5,
        Damned = 15,
        Dragon = 10,
        Drowned = 10,
        Exile = 10,
        Giants = 10,
        Ghouls = 7,
        Hexers = 10,
        Keepers = 15,
        Lich = 10,
        Manticore = 10,
        Minotaurs = 15,
        Necromancer = 20,
        Oracle = 15,
        Reaper = 10,
        Shaper = 10,
        Trolls = 7,
        Titans = 10,
        Undead = 20,
        Vampire = 7,
        Wight = 7,
        Wraith = 10,
        Wyrm  = 7,
        Wyvern = 7,
        Zombies = 10,

        -- Lovecraft
        Elders = 10,
        ["Deep Ones"] = 10,
        ["Old Ones"] = 10,
        Tentacles = 10,

        -- predatious animals
        --(or generally infamous animals)
        Cobra = 8,
        Crow = 8,
        Deathstalkers = 10,
        Eagle = 8,
        Hawk = 8,
        Lion = 7,
        Piranha = 8,
        Raven = 8,
        Scorpion = 8,
        Snake = 8,
        Spider = 8,
        Wolf = 8,

        -- general adjectives
        Abject = 10,
        Corrupt = 20,
        Cursed = 15,
        Dead = 20,
        Deplorable = 15,
        Dishonorable = 15,
        Doomed = 25,
        Fearless = 20,
        Hopeless = 20,
        Hunted = 20,
        Lost = 20,
        Risen = 20,
        Tormented = 20,
        Worthless = 10,

        -- war
        Despoiler = 10,
        Destroyer = 10,
        Executioner = 10,
        Exterminator = 10,
        Horde = 10,
        Iconoclast = 10,
        Invaders = 10,
        Legion = 10,
        Master = 10,
        Overlord = 20,
        Warmonger = 10,
        Ravager = 10,
        Swarm = 10,

        -- people who do bad and/or kill people
        Assassin = 10,
        Bandits = 8,
        Brigands = 10,
        Brutes = 10,
        Malefactor = 10,
        Marauder = 10,
        Murderer = 10,
        Outlaw = 8,
        Thief = 8,
        Transgressor = 10,
        Vandals = 8,

        -- people with normal jobs
        -- but sound bad in certain contexts
        Butcher = 10,
        Hunter = 10,
        Soldiers = 10,
        Slayer = 10,

        -- Armaetus adds things here
        ["Christ Denier"] = 15,
        ["Sin Bringer"] = 10,
        ["The Icon"] = 10,
        Deathbringers = 10,
        Dreadlords = 10,
        Hellbringers = 15,
        Voidbringers = 10,

        -- filth
        Afflicted = 10,
        Carious = 15,
        Decaying = 20,
        Fetid = 15,
        Foul = 10,
        Nidorous = 20,
        Putrefied = 20,
        Noxious = 15,
        Rancid = 20,
        Rotting = 25,
        Tainted = 20,
        Withered = 15,

        -- Pain
        Agonized = 15,
        Bleeding = 20,
        Bloody = 10,
        Charred = 15,
        Eviscerated = 15,
        Mangled = 10,
        Mutilated = 20,
        Suffering = 10,
        Tortured = 10
      },

      -- Materials, namely metal alloys
      m =
      {
        Iron = 30,
        Steel = 15,
        Cobalt = 7,
        Gold = 15,
        Brass = 5,
        Silver = 10,
        Bronze = 5,
        Copper = 7
      },

      c = -- contributor names
      {
        NOUNMEMBERS = 10
      }
    }
  },


  SUB_TITLE =
  {
    patterns =
    {
      ["%s"] = 60
    },

    lexicon =
    {
      s =
      {
        -- sequels
        ["II"]  = 60,
        ["III"] = 60,
        ["IV"]  = 30,
        ["V"]  = 15,
        ["VI"]  = 5,
        ["VII"]  = 5,
        ["VIII"]  = 5,
        ["IX"]  = 5,
        ["X"]  = 5,
        ["XI"]  = 5,
        ["XII"] = 5,

        ["R E D U X"] = 10,
        ["Revisited"] = 10,
        ["Reloaded"] = 10,
        ["Remastered"] = 10,
        ["Special Edition"] = 10,
        ["Limited Edition"] = 10,
        ["Anniversary Edition"] = 10,
        ["Full Mag Edition"] = 10,

        ["A New Generation"] = 40,
        ["The Resurrection"] = 30,
        ["The Reckoning"] = 40,
        ["Evil Is Reborn"] = 20,

        ["The Struggle Continues..."] = 20,
        ["The Endless Fight"] = 20,
        ["Recurring Evil"] = 20,
        ["The Demons Are Back"] = 20,
        ["Battle Everlasting"] = 20,

        -- prequels
        ["G E N E S I S"] = 40,
        ["The Awakening"] = 40,
        ["Evil Unleashed"] = 20,
        ["The Dead Shall Rise"] = 20,
        ["Where It All Began"] = 20,
        ["Dawn Of Eternity"] = 20,
        ["Dawn of Evil"] = 20,
        ["The Invasion Begins"] = 20,
        ["The Prophecy Unfolds"] = 20,

        ["Prelude to Destruction"] = 25,

        -- ObAddon specifics
        ["ObAddon Special"] = 50,
        ["ObAddon Exclusive"] = 50,
        ["ObAddon Limited Ed"] = 50,
        ["By ObAddon Contribs"] = 35,
        ["Carthage Special"] = 20,
        ["Simon-v Special"] = 20,
        ["Armaetus Approved"] = 20,
        ["Caligari Tested"] = 20,
        ["Frozsoul Edition"] = 20,
        ["Garrett Approves"] = 20,
        ["MogWaltz Plus Plus"] = 20,
        ["Craneo Edition"] = 20,
        ["Tapwave Exclusive"] = 20,
        ["EpicTyphlosion A OK"] = 20,

        -- describe the place
        ["The Evil Within"] = 20,
        ["What Lurks Beneath"] = 20,
        ["A God-forsaken Place"] = 20,
        ["A Land In Turmoil"] = 20,
        ["Point Of No Return"] = 20,
        ["Gateway to Hell"] = 20,
        ["Where Devils Spawn"] = 20,
        ["Hell's Fury"] = 25,
        ["Demise of Humanity"] = 25,

        -- miscellaneous
        ["A Dreaded Obligation"] = 30,
        ["Your Dire Obligation"] = 30,
        ["Obligated to Die"] = 30,
        ["Redemption Denied"]    = 30,
        ["Humanity's Epitaph"]   = 30,
        ["Senseless Violence"]   = 40,
        ["Souls Denied"] = 30,
        ["Cycle of Death"] = 30,
        ["Of Dark Light"] = 30,
        ["Crushing Odds"] = 30,
        ["Die and Die Again"] = 30,
        ["Bullets and Death"] = 25,

        ["The Final Hour"] = 20,
        ["Out Of Time"] = 20,
        ["All Or Nothing"] = 20,
        ["Days Of Rage"] = 20,
        ["Beyond Salvation"] = 20,
        ["No Salvation"] = 20,
        ["No More Time"] = 20,
        ["No Time To Waste"] = 20,
        ["No Time Left"] = 20,
        ["One Last Chance"] = 20,
        ["Last Chance"] = 20,
        ["Chaos Ensues"] = 20,
        ["A Fight for Survival"] = 20,
        ["Thirst for Vengeance"] = 20,
        ["Hell's Pinnacle"] = 20,

        ["The Brink of Disaster"] = 20,
        ["The Apocalypse Has Come"] = 20,
        ["Nobody Is Safe"] = 10,
        ["Nowhere Is Safe"] = 10,
        ["The Seeds of War"] = 20,
        ["The Will To Survive"] = 20,

        -- Armaetus adds names
        ["A Masterpiece in Progress"] = 40,
        ["A Bloody Good Time"] = 30,
        ["A Brand New World!"] = 30,
        ["A Developed Hellscape"] = 20,
        ["A Fantastic Place!"] = 25,
        ["A Folly For You"] = 20,
        ["A Multitude of Fun!"] = 25,
        ["A Pistol is Not Enough!"] = 25,
        ["A Survivor's Test"] = 30,
        ["A Withered World"] = 25,
        ["Abrasive to the Core"] = 30,
        ["Abuse Beyond Measure"] = 20,
        ["Always Being Improved"] = 40,
        ["Always Fun!"] = 30,
        ["Amped Up!"] = 20,
        ["An Excellent Choice!"] = 25,
        ["An ObAddon Production"] = 40,
        ["Another New World!"] = 30,
        ["Are You Man Enough?"] = 20,
        ["As Above, So Below"] = 30,
        ["Billions of Potential Levels!"] = 40,
        ["Blasted Into Bits"] = 25,
        ["Blasting Away!"] = 20,
        ["Bleed a Whole Lot More"] = 25,
        ["Bleeding Heavily"] = 35,
        ["Brace For Impact"] = 25,
        ["Breakdown of Order"] = 20,
        ["Bring Extra Ammunition!"] = 30,
        ["Brought to Your Knees!"] = 20,
        ["Bugs Do Exist, Plz Report!"] = 20,
        ["Burn It All Down"] = 30,
        ["Burning Bright in the Sky"] = 30,
        ["Burnt, Shot, Crushed, Blasted!"] = 20,
        ["Can It Be Any Harder?"] = 25,
        ["Carnal Desires"]=20,
        ["Check Us On The Discord!"] = 35,
        ["Cleansed By Fire"] = 25,
        ["Complete Destruction"]=20,
        ["Constantly Being Improved!"] = 30,
        ["Continued Destruction"] = 20,
        ["Corruption Abound"]=20,
        ["Corruption Unfettered"] = 20,
        ["Crash and Burn!"] = 20,
        ["Crimes Against Humanity"] = 25,
        ["Crucifixion By Buckshot"] = 20,
        ["Cruising for a Bruising"] = 30,
        ["Crushed into Dust"] = 30,
        ["Darkness Awaits Thee"] = 20,
        ["Death is Not An Option"] = 25,
        ["Descent Into Madness"] = 30,
        ["Die a Million Deaths"] = 25,
        ["Die and Die Once More"] = 20,
        ["Division by Blood"] = 20,
        ["Do Draconian Quantity!"]=15,
        ["Doomguy's Vacation"] = 25,
        ["Emblem of Destruction"] = 25,
        ["Embrace Your Doom"] = 30,
        ["Enemy Sighted!"] = 20,
        ["Environmental Abuse!"] = 20,
        ["Enter Combat"] = 25,
        ["Everybody Loves The Sub Titles"] = 20,
        ["Excessive Damage!"] = 25,
        ["Explosions Galore"] = 20,
        ["Existing To Bleed"] = 25,
        ["Face Smashed In"] = 20,
        ["Fairness Not Guaranteed"]=20,
        ["Fantastic!"] = 30,
        ["Feel the Pain!"] = 25,
        ["For The Emperor!"] = 30, -- Warhammer 40K
        ["Game Journos Need Not Apply!"] = 20,
        ["Get Psyched!"] = 30, -- Wolfenstein 3D
        ["Get Scorched"] = 30,
        ["Getting a Bit Spicy"] = 20,
        ["High Impact Abuse"] = 35,
        ["Hold On To Your Butts"] = 25, -- From Arnold in Jurassic Park, 1993,
        ["Hold Your Ground"] = 30,
        ["Is It Too Hard?"]=15,
        ["If it Moves, Shoot It"] = 30,
        ["It's a Disaster!"] = 20,
        ["It's Hard, Is it Not?"] = 25,
        ["It's Just Chaos"] = 20,
        ["It's Just Dead"] = 30,
        ["It's Raw!"] = 30,
        ["Jacked Up Past Safe Levels!"] = 25,
        ["John Romero says Hello"] = 25,
        ["Let's Get It On!"] = 30,
        ["Local Hellspawn Need Not Apply"] = 30,
        ["Lots More Where That Came From!"] = 30,
        ["Made with Blood, Sweat and Tears"] = 20,
        ["Make it Dark, Make it Evil"] = 30,
        ["Make it Like Silent Hill!"] = 25,
        ["Max out Trap Difficulty!"]=15,
        ["Masochism For Imps!"] = 30,
        ["Mods Usually Make Things Better!"] = 20,
        ["Move it up a Notch"] = 25,
        ["More Maps to Kill Things On!"] = 35,
        ["Nailed Via Obsidian Spikes"] = 20,
        ["Nappies Required to Play"]=15,
        ["Nearly Unlimited Variety!"] = 30,
        ["Not A Walk in the Park!"] = 30,
        ["Not Safe For Game Journalists"] = 35,
        ["Now with Dynamic Lights!"] = 30,
        ["Now with more Impse"] = 30,-- This is not a spelling error, look it up lol
        ["Oblige is Love, Oblige is Life"] = 40,
        ["Perfect on Ultra-Violence"] = 30,
        ["Peripheral Vision is Mandatory!"] = 30,
        ["Please Let Us Know!"] = 25,
        ["Potential Bugs May Exist!"] = 20,
        ["Prepare to Run Lots!"] = 20,
        ["Psychological Abuse"] = 30,
        ["Purified Sin"] = 20,
        ["Ramp it to the MAX!"] = 25,
        ["Road to the World Cup"] = 20, -- By Swedra
        ["Random by Nature"] = 30,
        ["Recreate id's Aesthetics!"]=10,
        ["Reign of Destruction"] = 25,
        ["Set the World Alight"]=15,
        ["Shining Bright!"] = 30,
        ["Should be A-OK!"] = 20,
        ["Single and Multiplayer!"] = 30,
        ["Skilled Players Sign Here"] = 25,
        ["Speedrunners are SOL"] = 25,
        ["Surviving By A Thread"] = 30,
        ["Symphony No 666 in H Minor"]=20,
        ["Tacticality Optional"] = 30,
        ["Take it Seriously"]=25,
        ["Tell Us What You Think"] = 40,
        ["Tell Your Friends!"] = 30,
        ["The Chaosbringer"] = 20,
        ["The Chaosweaver"] = 20, -- Partially from a Scar Symmetry song
        ["The Corridors of Contempt"] = 25,
        ["The Deadzone"] = 20,
        ["The Devil's Playground"] = 30,
        ["The Hellweaver"]=20,
        ["The More, The Merrier"] = 25,
        ["The New Challengers"] = 20, -- This one by Craneo
        ["The Principles of Doom"] = 30,
        ["The Threads of Life"] = 20,
        ["The Shreds of Humanity"] = 20,
        ["The True Story of Brutal Abuse"] = 20,
        ["The World Beyond"] = 25,
        ["There is Always Doomworld!"] = 20,
        ["There's Always More!"] = 25,
        ["There Is No Rationale"] = 20,
        ["Third Strike"] = 20, -- Also by Craneo
        ["This Generator Slays Demons"] = 25,
        ["This Is a Subtitle!"] = 20,
        ["This WAD Shouldn't Suck"] = 25,
        ["Thrashed Up for Seconds"] = 30,
        ["Time to Man Up"] = 30,
        ["Too Hard? Too Bad!"]=20,
        ["Total Blackout"] = 20,
        ["Totally Worth Your Time"] = 25,
        ["Trust in Thy Firearms"] = 20,
        ["Turn it to 11!"] = 30, -- Spinal Tap
        ["Turned Up to 110 Percent!"] = 20,
        ["TY for Supporting ObAddon!"] = 30,
        ["Under Construction"] = 25,
        ["Unrelenting Numbers!"] = 20,
        ["Up and At Em!"] = 30,
        ["Vigilance Is A Requirement!"] = 25,
        ["Virtuous By Nature"] = 20,
        ["Violation By Shotgun Barrel"] = 25,
        ["We Have to Start Somewhere"] = 20,
        ["We're in This Together"] = 25,
        ["What Awaits You?"] = 30,
        ["What Would Jesus Play?"] = 20,
        ["Working Overtime!"] = 30,
        ["You Guys Have Mods, Right?"] = 30,
        ["You Think You Can Hide?"] = 25,

        -- MSSP adds names
        ["Hell is Infinite"] = 50,

        -- based on popular movie/TV slogans
        ["A Minute in Hell"] = 20,
        ["Whoever Wins We Lose"] = 20,
        ["The Demons are Back"] = 20,
        ["Trapped in Hell"] = 20,
        ["Hell is War"] = 20,
        ["Escape or Die Trying"] = 20,
        ["No Rest for the Wicked"] = 20,
        ["Be Very Afraid"] = 20,
        ["There Can Only Be One"] = 20,
        ["Angels Fall"] = 20,
        ["The Last Man on Earth"] = 20,
        ["Welcome to the Suck"] = 20,
        ["A Hellspawn Reality"] = 20,
        ["Wake Up Screaming"] = 20,
        ["Wish You Were Here"] = 20,
        ["The Classic"] = 20,
        ["The Final Sentence"] = 20,
        ["The Mission is Survive"] = 20,
        ["There Will Be Blood"] = 20,
        ["Not A Romantic Comedy"] = 20,
        ["Might Hurt a Little"] = 20,
        ["Full Metal Jacket"] = 20,
        ["The Coast is Toast"] = 20,
        ["Too Proud To Run"] = 20,
        ["Fear Holds All Prisoner"] = 20,
        ["Nothing Spreads Like Fear"] = 20,
        ["A Few Days To Kill"] = 20,
        ["The Future is DOOM"] = 20,

        -- book serialization/publication buzzwords
        ["The Anthology"] = 40,
        ["The Trilogy"] = 40,
        ["The Complete Works"] = 20,
        ["Omnibus Edition"] = 20,
        ["Editor's Choice"] = 30,
        ["The Next Chapter"] = 20,

        -- production-related phrases
        ["11/10 IGN"] = 20,
        ["An ObligeFlix Original Series"] = 40,
        ["Classic Edition"] = 20,
        ["Day One Edition"] = 20,
        ["Deluxe Edition"] = 25,
        ["Game of the Year Edition"] = 20,
        ["Greatest Hits"] = 20, -- Craneo
        ["No Microtransactions"] = 20,
        ["Subscribe and Hit that Like Button"] = 40,
        ["The Official Video Game Tie-in"] = 20,
        ["The Original Series"] = 20,

        -- silly/annoying/occasionally informative
        ["Always Keep Hydrated"] = 20,
        ["Doesn't Contain Real Cheese"] = 10,
        ["Go Out and Vote"] = 15,
        ["Hate is Unmagic"] = 15,
        ["He Doesn't Afraid of Anything"] = 15,
        ["May Contain Chest-high Walls"] = 20,
        ["Now With More Sentence Enhancers!"] = 10,
        ["ObAdo What You ObAdon't"] = 20,
        ["People Die When They Are Killed"] = 10,
        ["Siri Look Up Doom Eternal"] = 10,
        ["So Sad Alexa Play D RUNNIN"] = 10,
        ["The World isn't Flat"] = 30,

        -- Based on music, be it artists, song titles or album titles
        ["Doomtanic Hellucinations"] = 20, -- Acid Witch - "Witchtanic Hellucinations" (song)
        ["Hymns of Destruction"] = 20, -- The Adicts - "Songs of Praise" (album title)
        ["Ashes of a Burning Earth"] = 25, -- Adversus Semita - "Ashes of a Burning Heaven" (song)
        ["Doomx V"] = 30, -- Aeba - "Kodex V" (album title)
        ["Demonic Rampage"] = 20, -- Afrobomination - "Galatic Rampage" (song)
        ["Hell in Motion"] = 20, --  Against Nature - "All in Motion" (song)
        ["Show Oneself the STARTAN"] = 15, -- Against Nature - "Show Myself the Door" (song)
        ["The Divinity of Cyberdemons"] = 20, -- Ahab - The Divinity of Oceans (album title)
        ["Enraptured by Death"] = 25, -- Akercocke - "Enraptured by Evil" (song)
        ["Ceremony of Nine Icons"] = 20, -- Akercocke - "The Ceremony of Nine Angels" (song)
        ["Demon's Lyric"] = 30, -- Akira Yamaoka - "Devil's Lyric" (Silent Hill Soundtrack)
        ["Blackness that Lurks in our Heart"] = 25, -- Akira Yamaoka - "The Darkness that Lurks in our Mind" (Silent Hill Soundtrack)
        ["Fear of the Abyss"] = 20, -- Akira Yamaoka - "Fear of the Dark" (Silent Hill Soundtrack)
        ["Death by the Shotgun"] = 20, -- Alestorm - "Death before the Mast" (song)
        ["No Secrets Known"] = 20, -- Alice in Chains - All Secrets Known (song)
        ["Earth Gives Way to Hell"] = 25, -- Alice in Chains - Black Gives Way to Blue (album title)
        ["Angry Demons"] = 20, -- Alice in Chains - Angry Chair (song)
        ["Consciousness Beyond Peril"] = 25, -- Alienation Cold - "Dream of an Obscured Consciousness" (song)
        ["Pursuit of Marines"] = 20, -- Amon Amarth - "The Pursuit of Vikings" (song)
        ["Ruined Armor and Bloody Rifles"] = 20, -- Amon Amarth - "Tattered Banners and Bloody Flags" (song)
        ["Maximum Doom"] = 20, -- Annihilator - "Maximum Satan" (song)
        ["Sometimes They Hear The Fist"] = 25, -- Atomizer - "Sometimes they hear the Bullet" (song)
        ["Hateful by Nature"] = 20, -- Atrophy - Violent by Nature (album title)
        -- I'll stop here, because I have over 18,000(!!) tracks to go through and this would make this
        -- list VERY, VERY LONG. - Armaetus

        ["Highway to DOOM"] = 20, -- AC/DC - "Highway to Hell" (song)
        ["Rhythm of Blood"] = 20, -- Unknown - "Rhythm of Red" (Tokyo Xtreme Racer Zero soundtrack)
        ["Born too Deadly"] = 20, -- The Crystal Method - "Born too Slow" (song)
        ["Angel and the Devil"] = 20, -- Wolfmother - "Joker and the Thief" (song)
        ["No Angels Fly"] = 20, -- Sabaton - "No Bullets Fly" (song)

        -- Nerdery stuff
        ["d20 Edition"] = 15 -- Also Swedra
      }
    }
  }
  -- end of 'TITLE' and 'SUB_TITLE' themes
  -- end of all the 'TEXT_XXX' themes
}


----------------------------------------------------------------


namelib.IGNORE_WORDS =
{
  ["the"]=1, ["a"]=1,  ["an"]=1, ["of"]=1, ["s"]=1,
  ["for"]=1, ["in"]=1, ["on"]=1, ["to"]=1
}



namelib.COMMUNITY_MEMBERS =
{

  -- Core ObAddon or regular(ish) contributors.
  contributors =
  {
    "Sgt. Shooter", --MsrSgtShooterPerson
    "Armaetus", -- Used to be known as Glaice
    "Frozsoul",
    "Caligari", --Caligari87,
    "Simon Vee", --Simon-v
    "Garrett",
    "Beed 28",
    "EpicTyphlosion",
    "Tapwave",
    "Craneo",
    "Swedra",
    "Demios",
    "Scionox",
    "Josh Seven" --josh771,
  },

  -- These people helped out OBLIGE and how they contributed.
  oblige_folks =
  {
    "Andrew Apted", -- THE developer of OBLIGE. ObAddon would not exist without him!
    "Dittohead", -- Made some prefabs
    "Doctor Nick", -- The Makefile MacOS file
    "Enhas", -- Lots of stuff. Modules, Psychedelic names, a boss map, feedback, fixes/tweaks
    "blackjar", -- Hexen theming
    "40oz", -- Tons of work on this very file, Cyberdemon arena map, some Doom prefabs
    "LakiSoft", -- Made a Heretic boss map
    "SylandroProbopas", -- Doom1 boss map
    "DoomJedi", -- Older V2/V3(?) Wolf3D testing, graphics and listing of Wolfenstein mods
    "esselfortium", -- General encouragement and detailed feedback
    "gggmork", -- Beta testing WIP versions and detailed feedback
    "flyingdeath", -- Lots of feedback and suggestions, namely seen on the forums
    "leilei", -- Base Amulets & Armor definition and general feedback
    "Maxim Samoylenko", -- General encouragement and testing
    "thesleeve", -- Monster placement analysis
  },

  -- this is an arbitrary list of regulars at the Unofficial Oblige
  -- Discord server. If you're a regular and you don't find your name
  -- here, feel free to add it yourself! (or ask a contributor to do so!)
  regulars =
  {
    "Samiam", -- Mr. ObHack!
    "Crowbars", -- crowbars82, Mr. Octothrop!
    "Big C",
    "Brad Man X",
    "DZ",
    "Elkinda",
    "Hexa Doken",
    "Kinker 31",
    "Kinsie",
    "Magpie", --MagPie
    "Mog Waltz",
    "Monika",
    "Obsidian Plague",
    "Nisteth",
    "Roundabout Lout",
    "Saint",
    "Sanser",
    "Sharahfluff",
    "Sharp",
    "TiZ",
    "The Dude", --TheDude1,
    "The Nate",
    "Thexare",
    "TTBNC",
    "Yandere Princess"
  }
}


namelib.HUMAN_NAMES =
{
  f =
  {
    ["A."] = 14,
    ["J."] = 11,
    ["M."] = 7,
    ["C."] = 6,
    ["E."] = 6,
    ["L."] = 6,
    ["K."] = 6,
    ["S."] = 5,
    ["B."] = 5,
    ["D."] = 4,
    ["R."] = 4,
    ["T."] = 3,
    ["N."] = 3,
    ["G."] = 3,
    ["H."] = 3,
    ["I."] = 3,
    ["P."] = 2,
    ["Z."] = 2,
    ["O."] = 2,
    ["W."] = 2,
    ["V."] = 2,
    ["F."] = 2,
    ["Y."] = 2,
    ["X."] = 1,
    ["Q."] = 1,
    ["U."] = 1
  },

  l =
  {
    Smith     = 1,
    Johnson     = 1,
    Williams     = 1,
    Jones     = 1,
    Brown     = 1,
    Davis     = 1,
    Miller     = 1,
    Wilson     = 1,
    Moore     = 1,
    Taylor     = 1,
    Anderson     = 1,
    Thomas     = 1,
    Jackson     = 1,
    White     = 1,
    Harris     = 1,
    Martin     = 1,
    Thompson     = 1,
    Garcia     = 1,
    Martinez     = 1,
    Robinson     = 1,
    Clark     = 1,
    Rodriguez     = 1,
    Lewis     = 1,
    Lee     = 1,
    Walker     = 1,
    Hall     = 1,
    Allen     = 1,
    Young     = 1,
    Hernandez     = 1,
    King     = 1,
    Wright     = 1,
    Lopez     = 1,
    Hill     = 1,
    Scott     = 1,
    Green     = 1,
    Adams     = 1,
    Baker     = 1,
    Gonzalez     = 1,
    Nelson     = 1,
    Carter     = 1,
    Mitchell     = 1,
    Perez     = 1,
    Roberts     = 1,
    Turner     = 1,
    Phillips     = 1,
    Campbell     = 1,
    Parker     = 1,
    Evans     = 1,
    Edwards     = 1,
    Collins     = 1,
    Stewart     = 1,
    Sanchez     = 1,
    Morris     = 1,
    Rogers     = 1,
    Reed     = 1,
    Cook     = 1,
    Morgan     = 1,
    Bell     = 1,
    Murphy     = 1,
    Bailey     = 1,
    Rivera     = 1,
    Cooper     = 1,
    Richardson     = 1,
    Cox     = 1,
    Howard     = 1,
    Ward     = 1,
    Torres     = 1,
    Peterson     = 1,
    Gray     = 1,
    Ramirez     = 1,
    James     = 1,
    Watson     = 1,
    Brooks     = 1,
    Kelly     = 1,
    Sanders     = 1,
    Price     = 1,
    Bennett     = 1,
    Wood     = 1,
    Barnes     = 1,
    Ross     = 1,
    Henderson     = 1,
    Coleman     = 1,
    Jenkins     = 1,
    Perry     = 1,
    Powell     = 1,
    Long     = 1,
    Patterson     = 1,
    Hughes     = 1,
    Flores     = 1,
    Washington     = 1,
    Butler     = 1,
    Simmons     = 1,
    Foster     = 1,
    Gonzales     = 1,
    Bryant     = 1,
    Alexander     = 1,
    Russell     = 1,
    Griffin     = 1,
    Diaz     = 1,
    Hayes     = 1,
    Myers     = 1,
    Ford     = 1,
    Hamilton     = 1,
    Graham     = 1,
    Sullivan     = 1,
    Wallace     = 1,
    Woods     = 1,
    Cole     = 1,
    West     = 1,
    Jordan     = 1,
    Owens     = 1,
    Reynolds     = 1,
    Fisher     = 1,
    Ellis     = 1,
    Harrison     = 1,
    Gibson     = 1,
    Mcdonald     = 1,
    Cruz     = 1,
    Marshall     = 1,
    Ortiz     = 1,
    Gomez     = 1,
    Murray     = 1,
    Freeman     = 1,
    Wells     = 1,
    Webb     = 1,
    Simpson     = 1,
    Stevens     = 1,
    Tucker     = 1,
    Porter     = 1,
    Hunter     = 1,
    Hicks     = 1,
    Crawford     = 1,
    Henry     = 1,
    Boyd     = 1,
    Mason     = 1,
    Morales     = 1,
    Kennedy     = 1,
    Warren     = 1,
    Dixon     = 1,
    Ramos     = 1,
    Reyes     = 1,
    Burns     = 1,
    Gordon     = 1,
    Shaw     = 1,
    Holmes     = 1,
    Rice     = 1,
    Robertson     = 1,
    Hunt     = 1,
    Black     = 1,
    Daniels     = 1,
    Palmer     = 1,
    Mills     = 1,
    Nichols     = 1,
    Grant     = 1,
    Knight     = 1,
    Ferguson     = 1,
    Rose     = 1,
    Stone     = 1,
    Hawkins     = 1,
    Dunn     = 1,
    Perkins     = 1,
    Hudson     = 1,
    Spencer     = 1,
    Gardner     = 1,
    Stephens     = 1,
    Payne     = 1,
    Pierce     = 1,
    Berry     = 1,
    Matthews     = 1,
    Arnold     = 1,
    Wagner     = 1,
    Willis     = 1,
    Ray     = 1,
    Watkins     = 1,
    Olson     = 1,
    Carroll     = 1,
    Duncan     = 1,
    Snyder     = 1,
    Hart     = 1,
    Cunningham     = 1,
    Bradley     = 1,
    Lane     = 1,
    Andrews     = 1,
    Ruiz     = 1,
    Harper     = 1,
    Fox     = 1,
    Riley     = 1,
    Armstrong     = 1,
    Carpenter     = 1,
    Weaver     = 1,
    Greene     = 1,
    Lawrence     = 1,
    Elliott     = 1,
    Chavez     = 1,
    Sims     = 1,
    Austin     = 1,
    Peters     = 1,
    Kelley     = 1,
    Franklin     = 1,
    Lawson     = 1,
    Fields     = 1,
    Gutierrez     = 1,
    Ryan     = 1,
    Schmidt     = 1,
    Carr     = 1,
    Vasquez     = 1,
    Castillo     = 1,
    Wheeler     = 1,
    Chapman     = 1,
    Oliver     = 1,
    Montgomery     = 1,
    Richards     = 1,
    Williamson     = 1,
    Johnston     = 1,
    Banks     = 1,
    Meyer     = 1,
    Bishop     = 1,
    Mccoy     = 1,
    Howell     = 1,
    Alvarez     = 1,
    Morrison     = 1,
    Hansen     = 1,
    Fernandez     = 1,
    Garza     = 1,
    Harvey     = 1,
    Little     = 1,
    Burton     = 1,
    Stanley     = 1,
    Nguyen     = 1,
    George     = 1,
    Jacobs     = 1,
    Reid     = 1,
    Kim     = 1,
    Fuller     = 1,
    Lynch     = 1,
    Dean     = 1,
    Gilbert     = 1,
    Garrett     = 1,
    Romero     = 1,
    Welch     = 1,
    Larson     = 1,
    Frazier     = 1,
    Burke     = 1,
    Hanson     = 1,
    Day     = 1,
    Mendoza     = 1,
    Moreno     = 1,
    Bowman     = 1,
    Medina     = 1,
    Fowler     = 1,
    Brewer     = 1,
    Hoffman     = 1,
    Carlson     = 1,
    Silva     = 1,
    Pearson     = 1,
    Holland     = 1,
    Douglas     = 1,
    Fleming     = 1,
    Jensen     = 1,
    Vargas     = 1,
    Byrd     = 1,
    Davidson     = 1,
    Hopkins     = 1,
    May     = 1,
    Terry     = 1,
    Herrera     = 1,
    Wade     = 1,
    Soto     = 1,
    Walters     = 1,
    Curtis     = 1,
    Neal     = 1,
    Caldwell     = 1,
    Lowe     = 1,
    Jennings     = 1,
    Barnett     = 1,
    Graves     = 1,
    Jimenez     = 1,
    Horton     = 1,
    Shelton     = 1,
    Barrett     = 1,
    Obrien     = 1,
    Castro     = 1,
    Sutton     = 1,
    Gregory     = 1,
    Mckinney     = 1,
    Lucas     = 1,
    Miles     = 1,
    Craig     = 1,
    Rodriquez     = 1,
    Chambers     = 1,
    Holt     = 1,
    Lambert     = 1,
    Fletcher     = 1,
    Watts     = 1,
    Bates     = 1,
    Hale     = 1,
    Rhodes     = 1,
    Pena     = 1,
    Beck     = 1,
    Newman     = 1,
    Haynes     = 1,
    Mcdaniel     = 1,
    Mendez     = 1,
    Bush     = 1,
    Vaughn     = 1,
    Parks     = 1,
    Dawson     = 1,
    Santiago     = 1,
    Norris     = 1,
    Hardy     = 1,
    Love     = 1,
    Steele     = 1,
    Curry     = 1,
    Powers     = 1,
    Schultz     = 1,
    Barker     = 1,
    Guzman     = 1,
    Page     = 1,
    Munoz     = 1,
    Ball     = 1,
    Keller     = 1,
    Chandler     = 1,
    Weber     = 1,
    Leonard     = 1,
    Walsh     = 1,
    Lyons     = 1,
    Ramsey     = 1,
    Wolfe     = 1,
    Schneider     = 1,
    Mullins     = 1,
    Benson     = 1,
    Sharp     = 1,
    Bowen     = 1,
    Daniel     = 1,
    Barber     = 1,
    Cummings     = 1,
    Hines     = 1,
    Baldwin     = 1,
    Griffith     = 1,
    Valdez     = 1,
    Hubbard     = 1,
    Salazar     = 1,
    Reeves     = 1,
    Warner     = 1,
    Stevenson     = 1,
    Burgess     = 1,
    Santos     = 1,
    Tate     = 1,
    Cross     = 1,
    Garner     = 1,
    Mann     = 1,
    Mack     = 1,
    Moss     = 1,
    Thornton     = 1,
    Dennis     = 1,
    Mcgee     = 1,
    Farmer     = 1,
    Delgado     = 1,
    Aguilar     = 1,
    Vega     = 1,
    Glover     = 1,
    Manning     = 1,
    Cohen     = 1,
    Harmon     = 1,
    Rodgers     = 1,
    Robbins     = 1,
    Newton     = 1,
    Todd     = 1,
    Blair     = 1,
    Higgins     = 1,
    Ingram     = 1,
    Reese     = 1,
    Cannon     = 1,
    Strickland     = 1,
    Townsend     = 1,
    Potter     = 1,
    Goodwin     = 1,
    Walton     = 1,
    Rowe     = 1,
    Hampton     = 1,
    Ortega     = 1,
    Patton     = 1,
    Swanson     = 1,
    Joseph     = 1,
    Francis     = 1,
    Goodman     = 1,
    Maldonado     = 1,
    Yates     = 1,
    Becker     = 1,
    Erickson     = 1,
    Hodges     = 1,
    Rios     = 1,
    Conner     = 1,
    Adkins     = 1,
    Webster     = 1,
    Norman     = 1,
    Malone     = 1,
    Hammond     = 1,
    Flowers     = 1,
    Cobb     = 1,
    Moody     = 1,
    Quinn     = 1,
    Blake     = 1,
    Maxwell     = 1,
    Pope     = 1,
    Floyd     = 1,
    Osborne     = 1,
    Paul     = 1,
    Mccarthy     = 1,
    Guerrero     = 1,
    Lindsey     = 1,
    Estrada     = 1,
    Sandoval     = 1,
    Gibbs     = 1,
    Tyler     = 1,
    Gross     = 1,
    Fitzgerald     = 1,
    Stokes     = 1,
    Doyle     = 1,
    Sherman     = 1,
    Saunders     = 1,
    Wise     = 1,
    Colon     = 1,
    Gill     = 1,
    Alvarado     = 1,
    Greer     = 1,
    Padilla     = 1,
    Simon     = 1,
    Waters     = 1,
    Nunez     = 1,
    Ballard     = 1,
    Schwartz     = 1,
    Mcbride     = 1,
    Houston     = 1,
    Christensen     = 1,
    Klein     = 1,
    Pratt     = 1,
    Briggs     = 1,
    Parsons     = 1,
    Mclaughlin     = 1,
    Zimmerman     = 1,
    French     = 1,
    Buchanan     = 1,
    Moran     = 1,
    Copeland     = 1,
    Roy     = 1,
    Pittman     = 1,
    Brady     = 1,
    Mccormick     = 1,
    Holloway     = 1,
    Brock     = 1,
    Poole     = 1,
    Frank     = 1,
    Logan     = 1,
    Owen     = 1,
    Bass     = 1,
    Marsh     = 1,
    Drake     = 1,
    Wong     = 1,
    Jefferson     = 1,
    Park     = 1,
    Morton     = 1,
    Abbott     = 1,
    Sparks     = 1,
    Patrick     = 1,
    Norton     = 1,
    Huff     = 1,
    Clayton     = 1,
    Massey     = 1,
    Lloyd     = 1,
    Figueroa     = 1,
    Carson     = 1,
    Bowers     = 1,
    Roberson     = 1,
    Barton     = 1,
    Tran     = 1,
    Lamb     = 1,
    Harrington     = 1,
    Casey     = 1,
    Boone     = 1,
    Cortez     = 1,
    Clarke     = 1,
    Mathis     = 1,
    Singleton     = 1,
    Wilkins     = 1,
    Cain     = 1,
    Bryan     = 1,
    Underwood     = 1,
    Hogan     = 1,
    Mckenzie     = 1,
    Collier     = 1,
    Luna     = 1,
    Phelps     = 1,
    Mcguire     = 1,
    Allison     = 1,
    Bridges     = 1,
    Wilkerson     = 1,
    Nash     = 1,
    Summers     = 1,
    Atkins     = 1,
    Wilcox     = 1,
    Pitts     = 1,
    Conley     = 1,
    Marquez     = 1,
    Burnett     = 1,
    Richard     = 1,
    Cochran     = 1,
    Chase     = 1,
    Davenport     = 1,
    Hood     = 1,
    Gates     = 1,
    Clay     = 1,
    Ayala     = 1,
    Sawyer     = 1,
    Roman     = 1,
    Vazquez     = 1,
    Dickerson     = 1,
    Hodge     = 1,
    Acosta     = 1,
    Flynn     = 1,
    Espinoza     = 1,
    Nicholson     = 1,
    Monroe     = 1,
    Wolf     = 1,
    Morrow     = 1,
    Kirk     = 1,
    Randall     = 1,
    Anthony     = 1,
    Whitaker     = 1,
    Oconnor     = 1,
    Skinner     = 1,
    Ware     = 1,
    Molina     = 1,
    Kirby     = 1,
    Huffman     = 1,
    Bradford     = 1,
    Charles     = 1,
    Gilmore     = 1,
    Dominguez     = 1,
    Oneal     = 1,
    Bruce     = 1,
    Lang     = 1,
    Combs     = 1,
    Kramer     = 1,
    Heath     = 1,
    Hancock     = 1,
    Gallagher     = 1,
    Gaines     = 1,
    Shaffer     = 1,
    Short     = 1,
    Wiggins     = 1,
    Mathews     = 1,
    Mcclain     = 1,
    Fischer     = 1,
    Wall     = 1,
    Small     = 1,
    Melton     = 1,
    Hensley     = 1,
    Bond     = 1,
    Dyer     = 1,
    Cameron     = 1,
    Grimes     = 1,
    Contreras     = 1,
    Christian     = 1,
    Wyatt     = 1,
    Baxter     = 1,
    Snow     = 1,
    Mosley     = 1,
    Shepherd     = 1,
    Larsen     = 1,
    Hoover     = 1,
    Beasley     = 1,
    Glenn     = 1,
    Petersen     = 1,
    Whitehead     = 1,
    Meyers     = 1,
    Keith     = 1,
    Garrison     = 1,
    Vincent     = 1,
    Shields     = 1,
    Horn     = 1,
    Savage     = 1,
    Olsen     = 1,
    Schroeder     = 1,
    Hartman     = 1,
    Woodard     = 1,
    Mueller     = 1,
    Kemp     = 1,
    Deleon     = 1,
    Booth     = 1,
    Patel     = 1,
    Calhoun     = 1,
    Wiley     = 1,
    Eaton     = 1,
    Cline     = 1,
    Navarro     = 1,
    Harrell     = 1,
    Lester     = 1,
    Humphrey     = 1,
    Parrish     = 1,
    Duran     = 1,
    Hutchinson     = 1,
    Hess     = 1,
    Dorsey     = 1,
    Bullock     = 1,
    Robles     = 1,
    Beard     = 1,
    Dalton     = 1,
    Avila     = 1,
    Vance     = 1,
    Rich     = 1,
    Blackwell     = 1,
    York     = 1,
    Johns     = 1,
    Blankenship     = 1,
    Trevino     = 1,
    Salinas     = 1,
    Campos     = 1,
    Pruitt     = 1,
    Moses     = 1,
    Callahan     = 1,
    Golden     = 1,
    Montoya     = 1,
    Hardin     = 1,
    Guerra     = 1,
    Mcdowell     = 1,
    Carey     = 1,
    Stafford     = 1,
    Gallegos     = 1,
    Henson     = 1,
    Wilkinson     = 1,
    Booker     = 1,
    Merritt     = 1,
    Miranda     = 1,
    Atkinson     = 1,
    Orr     = 1,
    Decker     = 1,
    Hobbs     = 1,
    Preston     = 1,
    Tanner     = 1,
    Knox     = 1,
    Pacheco     = 1,
    Stephenson     = 1,
    Glass     = 1,
    Rojas     = 1,
    Serrano     = 1,
    Marks     = 1,
    Hickman     = 1,
    English     = 1,
    Sweeney     = 1,
    Strong     = 1,
    Prince     = 1,
    Mcclure     = 1,
    Conway     = 1,
    Walter     = 1,
    Roth     = 1,
    Maynard     = 1,
    Farrell     = 1,
    Lowery     = 1,
    Hurst     = 1,
    Nixon     = 1,
    Weiss     = 1,
    Trujillo     = 1,
    Ellison     = 1,
    Sloan     = 1,
    Juarez     = 1,
    Winters     = 1,
    Mclean     = 1,
    Randolph     = 1,
    Leon     = 1,
    Boyer     = 1,
    Villarreal     = 1,
    Mccall     = 1,
    Gentry     = 1,
    Carrillo     = 1,
    Kent     = 1,
    Ayers     = 1,
    Lara     = 1,
    Shannon     = 1,
    Sexton     = 1,
    Pace     = 1,
    Hull     = 1,
    Leblanc     = 1,
    Browning     = 1,
    Velasquez     = 1,
    Leach     = 1,
    Chang     = 1,
    House     = 1,
    Sellers     = 1,
    Herring     = 1,
    Noble     = 1,
    Foley     = 1,
    Bartlett     = 1,
    Mercado     = 1,
    Landry     = 1,
    Durham     = 1,
    Walls     = 1,
    Barr     = 1,
    Mckee     = 1,
    Bauer     = 1,
    Rivers     = 1,
    Everett     = 1,
    Bradshaw     = 1,
    Pugh     = 1,
    Velez     = 1,
    Rush     = 1,
    Estes     = 1,
    Dodson     = 1,
    Morse     = 1,
    Sheppard     = 1,
    Weeks     = 1,
    Camacho     = 1,
    Bean     = 1,
    Barron     = 1,
    Livingston     = 1,
    Middleton     = 1,
    Spears     = 1,
    Branch     = 1,
    Blevins     = 1,
    Chen     = 1,
    Kerr     = 1,
    Mcconnell     = 1,
    Hatfield     = 1,
    Harding     = 1,
    Ashley     = 1,
    Solis     = 1,
    Herman     = 1,
    Frost     = 1,
    Giles     = 1,
    Blackburn     = 1,
    William     = 1,
    Pennington     = 1,
    Woodward     = 1,
    Finley     = 1,
    Mcintosh     = 1,
    Koch     = 1,
    Best     = 1,
    Solomon     = 1,
    Mccullough     = 1,
    Dudley     = 1,
    Nolan     = 1,
    Blanchard     = 1,
    Rivas     = 1,
    Brennan     = 1,
    Mejia     = 1,
    Kane     = 1,
    Benton     = 1,
    Joyce     = 1,
    Buckley     = 1,
    Haley     = 1,
    Valentine     = 1,
    Maddox     = 1,
    Russo     = 1,
    Mcknight     = 1,
    Buck     = 1,
    Moon     = 1,
    Mcmillan     = 1,
    Crosby     = 1,
    Berg     = 1,
    Dotson     = 1,
    Mays     = 1,
    Roach     = 1,
    Church     = 1,
    Chan     = 1,
    Richmond     = 1,
    Meadows     = 1,
    Faulkner     = 1,
    Oneill     = 1,
    Knapp     = 1,
    Kline     = 1,
    Barry     = 1,
    Ochoa     = 1,
    Jacobson     = 1,
    Gay     = 1,
    Avery     = 1,
    Hendricks     = 1,
    Horne     = 1,
    Shepard     = 1,
    Hebert     = 1,
    Cherry     = 1,
    Cardenas     = 1,
    Mcintyre     = 1,
    Whitney     = 1,
    Waller     = 1,
    Holman     = 1,
    Donaldson     = 1,
    Cantu     = 1,
    Terrell     = 1,
    Morin     = 1,
    Gillespie     = 1,
    Fuentes     = 1,
    Tillman     = 1,
    Sanford     = 1,
    Bentley     = 1,
    Peck     = 1,
    Key     = 1,
    Salas     = 1,
    Rollins     = 1,
    Gamble     = 1,
    Dickson     = 1,
    Battle     = 1,
    Santana     = 1,
    Cabrera     = 1,
    Cervantes     = 1,
    Howe     = 1,
    Hinton     = 1,
    Hurley     = 1,
    Spence     = 1,
    Zamora     = 1,
    Yang     = 1,
    Mcneil     = 1,
    Suarez     = 1,
    Case     = 1,
    Petty     = 1,
    Gould     = 1,
    Mcfarland     = 1,
    Sampson     = 1,
    Carver     = 1,
    Bray     = 1,
    Rosario     = 1,
    Macdonald     = 1,
    Stout     = 1,
    Hester     = 1,
    Melendez     = 1,
    Dillon     = 1,
    Farley     = 1,
    Hopper     = 1,
    Galloway     = 1,
    Potts     = 1,
    Bernard     = 1,
    Joyner     = 1,
    Stein     = 1,
    Aguirre     = 1,
    Osborn     = 1,
    Mercer     = 1,
    Bender     = 1,
    Franco     = 1,
    Rowland     = 1,
    Sykes     = 1,
    Benjamin     = 1,
    Travis     = 1,
    Pickett     = 1,
    Crane     = 1,
    Sears     = 1,
    Mayo     = 1,
    Dunlap     = 1,
    Hayden     = 1,
    Wilder     = 1,
    Mckay     = 1,
    Coffey     = 1,
    Mccarty     = 1,
    Ewing     = 1,
    Cooley     = 1,
    Vaughan     = 1,
    Bonner     = 1,
    Cotton     = 1,
    Holder     = 1,
    Stark     = 1,
    Ferrell     = 1,
    Cantrell     = 1,
    Fulton     = 1,
    Lynn     = 1,
    Lott     = 1,
    Calderon     = 1,
    Rosa     = 1,
    Pollard     = 1,
    Hooper     = 1,
    Burch     = 1,
    Mullen     = 1,
    Fry     = 1,
    Riddle     = 1,
    Levy     = 1,
    David     = 1,
    Duke     = 1,
    Odonnell     = 1,
    Guy     = 1,
    Michael     = 1,
    Britt     = 1,
    Frederick     = 1,
    Daugherty     = 1,
    Berger     = 1,
    Dillard     = 1,
    Alston     = 1,
    Jarvis     = 1,
    Frye     = 1,
    Riggs     = 1,
    Chaney     = 1,
    Odom     = 1,
    Duffy     = 1,
    Fitzpatrick     = 1,
    Valenzuela     = 1,
    Merrill     = 1,
    Mayer     = 1,
    Alford     = 1,
    Mcpherson     = 1,
    Acevedo     = 1,
    Donovan     = 1,
    Barrera     = 1,
    Albert     = 1,
    Cote     = 1,
    Reilly     = 1,
    Compton     = 1,
    Raymond     = 1,
    Mooney     = 1,
    Mcgowan     = 1,
    Craft     = 1,
    Cleveland     = 1,
    Clemons     = 1,
    Wynn     = 1,
    Nielsen     = 1,
    Baird     = 1,
    Stanton     = 1,
    Snider     = 1,
    Rosales     = 1,
    Bright     = 1,
    Witt     = 1,
    Stuart     = 1,
    Hays     = 1,
    Holden     = 1,
    Rutledge     = 1,
    Kinney     = 1,
    Clements     = 1,
    Castaneda     = 1,
    Slater     = 1,
    Hahn     = 1,
    Emerson     = 1,
    Conrad     = 1,
    Burks     = 1,
    Delaney     = 1,
    Pate     = 1,
    Lancaster     = 1,
    Sweet     = 1,
    Justice     = 1,
    Tyson     = 1,
    Sharpe     = 1,
    Whitfield     = 1,
    Talley     = 1,
    Macias     = 1,
    Irwin     = 1,
    Burris     = 1,
    Ratliff     = 1,
    Mccray     = 1,
    Madden     = 1,
    Kaufman     = 1,
    Beach     = 1,
    Goff     = 1,
    Cash     = 1,
    Bolton     = 1,
    Mcfadden     = 1,
    Levine     = 1,
    Good     = 1,
    Byers     = 1,
    Kirkland     = 1,
    Kidd     = 1,
    Workman     = 1,
    Carney     = 1,
    Dale     = 1,
    Mcleod     = 1,
    Holcomb     = 1,
    England     = 1,
    Finch     = 1,
    Head     = 1,
    Burt     = 1,
    Hendrix     = 1,
    Sosa     = 1,
    Haney     = 1,
    Franks     = 1,
    Sargent     = 1,
    Nieves     = 1,
    Downs     = 1,
    Rasmussen     = 1,
    Bird     = 1,
    Hewitt     = 1,
    Lindsay     = 1,
    Le     = 1,
    Foreman     = 1,
    Valencia     = 1,
    Oneil     = 1,
    Delacruz     = 1,
    Vinson     = 1,
    Dejesus     = 1,
    Hyde     = 1,
    Forbes     = 1,
    Gilliam     = 1,
    Guthrie     = 1,
    Wooten     = 1,
    Huber     = 1,
    Barlow     = 1,
    Boyle     = 1,
    Mcmahon     = 1,
    Buckner     = 1,
    Rocha     = 1,
    Puckett     = 1,
    Langley     = 1,
    Knowles     = 1,
    Cooke     = 1,
    Velazquez     = 1,
    Whitley     = 1,
    Noel     = 1,
    Vang     = 1
  },

  t =
  {
    AFK = 1,
    ALF = 1,
    Ace = 1,
    Adultman = 1,
    Alpha = 1,
    Android = 1,
    Angel = 1,
    Apex = 1,
    Apollo = 1,
    Arcade = 1,
    Atlas = 1,
    Axle = 1,
    Babe = 1,
    Babyface = 1,
    Ballsy = 1,
    Bananas = 1,
    Baron = 1,
    Beaks = 1,
    Beast = 1,
    Bebop = 1,
    Beef = 1,
    Beerhead = 1,
    Beetle = 1,
    Bishop = 1,
    Blinker = 1,
    Blitz = 1,
    Bobcat = 1,
    Bolts = 1,
    Bomber = 1,
    Bonus = 1,
    Bonzai = 1,
    Boogers = 1,
    Boomer = 1,
    Boots = 1,
    Bounce = 1,
    Brains = 1,
    Branch = 1,
    Breaker = 1,
    Brick = 1,
    Brute = 1,
    Buck = 1,
    Buddy = 1,
    Bug = 1,
    Bull = 1,
    Bully = 1,
    Bunnyhop = 1,
    Bush = 1,
    Buster = 1,
    Butcher = 1,
    Buzz = 1,
    Cake = 1,
    Caliban = 1,
    Cancelled = 1,
    Caper = 1,
    Cargo = 1,
    Cash = 1,
    Casino = 1,
    Caveman = 1,
    Chalk = 1,
    Checkmate = 1,
    Cheese = 1,
    Chef = 1,
    Chip = 1,
    Chips = 1,
    Chops = 1,
    Chum = 1,
    Civvy = 1,
    Clank = 1,
    Claymore = 1,
    Clopper = 1,
    Cobra = 1,
    Coffee = 1,
    Collateral = 1,
    Coma = 1,
    Combo = 1,
    Coney = 1,
    Congo = 1,
    Cook = 1,
    Cooties = 1,
    Cowboy = 1,
    Crash = 1,
    Crater = 1,
    Cub = 1,
    Cyclone = 1,
    Cyclops = 1,
    DJ = 1,
    Data = 1,
    Deacon = 1,
    Deadbolt = 1,
    Demon = 1,
    Desperado = 1,
    Dice = 1,
    Dicky = 1,
    Diesel = 1,
    Dinger = 1,
    Dino = 1,
    Disco = 1,
    Dizzy = 1,
    Doc = 1,
    Dog = 1,
    Doomsday = 1,
    Doot = 1,
    Double = 1,
    Dozer = 1,
    Drifter = 1,
    Dropout = 1,
    Dudebro = 1,
    Duke = 1,
    Dumpster = 1,
    Dutch = 1,
    Eagle = 1,
    Echo = 1,
    Egghead = 1,
    Electroviking = 1,
    Emo = 1,
    Enigma = 1,
    Ensign = 1,
    Expendable = 1,
    Eyebags = 1,
    FPS = 1,
    Fixer = 1,
    Flash = 1,
    Forklift = 1,
    Fox = 1,
    Freud = 1,
    Friendly = 1,
    Frog = 1,
    Fuzzyface = 1,
    Gangbanger = 1,
    Garrote = 1,
    Gassy = 1,
    Geronimo = 1,
    Ghost = 1,
    Gin = 1,
    Ginger = 1,
    Glasses = 1,
    Godfather = 1,
    Golem = 1,
    Gonzo = 1,
    Goose = 1,
    Granite = 1,
    Granny = 1,
    Gravedigger = 1,
    Grumble = 1,
    Gucci = 1,
    Gunner = 1,
    Guts = 1,
    Ham = 1,
    Hammer = 1,
    Hammerfist = 1,
    Hammerhead = 1,
    Hamster = 1,
    Hardcore = 1,
    Hazard = 1,
    Heaps = 1,
    Heartbreak = 1,
    Hex = 1,
    Hitch = 1,
    Hopps = 1,
    Horse = 1,
    Hotshot = 1,
    House = 1,
    Hulk = 1,
    Hutch = 1,
    Ice = 1,
    Icetea = 1,
    Inch = 1,
    Influencer = 1,
    Jabroni = 1,
    Jackhammer = 1,
    Jarhead = 1,
    Jaws = 1,
    Jock = 1,
    Joe = 1,
    Joker = 1,
    Jostler = 1,
    Judge = 1,
    Jughead = 1,
    Jumbo = 1,
    Jumper = 1,
    Junior = 1,
    Kickout = 1,
    Kingpin = 1,
    Knockout = 1,
    Kong = 1,
    Lacey = 1,
    Lance = 1,
    Lanky = 1,
    Lasagna = 1,
    Leather = 1,
    Leggy = 1,
    Lightning = 1,
    Lionheart = 1,
    Lockdown = 1,
    Loco = 1,
    Loki = 1,
    Longbow = 1,
    Lucky = 1,
    Lynch = 1,
    Mack = 1,
    Magic = 1,
    Marble = 1,
    Margarita = 1,
    Marvin = 1,
    Master = 1,
    Maverick = 1,
    Mayor = 1,
    Memelord = 1,
    Memer = 1,
    Missionary = 1,
    Money = 1,
    Moneyshot = 1,
    Mongol = 1,
    Monk = 1,
    Moon = 1,
    Moose = 1,
    Mouth = 1,
    Munchkin = 1,
    Murphy = 1,
    Mush = 1,
    Mustang = 1,
    Nasty = 1,
    Nemo = 1,
    Nero = 1,
    Newb = 1,
    Nightmare = 1,
    Nitro = 1,
    Nix = 1,
    Nobby = 1,
    Noob = 1,
    Nova = 1,
    Nugget = 1,
    Nuke = 1,
    Nuts = 1,
    Odin = 1,
    Olivaw = 1,
    Omega = 1,
    Omelet = 1,
    Ouija = 1,
    Pacman = 1,
    Pathfinder = 1,
    Peso = 1,
    Pharaoh = 1,
    Pillbox = 1,
    Pinky = 1,
    Pipes = 1,
    Pitbull = 1,
    Player = 1,
    Plumber = 1,
    Pod = 1,
    Potato = 1,
    Pox = 1,
    President = 1,
    Price = 1,
    Priest = 1,
    Prince = 1,
    Professor = 1,
    Prophet = 1,
    Prototype = 1,
    Psycho = 1,
    Pugilist = 1,
    Puppy = 1,
    Pyro = 1,
    Quitter = 1,
    Radio = 1,
    Radiohead = 1,
    Ragequit = 1,
    Rambo = 1,
    Ranger = 1,
    Rascal = 1,
    Rebel = 1,
    Rebound = 1,
    Red = 1,
    Redditor = 1,
    Regular = 1,
    Rhino = 1,
    Richter = 1,
    Rider = 1,
    Roach = 1,
    Roast = 1,
    Robby = 1,
    Rogue = 1,
    Rollback = 1,
    Romeo = 1,
    Rook = 1,
    Rookie = 1,
    Rotor = 1,
    Roundhouse = 1,
    Rubber = 1,
    Rum = 1,
    Ryle = 1,
    Sailor = 1,
    Saint = 1,
    Salsa = 1,
    Sandman = 1,
    Santa = 1,
    Saturn = 1,
    Scales = 1,
    Scambait = 1,
    Scarecrow = 1,
    Scat = 1,
    Scotch = 1,
    Sentinel = 1,
    Septic = 1,
    Shades = 1,
    Shadow = 1,
    Shady = 1,
    Sheriff = 1,
    Shield = 1,
    Shocker = 1,
    Shorty = 1,
    Shotsy = 1,
    Showboat = 1,
    Showoff = 1,
    Shrek = 1,
    Shy = 1,
    Siesta = 1,
    Silverback = 1,
    Skinner = 1,
    Sledge = 1,
    Slim = 1,
    Slugger = 1,
    Smallfoot = 1,
    Smarts = 1,
    Smash = 1,
    Smelly = 1,
    Smokes = 1,
    Smokey = 1,
    Smoothie = 1,
    Snake = 1,
    Snoopy = 1,
    Snow = 1,
    Snowflake = 1,
    Soap = 1,
    Socks = 1,
    Solo = 1,
    Spaced = 1,
    Sparky = 1,
    Specter = 1,
    Spewy = 1,
    Spider = 1,
    Spike = 1,
    Spitfire = 1,
    Splash = 1,
    Spoon = 1,
    Sportsman = 1,
    Springer = 1,
    Spuds = 1,
    Stacks = 1,
    Stag = 1,
    Stalker = 1,
    Steak = 1,
    Stick = 1,
    Strafer = 1,
    Streamer = 1,
    Strings = 1,
    Strobe = 1,
    Subscribe = 1,
    Superman = 1,
    Supreme = 1,
    Swallow = 1,
    Swampy = 1,
    Swanky = 1,
    Talos = 1,
    Tank = 1,
    Tectonic = 1,
    Tenacious = 1,
    Thrombo = 1,
    Thug = 1,
    Thunder = 1,
    Tictac = 1,
    Tiger = 1,
    Tombstone = 1,
    Toothpaste = 1,
    Trips = 1,
    Tubes = 1,
    Tug = 1,
    Twitch = 1,
    Vampire = 1,
    Vandal = 1,
    Viking = 1,
    Vita = 1,
    Vodka = 1,
    Voodoo = 1,
    Vulcan = 1,
    Walker = 1,
    Wardog = 1,
    Warlock = 1,
    Weab = 1,
    Weegee = 1,
    Werewolf = 1,
    Whiskey = 1,
    Wildchild = 1,
    Wolverine = 1,
    Woodchuck = 1,
    Wrestler = 1,
    Xeno = 1,
    Yeti = 1,
    Yoda = 1,
    YouTuber = 1,
    Zed = 1,
    Zen = 1,
    Zero = 1,
    Zeus = 1,
    Zilch = 1,
    Zulu = 1,
    ["Bad Hand"] = 1,
    ["Black Jack"] = 1,
    ["Can't See Me"] = 1,
    ["Can't Shoot Me"] = 1,
    ["Cat's Eyes"] = 1,
    ["Check Out My Channel"] = 1,
    ["Corporate Commander"] = 1,
    ["Cotton-eye"] = 1,
    ["Da Rappa"] = 1,
    ["Dead Inside"] = 1,
    ["Desert Fox"] = 1,
    ["Don't Need No Man"] = 1,
    ["Don't Shoot"] = 1,
    ["I Got Nothing"] = 1,
    ["I'm Alive"] = 1,
    ["IT Guy"] = 1,
    ["Ice Cube"] = 1,
    ["Iron Maiden"] = 1,
    ["Jack-booted"] = 1,
    ["Jimmie Rustler"] = 1,
    ["Kick Me"] = 1,
    ["Long Shot"] = 1,
    ["Low Rider"] = 1,
    ["Mad Dog"] = 1,
    ["Mad Lad"] = 1,
    ["Mad Man"] = 1,
    ["Man Down"] = 1,
    ["Moon-Moon"] = 1,
    ["Nice Guy"] = 1,
    ["Ninja Turtle"] = 1,
    ["Not Dead Yet"] = 1,
    ["Not a Zombie"] = 1,
    ["Oh Man"] = 1,
    ["One-Eyed"] = 1,
    ["Pays in Exposure"] = 1,
    ["Plan B"] = 1,
    ["Road Block"] = 1,
    ["Swamp Fox"] = 1,
    ["That Guy"] = 1,
    ["The Bear"] = 1,
    ["The Terror"] = 1,
    ["True Gamer"]=1,
    ["Turkey Neck"] = 1,
    ["Uh-oh"] = 1,
    ["Vanilla Ice"] = 1,
    ["War Horse"] = 1,
    ["White Death"] = 1,

    ["Hear no Evil"] = 1,
    ["See no Evil"] = 1,
    ["Do no Evil"] = 1
  }
}


namelib.SYLLABLES =
{
  e = -- EXOTIC names
  {
    -- country/place names
    a = 50,
    af = 50,
    an = 50,
    aq = 50,
    ar = 50,
    as = 50,
    au = 50,
    atia = 50,
    ba = 50,
    bab = 50,
    bad = 50,
    bah = 50,
    bai = 50,
    ban = 50,
    bar = 50,
    bang = 50,
    be = 50,
    ber = 50,
    bi = 50,
    bia = 50,
    bis = 50,
    bhu = 50,
    bo = 50,
    bon = 50,
    bou = 50,
    bourg = 50,
    bos = 50,
    bot = 50,
    bra = 50,
    bri = 50,
    bru = 50,
    bu = 50,
    bul = 50,
    cam = 50,
    can = 50,
    cco = 50,
    co = 50,
    con = 50,
    ce = 50,
    cent = 50,
    cez = 50,
    ci = 50,
    cia = 50,
    chad = 50,
    chi = 50,
    cho = 50,
    co = 50,
    cro = 50,
    cu = 50,
    cua = 50,
    cy = 50,
    da = 50,
    dad = 50,
    dan = 50,
    de = 50,
    den = 50,
    desh = 50,
    di = 50,
    dia = 50,
    dines = 50,
    dives = 50,
    dji = 50,
    ["do"] = 50,
    dom = 50,
    dos = 50,
    dor = 50,
    du = 50,
    e = 50,
    el = 50,
    eg = 50,
    em = 50,
    eng = 50,
    er = 50,
    es = 50,
    fa = 50,
    fra = 50,
    fi = 50,
    fin = 50,
    ga = 50,
    gal = 50,
    gan = 50,
    gam = 50,
    gar = 50,
    geor = 50,
    ger = 50,
    gre = 50,
    gree = 50,
    gha = 50,
    gen = 50,
    ger = 50,
    gia = 50,
    gium = 50,
    go = 50,
    gol = 50,
    gov = 50,
    gre = 50,
    gro = 50,
    gu = 50,
    gua = 50,
    guay = 50,
    gyz = 50,
    ham = 50,
    her = 50,
    hon = 50,
    i = 50,
    ia = 50,
    iet = 50,
    ["in"] = 50,
    ice = 50,
    ina = 50,
    ion = 50,
    ir = 50,
    ire = 50,
    is = 50,
    ish = 50,
    ja = 50,
    ji = 50,
    jian = 50,
    jor = 50,
    ka = 50,
    ken = 50,
    ki = 50,
    kia = 50,
    king = 50,
    kis = 50,
    --kitts = 50,
    ko = 50,
    ku = 50,
    kyr = 50,
    la = 50,
    lan = 50,
    land = 50,
    lay = 50,
    le = 50,
    leo = 50,
    les = 50,
    li = 50,
    lia = 50,
    lib = 50,
    lip = 50,
    liech = 50,
    lith = 50,
    lize = 50,
    lo = 50,
    lom = 50,
    lu = 50,
    lua = 50,
    lux = 50,
    ma = 50,
    mai = 50,
    mal = 50,
    mar = 50,
    mark = 50,
    mau = 50,
    men = 50,
    me = 50,
    mex = 50,
    mi = 50,
    mo = 50,
    moa = 50,
    mor = 50,
    mon = 50,
    mya = 50,
    na = 50,
    nam = 50,
    nau = 50,
    ne = 50,
    nea = 50,
    nei = 50,
    ni = 50,
    nia = 50,
    nis = 50,
    no = 50,
    nom = 50,
    non = 50,
    nor = 50,
    nua = 50,
    nin = 50,
    ny = 50,
    o = 50,
    ["os"] = 50,
    pa = 50,
    pan = 50,
    pe = 50,
    po = 50,
    por = 50,
    phi = 50,
    prin = 50,
    prus = 50,
    pua = 50,
    qa = 50,
    que = 50,
    ra = 50,
    rain = 50,
    ras = 50,
    rea = 50,
    ria = 50,
    ri = 50,
    ru = 50,
    roon = 50,
    ros = 50,
    rus = 50,
    rwan = 50,
    tal = 50,
    tar = 50,
    tain = 50,
    ["tan"] = 50,
    ted = 50,
    thai = 50,
    ther = 50,
    ti = 50,
    to = 50,
    ton = 50,
    tine = 50,
    tri = 50,
    tria = 50,
    tu = 50,
    sao = 50,
    sah = 50,
    sal = 50,
    sau = 50,
    scot = 50,
    se = 50,
    ser = 50,
    sey = 50,
    shall = 50,
    sia = 50,
    sier = 50,
    slo = 50,
    so = 50,
    ["sin"] = 50,
    sov = 50,
    sla = 50,
    sri = 50,
    swa = 50,
    swe = 50,
    stan = 50,
    stein = 50,
    su = 50,
    sy = 50,
    tai = 50,
    ["tan"] = 50,
    ten = 50,
    tho = 50,
    ti = 50,
    ton = 50,
    tral = 50,
    tu = 50,
    tzer = 50,
    u = 50,
    ua = 50,
    un = 50,
    und = 50,
    uz = 50,
    va = 50,
    ve = 50,
    ver = 50,
    vo = 50,
    via = 50,
    viet = 50,
    vin = 50,
    vis = 50,
    wa = 50,
    we = 50,
    wait = 50,
    way = 50,
    wi = 50,
    xi = 50,
    y = 50,
    ya = 50,
    ye = 50,
    yu = 50,
    ypt = 50,
    za = 50,
    zam = 50,
    zakh = 50,
    zer = 50,
    ze = 50,
    zea = 50,
    zi = 50,
    zim = 50,
    zil = 50,

    -- celestials
    -- note: some of the syllables are deliberately incomplete
    -- because they already show up in the country syllables list
    sol = 50, -- our sun

    ry = 50, --mercury

    nus = 50, --venus

    rra = 50, --terra

    mars = 50,

    ju = 50, --jupiter
    pi = 50,
    ter = 50,

    sa = 50, --saturn
    turn = 50,

    nep = 50, --neptune
    tune = 50,

    ur = 50, --uranus
    us = 50,

    plu = 50, -- pluto

    cer = 50, -- ceres

    -- minor celestial bodies
    kui = 50, -- kuiper belt
    per = 50,

    dei = 50, -- deimos

    pho = 50, -- phobos

    pal = 50, -- pallas
    las = 50,

    ves = 50, -- vesta

    hy = 50, --hygiea
    giea = 50,

    eu = 50, -- europa

    mede = 50, -- ganymede

    cal = 50, -- callisto
    lis = 50,

    en = 50, -- enceladus
    dus = 50,

    thys = 50, -- tethys

    di = 50,
    one = 50,

    rhea = 50,

    ia = 50, -- iapetus
    tus = 50,

    phoe = 50, --pheobe

    ran = 50, -- miranda

    riel = 50, -- ariel

    umb = 50, -- umbriel

    ron = 50, -- oberon

    pro = 50, -- pro
    teus = 50,

    reid = 50, -- nereid

    aurs = 50, -- centaurs

    cloids = 50, -- damocloids

    cha = 50, -- charon

    vanth = 50,

    hau = 50, -- haumea
    mea = 50,

    ris = 50, -- eris

    dys = 50, -- dysnomia
    mia = 50,

    oort = 50 -- oort
  },

  -- MYTHIC
  m =
  {
    p = --prefixes
    {
      ach = 1, aeth = 1, aion = 1, chro = 1, an = 1, anan = 1,
      cha = 1, ere = 1, er = 1, eb = 1,
      pha = 1, gai = 1, he = 1, me = 1, ou = 1, pont = 1, tha = 1, lass = 1,
      tar = 1, ta = 1, at = 1, ro = 1, clo = 1, lach = 1, es = 1,

      coe = 1, cri = 1, cro = 1, hy = 1, per = 1, ia = 1, pe = 1,
      dio = 1, mne = 1, no = 1,
      phoe = 1, rhea = 1, teth = 1, the = 1, them = 1,
      eos = 1, hel = 1, sel = 1,
      as = 1, ter = 1, pal = 1, per = 1,
      at = 1, epi = 1, meth = 1, me = 1, no = 1, pro = 1
    },
    s = --suffixes
    {
      lys = 1, er = 2, on = 2, nos = 1, us = 3, nes = 1, ra = 2, rea = 2,
      a = 5, nyx = 1, rus = 1, nus = 4, pos = 1, tho = 1, is = 2,

      ion = 2, tus = 1,
      ne = 1, syne = 1, be = 1, thys = 1, ia = 3,
      ios = 1,
      las = 2, ses = 1,
      eus = 1, theus = 1
    }
  },

  a = --ANGLICAN names
  {
    ["lower"] = 50,
    ["or"] = 50,
    ["read"] = 50,
    ["tan"] = 50,
    ["upper"] = 50,
    acre = 50,
    anna = 50,
    apple = 50,
    auburn = 50,
    aus = 50,
    away = 50,
    bait = 50,
    bath = 50,
    bay = 50,
    beach = 50,
    belle = 50,
    bello = 50,
    benson = 50,
    bick = 50,
    bing = 50,
    black = 50,
    blaine = 50,
    bloom = 50,
    bob = 50,
    body = 50,
    booth = 50,
    born = 50,
    boro = 50,
    bos = 50,
    bowl = 50,
    brent = 50,
    briar = 50,
    brick = 50,
    bridge = 50,
    brigh = 50,
    bron = 50,
    brook = 50,
    broom = 50,
    browns = 50,
    bruns = 50,
    buck = 50,
    bur = 50,
    burgh = 50,
    bury = 50,
    bush = 50,
    ca = 50,
    cal = 50,
    car = 50,
    carls = 50,
    castle = 50,
    cen = 50,
    ches = 50,
    chest = 50,
    chester = 50,
    chi = 50,
    cho = 50,
    cis = 50,
    co = 50,
    com = 50,
    cour = 50,
    cres = 50,
    dale = 50,
    dawn = 50,
    dar = 50,
    dave = 50,
    dear = 50,
    del = 50,
    den = 50,
    don = 50,
    drive = 50,
    east = 50,
    elting = 50,
    en = 50,
    emers = 50,
    ["end"] = 50,
    es = 50,
    eve = 50,
    eye = 50,
    fair = 50,
    falls = 50,
    far = 50,
    field = 50,
    flag = 50,
    flat = 50,
    ford = 50,
    fran = 50,
    frank = 50,
    fy = 50,
    galv = 50,
    gar = 50,
    gate = 50,
    gie = 50,
    gil = 50,
    glen = 50,
    go = 50,
    grand = 50,
    grant = 50,
    grape = 50,
    green = 50,
    grove = 50,
    gue = 50,
    gulf = 50,
    hack = 50,
    ham = 50,
    hamp = 50,
    harl = 50,
    harp = 50,
    harris = 50,
    hat = 50,
    haven = 50,
    head = 50,
    hicks = 50,
    hill = 50,
    hol = 50,
    home = 50,
    hunt = 50,
    hurst = 50,
    ien = 50,
    inns = 50,
    ing = 50,
    john = 50,
    jones = 50,
    kel = 50,
    kers = 50,
    kings = 50,
    la = 50,
    lake = 50,
    land = 50,
    lau = 50,
    le = 50,
    lees = 50,
    ley = 50,
    ling = 50,
    lock = 50,
    long = 50,
    loo = 50,
    lough = 50,
    low = 50,
    lyn = 50,
    mac = 50,
    mack = 50,
    man = 50,
    maple = 50,
    mas = 50,
    may = 50,
    med = 50,
    mi = 50,
    mid = 50,
    mint = 50,
    mo = 50,
    mond = 50,
    mont = 50,
    monte = 50,
    moore = 50,
    more = 50,
    morris = 50,
    morning = 50,
    mound = 50,
    mount = 50,
    na = 50,
    naan = 50,
    nas = 50,
    near = 50,
    neo = 50,
    new = 50,
    nor = 50,
    north = 50,
    nuet = 50,
    oak = 50,
    pach = 50,
    palm = 50,
    pat = 50,
    pea = 50,
    pete = 50,
    plains = 50,
    ple = 50,
    point = 50,
    port = 50,
    queens = 50,
    ram = 50,
    randall = 50,
    red = 50,
    rel = 50,
    rich = 50,
    rick = 50,
    ridge = 50,
    rock = 50,
    rom = 50,
    ross = 50,
    row = 50,
    roy = 50,
    ry = 50,
    sack = 50,
    san = 50,
    say = 50,
    scran = 50,
    sea = 50,
    sey = 50,
    shawn = 50,
    shef = 50,
    shir = 50,
    shore = 50,
    smith = 50,
    son = 50,
    sota = 50,
    south = 50,
    springs = 50,
    staff = 50,
    stam = 50,
    stead = 50,
    stee = 50,
    stone = 50,
    stream = 50,
    tar = 50,
    taunt = 50,
    ter = 50,
    thon = 50,
    tic = 50,
    tin = 50,
    ton = 50,
    town = 50,
    tree = 50,
    trent = 50,
    ty = 50,
    val = 50,
    vale = 50,
    ve = 50,
    ver = 50,
    vere = 50,
    vi = 50,
    ville = 50,
    vine = 50,
    wad = 50,
    wake = 50,
    walk = 50,
    wald = 50,
    wall = 50,
    war = 50,
    ward = 50,
    wark = 50,
    water = 50,
    well = 50,
    west = 50,
    whit = 50,
    white = 50,
    wich = 50,
    wick = 50,
    williams = 50,
    win = 50,
    wind = 50,
    wood = 50,
    yard = 50,
    yon = 50,
    youngs = 50
  }
}



-- noun generator, creates nouns from syllables
-- currently two modes:
-- "Exotic" - syllables come from country names
--            and solar system body names
-- "Anglican" - syllables come from US and UK towns
--              and places, usually emphasizes whole
--              words as syllables
function namelib.generate_unique_noun(m)
  local mode = m

  local function make_placelike_syllable(style)
    if style == "anglican" then
      return rand.key_by_probs(namelib.SYLLABLES.a)
    elseif style == "exotic" then
      return rand.key_by_probs(namelib.SYLLABLES.e)
    end
  end

  local function make_random_hashes(a, b)
    local hash_string = ""

    local number_list =
    {
      "0","1","2","3","4","5","6","7","8","9"
    }

    local alphabet_list =
    {
      "A","B","C","D","E","F","G","H","I",
      "J","K","L","M","N","O","P","Q","R",
      "S","T","U","V","W","X","Y","Z"
    }

    local function fetch_a_digit()
      if rand.odds(75) then
        return rand.pick(number_list)
      else
        return rand.pick(alphabet_list)
      end
    end

    if a == 0 then
      hash_string = fetch_a_digit()
    else
      if rand.odds(20) then
        hash_string = "-"
      end
      hash_string = hash_string .. fetch_a_digit()
    end

    return hash_string
  end

  local name = ""
  local syllable_count
  if mode == "anglican" then
    syllable_count = 2
  elseif mode == "exotic" then
    syllable_count = rand.pick({2,2,2,2,3,3,3,3,3,3,4})
  end

  local i = 1

  if mode == "anglican" or mode == "exotic" then
    repeat
      name = name .. make_placelike_syllable(mode)
      i = i + 1
    until i > syllable_count
  end

  name = string.gsub(name,"^%l",string.upper)

  if mode == "community_members" then
    local choice = rand.key_by_probs({c=6, r=2, o=2})
    if choice == "c" then
      name = rand.pick(namelib.COMMUNITY_MEMBERS.contributors)
    elseif choice == "r" then
      name = rand.pick(namelib.COMMUNITY_MEMBERS.regulars)
    elseif choice == "o" then
      name = rand.pick(namelib.COMMUNITY_MEMBERS.oblige_folks)
    end
  end

  local x = 0
  local num_string = ""
  if mode == "number" then
    -- pick numbers
    local num_length = rand.pick({1,2,3,3,4,4,5,6})

    while x < num_length do
      -- don't accept 0's for the first one
      if num_string:len() == 0 then
        num_string = tostring(rand.irange(1,9))
      else
        num_string = num_string .. tostring(rand.irange(0,9))
      end
      x = x + 1
    end

    name = num_string
  elseif mode == "serial" then
    local num_length = rand.pick({3,4,4,5,5,5,6,7,8})

    while x < num_length do
      num_string = num_string .. make_random_hashes(x, num_length)
      x = x + 1
    end

    name = num_string
  end

  return name
end


function namelib.fix_up(name)
  -- convert "_" to "-",
  name = string.gsub(name, "_ ", "-")
  name = string.gsub(name, "_",  "-")

  -- convert "A" to "AN" where necessary
  name = string.gsub(name, "^[aA] ([aAeEiIoOuU])", "An %1")

  -- the "+s" means to add "S" to a word (pluralize it)
  name = string.gsub(name, "s%+s", "s")
  name = string.gsub(name, "x%+s", "xes")
  name = string.gsub(name, "z%+s", "zes")
  name = string.gsub(name, "ay%+s", "ays")
  name = string.gsub(name, "oy%+s", "ays")
  name = string.gsub(name, "y%+s", "ies")
  name = string.gsub(name, "%+s", "s")

  -- the "/s" means to remove a trailing "S" from a word
  name = string.gsub(name, "ies/s", "y")
  name = string.gsub(name, "s/s", "")
  name = string.gsub(name, "/s", "")

  name = string.gsub(name, "NOUNGENANGLICAN", namelib.generate_unique_noun("anglican"))
  name = string.gsub(name, "NOUNGENEXOTIC", namelib.generate_unique_noun("exotic"))
  name = string.gsub(name, "NOUNMEMBERS", namelib.generate_unique_noun("community_members"))

  name = string.gsub(name, "NOUNNUMBER", namelib.generate_unique_noun("number"))
  name = string.gsub(name, "NOUNSERIAL", namelib.generate_unique_noun("serial"))
  return name
end


function namelib.split_word(tab, word)
  for w in string.gmatch(word, "%a+") do
    local low = string.lower(w)

    if not namelib.IGNORE_WORDS[low] then
      -- truncate to 4 letters
      if #low > 4 then
        low = string.sub(low, 1, 4)
      end

      tab[low] = (tab[low] or 0) + 1
    end
  end
end


function namelib.match_parts(word, parts)
  for p,_ in pairs(parts) do
    for w in string.gmatch(word, "%a+") do
      local low = string.lower(w)

      -- truncate to 4 letters
      if #low > 4 then
        low = string.sub(low, 1, 4)
      end

      if p == low then
        return true
      end
    end
  end

  return false
end


function namelib.one_from_pattern(DEF)
  local name = ""
  local words = {}

  local pattern = rand.key_by_probs(DEF.patterns)
  local pos = 1

  while pos <= #pattern do

    local c = string.sub(pattern, pos, pos)
    pos = pos + 1

    if c ~= '%' then
      name = name .. c
    else
      assert(pos <= #pattern)
      c = string.sub(pattern, pos, pos)
      pos = pos + 1

      if not string.match(c, "%a") then
        error("Bad naming pattern: expected letter after %")
      end

      local lex = DEF.lexicon[c]
      if not lex then
        error("Naming theme is missing letter: " .. c)
      end

      local w = rand.key_by_probs(lex)
      name = name .. w

      namelib.split_word(words, w)
    end
  end

  return name, words
end


function namelib.choose_one(DEF, max_len)
  local name, parts

  repeat
    name, parts = namelib.one_from_pattern(DEF)
  until #name <= max_len

  -- adjust probabilities
  for c,word_tab in pairs(DEF.lexicon) do
    local divisor = DEF.divisors[c] or 10

    for w,prob in pairs(word_tab) do
      if namelib.match_parts(w, parts) then
        DEF.lexicon[c][w] = prob / divisor
      end
    end
  end

  return namelib.fix_up(name)
end


function namelib.merge_theme(theme_name)
  -- verify the theme name
  if not namelib.NAMES[theme_name] then
    error("namelib.generate: unknown theme: " .. tostring(theme_name))
  end

  local theme = {}

  local sources = { namelib.NAMES, GAME.NAMES or {} }

  -- always merge in the "COMMON" theme before the main one
  for _,S in pairs(sources) do
    if S["COMMON"] then
      table.deep_merge(theme, S["COMMON"])
    end
  end

  -- now merge in the actual specific theme
  for _,S in pairs(sources) do
    if S[theme_name] then
      table.deep_merge(theme, S[theme_name])
    end
  end

  return theme
end


function namelib.generate(theme_name, count, max_len)
  local DEF = namelib.merge_theme(theme_name)

  local list = {}

  for i = 1, count do
    local name = namelib.choose_one(DEF, max_len)

    table.insert(list, name)
  end

  return list
end


function namelib.test()
  local function test_theme(T)
    for set = 1,30 do
      gui.rand_seed(set)
      local list = namelib.generate(T, 12, 28)

      for _,name in pairs(list) do
        gui.debugf("%s Set %d Name %2d: %s\n", T, set, _index, name)
      end

      gui.debugf("\n");
    end
  end

  test_theme("TECH")
  test_theme("GOTHIC")
  test_theme("URBAN")
  test_theme("CASTLE")

  test_theme("BOSS")
  test_theme("EPISODE")
  test_theme("TITLE")
end


function Naming_init()
  namelib.cache = {}
end


function Naming_grab_one(theme)
  local cache = namelib.cache
  assert(cache)

  if not cache[theme] or table.empty(cache[theme]) then
    cache[theme] = namelib.generate(theme, 30, 40)
  end

  return table.remove(namelib.cache[theme], 1)
end
