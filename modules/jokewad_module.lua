------------------------------------------------------------------------
--  MODULE: Jokewad Module
------------------------------------------------------------------------
--
--  Copyright (C) 2019-2021 MsrSgtShooterPerson
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

JOKEWAD_MODULE = {}

JOKEWAD_MODULE.ENABLE_DISABLE =
{
  "enable",  _("Enable"),
  "disable", _("Disable"),
}

function JOKEWAD_MODULE.setup(self)
  for name,opt in pairs(self.options) do
    local value = self.options[name].value
    PARAM[name] = value
  end
end

JOKEWAD_MODULE.SUPER_DEC =
[[
Actor ObE_LootValue : CustomInventory
{
  Height 16
  Radius 16
  Scale 0.5

  Inventory.Icon "OBTTE0"
  Inventory.AltHUDIcon "OBTTE0"
  Inventory.MaxAmount 9000001
  Inventory.InterHubAmount 9000001

  +INVENTORY.INVBAR
  +INVENTORY.ALWAYSPICKUP
  +INVENTORY.UNDROPPABLE
  +COUNTITEM

  States
  {
    Spawn:
      OBTT B 0
      Stop

    Use:
      TNT1 B 0 ACS_NamedExecute("CountTissues", 0)
      TNT1 B 0 A_GiveInventory("ObE_LootValue", 1)
      Stop
  }
}

Actor ObE_OneRoll : ObE_LootValue 14949
{
  Tag "Tissue Roll"

  Scale 0.25

  Inventory.PickupMessage "Found a 2-ply tissue roll! Every square stolen, a demon pays the price."
  -INVENTORY.INVBAR

  States
  {
    Spawn:
      OBTT F 20
      OBTT F 5 Bright
      GoTo Animate

    Animate:
      OBTT F 20
      OBTT F 5 Bright
      Loop

    Pickup:
      TNT1 F -1
      TNT1 F 0 A_GiveInventory("ObE_LootValue", 1)
      Stop
  }
}

Actor ObE_TwoRolls : ObE_LootValue 14950
{
  Tag "Two Tissue Rolls"

  Scale 0.4

  Inventory.PickupMessage "Found two tissue rolls! A victory against hell, two rolls at a time!"
  -INVENTORY.INVBAR

  States
  {
    Spawn:
      OBTT B 20
      OBTT B 5 Bright
      GoTo Animate

    Animate:
      OBTT B 20
      OBTT B 5 Bright
      Loop

    Pickup:
      TNT1 B -1
      TNT1 B 0 A_GiveInventory("ObE_LootValue", 2)
      Stop
  }
}

Actor ObE_FiveRolls : ObE_LootValue 14951
{
  Tag "Five Tissue Rolls"

  Inventory.PickupMessage "Found a stack of five tissue rolls! The people need this!"
  -INVENTORY.INVBAR

  States
  {
    Spawn:
      OBTT C 20
      OBTT C 5 Bright
      GoTo Animate

    Animate:
      OBTT C 20
      OBTT C 5 Bright
      Loop

    Pickup:
      TNT1 C -1
      TNT1 C 0 A_GiveInventory("ObE_LootValue", 5)
      Stop
  }
}

Actor ObE_HandSanitizer : ObE_LootValue 14952
{
  Tag "Hand Sanitizer"

  Inventory.PickupMessage "Picked up a hand sanitizer. Remember to disinfect and stay at home!"
  -INVENTORY.INVBAR

  States
  {
    Spawn:
      OBTT A 20
      OBTT A 5 Bright
      GoTo Animate

    Animate:
      OBTT A 20
      OBTT A 5 Bright
      Loop

    Pickup:
      TNT1 A -1
      TNT1 A 0 A_GiveInventory("ObE_LootValue", 7)
      Stop
  }
}

Actor ObE_RespiratorMask : ObE_LootValue 14953
{
  Tag "Respirator Mask"

  Scale 0.3

  Inventory.PickupMessage "Picked up a respirator mask! This will greatly help those in the frontlines!"
  -INVENTORY.INVBAR

  States
  {
    Spawn:
      OBTT D 20
      OBTT D 5 Bright
      GoTo Animate

    Animate:
      OBTT D 20
      OBTT D 5 Bright
      Loop

    Pickup:
      TNT1 D -1
      TNT1 D 0 A_GiveInventory("ObE_LootValue", 10)
      Stop
  }
}
]]

JOKEWAD_MODULE.TISSUES =
{
  ob_1roll =
  {
    id = 14949,
    cluster = 5,
  },

  ob_2roll =
  {
    id = 14950,
    cluster = 3,
  },

  ob_5roll =
  {
    id = 14951,
  },

  ob_handsanitizer =
  {
    id = 14952,
  },

  ob_mask =
  {
    id = 14953,
  },
}

function JOKEWAD_MODULE.get_levels()

  if PARAM.fireblu_mode == "enable" then
    JOKEWAD_MODULE.go_fireblue()
  end

end

function JOKEWAD_MODULE.end_level()

  if PARAM.pandemic_mode == "enable" then
    JOKEWAD_MODULE.add_tissues()
  end

end



function JOKEWAD_MODULE.go_fireblue()

  for m,def in pairs(GAME.MATERIALS) do
    if not string.match(m, "_SKY") then
      def.t = "GRAYTALL"
      def.f = "FIREBLU1"
    end
    if string.match(m, "DOOR") or
    string.match (m, "SW1") then
      def.t = "DOORTRAK"
      def.f = "FIREBLU1"
    end
  end

end

function JOKEWAD_MODULE.populate_level(stuff)

  local function render_items(h, x, y, offset)
    if not rand.odds(stuff.odds) then return end

    local choice = rand.key_by_probs(stuff.items)
    local item = stuff.templates[choice]
    local cluster
    local count = 1

    if item.cluster then
      count = rand.irange(1, item.cluster)
    end

    for i = 1, count do
      local thing = {}

      local final_z = h

      thing.id = stuff.templates[choice].id
      thing.z = final_z
      thing.x = rand.irange(x + offset, x - offset)
      thing.y = rand.irange(y + offset, y - offset)

      raw_add_entity(thing)
    end
  end

  for _,A in pairs(LEVEL.areas) do
    if (A.mode and A.mode == "floor") then
      for _,S in pairs(A.seeds) do

        -- not on chunks with something on it
        if S.chunk and S.chunk.content then goto continue end

        -- not by walls and diagonals
        if S.wall_depth or S.diagonal then goto continue end

        -- not on areas with liquid sinks
        if A.floor_group and A.floor_group.sink
        and A.floor_group.sink.mat == "_LIQUID" then goto continue end

        render_items(A.ceil_h, S.mid_x, S.mid_y, 48)
        ::continue::
      end
    elseif A.mode == "nature" then
      for _,WC in pairs(A.walk_rects) do
        if WC.chunk and WC.chunk.kind == "floor" then

          local i_x = WC.chunk.sx1
          local i_y = WC.chunk.sy1

          while i_x <= WC.chunk.sx2 do
          while i_y <= WC.chunk.sy2 do
            local pos_x = (i_x * SEED_SIZE) - 32
            local pos_y = (i_y * SEED_SIZE) - 32

            local S = SEEDS[i_x][i_y]

            if not S.wall_depth then
              render_items(WC.chunk.floor_h + 2, pos_x, pos_y, 32)
            end

            i_y = i_y + 1
          end
          i_x = i_x + 1
          i_y = WC.chunk.sy1
          end

        end
      end
    end
  end

end

function JOKEWAD_MODULE.add_tissues()

  if LEVEL.is_procedural_gotcha then return end

  if LEVEL.prebuilt then return end

  local item_params = {}

  item_params =
  {
    odds = 7,
    items =
    {
      ob_1roll = 2,
      ob_2roll = 1,
      ob_5roll = 1,
      ob_handsanitizer = 1,
      ob_mask = 1,
    },
    templates = JOKEWAD_MODULE.TISSUES
  }

  JOKEWAD_MODULE.populate_level(item_params)
end

function JOKEWAD_MODULE.all_done()

  if PARAM.pandemic_mode == "enable" then

    SCRIPTS.tissue_doc = JOKEWAD_MODULE.SUPER_DEC
    local dir = "games/doom/data/"
    gui.wad_merge_sections(dir .. "events.wad")

  end

end

OB_MODULES["jokewad_module"] =
{
  label = _("Jokewad Module"),

  game = "doomish",

  side = "left",
  priority = 60,

  hooks =
  {
    setup = JOKEWAD_MODULE.setup,
    get_levels = JOKEWAD_MODULE.get_levels,
    end_level = JOKEWAD_MODULE.end_level,
    all_done = JOKEWAD_MODULE.all_done
  },

  options =
  {
    fireblu_mode =
    {
      name = "fireblu_mode",
      label=_("FIREBLU Mode"),
      choices = JOKEWAD_MODULE.ENABLE_DISABLE,
      tooltip = _(
        "Allows the creation of the greatest maps to ever be generated on " ..
        "on the face of the earth. Warning: ticking this waives any " ..
        "liability for potential emotional and physical damage on the " ..
        "part of the user. \n"),
      default = "disable",
    },

    pandemic_mode =
    {
      name = "pandemic_mode",
      label=_("Pandemic Mode"),
      choices = JOKEWAD_MODULE.ENABLE_DISABLE,
      tooltip = _("Do your part in preventing the coronavirus crisis! Hell is taking " ..
      "away all our tissue rolls and hand sanitizers! It's up to the Slayer to take " ..
      "it back. Every square and every squeeze."),
      default = "disable",
    },
  },
}
