------------------------------------------------------------------------
--  Name Generator
------------------------------------------------------------------------
--
--  // Obsidian //
--
--  Copyright (C) 2008-2018 Andrew Apted
--  Copyright (C) 2008-2009 Jon Vail
--  Copyright (C)      2009 Enhas
--  Copyright (C) 2010-2022 Reisal
--  Copyright (C) 2010-2022 MsrSgtShooterPerson
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
--  Thanks to Enhas and Reisal for their additions.
--
------------------------------------------------------------------------

namelib = {}


namelib.NAMES = {}


----------------------------------------------------------------


namelib.IGNORE_WORDS =
{
  ["the"]=1, ["a"]=1,  ["an"]=1, ["of"]=1, ["s"]=1,
  ["for"]=1, ["in"]=1, ["on"]=1, ["to"]=1
}



namelib.COMMUNITY_MEMBERS =
{

  -- Core Obsidian or regular(ish) contributors.
  contributors =
  {
    "Reisal", -- Used to be known as Glaice
    "Beed 28",
    "Caligari", --Caligari87,
    "Craneo",
    "Dasho", --dashodanger
    "Demios",
    "EpicTyphlosion",
    "Frozsoul",
    "Garrett",
    "Josh Seven", --josh771,
    "Phytolizer",
    "Sgt. Shooter", --MsrSgtShooterPerson
    "Simon Vee", --Simon-v
    "Scionox",
    "Swedra",
    "Tapwave",
  },

  -- These people helped out OBLIGE and how they contributed.
  oblige_folks =
  {
    "Andrew Apted", -- THE developer of OBLIGE. Obsidian would not exist without him!
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
    "Samiam" -- Mr. ObHack!
  },

  -- this is an arbitrary list of regulars at the Unofficial Oblige
  -- Discord server. If you're a regular and you don't find your name
  -- here, feel free to add it yourself! (or ask a contributor to do so!)
  regulars =
  {
    "Brad Man X",
    "Cherry Bawble",
    "Crowbars", -- crowbars82, Mr. Octothrop!
    "Dan the Noob",
    "Hexa Doken",
    "Kinker 31",
    "Kinsie",
    "Magpie", --MagPie
    "Mog Waltz",
    "Monika",
    "Mr. Liden", --mrliden, created the R667ized Obsidian
    "Nisteth",
    "Roundabout Lout",
    "Sharahfluff",
    "Sharp",
    "TiZ",
    "The Dude", --TheDude1,
    "TTBNC",

    -- the following individuals are no longer active
    -- or haven't been in the server for a while...
    --"Big C",
    --"DZ",
    --"Elkinda",
    --"Obsidian Plague",
    --"Saint",
    --"Sanser",
    --"The Nate",
    --"Thexare",
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
  if PARAM.bool_whole_names_only and PARAM.bool_whole_names_only ~= 0 then
    return rand.key_by_probs(DEF.lexicon.s)
  end

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
    local name
    ::tryagain::
    name = namelib.choose_one(DEF, max_len)

    if table.has_elem(list, name) then goto tryagain end

    table.insert(list, name)
  end

  return list
end

function Naming_init(name_table)
  namelib.cache = {}
  namelib.NAMES = {}
  table.merge_w_copy(namelib.NAMES, name_table)
end


function Naming_grab_one(theme)
  local cache = namelib.cache
  assert(cache)

  if not cache[theme] or table.empty(cache[theme]) then
    cache[theme] = namelib.generate(theme, 30, 40)
  end

  return table.remove(namelib.cache[theme], 1)
end