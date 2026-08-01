-- Diablo II Skill: Skeleton Mastery
-- Class: Necromancer
-- 210 spells total, part of complete port
-- Uses D2C combat, synergies, CB, OW, DS, block, AR, freeze, corpse etc
function onCastSpell(creature, variant)
  local player = creature:getPlayer()
  if not player then return false end
  local skillName = "Skeleton Mastery"
  local lvl = 1
  if D2C and D2C.getSkillLevel then lvl = D2C.getSkillLevel(player, skillName) else lvl = player:getLevel() end
  if lvl <=0 then lvl=1 end
  local baseMana = 10
  local manaCost = math.floor(baseMana * (1 + lvl*0.1))
  if player:getMana() < manaCost then
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "Mana insuficiente para "..skillName.." precisa "..manaCost)
    return false
  end
  player:addMana(-manaCost)
  local baseDamage = 20
  local synergyBonus = 0
  if D2C and D2C.calcSynergyBonus then synergyBonus = D2C.calcSynergyBonus(skillName, {}) end
  local damage = math.floor(baseDamage * (1 + lvl*0.15 + synergyBonus/100))
  if skillName == "Corpse Explosion" then
    local found=false
    if D2C and D2C.CORPSE_RESOURCE then
      for id,c in pairs(D2C.CORPSE_RESOURCE) do
        if not c.used then D2C.consumeCorpse(id, player:getName(), "Corpse Explosion"); found=true; break end
      end
    end
    if not found then player:sendTextMessage(MESSAGE_STATUS_SMALL, "Sem cadaveres!"); return false end
    damage = damage*2
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, skillName.." explodiu cadaver! Dano "..damage)
  elseif skillName == "Find Item" then
    if D2C and D2C.CORPSE_RESOURCE then
      for id,c in pairs(D2C.CORPSE_RESOURCE) do if not c.used then D2C.consumeCorpse(id, player:getName(), "Find Item"); player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Find Item loot!") break end end
    end
  elseif skillName == "Redemption" then
    if D2C and D2C.CORPSE_RESOURCE then
      for id,c in pairs(D2C.CORPSE_RESOURCE) do if not c.used then D2C.consumeCorpse(id, player:getName(), "Redemption"); player:addHealth(math.floor(damage/4)) end end
    end
  end
  local target = creature:getTarget()
  if target and target:isMonster() then
    local params = {}
    params.ar = 100+player:getLevel()*5
    params.def = 50
    params.cs = 10
    params.ds = D2C and D2C.getAttr and D2C.getAttr(player,"DS") or 0
    params.cb = D2C and D2C.getAttr and D2C.getAttr(player,"CB") or 0
    params.ow = D2C and D2C.getAttr and D2C.getAttr(player,"OW") or 0
    params.kb = D2C and D2C.getAttr and D2C.getAttr(player,"KB") or 0
    if D2C and D2C.getAttr then params.kb = D2C.getAttr(player,"KB")>0 end
    local finalDmg, result = damage, "hit"
    if onD2Hit then finalDmg, result = onD2Hit(player, target, damage, params) end
    if result == "miss" then player:sendTextMessage(MESSAGE_STATUS_SMALL, skillName.." errou! AR vs Def"); return false
    elseif result == "blocked" then player:sendTextMessage(MESSAGE_STATUS_SMALL, skillName.." bloqueado! 75 cap"); return false
    else target:addHealth(-finalDmg)
      if D2C and D2C.applyLeech then D2C.applyLeech(player, finalDmg, 5,3) end
    end
  else
    if skillName == "Battle Orders" or skillName == "Shout" or skillName == "Battle Command" then
      if D2C then player:setStorageValue(D2C.STORAGES.CURSE_ACTIVE+1, lvl) end
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, skillName.." gritado! Buff party.")
    elseif skillName:find("Might") or skillName:find("Conviction") or skillName:find("Meditation") then
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Aura "..skillName.." Lvl "..lvl)
    end
  end
  if skillName:find("Cold") or skillName:find("Ice") or skillName:find("Blizzard") or skillName:find("Frozen") or skillName:find("Glacial") then
    if target then
      local dur = 3
      if D2C and D2C.freezeDuration then dur = D2C.freezeDuration(3, target, false) end
      target:setStorageValue(92000, os.time()+dur)
    end
  end
  if D2C and D2C.triggerCtC then D2C.triggerCtC(player, "onStriking", {}) end
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, string.format("%s Lvl %d dano %d sinergia +%d%%", skillName, lvl, damage, synergyBonus))
  return true
end
