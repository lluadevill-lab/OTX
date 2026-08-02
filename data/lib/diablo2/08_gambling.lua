-- Gambling: gastar ouro nos NPCs, qualidade escala com nível do personagem - agora da item real existente no Tibia.otb
D2C = D2C or {}
D2C.GAMBLE_COST = {
  ring=80000, amulet=120000, weapon=60000, armor=50000,
}

-- Mapeamento D2 item -> Tibia item existente (evita invalid thing type 17222 etc)
D2C.GAMBLE_ITEMS = {
  -- charms e gemas que existem no Tibia.otb
  2143, -- white pearl = Small Charm
  2144, -- black pearl = Large Charm
  2145, -- small diamond = Grand Charm
  2146, -- small sapphire = Gheed's Fortune
  2147, -- small ruby = Annihilus
  2149, -- small emerald = Torch
  2150, -- small amethyst = Rainbow Facet Fire
  9970, -- small topaz = Facet Cold
  2151, -- talon = Facet Lightning
  2322, -- voodoo doll = Facet Poison
  2260, -- blank rune = El Rune
  2274, -- avalanche rune = Tal Rune
  2288, -- stone shower rune = Amn Rune
  2302, -- fireball rune = Dol Rune
  2313, -- explosion rune = Ko Rune
  7618, -- health potion = Super Healing Potion
  7620, -- mana potion = Super Mana Potion
  1988, -- backpack = Horadric Cube (container)
}

function D2C.gambleItem(player)
  local clvl = player:getLevel()
  local ilvl = clvl - 5 + math.random(0,10)
  ilvl = math.max(1, math.min(99, ilvl))
  local roll = math.random(1000)
  local quality
  if clvl >= 80 and roll < 20 then quality = "unique"
  elseif clvl >= 60 and roll < 50 then quality = "set"
  elseif roll < 250 then quality = "rare"
  elseif roll < 700 then quality = "magic"
  else quality = "normal" end
  local prefix = D2C.rollPrefix(ilvl, D2C.getAreaLevel("Pit",D2C.getAttr(player,"DIFF")) or ilvl)
  local suffix = D2C.rollSuffix(ilvl, ilvl)
  local item = {ilvl=ilvl, quality=quality, prefix=prefix, suffix=suffix, gambled=true, clvl=clvl}
  return item
end

function D2C.gambleCost(player, itemType)
  return D2C.GAMBLE_COST[itemType] or 60000
end

function D2C.doGamble(player, npc, itemType)
  local cost = D2C.gambleCost(player, itemType)
  if player:getMoney() < cost then
    player:sendTextMessage(MESSAGE_STATUS_SMALL,"Ouro insuficiente para aposta. Custo "..cost)
    return false
  end
  player:removeMoney(cost)
  local item = D2C.gambleItem(player)
  -- Da item real existente no Tibia, com descricao custom
  local chosenId = D2C.GAMBLE_ITEMS[math.random(#D2C.GAMBLE_ITEMS)]
  local added = nil
  local ok, result = pcall(function() return player:addItem(chosenId, 1) end)
  if ok then added = result end
  if added then
    local desc = string.format("Gambled %s ilvl %d %s [%s/%s] - Gheed - MF %d%%", itemType or "item", item.ilvl, item.quality, item.prefix and item.prefix.name or "-", item.suffix and item.suffix.name or "-", D2C.getAttr(player,"MF"))
    pcall(function() added:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, desc) end)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Gamble: Recebeu item %d (%s) ilvl %d %s [%s/%s]! Desc: %s - Gheed ainda ri mas te deu item de verdade.", chosenId, added:getName(), item.ilvl, item.quality, item.prefix and item.prefix.name or "-", item.suffix and item.suffix.name or "-", desc))
  else
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Gamble: ilvl %d %s [%s/%s] - Gheed ainda ri de voce (falha ao criar item %d, tente !i %d)", item.ilvl, item.quality, item.prefix and item.prefix.name or "-", item.suffix and item.suffix.name or "-", chosenId, chosenId))
  end
  return item
end
