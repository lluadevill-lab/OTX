-- Combat mechanics: AR vs Defense, Block, Run vs Walk, Absorb, Leech, CB, DS, OW, ITD, Knockback, CtC
D2C = D2C or {}

-- Attack Rating vs Defense
function D2C.hitChance(attacker, defender, ar, defense, isITD)
  ar = ar or 100
  defense = defense or 50
  if isITD and defender:isMonster() then
    defense = 0
  end
  local aLvl = math.max(1, attacker:getLevel())
  local dLvl = math.max(1, defender:getLevel())
  -- D2 formula: Chance = 100 * AR/(AR+Def) * 2*aLvl/(aLvl+dLvl)
  local chance = 100 * (ar / math.max(1, ar + defense)) * (2 * aLvl / (aLvl + dLvl))
  -- Clamp 5-95
  chance = math.max(5, math.min(95, chance))
  -- If defender running, defense=0 already applied upstream
  return chance
end

-- Block Rate 75% max
function D2C.blockChance(player, shieldBlock, running, attackerAngle)
  shieldBlock = shieldBlock or 20 -- shield base block
  local dex = D2C.getAttr(player,"DEX") + D2C.CLASS_BASE[D2C.getClass(player)].dex
  local lvl = math.max(1, player:getLevel())
  -- Native D2: Blocking = (ShieldBlock * (Dex-15)) / (CharLevel*2)
  local block = (shieldBlock * (dex - 15)) / (2 * lvl)
  block = block + D2C.getAttr(player,"BLOCK_BONUS")
  if running or D2C.isRunning(player) then
    block = block / 3
  end
  block = math.max(0, math.min(75, block)) -- cap 75%
  return block
end

function D2C.isRunningBlockPenalty(block)
  return block / 3
end

-- Run vs Walk defense zero
function D2C.getDefense(player, baseDefense, running)
  if running or D2C.isRunning(player) then
    return 0
  else
    return baseDefense + D2C.getAttr(player,"DEFENSE")
  end
end

-- Absorption: fixed then percent, before/after resists?
function D2C.absorb(damage, fixedAbsorb, percentAbsorb, resist)
  -- Order: resists apply after absorb? According to diablowiki, absorb after resists for elemental but we support both orders
  -- D2C: fixed then percent
  local afterFixed = math.max(0, damage - math.max(0, fixedAbsorb or 0))
  local afterPercent = afterFixed * (1 - math.max(0, math.min(100, percentAbsorb or 0))/100)
  if resist then
    afterPercent = afterPercent * (1 - math.max(-100, math.min(100, resist))/100)
  end
  return math.max(0, math.floor(afterPercent))
end

-- Leech with NM/Hell penalties
function D2C.applyLeech(player, physicalDamage, lifePct, manaPct)
  local diff = D2C.getAttr(player,"DIFF")
  local mult = {[0]=1,[1]=0.5,[2]=0.25}[diff] or 1
  -- Leech only works if not vs undead? D2: leech doesn't work on skeletons etc? Simplified.
  local life = math.floor(physicalDamage * (lifePct or 0)/100 * mult)
  local mana = math.floor(physicalDamage * (manaPct or 0)/100 * mult)
  if life>0 then player:addHealth(life) end
  if mana>0 then player:addMana(mana) end
  return life, mana
end

-- Crushing Blow
function D2C.crushingBlow(target, isBoss, isPlayer)
  -- Removes fixed fraction of current life
  local curHP = target:getHealth()
  if curHP <= 0 then return 0 end
  local pct
  if isPlayer then pct = 0.10
  elseif isBoss then pct = 0.125
  else pct = 0.25 end
  -- vs ranged halved
  local dmg = math.floor(curHP * pct)
  -- physical res reduces? In Hell physical resist reduces effectiveness to 50%? Simplified no.
  return dmg
end

-- Deadly Strike / Critical Strike independent rolls
function D2C.deadlyCriticalRoll(csChance, dsChance)
  csChance = math.max(0, math.min(100, csChance or 0))
  dsChance = math.max(0, math.min(100, dsChance or 0))
  local rollCS = math.random(100) < csChance
  local rollDS = math.random(100) < dsChance
  local isCritical = rollCS or rollDS
  local chanceCombined = csChance + dsChance - (csChance*dsChance/100)
  return isCritical, chanceCombined
end
function D2C.applyDeadly(physicalDamage, cs, ds)
  local crit, _ = D2C.deadlyCriticalRoll(cs, ds)
  if crit then return physicalDamage*2 end
  return physicalDamage
end

-- Open Wounds 8 sec bleed based on char level, cancels monster regen
function D2C.openWoundsDamage(charLevel, isBoss)
  -- Formula from diablowiki: OW damage per frame scales.
  -- Simplified linear: level 1-15: 25*level approx per second? Actual: ( (CLvl^2 / 256 ) + ...)
  -- We'll implement table approximation:
  local lvl = math.max(1, math.min(99, charLevel))
  local perSec
  if lvl <=15 then perSec = 9.1* lvl - 2
  elseif lvl <=30 then perSec = 18.2*lvl - 136
  elseif lvl <=45 then perSec = 27.3*lvl - 409
  elseif lvl <=60 then perSec = 36.1*lvl - 805
  else perSec = 44.7*lvl - 1319 end
  local total8sec = perSec * 8
  if isBoss then total8sec = total8sec / 2 end -- boss reduced
  return math.floor(total8sec)
end
function D2C.applyOpenWounds(target, charLevel, duration)
  duration = duration or 8
  local dmg = D2C.openWoundsDamage(charLevel, target:isMonster() and target:getType():isRewardBoss() or false)
  -- schedule bleed tick: damage per second
  if target:isMonster() then
    target:setStorageValue(90000, os.time()+duration) -- open wounds active
  end
  return dmg, duration
end

-- Ignore Target Defense
function D2C.ignoreDefense(attacker, defender, hasITD)
  if not hasITD then return false end
  if defender:isMonster() then
    -- ITD doesn't work on bosses/champions/superuniques in D2
    local isBoss = defender:getType():isRewardBoss()
    if isBoss then return false end
    return true
  end
  return false -- ITD doesn't work on players
end

-- Knockback
function D2C.knockback(attacker, defender, hasKnockback)
  if not hasKnockback then return false end
  -- Cannot knockback bosses?
  if defender:getType():isRewardBoss() then return false end
  -- push back 2 tiles
  local pos = defender:getPosition()
  local aPos = attacker:getPosition()
  local dirX = pos.x - aPos.x
  local dirY = pos.y - aPos.y
  dirX = dirX ~=0 and dirX/math.abs(dirX) or 0
  dirY = dirY ~=0 and dirY/math.abs(dirY) or 0
  local newPos = {x=pos.x+dirX*2, y=pos.y+dirY*2, z=pos.z}
  -- check tile walkable (simplified)
  defender:teleportTo(newPos)
  return true
end

-- Chance to Cast
D2C.CTC_EVENTS = {"onAttack","onStriking","whenStruck","onKill","onDeath","onLevelUp"}
-- ctc = {chance=15, skill="Fire Ball", level=5, event="onStriking"}
function D2C.rollCtC(ctcTable)
  for _, c in ipairs(ctcTable or {}) do
    if math.random(100) <= (c.chance or 0) then
      return c -- triggered
    end
  end
  return nil
end
function D2C.triggerCtC(player, event, ctcList)
  for _, c in ipairs(ctcList or {}) do
    if c.event == event then
      if math.random(10000) <= math.floor((c.chance or 0)*100) then
        -- cast spell
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,"Chance to Cast: "..(c.skill or "???").." Lvl "..(c.level or 1).."!")
        -- real spell execution would go via Spell API
        return c
      end
    end
  end
  return nil
end

-- Weapon Range
function D2C.getWeaponRange(weaponType)
  return D2C.WEAPON_RANGE[weaponType] or 1
end

-- Ethereal
function D2C.applyEthereal(baseDamageOrDef, isArmor)
  return math.floor(baseDamageOrDef * (1 + D2C.ETHEREAL_BONUS))
end
function D2C.isEtherealBroken(item) -- cannot repair, breaks permanently
  return item.isEthereal and (item.durability or 100) <=0 and not item.hasAutoRepair
end

-- Kick Damage Assassin: based on boots + str/dex
D2C.BOOT_DAMAGE = {
  Leather=8, Heavy=12, Chain=15, LightPlate=24, Plate=28, Ogre=38,
  Myrmidon=42, -- elite
}
function D2C.kickDamage(player, bootType)
  local base = D2C.BOOT_DAMAGE[bootType] or 10
  local str = D2C.getAttr(player,"STR")
  local dex = D2C.getAttr(player,"DEX")
  -- D2 formula: Kick = BootDmg * (1+ (Str+Dex-40)/100?) actually (+Str*???)
  local mult = 1 + (str + dex) / 200
  return math.floor(base * mult)
end

-- Barb Two-Handed Mastery dual wield 2H swords
function D2C.canBarbDualWield2H(player, weaponType)
  local cls = D2C.getClass(player)
  if cls ~= "Barbarian" then return false end
  if weaponType == "two_handed_sword" then return true end
  return false
end
