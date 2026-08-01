-- Difficulty, Immunites, Break Immunity, /players X
D2C = D2C or {}

function D2C.setDifficulty(player, diff)
  -- 0 normal,1 nightmare,2 hell
  diff = math.max(0, math.min(2, diff))
  D2C.setAttr(player,"DIFF",diff)
  local penalty = D2C.RES_PENALTY[diff]
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Dificuldade: "..D2C.DIFF_NAMES[diff].." Resist penalty "..penalty.."%")
  return diff
end
function D2C.getResistWithPenalty(player, baseRes)
  local diff = D2C.getAttr(player,"DIFF")
  local penalty = D2C.RES_PENALTY[diff] or 0
  return baseRes + penalty
end

-- Immunities: monster res >100% = immune Fire, Cold, Light, Poison, Magic, Physical
D2C.IMMUNITY_TYPES = {"Fire","Cold","Lightning","Poison","Magic","Physical"}
function D2C.isImmune(monsterResist)
  return monsterResist > 100
end
function D2C.immunityString(resists)
  local immunes={}
  for k,v in pairs(resists) do
    if v>100 then table.insert(immunes,k) end
  end
  return table.concat(immunes,", ")
end

-- Break immunity: Conviction (Paladin) or Lower Resist (Necro) operate at 1/5 vs immune
function D2C.breakImmunity(monsterResist, reductionSkill, isImmune)
  if not isImmune then
    return monsterResist - reductionSkill
  else
    -- 1/5 effectiveness
    local effective = math.floor(reductionSkill/5)
    local newRes = monsterResist - effective
    local broken = newRes < 100
    return newRes, broken, effective
  end
end

-- Conviction example: lvl 25 = -150% res
-- Lower Resist lvl 10 = -62%
D2C.CONVICTION_TABLE = {
  [1]=30,[5]=60,[10]=95,[15]=125,[20]=140,[25]=150
}
D2C.LOWER_RESIST_TABLE = {
  [1]=31,[5]=47,[10]=62,[15]=70,[20]=75,[25]=78
}
function D2C.getConvictionReduction(level)
  return D2C.CONVICTION_TABLE[level] or math.min(150, 20+level*5)
end
function D2C.getLowerResistReduction(level)
  return D2C.LOWER_RESIST_TABLE[level] or math.min(78, 25+level*3)
end

-- Players X command
function D2C.setPlayers(player, n)
  n = math.max(1, math.min(8, n or 1))
  D2C.setAttr(player,"PLAYERS",n)
  -- Simulate presence of more players
  -- In party, monster HP +100% per player, etc handled in monster spawn hook
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED,"/players set to "..n.." - Vida dos monstros aumentada, XP e NoDrop reduzido.")
  return n
end
function D2C.getPlayers(player)
  local v = D2C.getAttr(player,"PLAYERS")
  if v<=0 then return 1 end
  return v
end

-- XP penalty leveling 90-99 and area diff
function D2C.xpPenalty(playerLevel, areaLevel, baseXP, isDiablo)
  local lvl = playerLevel
  local alvl = areaLevel
  local delta = math.abs(lvl - alvl)
  local mult = 1.0
  if delta >5 then mult = mult - (delta-5)*0.05 end
  if lvl >= 70 then
    -- Clvl high reduces xp if killing low area
  end
  -- Level 70+ xp penalty: shared in D2
  local levelPenaltyTable = {
    [70]=0.9, [75]=0.75, [80]=0.5, [85]=0.25, [90]=0.1, [95]=0.05, [98]=0.02
  }
  for th, pen in pairs(levelPenaltyTable) do
    if lvl >= th then mult = mult * pen end
  end
  if lvl < alvl -10 then mult = mult * 0.05 end
  mult = math.max(0.01, mult)
  local xp = math.floor(baseXP * mult)
  -- Players X bonus
  -- xp bonus handled in apply
  return xp
end
