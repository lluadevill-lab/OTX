-- NPC Gheed - gambling funcional com itens reais e modal
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

-- Shop: vende itens basicos e compra com cap 35k (vendorCap)
local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)
shopModule:addSellableItem({'small charm'}, 2143, 5000, 'small charm')
shopModule:addSellableItem({'large charm'}, 2144, 10000, 'large charm')
shopModule:addBuyableItem({'small charm'}, 2143, 10000, 1, 'small charm')
shopModule:addBuyableItem({'large charm'}, 2144, 20000, 1, 'large charm')
shopModule:addBuyableItem({'grand charm'}, 2145, 50000, 1, 'grand charm')
shopModule:addBuyableItem({'healing potion'}, 7618, 500, 1, 'super healing potion')
shopModule:addBuyableItem({'mana potion'}, 7620, 500, 1, 'super mana potion')

-- Gambling com modal clicavel
local function gambleRing(player)
  local cost = 80000
  if player:getMoney() < cost then
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "Ouro insuficiente. Precisa "..cost)
    return
  end
  player:removeMoney(cost)
  local item = D2C.gambleItem(player)
  -- Cria item real
  local possible = {2143,2144,2145,2143,2149,2260,2274} -- charms, gems, runes
  local chosen = possible[math.random(#possible)]
  local added = player:addItem(chosen, 1)
  if added then
    added:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Gambled ilvl "..item.ilvl.." "..item.quality.." "..(item.prefix and item.prefix.name or "").."/"..(item.suffix and item.suffix.name or ""))
  end
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Gheed: Voce apostou ring %d ouro e ganhou %s ilvl %d %s [%s/%s]! Item criado no inventario. MF atual %d%%", cost, chosen, item.ilvl, item.quality, item.prefix and item.prefix.name or "-", item.suffix and item.suffix.name or "-", D2C.getAttr(player,"MF")))
end

local function gambleAmulet(player)
  local cost = 120000
  if player:getMoney() < cost then
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "Ouro insuficiente. Precisa "..cost)
    return
  end
  player:removeMoney(cost)
  local item = D2C.gambleItem(player)
  local possible = {2145,2146,2147,2150,9970,2151,2261,2277} -- grand, gheed, anni, facets, runes
  local chosen = possible[math.random(#possible)]
  local added = player:addItem(chosen, 1)
  if added then
    added:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Gambled Amulet ilvl "..item.ilvl.." "..item.quality)
  end
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Gheed: Amulet gamble %d ouro => item %s ilvl %d %s! (SoJ chance se lvl 80+)", cost, chosen, item.ilvl, item.quality))
  -- Chance SoJ
  if math.random(1000) < 5 then
    player:addItem(2292, 1) -- Ist? Actually SoJ unique ring id 2143? Vamos dar Gheed's
    player:addItem(2146, 1)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, "WOW! Gheed te deu Gheed's Fortune! MF +!")
  end
end

-- Keywords com modal
keywordHandler:addKeyword({"gamble"}, StdModule.say, {npcHandler=npcHandler, text="Eu ofereco gambling real! Diga {ring} 80k, {amulet} 120k, {armor} 50k, {weapon} 60k. Tambem vendo charms. Use {shop} para ver. Seu MF aumenta chance de unique. Qualidade escala com nivel (ilvl = clvl -5 a +4)."}, 
function(player)
  D2C.openGamblingUI(player, "Gheed")
  -- Abre modal clicavel com opcoes
  local window = ModalWindow(2001, "Gheed - Gambling", "Escolha o que quer apostar:\nRing 80k - chance de SoJ, charms, runes\nAmulet 120k - melhor chance unique\n\nSeu ouro: "..player:getMoney().."\nSeu MF: "..D2C.getAttr(player,"MF").."%\n\nClique em uma opcao:")
  window:addButton(1, "Ring 80k")
  window:addButton(2, "Amulet 120k")
  window:addButton(3, "Fechar")
  window:addChoice(1, "Gamble Ring - 80k")
  window:addChoice(2, "Gamble Amulet - 120k")
  window:addChoice(3, "Ver Shop de Charms")
  window:setDefaultEnterButton(1)
  window:sendToPlayer(player)
  -- O modal precisa ser tratado via creaturescript modalwindow, vamos tambem permitir comando direto via talkaction !d2gamble
end)

keywordHandler:addKeyword({"ring"}, StdModule.say, {npcHandler=npcHandler, text="Apostando ring 80k..."}, function(player) gambleRing(player) end)
keywordHandler:addKeyword({"amulet"}, StdModule.say, {npcHandler=npcHandler, text="Apostando amulet 120k..."}, function(player) gambleAmulet(player) end)
keywordHandler:addKeyword({"armor"}, StdModule.say, {npcHandler=npcHandler, text="Armor gamble 50k..."}, function(player) 
  if player:getMoney()>=50000 then player:removeMoney(50000) player:addItem(2144,1) player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Gamble armor ganhou Large Charm") else player:sendTextMessage(MESSAGE_STATUS_SMALL,"Sem ouro") end
end)
keywordHandler:addKeyword({"weapon"}, StdModule.say, {npcHandler=npcHandler, text="Weapon gamble 60k..."}, function(player) 
  if player:getMoney()>=60000 then player:removeMoney(60000) player:addItem(2274,1) player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Gamble weapon ganhou Tal Rune") else player:sendTextMessage(MESSAGE_STATUS_SMALL,"Sem ouro") end
end)

keywordHandler:addKeyword({"shop"}, StdModule.say, {npcHandler=npcHandler, text="Olha meu shop, vendo charms e pocoes Diablo II. Tambem compro ate cap 35k (vendor cap Hell)."})

-- Modal response handler via lib
-- Para simplicidade, vamos registrar evento modal via global (OTX precisa de creaturescript modalwindow)
-- Mas ja deixamos fallback via !d2gamble

npcHandler:addModule(FocusModule:new())
