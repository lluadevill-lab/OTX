local OPCODE_SURVIVAL = 106
local window = nil
local updateEvent = nil
local isVertical = false
local statusData = {
    hunger = 100, thirst = 100, fatigue = 100, oxygen = 100, temperature = 50
}
local lastValues = {
    slotHunger = -1, slotThirst = -1, slotFatigue = -1, slotOxygen = -1, slotTemperature = -1
}

local STATUS_NAMES = {
    slotHunger = "Fome",
    slotThirst = "Sede",
    slotFatigue = "Fadiga",
    slotOxygen = "Oxigenio",
    slotTemperature = "Temp"
}

function init()
    connect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
    
    window = g_ui.displayUI('game_survival.otui')
    if not window then return end
    
    window:hide()
    
    for slotId, name in pairs(STATUS_NAMES) do
        local slot = window:recursiveGetChildById(slotId)
        if slot then
            local nameLabel = slot:getChildById('statusName')
            if nameLabel then
                nameLabel:setText(name)
            end
        end
    end
    
    local closeBtn = window:recursiveGetChildById('closeBtn')
    if closeBtn then closeBtn.onClick = hide end
    
    local toggleBtn = window:recursiveGetChildById('toggleBtn')
    if toggleBtn then toggleBtn.onClick = toggleLayout end
    
    loadSettings()
    
    if g_game.isOnline() then
        ProtocolGame.registerExtendedOpcode(OPCODE_SURVIVAL, onOpcode)
        startUpdateLoop()
    end
end

function terminate()
    disconnect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
    stopUpdateLoop()
    saveSettings()
    if g_game.getProtocolGame() then
        ProtocolGame.unregisterExtendedOpcode(OPCODE_SURVIVAL)
    end
    if window then
        window:destroy()
        window = nil
    end
end

function onGameStart()
    ProtocolGame.registerExtendedOpcode(OPCODE_SURVIVAL, onOpcode)
    startUpdateLoop()
end

function onGameEnd()
    stopUpdateLoop()
    saveSettings()
    ProtocolGame.unregisterExtendedOpcode(OPCODE_SURVIVAL)
    if window then window:hide() end
end

function loadSettings()
    if not window then return end
    
    local posX = g_settings.getNumber('survival_pos_x')
    local posY = g_settings.getNumber('survival_pos_y')
    local vertical = g_settings.getBoolean('survival_vertical')
    
    if posX and posY and posX > 0 and posY > 0 then
        window:setPosition({x = posX, y = posY})
    end
    
    if vertical then
        isVertical = true
        applyLayout()
    end
end

function saveSettings()
    if not window then return end
    
    local pos = window:getPosition()
    g_settings.set('survival_pos_x', pos.x)
    g_settings.set('survival_pos_y', pos.y)
    g_settings.set('survival_vertical', isVertical)
end

function toggle()
    if not window then return end
    if window:isVisible() then
        saveSettings()
        window:hide()
    else
        window:show()
        window:raise()
        requestUpdate()
    end
end

function show() 
    if window then 
        window:show() 
        window:raise() 
    end 
end

function hide() 
    if window then 
        saveSettings()
        window:hide() 
    end 
end

function applyLayout()
    if not window then return end
    
    local contentPanel = window:recursiveGetChildById('contentPanel')
    if not contentPanel then return end
    
    local layout = contentPanel:getLayout()
    if not layout then return end
    
    if isVertical then
        layout:setNumColumns(1)
        window:setSize({width = 100, height = 235})
    else
        layout:setNumColumns(5)
        window:setSize({width = 448, height = 65})
    end
end

function toggleLayout()
    isVertical = not isVertical
    applyLayout()
    saveSettings()
end

function startUpdateLoop()
    stopUpdateLoop()
    local function doUpdate()
        if g_game.isOnline() then
            if window and window:isVisible() then requestUpdate() end
            updateEvent = scheduleEvent(doUpdate, 1000)
        end
    end
    updateEvent = scheduleEvent(doUpdate, 1000)
end

function stopUpdateLoop()
    if updateEvent then removeEvent(updateEvent) updateEvent = nil end
end

function requestUpdate()
    if g_game.getProtocolGame() then
        g_game.getProtocolGame():sendExtendedOpcode(OPCODE_SURVIVAL, "REQUEST")
    end
end

function onOpcode(protocol, opcode, buffer)
    if opcode ~= OPCODE_SURVIVAL then return end
    
    if buffer == "TOGGLE" then
        toggle()
        return
    end
    
    local hunger = tonumber(buffer:match('"hunger":(%d+)'))
    local thirst = tonumber(buffer:match('"thirst":(%d+)'))
    local fatigue = tonumber(buffer:match('"fatigue":(%d+)'))
    local oxygen = tonumber(buffer:match('"oxygen":(%d+)'))
    local temperature = tonumber(buffer:match('"temperature":(%d+)'))
    
    if hunger then statusData.hunger = hunger end
    if thirst then statusData.thirst = thirst end
    if fatigue then statusData.fatigue = fatigue end
    if oxygen then statusData.oxygen = oxygen end
    if temperature then statusData.temperature = temperature end
    
    updateUI()
end

function getStatusColor(value)
    if value >= 75 then return "#55ff55"
    elseif value >= 50 then return "#ffff55"
    elseif value >= 25 then return "#ffaa55"
    else return "#ff5555"
    end
end

function getTemperatureColor(value)
    if value <= 10 then return "#5555ff"
    elseif value <= 25 then return "#55aaff"
    elseif value >= 90 then return "#ff5555"
    elseif value >= 75 then return "#ffaa55"
    elseif value >= 45 and value <= 55 then return "#55ff55"
    else return "#aaaaaa"
    end
end

function updateUI()
    if not window or not window:isVisible() then return end
    
    local function updateSlot(id, value, isTemp)
        if lastValues[id] == value then
            return
        end
        lastValues[id] = value
        
        local slot = window:recursiveGetChildById(id)
        if not slot then return end
        
        local valueLabel = slot:getChildById('statusValue')
        if valueLabel then
            if isTemp then
                valueLabel:setText(tostring(value))
                valueLabel:setColor(getTemperatureColor(value))
            else
                valueLabel:setText(tostring(value) .. "%")
                valueLabel:setColor(getStatusColor(value))
            end
        end
        
        local bar = slot:recursiveGetChildById('statusBar')
        if bar then
            local maxW = 70
            local percent = math.max(0, math.min(100, value)) / 100
            bar:setWidth(math.floor(maxW * percent))
            if isTemp then
                bar:setBackgroundColor(getTemperatureColor(value))
            else
                bar:setBackgroundColor(getStatusColor(value))
            end
        end
    end
    
    updateSlot('slotHunger', statusData.hunger, false)
    updateSlot('slotThirst', statusData.thirst, false)
    updateSlot('slotFatigue', statusData.fatigue, false)
    updateSlot('slotOxygen', statusData.oxygen, false)
    updateSlot('slotTemperature', statusData.temperature, true)
end