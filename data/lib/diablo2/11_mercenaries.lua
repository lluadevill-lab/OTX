-- Mercenaries
D2C = D2C or {}
D2C.MERCENARIES = {
  Act1_Rogue = {
    name="Rogue Scout", act=1,
    weapons={"bow"}, armor={"helm","armor"},
    skills={"Inner Sight","Fire Arrow","Cold Arrow"},
    auras={}, base="Bow, Inner Sight -5% enemy defense",
    hire_level={Normal=8, Nightmare=45, Hell=80},
    stats={str=30, dex=50, life=300}
  },
  Act2_Desert = {
    name="Desert Mercenary", act=2,
    weapons={"polearm","spear"}, armor={"helm","armor"},
    skills={"Jab"},
    auras={
      Normal={Combat="Prayer", Defense="Defiance", Offense="Blessed Aim"},
      Nightmare={Combat="Thorns", Defense="Holy Freeze", Offense="Might"},
      Hell={Combat="Prayer", Defense="Defiance", Offense="Blessed Aim"},
    },
    base="Crucial auras - Prayer, Defiance, Might, Holy Freeze",
    hire_level={Normal=20, Nightmare=50, Hell=85},
    stats={str=60, dex=30, life=500}
  },
  Act3_IronWolf = {
    name="Iron Wolf", act=3,
    weapons={"sword","shield"}, armor={"helm","armor"},
    skills={Fire="Fire Ball, Inferno", Cold="Glacial Spike, Frozen Armor", Lightning="Charged Bolt, Static Field"},
    auras={}, base="Sorcerer merc - fire/light/cold",
    hire_level={Normal=25, Nightmare=55, Hell=85},
    stats={str=40, dex=40, life=400}
  },
  Act5_Barbarian = {
    name="Barbarian", act=5,
    weapons={"sword","two_handed_sword"}, armor={"helm","armor"},
    skills={"Bash","Stun"},
    auras={}, base="Tank, Bash, Stun",
    hire_level={Normal=35, Nightmare=60, Hell=85},
    stats={str=80, dex=20, life=600}
  },
}
D2C.MERC_EQUIPS = {"weapon","armor","helm"} -- can use equip
-- Merc level up with player
function D2C.spawnMerc(player, act, difficulty, auraChoice)
  local mercType = nil
  if act==1 then mercType=D2C.MERCENARIES.Act1_Rogue
  elseif act==2 then mercType=D2C.MERCENARIES.Act2_Desert
  elseif act==3 then mercType=D2C.MERCENARIES.Act3_IronWolf
  else mercType=D2C.MERCENARIES.Act5_Barbarian end
  local lvl = player:getLevel()
  D2C.setAttr(player,"MERC_TYPE",act)
  D2C.setAttr(player,"MERC_LVL",lvl)
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Mercenário contratado: "..mercType.name.." Lvl "..lvl.." Aura: "..(auraChoice or "default"))
  return mercType
end
function D2C.mercLevelUp(player)
  local mercLvl = D2C.getAttr(player,"MERC_LVL")
  local plvl = player:getLevel()
  if plvl > mercLvl then
    D2C.setAttr(player,"MERC_LVL",plvl)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,"Seu mercenário subiu para nivel "..plvl.."!")
  end
end
function D2C.mercEquip(player, slot, item)
  if not table.contains(D2C.MERC_EQUIPS, slot) then return false, "Slot invalido" end
  -- merc can use ethereal without losing durability
  if item.isEthereal then item.durabilityLoss = 0 end
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Merc equipou "..item.name.." no slot "..slot)
  return true
end
if not table.contains then table.contains=function(a,v) for _,x in pairs(a) do if x==v then return true end end return false end end
