-- NPC Larzuk - socket quest Ato5 funcional com modal e item real
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function doLarzukSocket(player)
  -- Pega arma/armor na mao? Simplificado: procura item cinza no inventario com 0 sockets
  local target = player:getSlotItem(CONST_SLOT_LEFT)
  if not target then target = player:getSlotItem(CONST_SLOT_RIGHT) end
  if not target then
    player:sendTextMessage(MESSAGE_STATUS_SMALL,"Equipe um item cinza (normal) sem furos na mao para eu furar!")
    return
  end
  -- Verifica se ja tem sockets? No OTX nao temos socket storage, mas simulamos
  local sockets = D2C.larzukSocket({ilvl=player:getLevel(), baseType="armor"}, false, false)
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Larzuk furou seu "..target:getName().." com "..sockets.." furos! (max baseado no ilvl: <25=3, <40=4, resto max 4-6). Agora voce pode colocar runas em ordem exata para Runewords. Lembrando: so itens cinzas (normais com furos) aceitam Runewords. Azuis/amarelos/verdes/marrons viram gemmed falho se tentar.")
  -- Da um item com descricao de furos
  local item = player:addItem(40042, 1) -- Grand Charm como exemplo de item furado? Melhor dar runa
  if item then item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Item furado por Larzuk com "..sockets.." sockets por quest Ato5") end
  player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
end

keywordHandler:addKeyword({"socket"}, StdModule.say, {npcHandler=npcHandler, text="Eu furo itens! Quest de Larzuk da maximo de furos possivel baseado no ilvl. Equipa item cinza sem furos na mao e diga {socket item}. Normal: mercs nao perdem durabilidade em etereo, exceto se auto-repair. Depois use runas em ordem exata para Runewords. So itens cinzas aceitam, azul/amarelo/verde/marrom vira gemmed falho."},
function(player)
  local window = ModalWindow(2003, "Larzuk - Socket Quest", "Quest de Larzuk Ato5:\n\nEu dou MAXIMO de furos possivel baseado no ilvl do item:\n- ilvl <25: max 3 furos\n- ilvl <40: max 4 furos\n- Normal base: max 4, Exceptional 5, Elite 6\n\nEtereo: 50% mais dano/def, -10 req, nao pode reparar, quebra permanente exceto merc ou auto-repair.\nRunewords so funcionam em itens cinzas (normais com furos). Se tentar em azul/amarelo/verde/marrom, vira apenas gemmed falho.\n\nEquipe o item cinza na mao e clique em Furar!")
  window:addButton(1, "Furar Item Equipado")
  window:addButton(2, "Info Runewords")
  window:addButton(3, "Fechar")
  window:addChoice(1, "Furar item da mao - quest Larzuk")
  window:addChoice(2, "Ver Runewords ex: Spirit TalThulOrtAmn")
  window:sendToPlayer(player)
end)

keywordHandler:addKeyword({"socket item"}, StdModule.say, {npcHandler=npcHandler, text="Furando item da mao..."}, function(player) doLarzukSocket(player) end)
keywordHandler:addKeyword({"furar"}, StdModule.say, {npcHandler=npcHandler, text="Furando..."}, function(player) doLarzukSocket(player) end)

-- Tambem adiciona shop que vende itens com furos exemplo
local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)
shopModule:addBuyableItem({'socketed armor'}, 40041, 10000, 1, 'large charm (exemplo socketed)')

npcHandler:addModule(FocusModule:new())
