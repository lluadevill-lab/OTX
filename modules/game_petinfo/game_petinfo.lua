local OPCODE_PET = 95
local window
local petsData = {}
local currentIndex = 1
local releaseTimer = nil
local updateEvent = nil
local isCompact = false
local wantActiveAfterRefresh = false

local RANK_COLORS = {
    ["Comum"] = "#aaaaaa", ["Incomum"] = "#55ff55",
    ["Raro"] = "#55aaff", ["Elite"] = "#d055ff", ["Lendario"] = "#ffaa00"
}

local function getIvColor(value)
    local val = tonumber(value) or 0
    if val >= 30 then return "#ffcc00" end
    if val >= 21 then return "#55ff55" end
    if val >= 11 then return "#ffff55" end
    return "#ff5555"
end

function init()
    connect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
    window = g_ui.displayUI('game_petinfo.otui')
    window:hide()
    
    local function bindBtn(id, func)
        local btn = window:recursiveGetChildById(id)
        if btn then btn.onClick = func end
    end
    
    bindBtn('prevBtn', function() navigate(-1) end)
    bindBtn('nextBtn', function() navigate(1) end)
    bindBtn('selectBtn', requestSwap)
    bindBtn('healBtn', function() sendAction("HEAL") end)
    bindBtn('reviveBtn', function() sendAction("REVIVE") end)
    bindBtn('mountBtn', handleMount)
    bindBtn('releaseBtn', tryRelease)
    bindBtn('closeBtnX', function() hide() end)
    bindBtn('minBtn', toggleCompact)
    
    bindBtn('compactSummonBtn', compactSwap)
    bindBtn('compactHealBtn', function() sendActionToActive("HEAL") end)
    bindBtn('compactReviveBtn', function() sendActionToActive("REVIVE") end)
    bindBtn('compactMountBtn', compactMount)
    
    if g_game.isOnline() then ProtocolGame.registerExtendedOpcode(OPCODE_PET, onOpcode) end
end

function terminate()
    disconnect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
    if g_game.getProtocolGame() then ProtocolGame.unregisterExtendedOpcode(OPCODE_PET) end
    if window then window:destroy() end
    stopUpdateLoop()
    if releaseTimer then removeEvent(releaseTimer) end
end

function onGameStart() ProtocolGame.registerExtendedOpcode(OPCODE_PET, onOpcode) end
function onGameEnd() 
    ProtocolGame.unregisterExtendedOpcode(OPCODE_PET) 
    if window then window:hide() end 
    stopUpdateLoop()
end

function show() 
    if window then 
        window:show() 
        window:raise() 
        startUpdateLoop()
    end 
end

function hide() 
    if window then 
        window:hide() 
        stopUpdateLoop()
    end 
end

function startUpdateLoop()
    stopUpdateLoop()
    local function doRefresh()
        if window and window:isVisible() and g_game.getProtocolGame() then
            g_game.getProtocolGame():sendExtendedOpcode(OPCODE_PET, '{"action":"REFRESH"}')
        end
        if window and window:isVisible() then
            updateEvent = scheduleEvent(doRefresh, 600)
        end
    end
    updateEvent = scheduleEvent(doRefresh, 600)
end

function stopUpdateLoop()
    if updateEvent then 
        removeEvent(updateEvent) 
        updateEvent = nil 
    end
end

function toggleCompact()
    isCompact = not isCompact
    
    local header = window:recursiveGetChildById('headerPanel')
    local basic = window:recursiveGetChildById('basicPanel')
    local title = window:recursiveGetChildById('titleIv')
    local ivP = window:recursiveGetChildById('ivPanel')
    local selBtn = window:recursiveGetChildById('selectBtn')
    local actP = window:recursiveGetChildById('actionPanel')
    local sep = window:recursiveGetChildById('sep1')
    local minBtn = window:recursiveGetChildById('minBtn')
    local compactP = window:recursiveGetChildById('compactPanel')
    
    if isCompact then
        window:setHeight(70)
        if minBtn then minBtn:setText("+") end
        if header then header:setVisible(false) end
        if basic then basic:setVisible(false) end
        if title then title:setVisible(false) end
        if ivP then ivP:setVisible(false) end
        if selBtn then selBtn:setVisible(false) end
        if sep then sep:setVisible(false) end
        if actP then actP:setVisible(false) end
        if compactP then compactP:setVisible(true) end
        updateCompactButtons()
    else
        window:setHeight(580)
        if minBtn then minBtn:setText("-") end
        if header then header:setVisible(true) end
        if basic then basic:setVisible(true) end
        if title then title:setVisible(true) end
        if ivP then ivP:setVisible(true) end
        if selBtn then selBtn:setVisible(true) end
        if sep then sep:setVisible(true) end
        if actP then actP:setVisible(true) end
        if compactP then compactP:setVisible(false) end
    end
end

function getActivePet()
    for i, pet in ipairs(petsData) do
        if pet.is_active then
            return pet, i
        end
    end
    return nil, 0
end

function updateCompactButtons()
    if not isCompact then return end
    
    local data = getActivePet()
    if not data then return end
    
    local btnSummon = window:recursiveGetChildById('compactSummonBtn')
    local btnHeal = window:recursiveGetChildById('compactHealBtn')
    local btnRevive = window:recursiveGetChildById('compactReviveBtn')
    local btnMount = window:recursiveGetChildById('compactMountBtn')
    
    if btnSummon then
        if data.is_dead then
            btnSummon:setText("MORTO")
            btnSummon:setColor("#ff5555")
            btnSummon:setEnabled(false)
        elseif data.is_mounted then
            btnSummon:setText("Montado")
            btnSummon:setColor("#555555")
            btnSummon:setEnabled(false)
        elseif data.is_summoned then
            btnSummon:setText("Recolher")
            btnSummon:setColor("#ffaaaa")
            btnSummon:setEnabled(true)
        else
            btnSummon:setText("Invocar")
            btnSummon:setColor("#aaffaa")
            btnSummon:setEnabled(true)
        end
    end
    
    if btnHeal then
        if data.is_dead or data.hp >= data.maxHp then
            btnHeal:setEnabled(false)
            btnHeal:setColor("#555555")
        else
            btnHeal:setEnabled(true)
            btnHeal:setColor("#aaffaa")
        end
    end
    
    if btnRevive then
        if data.is_dead then
            btnRevive:setEnabled(true)
            btnRevive:setColor("#aaaaff")
        else
            btnRevive:setEnabled(false)
            btnRevive:setColor("#555555")
        end
    end
    
    if btnMount then
        if data.is_dead or not data.can_mount then
            btnMount:setEnabled(false)
            btnMount:setColor("#555555")
            btnMount:setText("Mount")
        else
            btnMount:setEnabled(true)
            if data.is_mounted then
                btnMount:setText("Dismount")
                btnMount:setColor("#ffaaaa")
            else
                btnMount:setText("Mount")
                btnMount:setColor("#ffffaa")
            end
        end
    end
end

function compactSwap()
    local data = getActivePet()
    if not data or data.is_dead or data.is_mounted then return end
    local payload = string.format('{"action":"SWAP","index":%d}', data.storage_index)
    g_game.getProtocolGame():sendExtendedOpcode(OPCODE_PET, payload)
end

function compactMount()
    local data = getActivePet()
    if not data or data.is_dead or not data.can_mount then return end
    local payload = string.format('{"action":"MOUNT","index":%d}', data.storage_index)
    g_game.getProtocolGame():sendExtendedOpcode(OPCODE_PET, payload)
end

function sendActionToActive(actionName)
    local data = getActivePet()
    if not data then return end
    local payload = string.format('{"action":"%s","index":%d}', actionName, data.storage_index)
    g_game.getProtocolGame():sendExtendedOpcode(OPCODE_PET, payload)
end

function navigate(delta)
    if #petsData <= 1 then return end
    currentIndex = currentIndex + delta
    if currentIndex > #petsData then currentIndex = 1 end
    if currentIndex < 1 then currentIndex = #petsData end
    updateUI()
end

function findActiveIndex()
    for i, pet in ipairs(petsData) do
        if pet.is_active then
            return i
        end
    end
    return 1
end

function onOpcode(protocol, opcode, buffer)
    if opcode ~= OPCODE_PET then return end
    local status, data = pcall(function() return json.decode(buffer) end)
    if not status or not data then return end

    if data.action == "OPEN" or data.action == "REFRESH" then
        petsData = data.pets or {}
        
        if #petsData == 0 then 
            hide() 
            return 
        end
        
        if wantActiveAfterRefresh then
            currentIndex = findActiveIndex()
            wantActiveAfterRefresh = false
        end
        
        if currentIndex > #petsData then currentIndex = #petsData end
        if currentIndex < 1 then currentIndex = 1 end
        
        updateUI()
        
        if data.action == "OPEN" and not window:isVisible() then 
            show() 
        end
    end
end

function updateUI()
    if not window then return end
    local data = petsData[currentIndex]
    if not data then return end
    resetReleaseButton()

    local header = window:recursiveGetChildById('headerPanel')
    if header and data.bg then header:setImageSource("/game_petinfo/images/" .. data.bg) end

    local imgWidget = window:recursiveGetChildById('petImage')
    if imgWidget and data.img then imgWidget:setImageSource("/game_petinfo/images/" .. data.img) end
    
    local lblName = window:recursiveGetChildById('nameLabel')
    if lblName then 
        local sexDisplay = data.sex or "?"
        local deadTag = data.is_dead and " [MORTO]" or ""
        lblName:setText(string.format("%s [%s]%s", data.name, sexDisplay, deadTag))
        if data.is_dead then
            lblName:setColor("#ff5555")
        else
            lblName:setColor("#ffffff")
        end
    end

    local lblRank = window:recursiveGetChildById('rankLabel')
    if lblRank then 
        lblRank:setText(data.rank)
        lblRank:setColor(RANK_COLORS[data.rank] or "#aaaaaa")
    end
    
    local counter = window:recursiveGetChildById('petCounter')
    if counter then
        counter:setText(string.format("%d / %d", currentIndex, #petsData))
    end
    
    local btnSelect = window:recursiveGetChildById('selectBtn')
    local btnMount = window:recursiveGetChildById('mountBtn')
    local btnHeal = window:recursiveGetChildById('healBtn')
    local btnRevive = window:recursiveGetChildById('reviveBtn')
    
    -- Heal
    if btnHeal then
        if data.is_dead or data.hp >= data.maxHp then
            btnHeal:setEnabled(false)
            btnHeal:setColor("#555555")
        else
            btnHeal:setEnabled(true)
            btnHeal:setColor("#aaffaa")
        end
    end
    
    -- Revive
    if btnRevive then
        if data.is_dead then
            btnRevive:setEnabled(true)
            btnRevive:setColor("#aaaaff")
        else
            btnRevive:setEnabled(false)
            btnRevive:setColor("#555555")
        end
    end

    -- Mount - SEMPRE habilitado se pode montar (exceto morto)
    if btnMount then
        if data.is_dead then
            btnMount:setText("Mount")
            btnMount:setColor("#555555")
            btnMount:setEnabled(false)
        elseif data.can_mount then
            btnMount:setEnabled(true)
            if data.is_mounted then
                btnMount:setText("Dismount")
                btnMount:setColor("#ffaaaa")
            else
                btnMount:setText("Mount")
                btnMount:setColor("#ffffaa")
            end
        else
            btnMount:setText("Mount")
            btnMount:setColor("#555555")
            btnMount:setEnabled(false)
        end
    end

    -- Select/Invoke/Recall
    if btnSelect then
        if data.is_dead then
            btnSelect:setText("PET MORTO")
            btnSelect:setColor("#ff5555")
            btnSelect:setEnabled(false)
        elseif data.is_active then
            -- Pet ativo
            if data.is_mounted then
                btnSelect:setText("DESMONTE PRIMEIRO")
                btnSelect:setColor("#555555")
                btnSelect:setEnabled(false)
            elseif data.is_summoned then
                btnSelect:setText("RECOLHER PET")
                btnSelect:setColor("#ffaaaa")
                btnSelect:setEnabled(true)
            else
                btnSelect:setText("INVOCAR PET")
                btnSelect:setColor("#aaffaa")
                btnSelect:setEnabled(true)
            end
        else
            -- Pet guardado
            btnSelect:setEnabled(true)
            btnSelect:setText("SELECIONAR PET")
            btnSelect:setColor("#ffffaa")
        end
    end

    local function setRow(rowId, text, colorOverride)
        local row = window:recursiveGetChildById(rowId)
        if row then
            local val = row:getChildById('val')
            if val then 
                val:setText(text)
                if colorOverride then val:setColor(colorOverride) end
            end
        end
    end

    local hpColor = data.is_dead and "#ff5555" or "#ffffff"
    setRow('rowHp', data.hp .. " / " .. data.maxHp, hpColor)
    setRow('rowLvl', data.level)
    setRow('rowExp', data.exp)
    
    if data.ivs then
        local sum = data.ivs.health + data.ivs.attack + data.ivs.defense + data.ivs.speed + data.ivs.resistance + data.ivs.vitality + data.ivs.xp_gain
        local avg = math.floor(sum / 7)
        local tIv = window:recursiveGetChildById('titleIv')
        if tIv then
            tIv:setText(string.format("Genetica (Media: %d)", avg))
            tIv:setColor(getIvColor(avg))
        end

        setRow('rowIvHp', data.ivs.health, getIvColor(data.ivs.health))
        setRow('rowIvAtk', data.ivs.attack, getIvColor(data.ivs.attack))
        setRow('rowIvDef', data.ivs.defense, getIvColor(data.ivs.defense))
        setRow('rowIvSpd', data.ivs.speed, getIvColor(data.ivs.speed))
        setRow('rowIvRes', data.ivs.resistance, getIvColor(data.ivs.resistance))
        setRow('rowIvVit', data.ivs.vitality, getIvColor(data.ivs.vitality))
        local xpVal = data.ivs.xp_gain or 0
        setRow('rowIvExp', "+" .. xpVal .. "%", getIvColor(xpVal))
    end
    
    updateCompactButtons()
end

function requestSwap()
    local data = petsData[currentIndex]
    if not data or data.is_dead then return end
    
    if not data.is_active then
        wantActiveAfterRefresh = true
    end
    
    local payload = string.format('{"action":"SWAP","index":%d}', data.storage_index)
    g_game.getProtocolGame():sendExtendedOpcode(OPCODE_PET, payload)
end

function handleMount()
    local data = petsData[currentIndex]
    if not data or data.is_dead or not data.can_mount then return end
    
    local payload = string.format('{"action":"MOUNT","index":%d}', data.storage_index)
    g_game.getProtocolGame():sendExtendedOpcode(OPCODE_PET, payload)
end

function sendAction(actionName)
    local data = petsData[currentIndex]
    if not data then return end
    
    local payload = string.format('{"action":"%s","index":%d}', actionName, data.storage_index)
    g_game.getProtocolGame():sendExtendedOpcode(OPCODE_PET, payload)
    if actionName == "RELEASE" then 
        hide() 
    end
end

function tryRelease()
    local btn = window:recursiveGetChildById('releaseBtn')
    if btn then
        if btn:getText() == "Release" then
            btn:setText("SURE?")
            btn:setColor("#ff0000")
            if releaseTimer then removeEvent(releaseTimer) end
            releaseTimer = scheduleEvent(resetReleaseButton, 5000)
        else
            sendAction("RELEASE")
            resetReleaseButton()
        end
    end
end

function resetReleaseButton()
    local btn = window:recursiveGetChildById('releaseBtn')
    if btn then
        btn:setText("Release")
        btn:setColor("#ffaaaa")
    end
    if releaseTimer then 
        removeEvent(releaseTimer) 
        releaseTimer = nil 
    end
end