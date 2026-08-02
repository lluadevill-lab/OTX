-- Combat mechanics: AR vs Defense, Block, Run vs Walk, Absorb, Leech, CB, DS, OW, ITD, Knockback, CtC
D2C = D2C or {}

function D2C.safeLevel(creature)
  if not creature then return 1 end
  if creature.getLevel then
    local ok, lvl = pcall(function() return creature:getLevel() end)
    if ok and lvl and type(lvl)=="number" and lvl>0 then return lvl end
  end
  if creature.isMonster and creature:isMonster() then return 20 end
  return 1
end

-- Attack Rating vs Defense
function D2C.hitChance(attacker, defender, ar, defense, isITD)
  ar = ar or 100
  defense = defense or 50
  if isITD and defender and defender.isMonster and defender:isMonster() then defense = 0 end
  local aLvl = math.max(1, D2C.safeLevel(attacker))
  local dLvl = math.max(1, D2C.safeLevel(defender))
  local chance = 100 * (ar / math.max(1, ar + defense)) * (2 * aLvl / (aLvl + dLvl))
  chance = math.max(5, math.min(95, chance))
  return chance
end

function D2C.blockChance(player, shieldBlock, running, attackerAngle)
  shieldBlock = shieldBlock or 20
  local dex = D2C.getAttr and D2C.getAttr(player,"DEX") or 20
  if D2C.CLASS_BASE and D2C.getClass then
    local cls = D2C.getClass(player)
    if D2C.CLASS_BASE[cls] then dex = dex + D2C.CLASS_BASE[cls].dex end
  end
  local lvl = math.max(1, D2C.safeLevel(player))
  local block = (shieldBlock * (dex - 15)) / (2 * lvl)
  if D2C.getAttr then block = block + D2C.getAttr(player,"BLOCK_BONUS") end
  if running or (D2C.isRunning and D2C.isRunning(player)) then block = block / 3 end
  block = math.max(0, math.min(75, block))
  return block
end

function D2C.isRunningBlockPenalty(block) return block / 3 end

function D2C.getDefense(player, baseDefense, running)
  if running or (D2C.isRunning and D2C.isRunning(player)) then return 0 end
  return baseDefense + (D2C.getAttr and D2C.getAttr(player,"DEFENSE") or 0)
end

function D2C.absorb(damage, fixedAbsorb, percentAbsorb, resist)
  local afterFixed = math.max(0, damage - math.max(0, fixedAbsorb or 0))
  local afterPercent = afterFixed * (1 - math.max(0, math.min(100, percentAbsorb or 0))/100)
  if resist then afterPercent = afterPercent * (1 - math.max(-100, math.min(100, resist))/100) end
  return math.max(0, math.floor(afterPercent))
end

function D2C.applyLeech(player, physicalDamage, lifePct, manaPct)
  local diff = D2C.getAttr and D2C.getAttr(player,"DIFF") or 0
  local mult = ({[0]=1,[1]=0.5,[2]=0.25})[diff] or 1
  local life = math.floor(physicalDamage * (lifePct or 0)/100 * mult)
  local mana = math.floor(physicalDamage * (manaPct or 0)/100 * mult)
  if player and player.addHealth and life>0 then player:addHealth(life) end
  if player and player.addMana and mana>0 then player:addMana(mana) end
  return life, mana
end

function D2C.crushingBlow(target, isBoss, isPlayer)
  if not target or not target.getHealth then return 0 end
  local curHP = target:getHealth()
  if curHP <= 0 then return 0 end
  local pct = isPlayer and 0.10 or (isBoss and 0.125 or 0.25)
  return math.floor(curHP * pct)
end

function D2C.deadlyCriticalRoll(csChance, dsChance)
  csChance = math.max(0, math.min(100, csChance or 0))
  dsChance = math.max(0, math.min(100, dsChance or 0))
  local rollCS = math.random(100) < csChance
  local rollDS = math.random(100) < dsChance
  return rollCS or rollDS, csChance + dsChance - (csChance*dsChance/100)
end

function D2C.applyDeadly(physicalDamage, cs, ds)
  local crit = D2C.deadlyCriticalRoll(cs, ds)
  if crit then return physicalDamage*2 end
  return physicalDamage
end

function D2C.openWoundsDamage(charLevel, isBoss)
  local lvl = math.max(1, math.min(99, charLevel))
  local perSec
  if lvl <=15 then perSec = 9.1* lvl - 2
  elseif lvl <=30 then perSec = 18.2*lvl - 136
  elseif lvl <=45 then perSec = 27.3*lvl - 409
  elseif lvl <=60 then perSec = 36.1*lvl - 805
  else perSec = 44.7*lvl - 1319 end
  local total8sec = perSec * 8
  if isBoss then total8sec = total8sec / 2 end
  return math.floor(total8sec)
end

function D2C.applyOpenWounds(target, charLevel, duration)
  duration = duration or 8
  local isBoss = false
  if target and target.getType and target:isMonster() then
    local ok, b = pcall(function() return target:getType():isRewardBoss() end)
    if ok then isBoss = b end
  end
  local dmg = D2C.openWoundsDamage(charLevel, isBoss)
  if target and target.setStorageValue then
    pcall(function() target:setStorageValue(90000, os.time()+duration) end)
  end
  return dmg, duration
end

function D2C.ignoreDefense(attacker, defender, hasITD)
  if not hasITD then return false end
  if defender and defender.isMonster and defender:isMonster() then
    local ok, isBoss = pcall(function() return defender:getType():isRewardBoss() end)
    if ok and isBoss then return false end
    return true
  end
  return false
end

function D2C.knockback(attacker, defender, hasKnockback)
  if not hasKnockback then return false end
  if defender and defender.getType then
    local ok, isBoss = pcall(function() return defender:getType():isRewardBoss() end)
    if ok and isBoss then return false end
  end
  if not defender or not defender.getPosition then return false end
  if not attacker or not attacker.getPosition then return false end
  local pos = defender:getPosition()
  local aPos = attacker:getPosition()
  local dirX = pos.x - aPos.x
  local dirY = pos.y - aPos.y
  dirX = dirX ~=0 and dirX/math.abs(dirX) or 0
  dirY = dirY ~=0 and dirY/math.abs(dirY) or 0
  local newPos = {x=pos.x+dirX*2, y=pos.y+dirY*2, z=pos.z}
  pcall(function() defender:teleportTo(newPos) end)
  return true
end

D2C.CTC_EVENTS = {"onAttack","onStriking","whenStruck","onKill","onDeath","onLevelUp"}

function D2C.rollCtC(ctcTable)
  for _, c in ipairs(ctcTable or {}) do
    if math.random(100) <= (c.chance or 0) then return c end
  end
  return nil
end

function D2C.triggerCtC(player, event, ctcList)
  for _, c in ipairs(ctcList or {}) do
    if c.event == event then
      if math.random(10000) <= math.floor((c.chance or 0)*100) then
        if player and player.sendTextMessage then
          player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,"Chance to Cast: "..(c.skill or "???").." Lvl "..(c.level or 1).."!")
        end
        return c
      end
    end
  end
  return nil
end

function D2C.getWeaponRange(weaponType) return D2C.WEAPON_RANGE[weaponType] or 1 end

function D2C.applyEthereal(baseDamageOrDef, isArmor)
  return math.floor(baseDamageOrDef * (1 + D2C.ETHEREAL_BONUS))
end

function D2C.isEtherealBroken(item)
  return item.isEthereal and (item.durability or 100) <=0 and not item.hasAutoRepair
end

D2C.BOOT_DAMAGE = {Leather=8, Heavy=12, Chain=15, LightPlate=24, Plate=28, Ogre=38, Myrmidon=42}

function D2C.kickDamage(player, bootType)
  local base = D2C.BOOT_DAMAGE[bootType] or 10
  local str = D2C.getAttr and D2C.getAttr(player,"STR") or 20
  local dex = D2C.getAttr and D2C.getAttr(player,"DEX") or 20
  local mult = 1 + (str + dex) / 200
  return math.floor(base * mult)
end

function D2C.canBarbDualWield2H(player, weaponType)
  local cls = D2C.getClass and D2C.getClass(player) or "Barbarian"
  if cls ~= "Barbarian" then return false end
  if weaponType == "two_handed_sword" then return true end
  return false
end
