local OPCODE_UPGRADE = 105
local window = nil
local currentTab = "skills"
local playerPoints = 0
local skillsData = {}
local attributesData = {}

local SKILL_IMAGES = {
    [1] = "/game_skillupgrade/images/health",
    [2] = "/game_skillupgrade/images/mana",
    [3] = "/game_skillupgrade/images/speed",
    [4] = "/game_skillupgrade/images/magic",
    [5] = "/game_skillupgrade/images/club",
    [6] = "/game_skillupgrade/images/sword",
    [7] = "/game_skillupgrade/images/axe",
    [8] = "/game_skillupgrade/images/distance",
    [9] = "/game_skillupgrade/images/shielding"
}

local ATTRIBUTE_IMAGES = {
    [1] = "/game_skillupgrade/images/life_leech",      -- Life Leech Chance
    [2] = "/game_skillupgrade/images/life_leech2",      -- Life Leech Amount
    [3] = "/game_skillupgrade/images/mana_leech",      -- Mana Leech Chance
    [4] = "/game_skillupgrade/images/mana_leech2",      -- Mana Leech Amount
    [5] = "/game_skillupgrade/images/critical",        -- Critical Chance
    [6] = "/game_skillupgrade/images/critical2"         -- Critical Damage
}

function init()
    connect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
    
    window = g_ui.displayUI('game_skillupgrade.otui')
    if not window then
        return
    end
    window:hide()
    
    local closeBtn = window:recursiveGetChildById('closeBtn')
    if closeBtn then closeBtn.onClick = hide end
    
    local tabSkills = window:recursiveGetChildById('tabSkills')
    if tabSkills then tabSkills.onClick = function() switchTab("skills") end end
    
    local tabAttributes = window:recursiveGetChildById('tabAttributes')
    if tabAttributes then tabAttributes.onClick = function() switchTab("attributes") end end
    
    if g_game.isOnline() then
        ProtocolGame.registerExtendedOpcode(OPCODE_UPGRADE, onOpcode)
    end
end

function terminate()
    disconnect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
    if g_game.getProtocolGame() then
        ProtocolGame.unregisterExtendedOpcode(OPCODE_UPGRADE)
    end
    if window then
        window:destroy()
        window = nil
    end
end

function onGameStart()
    ProtocolGame.registerExtendedOpcode(OPCODE_UPGRADE, onOpcode)
end

function onGameEnd()
    ProtocolGame.unregisterExtendedOpcode(OPCODE_UPGRADE)
    if window then window:hide() end
end

function show()
    if window then
        window:show()
        window:raise()
        window:focus()
    end
end

function hide()
    if window then
        window:hide()
    end
end

function onOpcode(protocol, opcode, buffer)
    if opcode ~= OPCODE_UPGRADE then return end
    
    local status, data = pcall(function() return json.decode(buffer) end)
    if not status or not data then
        return
    end
    
    if data.action == "OPEN" then
        playerPoints = data.points or 0
        skillsData = data.skills or {}
        attributesData = data.attributes or {}
        
        updatePointsDisplay()
        switchTab(currentTab)
        show()
        
    elseif data.action == "SUCCESS" then
        playerPoints = data.points or playerPoints
        skillsData = data.skills or skillsData
        attributesData = data.attributes or attributesData
        
        updatePointsDisplay()
        updateGrid()
        
        showFeedback(data.message or "Upgrade realizado!", "#55ff55")
        
    elseif data.action == "ERROR" then
        showFeedback(data.message or "Erro!", "#ff5555")
    end
end

function showFeedback(message, color)
    if not window then return end
    local feedbackLabel = window:recursiveGetChildById('feedbackLabel')
    if feedbackLabel then
        feedbackLabel:setText(message)
        feedbackLabel:setColor(color)
        scheduleEvent(function()
            if feedbackLabel then feedbackLabel:setText("") end
        end, 2500)
    end
end

function updatePointsDisplay()
    if not window then return end
    local pointsLabel = window:recursiveGetChildById('pointsLabel')
    if pointsLabel then
        local points = playerPoints
        local displayText = ""
        if points >= 1000000 then
            displayText = string.format("%.1fM", points / 1000000)
        elseif points >= 1000 then
            displayText = string.format("%.1fK", points / 1000)
        else
            displayText = tostring(points)
        end
        
        pointsLabel:setText(displayText)
        
        if points > 0 then
            pointsLabel:setColor("#55ff55")
        else
            pointsLabel:setColor("#ff5555")
        end
    end
end

function switchTab(tab)
    if not window then return end
    currentTab = tab
    
    local tabSkills = window:recursiveGetChildById('tabSkills')
    local tabAttributes = window:recursiveGetChildById('tabAttributes')
    
    if tabSkills then
        if tab == "skills" then
            tabSkills:setColor("#ffffff")
        else
            tabSkills:setColor("#666666")
        end
    end
    
    if tabAttributes then
        if tab == "attributes" then
            tabAttributes:setColor("#ffffff")
        else
            tabAttributes:setColor("#666666")
        end
    end
    
    updateGrid()
end

function updateGrid()
    if not window then return end
    local gridPanel = window:recursiveGetChildById('gridPanel')
    if not gridPanel then
        return
    end
    
    gridPanel:destroyChildren()
    
    local dataList = currentTab == "skills" and skillsData or attributesData
    local imageList = currentTab == "skills" and SKILL_IMAGES or ATTRIBUTE_IMAGES
    
    for i, item in ipairs(dataList) do
        local slot = g_ui.createWidget('SkillSlot', gridPanel)
        if slot then
            local imgWidget = slot:getChildById('skillImage')
            if imgWidget then
                local imgPath = imageList[item.id]
                if imgPath then
                    imgWidget:setImageSource(imgPath)
                else
                    imgWidget:setVisible(false)
                end
            end
            
            local nameLabel = slot:getChildById('skillName')
            if nameLabel then
                local shortName = item.name
                -- Remove o (X/Y%) do nome para exibição
                shortName = shortName:gsub("%s*%b()%s*", "")
                if #shortName > 12 then
                    shortName = shortName:sub(1, 11) .. "."
                end
                nameLabel:setText(shortName)
            end
            
            local valueLabel = slot:getChildById('skillValue')
            if valueLabel then
                local displayValue = item.value
                if displayValue >= 1000000 then
                    displayValue = string.format("%.1fM", displayValue / 1000000)
                elseif displayValue >= 1000 then
                    displayValue = string.format("%.1fK", displayValue / 1000)
                end
                valueLabel:setText("Lv: " .. tostring(displayValue))
            end
            
            local upgradeBtn = slot:getChildById('upgradeBtn')
            if upgradeBtn then
                -- Verifica se está no máximo
                local isMaxed = item.isMaxed or (item.max and item.max > 0 and item.value >= item.max)
                
                if isMaxed then
                    upgradeBtn:setText("MAX")
                    upgradeBtn:setEnabled(false)
                    upgradeBtn:setColor("#ffaa00")  -- Dourado para MAX
                elseif playerPoints >= item.cost then
                    upgradeBtn:setText(item.cost .. " pts")
                    upgradeBtn:setEnabled(true)
                    upgradeBtn:setColor("#55ff55")  -- Verde
                else
                    upgradeBtn:setText(item.cost .. " pts")
                    upgradeBtn:setEnabled(false)
                    upgradeBtn:setColor("#555555")  -- Cinza
                end
                
                local skillId = item.id
                local skillType = currentTab
                upgradeBtn.onClick = function()
                    if not isMaxed then
                        requestUpgrade(skillId, skillType)
                    end
                end
            end
        end
    end
end


function requestUpgrade(skillId, skillType)
    if not g_game.getProtocolGame() then return end
    
    local payload = json.encode({
        action = "UPGRADE",
        type = skillType,
        id = skillId
    })
    
    g_game.getProtocolGame():sendExtendedOpcode(OPCODE_UPGRADE, payload)
end