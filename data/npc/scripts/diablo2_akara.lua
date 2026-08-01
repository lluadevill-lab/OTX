-- NPC Akara - cura real, vende pocoes Diablo II, armas, charms, com modal clicavel
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)
-- Akara vende pocoes e itens iniciais Diablo II
shopModule:addBuyableItem({'super healing potion'}, 40090, 500, 1, 'super healing potion')
shopModule:addBuyableItem({'super mana potion'}, 40091, 500, 1, 'super mana potion')
shopModule:addBuyableItem({'healing potion'}, 7618, 50, 1, 'health potion') -- tibia normal
shopModule:addBuyableItem({'mana potion'}, 7620, 50, 1, 'mana potion')
shopModule:addBuyableItem({'small charm'}, 40040, 10000, 1, 'small charm')
shopModule:addBuyableItem({'grand charm'}, 40042, 50000, 1, 'grand charm')
shopModule:addBuyableItem({'horadric cube'}, 40080, 1000, 1, 'horadric cube')
shopModule:addBuyableItem({'wirts leg'}, 40081, 1000, 1, 'wirts leg')
shopModule:addBuyableItem({'token'}, 40082, 5000, 1, 'token of absolution')

shopModule:addSellableItem({'small charm'}, 40040, 5000, 'small charm')
shopModule:addSellableItem({'super healing potion'}, 40090, 250, 'super healing potion')

local function healPlayer(player)
  player:addHealth(player:getMaxHealth())
  player:addMana(player:getMaxMana())
  -- Cura condicoes: poison, paralyze etc
  if player:getCondition(CONDITION_POISON) then player:removeCondition(CONDITION_POISON) end
  if player:getCondition(CONDITION_PARALYZE) then player:removeCondition(CONDITION_PARALYZE) end
  -- PLR: reduz tempo veneno, mas cura remove
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Akara curou voce! Vida e mana cheias, veneno e paralyze removidos. PLR atual "..D2C.getAttr(player,"PLR").."%")
  player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
end

keywordHandler:addKeyword({"heal"}, StdModule.say, {npcHandler=npcHandler, text="Curando voce..."}, function(player) healPlayer(player) end)
keywordHandler:addKeyword({"cure"}, StdModule.say, {npcHandler=npcHandler, text="Curando..."}, function(player) healPlayer(player) end)

keywordHandler:addKeyword({"craft"}, StdModule.say, {npcHandler=npcHandler, text="Sou especialista em craft! Vendo Horadric Cube 1k. Receitas: 3 runas + gema -> proxima runa, Tal+Thul+PTopaz+armor -> socket, Ral+Thul+PAmy+weapon Normal -> Exceptional, Wirt's Leg + Tome Town Portal (use 40081 + 0) -> Cow Level, 3 Keys -> Uber portal, 4 essencias -> Token respec. Diga {cube} para comprar cubo."},
function(player)
  local window = ModalWindow(2002, "Akara - Craft & Loja", "Bem vindo! Eu curo e vendo pocoes Diablo II e Horadric Cube.\n\nSeu ouro: "..player:getMoney().."\nOpcoes:\n1 - Curar (gratis)\n2 - Comprar Horadric Cube (1k)\n3 - Comprar Super Healing/Mana Potion (500)\n4 - Ver receitas Cubo\n5 - Mercenarios (Diga merc)")
  window:addButton(1, "Curar")
  window:addButton(2, "Comprar Cube")
  window:addButton(3, "Comprar Pocoes")
  window:addButton(4, "Receitas")
  window:addButton(5, "Fechar")
  window:addChoice(1, "Curar vida/mana/poison")
  window:addChoice(2, "Comprar Horadric Cube 1000 gold")
  window:addChoice(3, "Comprar Super Potions 500 gold")
  window:addChoice(4, "Ver receitas Cubo")
  window:addChoice(5, "Info Mercenarios")
  window:sendToPlayer(player)
end)

keywordHandler:addKeyword({"cube"}, StdModule.say, {npcHandler=npcHandler, text="Horadric Cube custa 1000 gold, digo {buy cube} ou use shop."},
function(player)
  if player:getMoney()>=1000 then
    player:removeMoney(1000)
    player:addItem(40080,1)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Voce comprou Horadric Cube! Use-o como container 3x4, coloque itens dentro e use !d2cube ou clique no cubo.")
  else
    player:sendTextMessage(MESSAGE_STATUS_SMALL,"Ouro insuficiente")
  end
end)

keywordHandler:addKeyword({"merc"}, StdModule.say, {npcHandler=npcHandler, text="Mercenarios: Act1 Rogue com Inner Sight (reduz defesa), Act2 Desert com auras Prayer (cura), Defiance (+def), Blessed Aim (+AR), Thorns (retorna dano), Holy Freeze (lenta), Might (+dano fisico crucial!), Act3 Iron Wolf mago fire/cold/light, Act5 Barbaro tank Bash/Stun. Eles sobem de nivel com voce, usam equip arma/armor/helm e auras ativas. Contrate com !d2merc 1-5 ou va no Greiz (Act2). Diga {hire merc}?"}
)

keywordHandler:addKeyword({"shop"}, StdModule.say, {npcHandler=npcHandler, text="Abro shop: super healing/mana potion 500, charms, cube 1k, wirts leg 1k, token respec 5k."})

npcHandler:addModule(FocusModule:new())
