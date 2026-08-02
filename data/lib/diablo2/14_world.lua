-- World mechanics: AI target, curse overriding, corpse, cold shatter, weapon swap, gold loss, stash, vendor caps, loot shared, ubers, events
D2C = D2C or {}

-- Monster AI Target
D2C.AI_TARGETS = {
  priority = {"player_closest","decoy","golem","merc","valkyrie"},
}
function D2C.getAITarget(monster, nearbyEntities)
  -- Prioritizes nearest player unless Decoy/Golem present
  for _, ent in ipairs(nearbyEntities) do
    if ent.type=="Decoy" or ent.type=="Golem" or ent.type=="Valkyrie" then
      return ent -- taunt alters threat
    end
  end
  local closest=nil
  local minDist=999
  for _, ent in ipairs(nearbyEntities) do
    if ent.type=="player" then
      if ent.dist < minDist then closest=ent; minDist=ent.dist end
    end
  end
  return closest
end

-- Curse Overriding: only one curse per enemy, last overwrites, same for barb warcries
D2C.CURSES = {"Amplify Damage","Dim Vision","Weaken","Iron Maiden","Terror","Confuse","Life Tap","Attract","Decrepify","Lower Resist"}
D2C.WARCRIES = {"Taunt","Battle Cry","War Cry"}
function D2C.applyCurse(target, curseName, level, player)
  local cur = target:getStorageValue(D2C.STORAGES.CURSE_ACTIVE)
  -- overwrite
  target:setStorageValue(D2C.STORAGES.CURSE_ACTIVE, level)
  target:setStorageValue(91000, curseName:len()) -- placeholder curse id storage
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,"Maldição "..curseName.." aplicada, sobrescreveu anterior.")
  return true
end
function D2C.isCursed(target)
  local v = target:getStorageValue(D2C.STORAGES.CURSE_ACTIVE)
  return v>0
end

-- Corpse Consumption: contested
D2C.CORPSE_RESOURCE = {}
function D2C.createCorpse(monster)
  local pos = monster:getPosition()
  local id = os.time()..math.random(1000)
  D2C.CORPSE_RESOURCE[id] = {pos=pos, time=os.time(), monster=monster:getName(), used=false}
  return id
end
function D2C.consumeCorpse(corpseId, consumer, reason)
  local c = D2C.CORPSE_RESOURCE[corpseId]
  if not c or c.used then return false, "Corpo já consumido/disputado" end
  c.used=true
  c.reason=reason
  c.consumer=consumer
  -- reasons: Corpse Explosion, Find Item (Barb), Redemption (Paladin), Raise Skeleton, etc
  return true
end
function D2C.listCorpses()
  return D2C.CORPSE_RESOURCE
end

-- Cold Shatter: enemies dead while frozen have chance to shatter, no corpse
function D2C.rollColdShatter(isFrozen, coldDamagePct)
  if not isFrozen then return false end
  local chance = 30 + (coldDamagePct or 0)/2 -- base 30%
  chance = math.min(100, chance)
  local roll = math.random(100)
  local shattered = roll <= chance
  return shattered
end
function D2C.onMonsterDeathFrozenCheck(monster, killer)
  local isFrozen = monster:getStorageValue(92000)>0 -- frozen marker
  if isFrozen then
    local shattered = D2C.rollColdShatter(true, 50)
    if shattered then
      monster:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Cold Shatter! Corpo estilhaçado, não deixa resto.")
      -- prevent corpse creation
      return true -- shattered
    end
  end
  D2C.createCorpse(monster)
  return false
end

-- Weapon Swapping W + pre-buff
D2C.WEAPON_SETS = {0,1} -- 0 primary,1 secondary
function D2C.swapWeapon(player)
  local curSet = D2C.getAttr(player,"WEAPON_SET")
  local newSet = (curSet==0) and 1 or 0
  D2C.setAttr(player,"WEAPON_SET", newSet)
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Troca de armas: Set "..newSet.." (W). Pre-buff trick ativo: buffs do set anterior permanecem por 30s.")
  -- apply pre-buff aura persistence
  player:setStorageValue(93000, os.time()+30) -- buff persistence
  return newSet
end
function D2C.getCurrentWeaponSet(player)
  return D2C.getAttr(player,"WEAPON_SET")
end

-- Gold Loss on Death
function D2C.goldLossOnDeath(player)
  local level = player:getLevel()
  local invGold = player:getMoney()
  local stashGold = player:getBankBalance()
  -- % loss: 20% inventory, 10% stash? D2: lose all gold carried + % stash based on level
  local lostInv = invGold -- loses all carried? Actually loses carried and some stash
  local lossPctStash = math.min(0.20, level*0.002) -- scaled
  local lostStash = math.floor(stashGold * lossPctStash)
  local fee = math.floor(level*100) -- bank deduct fee based on level
  -- apply
  player:removeMoney(lostInv)
  player:setBankBalance(math.max(0, stashGold - lostStash - fee))
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED,string.format("Morreu! Perdeu %d ouro da mochila, %d do banco + taxa %d", lostInv, lostStash, fee))
  return lostInv, lostStash, fee
end

-- Stash Separation Shared vs Personal
D2C.STASH = {
  personalTabs=4, sharedTabs=3, slotsPerTab=100,
}
function D2C.stashAdd(accountId, tab, item, isShared)
  -- tab: 0-3 personal, 4-6 shared
  -- In real DB insert into d2_account_stash
  -- isShared determines if survives HC death
  return true
end
function D2C.stashGet(accountId, isShared)
  -- retrieve stash items
  return {}
end
function D2C.onHardcoreDeathStashDrop(player)
  local accountId = player:getAccountId()
  -- personal tabs drop, shared tabs remain
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED,"Hardcore: baú pessoal caiu no chão, baú compartilhado permanece.")
end

-- Vendor Price Caps: max gold NPC pays
function D2C.vendorCap(difficulty, act)
  -- Max 5000 Act1 Normal scaling to 35k any act NM/Hell
  if difficulty==0 then
    local caps = {[1]=5000,[2]=10000,[3]=15000,[4]=20000,[5]=25000}
    return caps[act] or 5000
  else
    return 35000
  end
end
function D2C.vendorOffer(itemValue, difficulty, act)
  local cap = D2C.vendorCap(difficulty, act)
  return math.min(itemValue, cap)
end

-- Loot Compartilhado no Chão + scaling
D2C.LOOT_SHARED = {}
function D2C.dropLootShared(monster, lootTable, position, playersNearby)
  -- loot shared: items fall for all players on screen, first click wins
  local dropId = os.time()..math.random(1000)
  D2C.LOOT_SHARED[dropId] = {
    monster=monster:getName(),
    loot=lootTable,
    pos=position,
    players=playersNearby,
    time=os.time(),
    claimed=false,
  }
  -- broadcast to players
  for _, pid in ipairs(playersNearby) do
    local p = Player(pid)
    if p then p:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Loot compartilhado caiu! Clique rápido! "..monster:getName()) end
  end
  return dropId
end
function D2C.claimLootShared(player, dropId, itemIndex)
  local drop = D2C.LOOT_SHARED[dropId]
  if not drop or drop.claimed then return false, "Já foi coletado" end
  drop.claimed = true
  drop.claimedBy = player:getName()
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Você pegou o loot compartilhado!")
  return true, drop.loot[itemIndex]
end

-- Party (Grupo): necessidade convite para compartilhar XP, auras, shouts
function D2C.partyShareXP(party, killer, xp)
  for _, member in ipairs(party.members) do
    local p = Player(member)
    if p and p:getPosition():getDistance(killer:getPosition())<30 then
      p:addExperience(xp, true)
    end
  end
end

-- Chill/Freeze Length, Cannot Be Frozen, PLR
function D2C.freezeDuration(baseSeconds, player, sourceIsHolyFreeze)
  if not player then return baseSeconds end
  local cannotFreeze = 0
  pcall(function() cannotFreeze = D2C.getAttr(player,"CANNOT_BE_FROZEN") end)
  if not sourceIsHolyFreeze and cannotFreeze>0 then
    return 0 -- Cannot Be Frozen anulates completely blue slow, but not Holy Freeze aura
  end
  local diff = D2C.getAttr(player,"DIFF")
  local mult = ({[0]=1,[1]=0.5,[2]=0.25})[diff] or 1
  return baseSeconds*mult
end
function D2C.plrReduction(basePoisonSeconds, player)
  local plr = D2C.getAttr(player,"PLR") or 0
  -- PLR suffers same -40/-100 penalties
  local diff = D2C.getAttr(player,"DIFF")
  local penalty = D2C.RES_PENALTY[diff] -- negative
  local effectivePLR = plr + penalty
  effectivePLR = math.max(-100, math.min(100, effectivePLR))
  local dur = basePoisonSeconds * (1 - effectivePLR/100)
  return math.max(0.2, dur)
end

-- Diminishing Returns Stun
function D2C.stunDuration(target, baseDuration)
  if target:isMonster() then
    if target:getType():isRewardBoss() then
      return baseDuration * 0.1 -- champions/bosses severely reduced
    end
    -- check if champion
    local isChampion = target:getStorageValue(94000)>0
    if isChampion then return baseDuration*0.3 end
  end
  return baseDuration
end

-- Uber Diablo global event: SoJ counter
D2C.SOJ_COUNTER_MAX = 75 -- number of SoJ sold to trigger
function D2C.sellSoJ(player)
  local counter = D2C.getAttr(player,"SOJ_SOLD") + 1
  D2C.setAttr(player,"SOJ_SOLD", counter)
  -- global counter (use Game storage)
  local global = Game.getStorageValue(100000) or 0
  if global<0 then global=0 end
  global = global+1
  Game.setStorageValue(100000, global)
  if global >= D2C.SOJ_COUNTER_MAX then
    Game.setStorageValue(100000, 0)
    D2C.spawnUberDiablo()
    return true, global
  end
  return false, global
end
function D2C.spawnUberDiablo()
  -- shakes screen, next superunique becomes Uber Diablo
  for _, p in ipairs(Game.getPlayers()) do
    p:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED,"O jogo treme... Diablo Clone caminha pela terra...")
    p:getPosition():sendMagicEffect(CONST_ME_GROUNDSHAKER)
  end
  Game.setStorageValue(100001, 1) -- Uber Diablo active marker
end

-- Pandemonium Event Keys
D2C.KEYS = {
  Terror={boss="The Countess", act=1, level=85, dropRate=0.1},
  Hate={boss="The Summoner", act=2, level=85, dropRate=0.1},
  Destruction={boss="Nihlathak", act=5, level=85, dropRate=0.1},
}
D2C.UBER_PORTALS = {
  {keys={"Terror","Hate","Destruction"}, boss="Lilith", organ="Diablo's Horn"},
  {keys={"Terror","Hate","Destruction"}, boss="Uber Duriel", organ="Baal's Eye"},
  {keys={"Terror","Hate","Destruction"}, boss="Uber Izual", organ="Mephisto's Brain"},
}
D2C.UBER_TRISTRAM = {
  organs={"Diablo's Horn","Baal's Eye","Mephisto's Brain"},
  bosses={"Uber Mephisto","Uber Diablo","Uber Baal"},
  reward="Hellfire Torch"
}
function D2C.openPandemoniumPortal(player, keys)
  if #keys<3 then return false, "Precisa de 3 chaves: Terror, Hate, Destruction" end
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Portal vermelho aberto para Uber Bosses!")
  -- create portal item
  return true
end
function D2C.openUberTristram(player, organs)
  if #organs<3 then return false, "Precisa de 3 orgãos" end
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED,"Portal final para Uber Tristram aberto! Enfrente Mephisto, Baal e Diablo Ubers!")
  return true
end
