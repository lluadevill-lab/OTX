-- Gambling: gastar ouro nos NPCs, qualidade escala com nível do personagem
D2C = D2C or {}
D2C.GAMBLE_COST = {
  ring=80000, amulet=120000, weapon=60000, armor=50000,
}
D2C.GAMBLE_QUALITY = {
  -- chance based on char level
  -- clvl 1: 0% unique, high magic; clvl 80+: 2-3% unique, 10% set, 30% rare
}
function D2C.gambleItem(player)
  local clvl = player:getLevel()
  local ilvl = clvl - 5 + math.random(0,10) -- gamble ilvl = clvl + random -5 to +4
  ilvl = math.max(1, math.min(99, ilvl))
  local roll = math.random(1000)
  local quality
  if clvl >= 80 and roll < 20 then quality = "unique"
  elseif clvl >= 60 and roll < 50 then quality = "set"
  elseif roll < 250 then quality = "rare"
  elseif roll < 700 then quality = "magic"
  else quality = "normal" end
  -- affix level from ilvl
  local prefix = D2C.rollPrefix(ilvl, D2C.getAreaLevel("Pit",D2C.getAttr(player,"DIFF")) or ilvl)
  local suffix = D2C.rollSuffix(ilvl, ilvl)
  local item = {ilvl=ilvl, quality=quality, prefix=prefix, suffix=suffix, gambled=true, clvl=clvl}
  return item
end
function D2C.gambleCost(player, itemType)
  return D2C.GAMBLE_COST[itemType] or 60000
end

-- NPC Gheed etc gambling script hook
function D2C.doGamble(player, npc, itemType)
  local cost = D2C.gambleCost(player, itemType)
  if player:getMoney() < cost then
    player:sendTextMessage(MESSAGE_STATUS_SMALL,"Ouro insuficiente para aposta. Custo "..cost)
    return false
  end
  player:removeMoney(cost)
  local item = D2C.gambleItem(player)
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,string.format("Gamble: ilvl %d %s [%s/%s] - Gheed ainda ri de você", item.ilvl, item.quality, item.prefix and item.prefix.name or "-", item.suffix and item.suffix.name or "-"))
  return item
end
