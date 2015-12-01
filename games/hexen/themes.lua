------------------------------------------------------------------------
--  HEXEN THEMES
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2011 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HEXEN.THEMES =
{
  DEFAULTS =
  {
    keys =
    {
      k_axe = 50
      k_cave = 50
      k_castle = 50
      k_dungeon = 50
      k_emerald = 50
      k_fire = 20
      k_horn = 50
      k_rusty = 50
      k_silver = 50
      k_swamp = 50
      k_steel = 50
    }

    switches =
    {
      sw_demon = 50
      sw_moon  = 40
    }

  }


  any_Stairwell =
  {
    kind = "stairwell"

    walls =
    {
      STEEL08 = 50
    }

    floors =
    {
      F_073 = 30
    }
  }


  --------------------------------------------------

  -- FIXME
}



-- TODO / FIXME:  Split-off various special/novelty walls, further split many themes, and
-- remove many excessiv or poorly picked floor/cieling (and a few wall) textures, JB.
HEXEN.ROOM_THEMES =
{
  -- This is the monestary / palacial castle type dungeon

    Dungeon_monktan =
  {
    walls =
    {
      MONK02=40
      MONK03=15
      MONK16=15
    }

    floors =
    {
      F_011=20
      F_014=8
      F_025=15
      F_028=10
      F_029=10
      F_077=10
      F_089=12
    }

    ceilings =
    {
      F_011=20
      F_014=8
      F_025=15
      F_028=10
      F_029=10
      F_092=5
    }
    
    hallways  = { Dungeon_monktan=50 }
  }

    Dungeon_monktan_large =
  {
    walls =
    {
      MONK14=35
      MONK15=15
      MONK16=5
      MONK17=3
      MONK18=2
    }

    floors =
    {
      F_011=20
      F_014=8
      F_025=15
      F_028=10
      F_029=10
      F_077=10
      F_089=12
    }

    ceilings =
    {
      F_011=20
      F_014=8
      F_025=15
      F_028=10
      F_029=10
      F_092=5
    }

    hallways  = { Dungeon_monktan_large=50 }
  }

  Dungeon_monkgray =
  {
    walls =
    {
      MONK01=30
  }

    floors =
    {
      F_009=30
      F_012=40
      F_030=10
      F_031=15
      F_042=8
      F_043=4
      F_048=9
      F_057=5
      F_073=3
      F_089=12
    }

    ceilings =
    {
      F_009=30
      F_012=40
      F_031=25
      F_041=3
      F_042=8
      F_043=4
      F_048=9
      F_057=5
      F_089=12
      F_092=5
    }
    
    hallways  = { Dungeon_monkgray=25, Dungeon_monkrosette=50 }
  }

  Dungeon_monkrosette =
  {
        facades =
  {
      MONK01=35
      MONK07=15
        }

    walls =
    {
      MONK07=35
      MONK08=10
    }

    floors =
    {
      F_031=50
    }

    ceilings =
    {
      F_031=50
    }

    hallways  = { Dungeon_monkgray=25, Dungeon_monkrosette=50 }
  }

  Dungeon_portals1 =
  {
        facades =
        {
      PRTL02=30
      PRTL03=5
        }

    walls =
    {
      PRTL04=40
      PRTL05=25
    }

    floors =
    {
      F_010=25
      F_044=50
      F_089=10
    }

    ceilings =
    {
      F_010=25
      F_044=50
  }

    hallways  = { Dungeon_portals1=50 }
  }

  Dungeon_portals2 =
  {
    walls =
    {
      PRTL02=30
      PRTL03=5
        }

    floors =
    {
      F_010=25
      F_044=50
      F_089=10
    }

    ceilings =
    {
      F_010=25
      F_044=50
    }

    hallways  = { Dungeon_portals2=50 }
  }

  -- This is the dark, dank dungeon type of crumbling castles, cemetaries, 
  -- crypts, sewers, and of course, dungeons.

  Dungeon_tomb1 =
  {
    walls =
    {
      TOMB04=15
      TOMB02=15
      TOMB01=5
      TOMB02=5
      --GRAVE01=2
    }

    floors =
    {
      F_009=10
      F_012=25
      F_013=25
      F_031=5
      F_042=5
      F_043=5
      F_045=5
      F_077=10
      F_089=5
    }

    ceilings =
    {
      F_009=10
      F_012=25
      F_013=25
      F_031=5
      F_042=5
      F_043=5
      F_045=5
      F_077=10
      F_089=5
    }

    hallways  = { Dungeon_tomb1=50 }
    }

  Dungeon_tomb2 =
  {
    walls =
    {
      TOMB05=45
      TOMB06=5
  }

    floors =
  {
      F_046=5
      F_047=5
      F_059=70
      F_077=15
      F_089=5
    }

    ceilings =
    {        
      F_046=5
      F_047=5
      F_059=70
      F_077=15
      F_089=5
    }
    
    hallways  = { Dungeon_tomb2=50 }
  }

  Dungeon_tomb3 =
  {
    walls =
    {
      TOMB07=25
      TOMB11=10
      --GRAVE01=2
    }

    floors =
    {
      F_046=25
      F_047=15
      F_048=10
    }

    ceilings =
    { 
      F_046=25
      F_047=15
      F_048=10
    }
    
    hallways  = { Dungeon_tomb3=50 }
  }

  Dungeon_castle_gray =
  {  

    walls =
    {
      CASTLE07=35
      CAVE02=15
      PRTL03=5
    }

    floors =
    {
      F_009=10
      F_012=10
      F_013=10
      F_015=10
      F_022=10
      F_076=5
    }

    ceilings =
    {
      F_009=10
      F_012=10
      F_013=10
      F_015=10
      F_022=10
      F_076=5
    }

    hallways  = { Dungeon_castle_gray=50 }
  }

  Dungeon_castle_gray_small =
  {
    facades = 
  {
      CASTLE07=35
      CAVE02=15
      PRTL03=5
    }
    
    walls =
    {
      CASTLE01=20
      CAVE07=5
      -- Next, some novelty patterns that should be used rarely
      --CASTLE02=1
      --CASTLE03=1
      --CASTLE06=1
    }

    floors =
    {
      F_008=25
      F_009=10
      F_012=10
      F_013=10
      F_015=10
      F_022=10
      F_076=5
    }

    ceilings =
    {
      F_008=25
      F_009=10
      F_012=10
      F_013=10
      F_015=10
      F_022=10
      F_076=5
    }

    hallways  = { Dungeon_castle_gray_small=50 }
  }

  Dungeon_castle_gray_chains =
  { -- These patterns are pretyy much the same as castle01 (but with chains) -- should the be separate?  JB
        rarity="minor"

        facades =
        {
      CASTLE07=35
      CAVE02=10
      PRTL03=5
        }

    walls =
    {
      CASTLE02=1
      CASTLE03=1
      CASTLE06=1
    }

    floors =
    {
      F_008=25
      F_009=10
      F_012=10
      F_013=10
      F_015=10
      F_022=10
      F_076=5
    }

    ceilings =
    {
      F_008=25
      F_009=10
      F_012=10
      F_013=10
      F_015=10
      F_022=10
      F_076=5
    }
    
    hallways  = { Dungeon_castle_gray_small=50 }
  }

  Dungeon_castle_yellow =
  {    
    walls =
    {
      CASTLE11=25
      CAVE01=10
      WINN01=5
    }

    floors =
    {
      F_011=5
      F_014=35
      F_025=15
      F_028=10
      F_029=10
    }

    ceilings =
  {
      F_011=5
      F_014=35
      F_025=15
      F_028=10
      F_029=10
    }
    
    hallways  = { Dungeon_castle_yellow=50 }
  }

  Dungeon_library =
  {
    facades =
    {
      MONK01=10
      MONK02=10
      CASTLE11=10
        }

    rarity="episode"

    walls =
    { -- When/if prefab bookshelve are available, the walls should usuallty not be books, JB
      --MONK01=10
      --MONK02=10
      --CASTLE11=10
      --WOOD01=25
      --WOOD01=5
      BOOKS01=15
      BOOKS02=10
    }

    floors =
    {
      F_010=15
      F_024=15
      F_030=5
      F_054=15
      F_055=15
      F_089=5
      F_092=15
    }

    ceilings =
    {
      F_010=10
      F_024=10
      F_030=5
      F_054=20
      F_055=20
      F_089=5
      F_092=20
    }
    }

  Dungeon_sewer1 =
    {
    walls =
    {
      SEWER01=25
      SEWER05=5
      SEWER06=5
      SEWER02=1
  }

    floors =
  {
      F_017=10
      F_018=10
      F_021=12
      F_022=15
      F_023=3
    }

    ceilings =
    {
      F_017=10
      F_018=10
      F_021=10
      F_022=10
      F_023=10
    }
    
    hallways  = { Dungeon_sewer1=50 }
  }

  Dungeon_sewer2 =
  {
    walls =
    {
      SEWER07=15
      --SEWER08=15
      SEWER09=1
      SEWER10=1
      SEWER11=1
      SEWER12=1
    }

    floors =
    {
      F_017=10
      F_018=10
      F_021=12
      F_022=15
      F_023=3
    }

    ceilings =
    {
      F_017=10
      F_018=10
      F_021=10
      F_022=10
      F_023=10
    }
    
    hallways  = { Dungeon_sewer2=50 }
  }

  Dungeon_sewer_metal =
  {
    rarity="minor"

    walls =
    {
      STEEL01=25
      STEEL02=5
    }

    floors =
    {
      F_073=10 
      F_074=50
      F_075=25
      F_021=5
    }

    ceilings =
    {
      F_073=10 
      F_074=50
      F_075=25
      F_021=10 
      F_023=10
    }
    
    hallways  = { Dungeon_sewer1=40, Dungeon_sewer2=50 }
  }

  Dungeon_outdoors1 =
  {
    floors =
    {
      F_024=75
      F_034=50
      F_001=10
      F_002=10
      F_004=10
      F_005=10
      F_006=10
      F_007=10
      F_010=2
      F_011=4 
      F_025=3
      F_028=2
      F_029=2
      F_030=2
      F_031=2
      F_046=2
      F_047=2
      F_048=2
      F_057=1
      F_059=2
      F_077=2
      F_089=2
      F_012=2
      F_014=2
    }

    naturals =
    {
      WASTE02=50
      WASTE01=20
      CAVE05=40
    }
  }

  Dungeon_outdoors2 =
  {
    floors =
    {
      F_024=50
      F_034=75
      F_001=10
      F_002=10
      F_004=10
      F_005=10
      F_006=10
      F_007=10
      F_008=2
      F_009=2
      F_012=2
      F_013=2
      F_015=2
      F_017=2
      F_018=2
      F_021=1 
      F_022=2
      F_027=2
      F_030=2 
      F_031=1
      F_038=10
      F_042=1
      F_044=2 
      F_045=1
      F_057=2
      F_058=2
      F_059=2
      F_073=2
      F_076=2
    }

    naturals =
    { 
      WASTE02=30
      FOREST02=10 
    }
  }

  -- This is the element fire, as in "The Guardian or Fire" in Raven's original wad.
  Fire_room1 =
  {
    walls =
    {
      FIRE06=15
      FIRE07=15
      FIRE08=10
      FIRE09=10
      FIRE10=10
      FIRE11=10
      FIRE12=10
    }

    floors =
    {
      F_013=25
      F_032=5
      F_040=4
      F_044=1
      F_082=5
    }

    ceilings =
    {
      F_013=25
      F_032=5
      F_040=4
      F_044=1
      F_082=5
    }

    __corners =
    {
      FIRE01=30
      FIRE04=5
      FIRE05=10
      FIRE06=15 
      FIRE07=15
      FIRE08=10
      FIRE09=10
      FIRE10=10
      FIRE11=10
      FIRE12=10
      X_FIRE01=30
    }

        hallways  = { Fire_room1=50, Fire_room2=25 }
  }

  Fire_room2 =
  {
    walls =
    {
      FIRE01=30
      FIRE04=5
      FIRE05=10
    }

    floors =
    {
      F_032=25
      F_040=5
      F_082=5
    }

    ceilings =
    {
      F_032=25
      F_040=5
      F_082=5
    }

    naturals =
    {
      FIRE01=60
    }

        hallways  = { Fire_room1=15, Fire_room2=65 }
  }


  -- This is the element fire, as in "The Guardian or Fire" in Raven's original wad.
  Fire_lavawalls =
  { -- Fire could be split up, but these textures were pretty mixed up in the
    -- original wads, and it looks good as it is, JB
        rarity="zone"

    walls =
    {
      X_FIRE01=100
    }
    
    floors =
    {
      F_013=25
      F_032=25
      F_040=15
      F_044=5
      F_082=15
    }
    
    ceilings =
    {
      X_001=85
      F_013=25
      F_032=25
      F_040=15
      F_044=5
      F_082=15
    }

    __corners =
    {
      FIRE01=30
      FIRE04=5
      FIRE05=10
      FIRE06=15 
      FIRE07=15
      FIRE08=10
      FIRE09=10
      FIRE10=10
      FIRE11=10
      FIRE12=10
      X_FIRE01=30
    }
    
    hallways = { Fire_room1=50 }
  }

  Fire_outdoors =
  {
    floors =
    {
      F_013=5
      F_032=30
      F_040=25
      F_044=4
      F_082=20
    }

    naturals =
    {
      FIRE01=30
      FIRE04=5
      FIRE05=10
      FIRE06=15
      FIRE07=15
      FIRE08=10
      FIRE09=10
      FIRE10=10
      FIRE11=10
      FIRE12=10
    }
  }

  -- This is the "element" ice
  Ice_room1 =
  {
    walls =
    {
      ICE02=30
      ICE03=5
      ICE06=25
    }
    
    floors =
    {
      F_013=40
      F_040=30
    }

    ceilings =
    {
      F_013=40
      F_040=30
    }

    hallways  = { Ice_room1=50 }
  }

  Ice_room2 =
  { -- Not technically right, but works for what it does ;-) JB
    walls =
    {
      ICE01=15
      ICE02=30
      ICE03=5
      ICE06=25
    }

    floors =
    {
      F_013=20
      F_033=25
      F_040=15
    }

    ceilings =
    {
      F_013=40
      F_033=15
      F_040=30
    }

    hallways  = { Ice_room1=50, Ice_room2=50 }
  }

  Ice_cave =
  {
    naturals =
    {
      ICE01=75
      ICE06=25
    }
  }

  Ice_outdoors =
  {
    floors =
    {
      F_013=15
      F_033=75
      F_040=30
    }

    naturals =
    {
      ICE01=45
      ICE02=30
      ICE03=5
      ICE06=25
    }
  }


  -- This is the "element" steel, as in "The Guardian or Steel" in Raven's original wad.
  Steel_room_mix =
  { -- Not technically right, but works for what it does ;-) JB
        rarity="minor"

    walls =
    {
      STEEL01=40
      STEEL02=10
      STEEL05=1  -- This one should be rare, since also the door texture, JB
      STEEL06=15
      STEEL07=5
      STEEL08=5
    }

    floors =
    {
      F_065=10
      F_066=10
      F_067=10
      F_068=10
      F_069=15
      F_070=15
      F_074=40
      F_075=15
      F_078=10
    }

    ceilings =
    {
      F_065=10
      F_066=10
      F_067=10
      F_068=10
      F_069=15
      F_070=15
      F_074=40
      F_075=15
      F_078=10
  }

    naturals =
    {
      STEEL01=40
      STEEL02=10
      STEEL05=10
      STEEL06=15
      STEEL07=5
      STEEL08=5
    }

    __corners =
    {
      STEEL01=40
      STEEL02=10
      STEEL05=10
      STEEL06=15
      STEEL07=5
      STEEL08=5
    }
    }
    
  Steel_room_gray =
  {
    walls =
  {
      STEEL06=35
      STEEL07=15
      STEEL08=5
    }

    floors =
    {
      F_065=10
      F_066=10
      F_067=10
      F_068=10
      F_069=15
      F_070=15
      F_078=10
    }

    ceilings =
    {
      F_065=10
      F_066=10
      F_067=10
      F_068=10
      F_069=15
      F_070=15
      F_078=10
    }

    naturals =
    {
      STEEL06=35
      STEEL07=15
      STEEL08=5
    }
  }

  Steel_room_rust =
  {
    walls =
    {
      STEEL01=40
      STEEL02=10
    }

    floors =
    {
      F_074=40
      F_075=15
    }

    ceilings =
    {
      F_074=40
      F_075=15
    }

    naturals =
    {
      STEEL01=40
      STEEL02=10
    }
    }

  -- This is the barren, deserty wildness, based on "The Wasteland" in Raven's original wad.
  Desert_room_stone =
  {
        facades =
    {
      FOREST01=10
      MONK16=25
    }

    walls =
    {
      WASTE04=10
      FOREST01=10
      MONK16=25
    }
    
    floors =
    {
      F_002=10
      F_003=10
      F_004=5
      F_037=20
      F_029=20
      F_044=15
      F_082=10
  }

    ceilings =
  {
      F_037=20
      F_029=20
      F_044=15
      F_082=10
      D_END3=27
      D_END4=3
    }
  }

  Desert_outdoors =
  {
    floors =
    {
      F_002=25
      F_003=25
      F_004=10
      F_005=5
      F_037=20
    }

    naturals =
    {
      WASTE01=35
      WASTE02=15
      WASTE04=10
      WASTE03=5
    }
  }

  -- This is the cave type wildness; also, many caves used elsewhere;
  -- most caves have floor, ceiling, and walls so that they can double
  -- in other cave-ish roles. JB
  Cave_room =
  { -- These are built rooms for the cave level (the rest are naturals of some kind)
    walls =
    {
      CAVE01=30
      CAVE02=30
      CAVE07=25
    }

    floors =
    {
      F_039=75
      F_040=40
      F_073=10
      F_076=15
    }

    ceilings =
    {
      F_039=75
      F_040=40
      F_073=10
      F_076=15
  }

    __corners =
    { 
      PILLAR01=20
      WOOD01=15
      WOOD03=15
      D_END3=50
      D_END4=5
    }

    hallways  = { Cave_gray=50, Cave_room=50 }
  }

  Cave_gray =
  {
    facades =
    { 
      CAVE03=10
    }
    
    walls =
    { 
      CAVE03=10
      CAVE04=55
      WASTE02=15
    }

    floors =
    {
      F_039=75
      F_040=40
    }

    ceilings =
    {
      F_039=75
      F_040=40
    }

    naturals =
    { 
      CAVE03=10
      CAVE04=55
      WASTE02=15
    }
    
    hallways  = { Cave_gray=50 }
  }

  Cave_stalag =
  {
        facades =
        {
      CAVE03=10
        }

    walls =
    {
      CAVE06=60
    }

    floors =
    {
      F_039=75
      F_040=40
    }

    ceilings =
    {
      F_039=75
      F_040=40
    }

    naturals =
    {
      CAVE06=60
    }

        hallways  = { Cave_gray=50, Cave_stalag=50 }
  }

  Cave_brown =
  {
    walls =
    {        
      CAVE05=60
  }

    floors =
    {
      F_001=75
      F_002=40
    }

    ceilings =
    {        
      F_001=75
      F_002=40
  }

    naturals =
    { 
      CAVE03=20
      CAVE05=60
    }

    hallways  = { Cave_brown=50 }
  }

  Cave_green =
  {
    walls =
    {
      FOREST02=25
    }

    floors =
    {
      F_001=15
      F_002=10
      F_038=75
    }

    ceilings =
    {
      F_001=15
      F_002=10
      F_038=75
    }

    naturals =
    {
      FOREST02=25
    }
    
    hallways  = { Cave_green=50 }
  }

  Cave_swamp =
  {
    walls =
    {
      SWAMP01=20
      SWAMP03=20  
    }

    floors =
    {
      F_019=75
      F_020=40
      F_039=25
      F_040=20
  }

    ceilings =
  {
      F_019=75
      F_020=40
      F_039=25
      F_040=20
    }

    naturals =
    {
      SWAMP01=20
      SWAMP03=20  
    }
    
    hallways  = { Cave_swamp=50 }
  }

  Cave_desert_tan =
  {
    walls =
    {
      WASTE01=35
    }

    floors =
    {
      F_003=75
      F_002=40
      F_004=10
      F_037=25
    }

    ceilings =
    {
      F_003=75
      F_002=40
  }

    naturals =
    {
      WASTE01=35
      WASTE04=10
    }

    hallways  = { Cave_desert_tan=50 }
  }

  Cave_desert_gray =
  {
    walls =
    {
      WASTE02=30
    }

    floors =
    {
      F_039=75
      F_040=40
    }

    ceilings =
    {
      F_039=75
      F_040=40
    }

    naturals =
    {
      WASTE02=30
      WASTE03=5
    }
    
    hallways  = { Cave_desert_gray=50 }
  }

  Cave_outdoors =
  {
    floors =
  {
      F_007=10
      F_039=75
      F_040=40
      F_073=10
      F_076=10
    }

    naturals =
    {
      CAVE03=70
    }
  }


  -- This is the swamp-type wilderness
  Swamp1_castle =
  {
    walls =
  {
      SWAMP01=30
      SWAMP03=30
      SWAMP04=30
      -- This should probably be a separate theme, but seems to work best this way, JB
      FOREST07=10
    }

    floors =
    {
      F_017=10
      F_018=10
      F_019=20
      F_020=15
      F_054=5
      F_055=5
      F_092=5
    }

    ceilings =
    {
      F_017=10
      F_018=10
      F_019=20
      F_020=15
      F_054=5
      F_055=5
      F_092=5
    }
    
    hallways  = { Swamp1_castle=50 }
  }

  Swamp1_hut =
  {
    walls =
    {
      VILL01=5
      VILL04=25
      VILL05=25
      WOOD01=5
      WOOD02=5
      WOOD03=15
    }

    floors =
    {
      F_054=10
      F_055=10
      F_092=10
    }

    ceilings =
    {
      F_054=10
      F_055=10
      F_092=10
    }
    
    hallways  = { Swamp1_hut=50 }
  }

  Swamp1_outdoors =
  {
    floors =
    {
      F_017=5
      F_018=5
      F_019=10
      F_020=10
      F_054=1
      F_055=1
      F_092=1
      F_005=10
      F_006=10
      F_007=5
  }

    naturals =
    {
      SWAMP01=20
      SWAMP03=20
      SWAMP04=20
      FOREST07=10
      CAVE03=10
      CAVE04=10
      CAVE05=10
      CAVE06=10
      WASTE02=5
    }
  }


  -- This is the woodland wilderness found in The Shadow Wood and Winnowing Hall;
  Forest_room1 =
  {
    walls =
    {
      FOREST01=40
    }

    floors =
    {
      F_010=25
      F_011=25
      F_030=15
      F_077=10
      F_089=25
    }

    ceilings =
    {
      F_010=25
      F_011=25
      F_030=15
      F_089=10
    }

    __corners =
    {
      FOREST10=20
      WOOD01=15
      WOOD03=3
    }
    
    hallways  = { Forest_room1=50 }
  }

  Forest_room2 =
  {
    facades = 
    {
      FOREST01=40
      FOREST02=10    
  }

    walls =
  {
      FOREST02=40
      FOREST03=10
      FOREST04=10
    }

    floors =
    {
      F_038=25
      F_048=25
      F_089=25
    }

    ceilings =
    {
      F_038=25
    }

    __corners =
    {
      FOREST10=20
      WOOD01=15
      WOOD03=3
    }
    
    hallways  = { Forest_room2=50 }
  }

  Forest_room3 =
  {
    facades = 
  {
      FOREST01=10
      WINN01=40    
    }
    
    walls =
    {
      FOREST10=40
      WINN01=10
    }

    floors =
    {
      F_073=25
      F_077=20
      F_089=25
    }

    ceilings =
    {
      F_073=25
    }

    __corners =
    {
      FOREST10=20
      WOOD01=15
      WOOD03=3
  }
    
    hallways  = { Forest_room3=50 }
}

  Forest_outdoors =
  {
    floors =
    {
      F_005=15
      F_006=25
      F_007=60
    }

    naturals =
    {
      FOREST01=25
      FOREST02=25
      FOREST07=35
      CAVE05=40
      CAVE03=50
    }
  }

  Village_room =
  {
    walls =
    {
      WOOD01=5
      VILL04=10
      VILL05=10
    }

    floors =
    {
      F_002=10
      F_003=10
      F_004=5
      F_037=10
      F_028=20
      F_029=20
      F_054=20
      F_055=20
    }

    ceilings =
    {
      F_037=10
      F_028=20
      F_029=20
      F_054=20
      F_055=20
    }
  }

  Village_brick =
  {
    walls =
    {
      VILL01=5
    }

    floors =
    {
      F_002=10
      F_003=10
      F_004=5
      F_030=30
      F_028=10
      F_029=10
      F_054=10
      F_055=10
    }

    ceilings =
    {
      F_030=30
      F_028=20
      F_029=20
      F_054=20
      F_055=20
    }
  }
}  


HEXEN.LEVEL_THEMES =
{
  hexen_dungeon1 =
  {
    prob = 50

    buildings = { Dungeon_monktan=40, Dungeon_monktan_large=20,
                  Dungeon_monkgray=30, Dungeon_monkrosette=15,
                }
    caves     = { Cave_gray=50 }
    outdoors  = { Dungeon_outdoors1=50 }
    hallways  = { Dungeon_monktan=40, Dungeon_monktan_large=20,
                  Dungeon_monkgray=30, Dungeon_monkrosette=15 }

    pictures =
    {
      Pic_GlassSmall=65
	  Pic_GlassBig=10
	  Pic_BooksSmall=10
	  Pic_BooksBig=10
	  Pic_Planets=5
	  Pic_Saint=10
	  Pic_Dogs=15
	  Pic_Dragon=15 
      Pic_DemonFace2=10
      Pic_DemonFace=10
    }

    -- FIXME: other stuff

    style_list =
    {
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }

    monster_prefs =
    {
      bishop=3.0, centaur1=2.0, centaur2=1.5
    }

  }


  -- Castle type dungeon
  hexen_dungeon2 =
  {
    prob = 50

    liquids = { water=25, muck=70, icefloor=5 }
  
    buildings = { Dungeon_castle_gray=30,  Dungeon_castle_gray_small= 15,
                  Dungeon_castle_gray_chains=5, Dungeon_castle_yellow=15,
                }
    caves     = { Cave_gray=30, Cave_swamp=5, Cave_green=15 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_castle_gray=30,  Dungeon_castle_gray_small= 15,
                  Dungeon_castle_yellow=15 }

    facades =
    {
      CASTLE07=50, CASTLE11=10, CAVE01=10, 
      CAVE02=15, PRTL03=10
    }
	
    pictures =
    {
      Pic_GlassSmall=5
	  Pic_BooksSmall=5
	  Pic_BooksBig=5
	  Pic_Saint=10
	  Pic_Dogs=15
	  Pic_Dragon=15 
      Pic_DemonFace2=15
      Pic_SwordGuy=25
    }

    -- FIXME: other stuff

    monster_prefs =
    {
      centaur1=2.0, centaur2=3.0, demon1=3.0
    }

    style_list =
    {
      caves = { none=30, few=70, some=20,  heaps=0 }
      outdoors = { none=50, few=50, some=20,  heaps=0 }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  }
  

  -- Tombs / necropolis
  hexen_dungeon3 =
  {
    prob = 30

    liquids = { water=25, muck=25, icefloor=25, lava=25 }
  
    buildings = { Dungeon_tomb1=10, Dungeon_tomb2=10, Dungeon_tomb3=10 }
    caves     = { Cave_gray=50, Cave_swamp=10, Cave_green=5 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_tomb1=10, Dungeon_tomb2=10, Dungeon_tomb3=10 }
  
    	
    pictures =
    {
      Pic_GlassSmall=25
      Pic_GlassBig=50
	  Pic_Saint=25
	  Pic_Dogs=15
      Pic_DemonFace2=25
      Pic_DemonCross=5
      Pic_Grave=60
	  
    }

    -- FIXME: other stuff

    monster_prefs =
    {
      bishop=3.0, centaur2=3.0, reiver=2.5
    }

    style_list =
    {
      caves = { none=30, few=70, some=20,  heaps=0 }
      outdoors = { none=50, few=50, some=20,  heaps=0 }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  }

  -- Sewers / effluvium
  hexen_dungeon4 =
  {
    prob = 20

    liquids = { muck=70 }
  
    buildings = { Dungeon_sewer1=30, Dungeon_sewer2=20, 
                  Dungeon_sewer_metal=5 }
    caves     = { Cave_gray=25, Cave_swamp=25 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_sewer1=30, Dungeon_sewer2=20 }
	
    pictures =
    {
      Pic_DemonFace2=90
      Pic_DemonCross=5
      Pic_DemonFace3=5
    }

    facades =
    {
      CASTLE07=50, CASTLE11=10, CAVE01=10,
      CAVE02=15, PRTL03=10
    }
  
    monster_prefs =
    {
      -- need high values just to make them appear
      serpent1=5000, serpent2=3000
    }

    style_list =
    {
      liquids  = { none=0,  few=0,  some=0,   heaps=100 }
      caves    = { none=30, few=70, some=20,  heaps=0   }
      outdoors = { none=50, few=50, some=20,  heaps=0 }
    }
  }

  hexen_dungeon5 =
  {
    prob = 20

    buildings = { Dungeon_portals1=45, Dungeon_portals2=15 }
    caves     = { Cave_gray=50 }
    outdoors  = { Dungeon_outdoors1=50 }
    hallways  = { Dungeon_portals1=45, Dungeon_portals2=15 }
	
    pictures =
    {
      Pic_DemonFace2=20
      Pic_DemonCross=5
      Pic_DemonFace3=5
      Pic_Dogs=10
      Pic_Saint=10
    }

    -- FIXME: other stuff

    monster_prefs =
    {
      ettin=3.0, demon1=2.0, centaur1=1.5, iceguy=3.0
    }
  }

  -- Hypostyle
  hexen_dungeon6 =
  {
    prob = 10

    liquids = { lava=95, icefloor=5 }

    buildings = { Dungeon_castle_gray=5,  Fire_room1=5,
                  Forest_room3=45, Dungeon_tomb3=5 }
    caves     = { Cave_gray=55, Cave_stalag=25, Fire_room1=10 }
    outdoors  = { Dungeon_outdoors2=50 }
    hallways  = { Dungeon_castle_gray=5,  Fire_room1=5,
                  Forest_room3=45, Dungeon_tomb3=5 }
	
    pictures =
    {
      Pic_GlassSmall=5
	  Pic_BooksSmall=5
	  Pic_BooksBig=5
	  Pic_Saint=10
	  Pic_Dogs=15
	  Pic_Dragon=15 
      Pic_DemonFace2=25
      Pic_SwordGuy=5
    }

    facades =
    {
      CASTLE07=50, CASTLE11=10, CAVE01=10,
      CAVE02=15, PRTL03=10
    }

    -- FIXME: other stuff

    monster_prefs =
    {
      afrit=2.0, centaur1=3.0, demon1=3.0, afrit=3.0
    }

    style_list =
    {
      caves = { none=20, few=70, some=30,  heaps=0 }
      outdoors = { none=100, few=0, some=0,  heaps=0 }
    }
  }
  

  hexen_element1 =
  {
    prob = 20

    liquids = { lava=100 }

    buildings = { Fire_room1=65,  Fire_room2=35,  Fire_lavawalls=5}
    caves     = { Fire_room2=50 }
    outdoors  = { Fire_outdoors=50 }
    hallways  = { Fire_room1=50, Fire_room2=40 }
	
    pictures =
    {
	  Pic_DemonFace3=65
      Pic_DemonCross=40
	  Pic_Saint=5
	  Pic_Dogs=5
      Pic_DemonFace2=5
    }

    __big_pillars = { pillar02=10, fire06=25, xfire=15 }

    __outer_fences = 
    {
      FIRE01=30, FIRE04=5, FIRE05=10, FIRE06=15, 
      FIRE07=15, FIRE08=10, FIRE09=10, FIRE10=10, 
      FIRE11=10, FIRE12=10
    }

    monster_prefs =
    {
      afrit=3.5
    }

    style_list =
    {
      caves = { none=30, few=70,  some=30,  heaps=0  }
      outdoors = { none=70, few=5,   some=0,   heaps=0  }
      liquids  = { none=0,  few=10,  some=60,  heaps=40 }
      lakes    = { none=0,  few=10,  some=60,  heaps=40 }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  }
  

  hexen_element2 =
  {
    prob = 20

    liquids = { icefloor=100 } -- ice1 will use "liquids = { ice=70, water=30 }" instead, for variety.
  
    buildings = { Ice_room1=65, Ice_room2=35 }
    caves     = { Ice_cave=50 }
    outdoors  = { Ice_outdoors=50 }
    hallways  = { Ice_room1=65, Ice_room2=35 }
	
    pictures =
    {
	  Pic_DemonFace2=65
	  Pic_DemonFace3=5
	  Pic_Dogs=5
      Pic_Saint=25
    }

    __big_pillars = { ice01=5, ice02=20 }

    __outer_fences = 
    {
      ICE01=25, ICE06=75
    }

    style_list =
    {
      caves = { none=30, few=70,  some=30,  heaps=0  }
      outdoors = { none=70, few=5,   some=0,   heaps=0  }
      liquids  = { none=0,  few=10,  some=60,  heaps=40 }
      lakes    = { none=0,  few=0,   some=40,  heaps=60 }
      pictures = { none=50, few=10,  some=10,  heaps=0  }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  
    monster_prefs =
    {
      iceguy =500, afrit=0.2
    }
  }
  
    
  hexen_element3 =
  {
    prob = 20

    square_caves = true

    liquids = { lava=20, icefloor=10, water=5, muck=5 }

    buildings = { Steel_room_mix=10, Steel_room_gray=35, Steel_room_rust=25 }
    caves     = { Steel_room_mix=25, Steel_room_gray=25, Steel_room_rust=25 }
    outdoors  = { Steel_room_mix=25, Steel_room_gray=25, Steel_room_rust=25 }
    hallways  = { Steel_room_mix=10, Steel_room_gray=35, Steel_room_rust=25 }
	
    pictures =
    {
	  Pic_Dragon=5
      Pic_DemonCross=45
    }

    __big_pillars = { steel01=10, steel02=10, steel06=10, steel07=10 }

    __outer_fences = 
    {
      STEEL01=40, STEEL02=10, STEEL05=10, 
      STEEL06=15, STEEL07=5, STEEL08=5
    }

    style_list =
    {
      caves = { none=70, few=30,  some=5,  heaps=0 }
      outdoors = { none=70, few=5,   some=0,  heaps=0 }
      liquids  = { none=40, few=60,  some=10, heaps=0 }
      lakes    = { none=60, few=40,  some=0,  heaps=0 } -- I don't think this is need, but to be safe...
      pictures = { none=50, few=0,   some=0,  heaps=0 }
    }
  }
  
    
  hexen_wild1 =
  {
    prob = 30

    liquids = { water=30, muck=40, lava=20 }

    buildings = { Desert_room_stone=25, Cave_desert_tan=20,
                  Cave_desert_gray=15, Village_room=25 }
    caves     = { Cave_desert_tan=60, Cave_desert_gray=40,  
                  Cave_brown=25 }
    outdoors  = { Desert_outdoors=50 }
    hallways  = { Cave_desert_tan=55, Cave_desert_gray=40 }
	
    pictures =
    {
	  Pic_DemonFace=4
	  Pic_BooksSmall=1
      Pic_DemonFace2=10
	  Pic_Dogs=5
	  Pic_Saint=5
    }

    __pictures =
    {
      pic_forest11=5, pic_books01=1, pic_tomb06=15, 
      pic_monk06=2, pic_monk11=2, pic_spawn13=2
    }

    __big_pillars = { pillar01=5, monk14=25 }

    __outer_fences = 
    {
      WASTE01=35, WASTE02=15
    }

    style_list =
    {
      outdoors = { none=0,  few=0,  some=80,  heaps=20 }
      liquids  = { none=30, few=70, some=5,   heaps=0  }
      lakes    = { none=10, few=70, some=10,  heaps=0  }
  --  I have an idea for a natural-net dividing a large natural into small ones connected by tunnels, 
  --  but this doesn't exist and I can't create it now, so...
  --   This is the wrong type of hallway, but best I can do now.
  --  hallways = { none=0,  few=10, some=30, heaps=90 }    
    }
  }
  
  
  hexen_wild2 =
  {
    prob = 30

    liquids = { water=60, muck=10, lava=25 }

    --Not sure I like mixing the gray and brown cave themes too much, JB
    buildings = { Cave_room=50, Cave_gray=15, Cave_brown=5 }
    caves     = { Cave_gray=20, Cave_stalag=30, Cave_brown=10 }
    outdoors  = { Cave_outdoors=50 }
    hallways  = { Cave_gray=30, Cave_stalag=20, Cave_brown=10 }
	
    pictures =
    {
	  Pic_DemonFace=4
	  Pic_DemonCross=1
      Pic_DemonFace2=10
	  Pic_DemonFace3=5
	  Pic_Dogs=5
	  Pic_Saint=5
    }

    __big_pillars =
    { 
      monk14=10, castle07=5, prtl02=5, fire06=10
    }

    __outer_fences = { CAVE03=20, CAVE04=40, CAVE05=15, WASTE02=25 }

    style_list =
    {
      caves      = { none=0,  few=0,  some=0,  heaps=70 }      
      odd_shapes = { none=0,  few=0,  some=30, heaps=70 }
      outdoors = { none=30, few=70, some=5,  heaps=0  }
      crates   = { none=60, few=40, some=0,  heaps=0  }
    }
  
    monster_prefs =
    {
      demon1=3.0, demon2=3.0
    }

    door_probs   = { out_diff=10, combo_diff= 3, normal=1 }
    window_probs = { out_diff=30, combo_diff=30, normal=5 }
  }

  
  hexen_wild3 =
  {
    prob = 30

    liquids = { muck=100 }  -- for whole mulit-level swamp1 theme this will be "liquids = { muck=80, water 20 }"
  
    buildings = { Swamp1_castle=20, Dungeon_castle_gray=20, Swamp1_hut=60 }
    caves     = { Cave_swamp=20, Cave_gray=30 }
    outdoors  = { Swamp1_outdoors=50 }
    hallways  = { Swamp1_castle=20, Dungeon_castle_gray=20, Swamp1_hut=60 }
	
    pictures =
    {
	  Pic_DemonFace=2
	  Pic_BooksSmall=1
      Pic_DemonFace2=25
      Pic_DemonFace3=7
	  Pic_Dogs=5
	  Pic_Saint=5
    }

    __big_pillars =
    { 
      swamp01=20, swamp02=20, vill01=5, wood03=15
    }

    __outer_fences = 
    {
      SWAMP01=20, SWAMP03=20, SWAMP04=20, FOREST07=10,            
      CAVE03=10, CAVE04=10, CAVE05=10, CAVE06=10, 
      WASTE02=5
    }

    style_list =
    {
      caves = { none=0, few=5, some=80, heaps=10  }
      outdoors = { none=0, few=5, some=80, heaps=10  }
  --   I had considered including flat x_09 (muck) as a floor texture, and not using
  --  liquids, but realized this would likely produce diases of muck, ect.  We need 
  --  officially transversable liquids for this theme to really work.  
      liquids  = { none=0, few=0, some=0,  heaps=100 }
      lakes    = { none=0, few=0, some=0,  heaps=100 }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  
    monster_prefs =
    {
      -- need high values just to make them appear
      serpent1=5000, serpent2=3000
    }
  }

  
  hexen_wild4 =
  {
    prob = 30

    liquids = { water=60, muck=15, lava=10 }
  
    buildings = { Forest_room1=30, Forest_room2=20, Forest_room3=30 }
    caves     = { Cave_gray=30, Cave_green=25, Cave_brown=40 }
    outdoors  = { Forest_outdoors=50 }
    hallways  = { Forest_room3=30, Forest_room2=20, Forest_room3=30 }
	
    pictures =
    {
	  Pic_DemonFace=4
	  Pic_BooksSmall=1
      Pic_DemonFace2=10
	  Pic_GlassSmall=5
	  Pic_Dogs=5
	  Pic_Saint=5
    }

    __big_pillars =
    { 
      vill01=5, wood01=15, wood02=5, forest01=25,
      pillar01=10, pillar02=5, prtl02=20, monk15=10,
      castle07=5
    }
  
    style_list =
    {
      caves      = { none=0, few=5,  some=50, heaps=10 }
      outdoors   = { none=0, few=5,  some=50, heaps=10 }
      subrooms   = { none=0, few=15, some=50, heaps=50 }
      islands    = { none=0, few=15, some=50, heaps=50 }
    }
  
    monster_prefs =
    {
      afrit=3.0, etin=2.5, bishop=1.5
    }
  }
    
  
  hexen_cave1 =
  {
    prob = 20

    liquids = { water=60, muck=10, lava=25 }

    --Not sure I like mixing the gray and brown cave themes too much, JB
    buildings = { Cave_room=50, Cave_gray=15, Cave_brown=5 }
    caves     = { Cave_gray=20, Cave_stalag=30, Cave_brown=10 }
    outdoors  = { Cave_outdoors=50 }
    hallways  = { Cave_gray=30, Cave_stalag=20, Cave_brown=10 }
	
    pictures =
    {
	  Pic_DemonFace=4
	  Pic_DemonCross=1
      Pic_DemonFace2=10
	  Pic_DemonFace3=5
	  Pic_Dogs=5
	  Pic_Saint=5
    }

    __big_pillars =
    { 
      monk14=10, castle07=5, prtl02=5, fire06=10
    }

    __outer_fences = { CAVE03=20, CAVE04=40, CAVE05=15, WASTE02=25 }

    style_list =
    {
      caves      = { none=0,  few=0,  some=0,  heaps=70 }      
      odd_shapes = { none=0,  few=0,  some=30, heaps=70 }
      outdoors = { none=30, few=70, some=5,  heaps=0  }
      crates   = { none=60, few=40, some=0,  heaps=0  }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  
    monster_prefs =
    {
      demon1=3.0, demon2=3.0
    }

    door_probs   = { out_diff=10, combo_diff= 3, normal=1 }
    window_probs = { out_diff=30, combo_diff=30, normal=5 }
  }
  

  hexen_ice1 =
  {
    prob = 20

    liquids = { icefloor=70, water=30 }
  
    buildings = { Ice_room1=65, Ice_room2=35 }
    caves     = { Ice_cave=50 }
    outdoors  = { Ice_outdoors=50 }
    hallways  = { Ice_room1=65, Ice_room2=35 }
	
    pictures =
    {
	  Pic_Dragon=5
      Pic_DemonCross=15
    }

    __big_pillars = { ice01=5, ice02=20 }

    __outer_fences = 
    {
      ICE01=25, ICE06=75
    }

    style_list =
    {
      caves = { none=30, few=70,  some=30,  heaps=0  }
      outdoors = { none=70, few=5,   some=0,   heaps=0  }
      liquids  = { none=0,  few=10,  some=60,  heaps=40 }
      lakes    = { none=0,  few=0,   some=40,  heaps=60 }
      pictures = { none=50, few=10,  some=10,  heaps=0  }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  
    monster_prefs =
    {
      iceguy=500, afrit=0.2
    }
  }

  
  hexen_swamp1 =
  {
    prob = 20

    liquids = { muck=80, water=20 }
  
    buildings = { Swamp1_castle=20, Dungeon_castle_gray=20, Swamp1_hut=60  }
    caves     = { Cave_swamp=20, Cave_gray=30 }
    outdoors  = { Swamp1_outdoors=50 }
    hallways  = { Swamp1_castle=20, Dungeon_castle_gray=20, Swamp1_hut=60  }
	
    pictures =
    {
	  Pic_DemonFace=2
	  Pic_BooksSmall=1
      Pic_DemonFace2=25
      Pic_DemonFace3=7
	  Pic_Dogs=5
	  Pic_Saint=5
    }

    __big_pillars = { swamp01=20, swamp02=20, vill01=5, wood03=15 }

    __outer_fences = 
    {
      SWAMP01=20, SWAMP03=20, SWAMP04=20, FOREST07=10,            
      CAVE03=10, CAVE04=10, CAVE05=10, CAVE06=10, 
      WASTE02=5
    }

    style_list =
    {
      caves = { none=0, few=5, some=80, heaps=10  }
      outdoors = { none=0, few=5, some=80, heaps=10  }
  --   I had considered including flat x_09 (muck) as a floor texture, and not using
  --  liquids, but realized this would likely produce diases of muck, ect.  We need 
  --  officially transversable liquids for this theme to really work.  
      liquids  = { none=0, few=0, some=0,  heaps=100 }
      lakes    = { none=0, few=0, some=0,  heaps=100 }
      mon_variety = { none=1, few=65, some=30, heaps=4 }               
    }
  
    monster_prefs =
    {
      -- need high values just to make them appear
      serpent1=5000, serpent2=3000
    }
  }

  hexen_village1 =
  {
    prob = 30

    liquids = { water=60, muck=15, lava=10 }
  
    buildings = { Forest_room1=30, Forest_room2=20, Forest_room3=30,
                  Desert_room_stone=25, Village_room=45, Village_brick=25,
                  Dungeon_castle_gray=15 }
    caves     = { Cave_gray=30, Cave_green=25, Cave_brown=40 }
    outdoors  = { Forest_outdoors=50 }
    hallways  = { Forest_room3=30, Forest_room2=20, Forest_room3=30,
                  Desert_room_stone=25, Village_room=45,
                  Dungeon_castle_gray=15 }
	
    pictures =
    {
	  Pic_DemonFace=5
	  Pic_BooksSmall=10
	  Pic_BooksBig=10
      Pic_DemonFace2=10
      Pic_GlassSmall=15
	  Pic_GlassBig=10
	  Pic_Dogs=5
	  Pic_Saint=5
	  Pic_Dragon=5 
      Pic_SwordGuy=5
    }

    __big_pillars =
    {
      vill01=5, wood01=15, wood02=5, forest01=25,
      pillar01=10, pillar02=5, prtl02=20, monk15=10,
      castle07=5
    }

    style_list =
    {
      caves      = { none=0, few=5,  some=50, heaps=10 }
      outdoors   = { none=0, few=5,  some=50, heaps=10 }
      subrooms   = { none=0, few=15, some=50, heaps=50 }
      islands    = { none=0, few=15, some=50, heaps=50 }
    }

    monster_prefs =
    {
      afrit=3.0, etin=2.5, bishop=1.5
    }
  }
}


------------------------------------------------------------------------

HEXEN.ROOMS =
{
  GENERIC =
  {
    environment = "any"
  }
}


------------------------------------------------------------------------

HEXEN.NAMES =
{
  -- these tables provide *additional* words to those in naming.lua

  GOTHIC =
  {
    lexicon =
    {
      a =
      {
        Wooded=30
        Silent=20
        Mysterious=10
        Deathly=10
        Dark=20
        Bright=10
        Luminous=10
        Twilight=10
        Ruined=10
        Abandoned=20
        Guarded=15
        Lost=15
        Secret=10
        Barbarain=5
        Monstrous=15
        Dead=10
        Faerie=10
        Enchanted=5
        Inhuman=5
      }

      n =
      {
        Wood=30
        Woods=20
        Forest=10
        Woodland=10
        Seminary=20
        Monestary=10
        Mountain=10
        Catacombs=20
        Keep=15
        Castle=20
        Fortress=15
        Fort=10
        Barbican=5
        Tower=10
        Outpost=15
        Manor=15
        Dungeon=15
        Necropolis=10
        Cavern=20
        Cave=10
        Tomb=25
        Crypt=15
        Barrow=15
        Mound=5
        ["Burial Mound"]=5
        Mere=10
        Mire=15
        Bog=10
        Swamp=10
        Marsh=15
        Desert=5
        Waste=15
        Wasteland=15
        Badlands=10
        Village=20
        Hamlet=15
        City=15
        Settlement=10
        Township=10
        Colony=5
        Town=5
        Encampment=5
        Citadel=10
        Plaza=5
        Square=5
        Kingdom=15
        Stronghold=5
        Palace=20
        Courtyard=10
        Court=10
        Halls=10
        Hollow=20
        Valley=15
        Plateau=10
        Mesa=5
        Sewer=5
        Effluvium=5
        Plane=10
        Dimension=15
        Realm=10
        Portal=10
        Portals=5
      }

      m =
      {
        -- Duplicated in 'h' since it doesn't seem to do anything yet
        -- Comon Hexen monster
        Ettins=20
        Afriti=20
        Wendigos=5
        ["Chaos Serpents"]=20
        Centaurs=20
        Slaughtars=10
        ["Dark Bishops"]=20
        Reivers=10
        -- Other creatures that work
        Demons=10
        Dragons=5
        Fairies=15
        Elves=5
        Trolls=10
        Nymphs=5
        Satyrs=5
        Ghosts=15
        Shadows=30
        Spirits=25
        ["Evil Spirits"]=10
        Beasts=20
        Animals=5
        Serpents=10
        Humans=2
        ["the People"]=3
        ["the Legion"]=8
        Legionaires=6
        Legions=6
        Magi=20
        Priests=6
        ["the Priesthood"]=10
        Clergy=4
        Barbarians=10
        ["the Wildmen"]=10
        ["the Untaimed"]=10
        Corpses=10
      }

      h =
      {
        Sorcery=25
        Magic=10
        Mystery=10
        Mysteries=15
        Theurgy=10
        Thaumaturgy=10
        Diablerie=10
        Necromancy=10
        Conjuring=5
        Illusion=10
        Alchemy=5
        Dreams=5
        Dreaming=5
        Nightmares=10
        Darkness=10
        Enchantment=10
        -- Comon Hexen monster
        ["the Ettins"]=20
        ["the Afriti"]=20
        ["the Wendigo"]=5
        ["Chaos Serpents"]=20
        ["the Centaurs"]=20
        ["the Slaughtars"]=10
        ["Dark Bishops"]=20
        ["the Reiver"]=5
        Wraiths=10
        ["the Stalkers"]=5
        -- Other creatures that work
        Demons=15
        Dragons=5
        Fairies=15
        ["the Elves"]=5
        Trolls=10
        ["the Nymphs"]=5
        ["the Satyrs"]=5
        Ghosts=15
        Shadows=30
        Spirits=25
        ["Evil Spirits"]=10
        Beasts=20
        ["the Animals"]=5
        Serpents=10
        ["the Humans"]=2
        ["the People"]=3
        ["the Legion"]=8
        Legionaires=6
        Legions=6
        ["the Magi"]=20
        Priests=6
        ["the Priesthood"]=10
        ["the Clergy"]=4
        Barbarians=10
        ["the Wildmen"]=10
        ["the Untaimed"]=10
        Corpses=10
      }

      e =
      {
        Korax=100
        ["D'Sparil"]=25
        Eidolon=10
        ["the Heresiarch"]=75
        Zedek=30
        Menalkir=30
        Traductus=30
        Circe=5
        Hades=5
        Persephone=5
        Hecate=5
        Medea=1
        Loki=5
        Hel=3
        ["Frau Hoelle"]=2
        ["Black Annis"]=5
        Cerridwen=4
        Morgaina=5
        Anubis=3
        Set=2
      }
    }
  }
}


--------------------------------------------------

UNFINISHED["x_dungeon"] =
{
  label = "Dungeon"
  name_theme = "GOTHIC"
  mixed_prob = 50
}

UNFINISHED["x_element"] =
{
  label = "Elemental"
  name_theme = "GOTHIC"
  mixed_prob = 50
}

UNFINISHED["x_wild"] =
{
  label = "Wilderness"
  name_theme = "GOTHIC"
  mixed_prob = 50
}

UNFINISHED["x_cave"] =
{
  label = "Cave"
  name_theme = "GOTHIC"
  mixed_prob = 20
}

UNFINISHED["x_ice"] =
{
  label = "Ice"
  name_theme = "GOTHIC"
  mixed_prob = 10
}

UNFINISHED["x_swamp"] =
{
  label = "Swamp"
  name_theme = "GOTHIC"
  mixed_prob = 20
}

UNFINISHED["x_village"] =
{
  label = "Village"
  name_theme = "URBAN"
  mixed_prob = 20
}

