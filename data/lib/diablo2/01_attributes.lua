-- Attributes: STR DEX VIT ENE, requisitos, stamina - SAFE for monsters/players
D2C = D2C or {}

function D2C.getAttr(creature, key)
  if not creature then return 0 end
  local st = D2C.STORAGES[key:upper()] or D2C.STORAGES[key]
  if not st then return 0 end
  if not creature.getStorageValue then return 0 end
  local ok, v = pcall(function() return creature:getStorageValue(st) end)
  if not ok or v==nil or v<0 then return 0 end
  return v
end

function D2C.setAttr(creature, key, val)
  if not creature then return 0 end
  local st = D2C.STORAGES[key:upper()] or D2C.STORAGES[key]
  if not st then return 0 end
  if not creature.setStorageValue then return 0 end
  pcall(function() creature:setStorageValue(st, math.max(0, math.floor(val))) end)
  return val
end

function D2C.getClass(creature)
  if not creature then return "Barbarian" end
  if not creature.getVocation then return "Barbarian" end
  local ok, voc = pcall(function() return creature:getVocation():getId() end)
  if not ok then return "Barbarian" end
  local map = {[1]="Sorceress",[2]="Sorceress",[3]="Paladin",[4]="Paladin",[5]="Amazon",[6]="Amazon",[7]="Barbarian",[8]="Barbarian",[9]="Druid",[10]="Necromancer",[11]="Assassin",
               [12]="Amazon",[13]="Assassin",[14]="Barbarian",[15]="Druid",[16]="Necromancer",[17]="Paladin",[18]="Sorceress"}
  return map[voc] or "Barbarian"
end

function D2C.calcLife(player)
  if not player or not player.getLevel then return 100 end
  local cls = D2C.getClass(player)
  local base = D2C.CLASS_BASE[cls] or D2C.CLASS_BASE["Barbarian"]
  local vit = D2C.getAttr(player,"VIT")
  local lvl = D2C.safeLevel(player)
  return math.floor( (base.vit+vit)*base.lifePerVit + base.lifePerLvl*lvl + 50 )
end

function D2C.calcMana(player)
  if not player or not player.getLevel then return 50 end
  local cls = D2C.getClass(player)
  local base = D2C.CLASS_BASE[cls] or D2C.CLASS_BASE["Barbarian"]
  local ene = D2C.getAttr(player,"ENE")
  local lvl = D2C.safeLevel(player)
  return math.floor( (base.ene+ene)*base.manaPerEne + base.manaPerLvl*lvl + 15 )
end

function D2C.calcStamina(player)
  if not player then return 100 end
  local cls = D2C.getClass(player)
  local base = D2C.CLASS_BASE[cls] or D2C.CLASS_BASE["Barbarian"]
  local vit = D2C.getAttr(player,"VIT")
  return math.floor( 100 + vit*base.staminaPerVit + D2C.safeLevel(player) )
end

function D2C.requireCheck(player, itemReq)
  if not player then return true end
  local base = D2C.CLASS_BASE[D2C.getClass(player)] or D2C.CLASS_BASE["Barbarian"]
  local str = D2C.getAttr(player,"STR") + base.str
  local dex = D2C.getAttr(player,"DEX") + base.dex
  if itemReq.isEthereal then
    str = str + D2C.ETHEREAL_REQ_REDUCTION
    dex = dex + D2C.ETHEREAL_REQ_REDUCTION
  end
  if (itemReq.str or 0) > str then return false, "Força insuficiente" end
  if (itemReq.dex or 0) > dex then return false, "Destreza insuficiente" end
  return true
end

D2 = D2 or {}
function D2.get(player, stat) return D2C.getAttr(player, stat) end
function D2.add(player, stat, amount)
  local cur = D2C.getAttr(player, stat)
  D2C.setAttr(player, stat, cur+amount)
  return cur+amount
end
