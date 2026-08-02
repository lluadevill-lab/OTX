-- Items: iLvl, aLvl, Treasure Classes, Prefixos, Sufixos, Raros, Únicos, Sets, Sockets, Gemas, Joias, Facets, etc
D2C = D2C or {}

-- Area Level 85 farming zones from diablo2.diablowiki.net
D2C.AREA_LEVELS = {
  ["Moo_Moo_Farm"]=90, ["Chaos_Sanctuary"]=85, ["Worldstone_Keep_Lvl3"]=85,
  ["The_Pit_Lvl2"]=85, ["Ancient_Tunnels"]=85, ["Mausoleum"]=85,
  ["Magot_Lair"]=85, ["Bloody_Foothills"]=85, ["Throne_of_Destruction"]=85,
  ["Pit"]=85, ["River_of_Flame"]=85, ["City_of_the_Damned"]=85,
}
function D2C.getAreaLevel(areaName, difficulty)
  local base = D2C.AREA_LEVELS[areaName] or 1
  if difficulty==1 then base = base + 10
  elseif difficulty==2 then base = math.min(90, base+15) end
  return base
end

-- Monster level = aLvl + mods
function D2C.monsterLevel(areaLevel, isChampion, isUnique, isBoss)
  local mlvl = areaLevel
  if isChampion then mlvl = mlvl+2 end
  if isUnique then mlvl = mlvl+3 end
  if isBoss then mlvl = mlvl+3 end
  return math.min(99, mlvl)
end

-- Item Level = monster level
function D2C.itemLevel(monsterLevel)
  return monsterLevel
end

-- Treasure Classes: agrupamentos ocultos
D2C.TREASURE_CLASSES = {
  Normal = {"Act 1 Equip A","Act 1 Junk","Gold"},
  ["Act 5 (H) Equip B"] = {"weap90","armo90","Act 5 (H) Good","Gold"},
  weap90 = {"7wa","7wb","7wc"},
  armo90 = {"7ha","7ba","7la"},
  weap60 = {"6wa","6wb"},
  armo60 = {"6ha","6ba"},
  -- boss TC
  Andariel = {"Andariel (H)"},
  Mephisto = {"Mephisto (H)"},
  Diablo = {"Diablo (H)"},
  Baal = {"Baal (H)"},
}
function D2C.resolveTC(tcName)
  local tc = D2C.TREASURE_CLASSES[tcName]
  if not tc then return {tcName} end
  return tc
end
function D2C.canDropFromTC(itemBase, tcName, qlvl)
  -- qlvl of item must be <= monster lvl and TC must contain group
  local mlvl = D2C.monsterLevel(D2C.getAreaLevel(tcName,0),false,false,false)
  return qlvl <= mlvl
end

-- qLvl, mLvl, oLvl
function D2C.checkAffixLevel(monsterLevel, affixLevel)
  return monsterLevel >= affixLevel
end

-- Prefixes and Suffixes: magical blue and yellow rare
D2C.PREFIXES = {
  {name="Bronze", mod="+20% Enhanced Damage", alvl=1, ilvl=1, group="damage"},
  {name="Iron", mod="+40% Enhanced Damage", alvl=12, ilvl=12, group="damage"},
  {name="Steel", mod="+60% Enhanced Damage", alvl=22, ilvl=22, group="damage"},
  {name="Ruby", mod="Fire Resist +20%", alvl=8, ilvl=8, group="res"},
  {name="Amber", mod="Light Resist +20%", alvl=10, ilvl=10, group="res"},
  {name="Shimmering", mod="All Res +10%", alvl=25, ilvl=25, group="res"},
  {name="Mechanic's", mod="+2 sockets", alvl=1, ilvl=1, group="socket"},
  {name="Whale", mod="+100 Life", alvl=20, ilvl=20, group="life"},
  {name="Fox", mod="+10 Mana", alvl=5, ilvl=5, group="mana"},
  {name="Knowledge", mod="+1 skills", alvl=40, ilvl=40, group="skills"},
  -- more
  {name="Sharp", mod="+50 AR", alvl=10, ilvl=10, group="ar"},
  {name="Maiden's", mod="+50 Defense", alvl=15, ilvl=15, group="def"},
}
D2C.SUFFIXES = {
  {name="of Strength", mod="+10 Strength", alvl=1, ilvl=1, req=10},
  {name="of Dexterity", mod="+10 Dexterity", alvl=1, ilvl=1, req=10},
  {name="of the Apprentice", mod="+1-2 Mana After Kill", alvl=1, ilvl=1},
  {name="of Slaughter", mod="Deadly Strike 10%", alvl=30, ilvl=30},
  {name="of Absorption", mod="20% Lightning Absorb", alvl=25, ilvl=25},
  {name="of Burning", mod="Adds 5-10 Fire Damage", alvl=5, ilvl=5},
  {name="of Frost", mod="Adds Cold Damage + Freeze", alvl=10, ilvl=10},
  {name="of the Titan", mod="+20 Strength +30 Life", alvl=45, ilvl=45, req=55},
  {name="of Excellence", mod="+2 All Skills", alvl=60, ilvl=60, req=70},
}
function D2C.rollPrefix(ilvl, alvl)
  local candidates = {}
  for _, p in ipairs(D2C.PREFIXES) do
    if ilvl >= p.ilvl and alvl >= p.alvl then table.insert(candidates,p) end
  end
  if #candidates==0 then return nil end
  return candidates[math.random(#candidates)]
end
function D2C.rollSuffix(ilvl, alvl)
  local candidates = {}
  for _, s in ipairs(D2C.SUFFIXES) do
    if ilvl >= s.ilvl and alvl >= s.alvl then table.insert(candidates,s) end
  end
  if #candidates==0 then return nil end
  return candidates[math.random(#candidates)]
end

-- Rarity rolls with MF diminishing returns
function D2C.rarityRoll(mf, ilvl, tc)
  -- MF effective
  local eff = {
    magic = mf,
    rare = mf * 600 / (600+mf),
    set = mf * 500 / (500+mf),
    unique = mf * 250 / (250+mf),
  }
  local r = math.random(1000)
  if r < (10 + eff.unique/10) then return "unique"
  elseif r < (30 + eff.set/10) then return "set"
  elseif r < (100 + eff.rare/5) then return "rare"
  elseif r < (300 + eff.magic/2) then return "magic"
  else return "normal" end
end

-- Unique, Set, Rare item bases
D2C.UNIQUES = {
  -- weapons
  {name="The Stone of Jordan", base="Ring", qlvl=29, rarity="unique", mods="+1 Skills, +20 Mana, Lightning Damage"},
  {name="Harlequin Crest", base="Shako", qlvl=50, rarity="unique", mods="+2 Skills, MF, Life/Mana, DR 10%"},
  {name="Windforce", base="Hydra Bow", qlvl=70, rarity="unique", mods="250% ED, 20% IAS, Knockback, Mana Leech"},
  {name="Titan's Revenge", base="Ceremonial Javelin", qlvl=42, rarity="unique", mods="+2 Amazon, +20 Str/Dex, Life Leech"},
  -- armor
  {name="Enigma", base="Mage Plate", qlvl=65, rarity="runeword", mods="Teleport, +2 Skills, Strength, MF"},
}
D2C.SETS = {
  {set="Tal Rasha's Wrappings", pieces={"Amulet","Armor","Belt","Helm","Wand"}, bonuses={"Partial: +10% FCR","Full: -15% enemy res"}},
  {set="Immortal King", pieces={"Armor","Helm","Gloves","Boots","Belt","Maul"}, bonuses={"Partial: +200 Defense","Full: +50% CB, +2 Skills"}},
  {set="M'avina's Battle Hymn", pieces={"Armor","Bow","Gloves","Belt","Diadem"}, bonuses={"Full: +2 Skills, 20% IAS"}},
}

-- Sockets, Gems, Jewels, Rainbow Facets
D2C.SOCKET_MAX = {normal=4, exceptional=5, elite=6}
function D2C.rollSockets(itemType, ilvl, isEthereal)
  local maxS = D2C.SOCKET_MAX[itemType] or 4
  if ilvl < 25 then maxS = math.min(maxS, 3)
  elseif ilvl < 40 then maxS = math.min(maxS, 4) end
  local sockets = math.random(1,maxS)
  -- Only gray normal items can get sockets for runewords
  return sockets
end

D2C.GEMS = {
  -- 5 levels: Chipped, Flawed, Normal, Flawless, Perfect
  Amethyst = {levels={"Chipped","Flawed","Amethyst","Flawless","Perfect"}, weapon="+ATK rating", shield="+Defense", helmarmor="+Strength"},
  Topaz = {levels={"Chipped","Flawed","Topaz","Flawless","Perfect"}, weapon="Light Damage", shield="Light Res", helmarmor="MF"},
  Sapphire = {levels={"Chipped","Flawed","Sapphire","Flawless","Perfect"}, weapon="Cold Damage", shield="Cold Res", helmarmor="+Mana"},
  Emerald = {levels={"Chipped","Flawed","Emerald","Flawless","Perfect"}, weapon="Poison Damage", shield="Poison Res", helmarmor="+Dex"},
  Ruby = {levels={"Chipped","Flawed","Ruby","Flawless","Perfect"}, weapon="Fire Damage", shield="Fire Res", helmarmor="+Life"},
  Diamond = {levels={"Chipped","Flawed","Diamond","Flawless","Perfect"}, weapon="Damage vs Undead", shield="All Res", helmarmor="+AR"},
  Skull = {levels={"Chipped","Flawed","Skull","Flawless","Perfect"}, weapon="Life/Mana Leech", shield="+Life regen", helmarmor="+Life/ Mana hill"},
}
function D2C.gemBonus(gemType, level, slot)
  local gem = D2C.GEMS[gemType]
  if not gem then return "???" end
  local lvlIndex = 1
  for i, l in ipairs(gem.levels) do if l==level then lvlIndex=i break end end
  local mult = lvlIndex
  if slot=="weapon" then return gem.weapon.." x"..mult
  elseif slot=="shield" then return gem.shield.." x"..mult
  else return gem.helmarmor.." x"..mult end
end

D2C.JEWELS = {
  magic = {"+20% ED","15% IAS","+15 All Res","+15 Strength"},
  rare = {"30% ED, 15% IAS, +10 Min Damage","20% ED, +15 Dex, +20 Mana"},
}
D2C.RAINBOW_FACETS = {
  {name="Fire Facet", element="Fire", onDie="5% Chance to Cast Lvl 10 Meteor on Death", mods="+5% Fire Damage, -5% Enemy Fire Res"},
  {name="Cold Facet", element="Cold", onDie="100% Chance to Cast Lvl 44 Nova when you Die", mods="+5% Cold Damage, -5% Enemy Cold Res"},
  {name="Lightning Facet", element="Lightning", onDie="100% Chance to Cast Lvl 41 Nova when you Die", mods="+5% Light Damage, -5% Enemy Light Res"},
  {name="Poison Facet", element="Poison", onDie="100% Chance to Cast Lvl 51 Poison Nova when you Die", mods="+5% Poison Damage, -5% Enemy Poison Res"},
}
function D2C.isRainbowFacet(item) return item.isFacet end

-- Base Upgrading
D2C.BASE_UPGRADE = {
  Normal_to_Exceptional = {rune="Ral", gem="Thul", pgem="Perfect Amethyst", weapon=true, armor=true},
  Exceptional_to_Elite = {rune="Ko", gem="Lem", pgem="Perfect Diamond", weapon=true, armor=true},
  Rare_Normal_to_Exceptional = {rune="Ral", gem="Thul", pgem="Amn"},
  Rare_Exceptional_to_Elite = {rune="Ko", gem="Pul", pgem="Perfect Amethyst"},
  Unique_Normal_to_Exceptional = {rune="Ral", gem="Thul", pgem="Perfect Amethyst"},
  Unique_Exceptional_to_Elite = {rune="Ko", gem="Lem", pgem="Perfect Diamond"},
}
function D2C.upgradeBase(item, targetTier)
  -- targetTier = exceptional/elite
  -- increases base damage/def by ~50-100% while keeping magical mods
  local newBaseMult = targetTier=="exceptional" and 1.5 or 2.5
  local base = item.baseDef or item.baseDamage or 100
  item.base = math.floor(base*newBaseMult)
  item.tier = targetTier
  return item
end

-- Charges
D2C.CHARGES = {
  {skill="Teleport", class="Sorceress", maxCharges=20, costRecharge=50000},
  {skill="Battle Orders", class="Barbarian", maxCharges=25, costRecharge=2260},
  {skill="Enchant", class="Sorceress", maxCharges=30, costRecharge=30000},
  {skill="Lower Resist", class="Necromancer", maxCharges=15, costRecharge=60000},
}
function D2C.useCharge(item, skillName)
  if not item.charges then return false end
  for _, c in ipairs(item.charges) do
    if c.skill==skillName and c.cur>0 then
      c.cur = c.cur-1
      return true
    end
  end
  return false
end
function D2C.rechargeCost(item)
  local total=0
  for _, c in ipairs(item.charges or {}) do
    local def = nil
    for _, d in ipairs(D2C.CHARGES) do if d.skill==c.skill then def=d break end end
    if def then total = total + def.costRecharge * (def.maxCharges - c.cur)/def.maxCharges end
  end
  return math.floor(total)
end

-- oLvl/mLvl/qLvl explanation
D2C.LEVEL_REQUIREMENTS = {
  -- affix requires monster level
  plus2class = {oLvl=40, mLvl=45, qLvl=50, desc="+2 Class Skills needs monster lvl 50+"},
  plus45ias = {oLvl=30, mLvl=50, qLvl=55},
  plusToMana = {oLvl=1, mLvl=1, qLvl=1},
}
