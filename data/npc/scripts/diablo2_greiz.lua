-- NPC Greiz - mercenaries Act2 funcional com modal que da merc item
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local function hireMerc(player, act, aura)
  local cost = 10000
  if player:getMoney() < cost then
    player:sendTextMessage(MESSAGE_STATUS_SMALL,"Precisa "..cost.." gold para contratar mercenario")
    return
  end
  player:removeMoney(cost)
  local merc = D2C.spawnMerc(player, act, 1, aura)
  -- Da um item que representa contrato merc? Ou summon?
  player:addItem(40042, 1) -- Grand Charm como token merc temporario
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Mercenario contratado: Act"..act.." "..aura.." Lvl "..player:getLevel().."! Ele sobe com voce, usa arma/armor/helm (etereo sem gastar dura) e da aura ativa crucial. Use !d2merc para ver status. Aura Might + dano fisico e Holy Freeze lenta sao mais importantes.")
  player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
end

keywordHandler:addKeyword({"hire"}, StdModule.say, {npcHandler=npcHandler, text="Desert Mercenary Act2: escolha aura - Normal Combat Prayer (cura), Defense Defiance (+def), Offense Blessed Aim (+AR); Nightmare Combat Thorns (retorna dano), Defense Holy Freeze (lenta inimigos - essencial!), Offense Might (+dano fisico crucial - melhor!). Hell volta a Normal. Custo 10k. Diga {hire prayer}, {hire defiance}, {hire might}, {hire holy freeze} ou {hire thorns}. Ou abre modal com {merc}."},
function(player)
  local window = ModalWindow(2004, "Greiz - Mercenarios Act2", "Desert Mercenary - Crucial para build!\n\nNormal:\n- Combat: Prayer (cura lenta)\n- Defense: Defiance (+defesa)\n- Offense: Blessed Aim (+AR)\n\nNightmare (melhores):\n- Combat: Thorns (retorna dano)\n- Defense: Holy Freeze (lenta inimigos ao redor - MUITO FORTE, mesmo com Cannot Be Frozen nao protege totalmente? Sim, Holy Freeze ainda lenta)\n- Offense: Might (aumenta dano fisico +230% lvl 20 - ESSENCIAL para fisico)\n\nHell: igual Normal\n\nCusto 10k cada. Qual quer contratar?\nSeu ouro: "..player:getMoney())
  window:addButton(1, "Might")
  window:addButton(2, "Holy Freeze")
  window:addButton(3, "Prayer")
  window:addButton(4, "Defiance")
  window:addButton(5, "Fechar")
  window:addChoice(1, "Hire Might - +dano fisico Nightmare Offense")
  window:addChoice(2, "Hire Holy Freeze - lenta inimigos Nightmare Defense")
  window:addChoice(3, "Hire Prayer - cura Normal Combat")
  window:addChoice(4, "Hire Defiance - +def Normal Defense")
  window:addChoice(5, "Hire Thorns - retorna dano Nightmare Combat")
  window:sendToPlayer(player)
end)

keywordHandler:addKeyword({"hire might"}, StdModule.say, {npcHandler=npcHandler, text="Contratando Might..."}, function(player) hireMerc(player, 2, "Might") end)
keywordHandler:addKeyword({"hire holy freeze"}, StdModule.say, {npcHandler=npcHandler, text="Contratando Holy Freeze..."}, function(player) hireMerc(player, 2, "Holy Freeze") end)
keywordHandler:addKeyword({"hire prayer"}, StdModule.say, {npcHandler=npcHandler, text="Contratando Prayer..."}, function(player) hireMerc(player, 2, "Prayer") end)
keywordHandler:addKeyword({"hire defiance"}, StdModule.say, {npcHandler=npcHandler, text="Contratando Defiance..."}, function(player) hireMerc(player, 2, "Defiance") end)
keywordHandler:addKeyword({"hire thorns"}, StdModule.say, {npcHandler=npcHandler, text="Contratando Thorns..."}, function(player) hireMerc(player, 2, "Thorns") end)
keywordHandler:addKeyword({"merc"}, StdModule.say, {npcHandler=npcHandler, text="Digite hire might, hire holy freeze, hire prayer etc ou abra modal com hire."}, function(player) 
  local window = ModalWindow(2004, "Greiz - Merc", "Escolha aura")
  window:addButton(1, "Might")
  window:addButton(2, "Holy Freeze")
  window:sendToPlayer(player)
end)

npcHandler:addModule(FocusModule:new())
