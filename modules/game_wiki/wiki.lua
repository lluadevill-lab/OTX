wikiWindow = nil
wikiButton = nil

local listPanel = nil
local detailPanel = nil
local detailTitle = nil
local detailText = nil
local topicsScrollPanel = nil
local detailScrollPanel = nil
local topicsScrollBar = nil
local detailScrollBar = nil

-- ==========================
--  ORDEM DOS TÓPICOS (como solicitado)
-- ==========================
local topicOrder = {
  "Auto Loot",
  "BagLoot",
  "Bank",
  "Bestiary",
  "Change Vocation",
  "Death Recover",
  "Exp & Loot",
  "Extra Information",
  "Find NPC",
  "Forge",
  "Houses",
  "Infusion Attributes",
  "Instanced hunts",
  "Items",
  "Mana/Life Leech",
  "MC & Bot",
  "Minimap",
  "Monsters",
  "Monsters Demoniacs",
  "Non-PvP",
  "Online Points",
  "Premium Account",
  "Promotions",
  "Quests",
  "Rookie Battle",
  "Roulette",
  "Soul Bosses",
  "Spells",
  "Stamina",
  "Summons",
  "Tasks",
  "Trainers",
  "Traveling",
  "Treasure Chest",
  "Vocation Guide",
}

-- Texto base lorem ipsum para gerar conteúdo longo e rolável
local loremBase = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. 
Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.

Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.

]]

local function buildLorem(topic)
  local intro = string.format("== %s ==\n\nBem-vindo à seção de %s.\nAqui você pode descrever detalhadamente como o sistema funciona no seu servidor.\n\n", topic, topic)
  local body = ""
  for i=1,6 do
    body = body .. string.format("[%s - Parte %d]\n%s\n\n", topic, i, loremBase)
  end
  body = body .. string.format("Dicas finais sobre %s:\n- Lorem ipsum tip 1\n- Lorem ipsum tip 2\n- Lorem ipsum tip 3\n\nFim da documentação de %s.\n", topic, topic)
  return intro .. body
end

-- ==========================
--  CONTEÚDO EDITÁVEL
--  Você pode preencher cada tópico aqui manualmente.
--  Se deixar como nil, vai usar lorem ipsum automático.
-- ==========================
wikiData = {}

-- Preenche automaticamente com lorem ipsum (você pode substituir depois)
for _, title in ipairs(topicOrder) do
  wikiData[title] = buildLorem(title)
end

-- EXEMPLOS DE COMO PERSONALIZAR (descomente e edite):
-- Para editar, descomente as linhas abaixo e troque o texto:
-- wikiData["Auto Loot"] = [[
-- Sistema de Auto Loot
-- --------------------
-- O Auto Loot permite que seu personagem colete automaticamente itens de criaturas.
--
-- Como usar:
-- !autoloot add, nome do item
-- !autoloot remove, nome do item
-- !autoloot clear
-- !autoloot list
--
-- Você pode configurar listas, etc. Coloque o texto que quiser, ele será rolável.
-- ]]
--
-- wikiData["Bank"] = [[
-- Sistema de Bank
-- --------------
-- Informações detalhadas sobre o Bank...
-- ]]

local function getChild(id)
  if not wikiWindow then return nil end
  if wikiWindow.recursiveGetChildById then
    return wikiWindow:recursiveGetChildById(id)
  else
    return wikiWindow:getChildById(id)
  end
end

function init()
  connect(g_game, {
    onGameStart = online,
    onGameEnd = offline
  })

  g_ui.importStyle('wiki')

  wikiWindow = g_ui.displayUI('wiki')
  wikiWindow:hide()

  -- referencia dos widgets (robusta)
  listPanel = getChild('listPanel')
  detailPanel = getChild('detailPanel')
  detailTitle = getChild('detailTitle')
  detailText = getChild('detailText')
  topicsScrollPanel = getChild('topicsScrollPanel')
  detailScrollPanel = getChild('detailScrollPanel')
  topicsScrollBar = getChild('topicsScrollBar')
  detailScrollBar = getChild('detailScrollBar')

  populateTopics()

  -- Cria botão no topmenu (se disponível)
  if modules.client_topmenu then
    wikiButton = modules.client_topmenu.addLeftGameButton('wikiButton', tr('Wiki'), '/images/topbuttons/ciclopedia', toggle, false, 6)
  else
    -- fallback tenta novamente após 1s caso topmenu ainda não carregou
    scheduleEvent(function()
      if modules.client_topmenu and not wikiButton then
        wikiButton = modules.client_topmenu.addLeftGameButton('wikiButton', tr('Wiki'), '/images/topbuttons/ciclopedia', toggle, false, 6)
        if g_game.isOnline() then wikiButton:show() else wikiButton:hide() end
      end
    end, 1000)
  end

  if g_game.isOnline() then
    online()
  else
    offline()
  end
end

function terminate()
  disconnect(g_game, {
    onGameStart = online,
    onGameEnd = offline
  })

  if wikiWindow then
    wikiWindow:destroy()
    wikiWindow = nil
  end

  if wikiButton then
    wikiButton:destroy()
    wikiButton = nil
  end

  listPanel = nil
  detailPanel = nil
  detailTitle = nil
  detailText = nil
  topicsScrollPanel = nil
  detailScrollPanel = nil
end

function online()
  if wikiButton then
    wikiButton:show()
  end
end

function offline()
  hide()
  if wikiButton then
    wikiButton:hide()
  end
end

function populateTopics()
  if not topicsScrollPanel then return end
  topicsScrollPanel:destroyChildren()

  local columns = 3
  if g_app.isMobile() then
    columns = 1
  end

  local currentRow = nil
  local countInRow = 0

  for idx, title in ipairs(topicOrder) do
    if not currentRow or countInRow >= columns then
      currentRow = g_ui.createWidget('WikiRow', topicsScrollPanel)
      -- garante que a linha ocupe largura total e não colapse
      if currentRow then
        currentRow:setId('wikiRow_' .. math.floor((idx-1)/columns + 1))
      end
      countInRow = 0
    end

    if currentRow then
      local button = g_ui.createWidget('WikiButton', currentRow)
      if button then
        button:setText(title)
        local safeId = title:gsub("%s+", "_"):gsub("&", "and"):gsub("[^%w_]", "")
        button:setId('wikiBtn_' .. safeId)
        button:setTooltip(tr('Clique para ver informações sobre ') .. title)
        button.onClick = function()
          showTopic(title)
        end
        countInRow = countInRow + 1
      end
    end
  end

  -- força atualização do scroll após criar tudo
  if topicsScrollPanel.updateScrollBars then
    scheduleEvent(function()
      if topicsScrollPanel and topicsScrollPanel.updateScrollBars then
        topicsScrollPanel:updateScrollBars()
      end
      if topicsScrollBar then
        topicsScrollBar:setValue(0)
      end
    end, 50)
  end
end

function showTopic(topicName)
  if not wikiWindow or not detailTitle or not detailText then return end

  local text = wikiData[topicName]
  if not text or text == "" then
    text = buildLorem(topicName)
  end

  detailTitle:setText(topicName)
  detailText:setText(text)

  if detailScrollBar then
    detailScrollBar:setValue(0)
  end
  if detailScrollPanel then
    addEvent(function()
      if detailScrollBar then
        detailScrollBar:setValue(0)
      end
      if detailScrollPanel then
        detailScrollPanel:updateScrollBars()
      end
    end, 50)
  end

  if listPanel then listPanel:hide() end
  if detailPanel then detailPanel:show() end

  if not wikiWindow:isVisible() then
    wikiWindow:show()
    wikiWindow:raise()
    wikiWindow:focus()
  end
end

function showList()
  if not wikiWindow then return end
  if detailPanel then detailPanel:hide() end
  if listPanel then listPanel:show() end
  if topicsScrollBar then
    topicsScrollBar:setValue(0)
  end
end

function hide()
  if wikiWindow then
    wikiWindow:hide()
    showList()
  end
end

function show()
  if wikiWindow then
    showList()
    wikiWindow:show()
    wikiWindow:raise()
    wikiWindow:focus()
  end
end

function toggle()
  if wikiWindow and wikiWindow:isVisible() then
    hide()
  else
    show()
  end
end

function backOrClose()
  if not wikiWindow or not wikiWindow:isVisible() then return end
  if detailPanel and detailPanel:isVisible() then
    showList()
  else
    hide()
  end
end

-- API pública para adicionar/editar tópicos em tempo de execução
function addCustomTopic(title, content)
  if not title then return end
  for _, t in ipairs(topicOrder) do
    if t == title then
      wikiData[title] = content or buildLorem(title)
      if detailTitle and detailTitle:getText() == title then
        detailText:setText(wikiData[title])
      end
      return
    end
  end
  table.insert(topicOrder, title)
  wikiData[title] = content or buildLorem(title)
  populateTopics()
end

function setTopicContent(title, content)
  wikiData[title] = content
  if detailTitle and detailTitle:getText() == title and detailText then
    detailText:setText(content)
  end
end

function getTopicContent(title)
  return wikiData[title]
end
