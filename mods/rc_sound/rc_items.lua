-- rc_item_sounds.lua

local ITEM_SOUNDS_CONFIG = {
    scanInterval = 100,     -- Verifica itens a cada 0.5s
    updateInterval = 50,    -- Atualiza volume a cada 0.05s
    folder = 'effects/',
    channelStart = 60,
    channelEnd = 80,
    defaultRange = 4,       -- Aumentei o range padrão para garantir
    defaultFullVol = 2,     -- Distância onde o volume permanece 100% (antes de começar a cair)
    maxVolume = 1.0,
    fadeSpeed = 0.05
}

-- Configuração dos Itens
-- range: Onde o som some completamente (Zero volume)
-- fullVol: (Opcional) Até qual distância o som fica no máximo. Se não por, usa o defaultFullVol (3)
local ITEMS = {
    [1999] = { sound = "campfire.ogg", range = 8, fullVol = 3 },
    [1998] = { sound = "campfire.ogg", range = 8, fullVol = 3 },
    [1425] = { sound = "campfire.ogg", range = 8, fullVol = 3 },
    [2122] = { sound = "zap.ogg", range = 10, fullVol = 4 }, -- Fonte ouve-se mais longe
}

local scanEvent = nil
local updateEvent = nil
local activeSounds = {}

local function debugPrint(msg)
    -- print("[ItemSounds] " .. msg)
end

local function getPosKey(pos)
    return pos.x .. "_" .. pos.y .. "_" .. pos.z
end

-- Distância real (Pitágoras) para suavidade em diagonais
local function getRealDistance(pos1, pos2)
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    return math.sqrt(dx*dx + dy*dy)
end

local function getFreeChannel()
    local usedChannels = {}
    for _, soundData in pairs(activeSounds) do
        usedChannels[soundData.channelId] = true
    end
    for i = ITEM_SOUNDS_CONFIG.channelStart, ITEM_SOUNDS_CONFIG.channelEnd do
        if not usedChannels[i] then return i end
    end
    return nil
end

local function stopAllItemSounds()
    for key, data in pairs(activeSounds) do
        local channel = g_sounds.getChannel(data.channelId)
        if channel then channel:stop() end
    end
    activeSounds = {}
end

-- ============================================================================
-- ATUALIZAÇÃO RÁPIDA (VOLUME INTELIGENTE)
-- ============================================================================
local function updateSoundVolumes()
    local player = g_game.getLocalPlayer()
    if not player then return end
    
    local playerPos = player:getPosition()
    local pendingDeletion = {}

    for key, data in pairs(activeSounds) do
        local channel = g_sounds.getChannel(data.channelId)
        
        if channel then
            local currentDist = getRealDistance(playerPos, data.pos)
            local targetVol = 0

            -- Se marcado para deletar ou fora do range máximo
            if data.toDelete or currentDist > data.range then
                targetVol = 0
            else
                -- LÓGICA NOVA DE VOLUME:
                -- Se a distância for menor que o fullVolRange, mantém volume MAXIMO.
                if currentDist <= data.fullVolRange then
                    targetVol = ITEM_SOUNDS_CONFIG.maxVolume
                else
                    -- Se passou do raio de volume cheio, começa a cair gradualmente até o range máximo
                    -- Matematica: (Distancia Restante / Espaço de Fade)
                    local fadeDistance = data.range - data.fullVolRange
                    local distanceInFade = currentDist - data.fullVolRange
                    
                    local volFactor = 1 - (distanceInFade / fadeDistance)
                    
                    -- Proteção matemática e curva suave (raiz quadrada mantém o som mais alto por mais tempo)
                    if volFactor < 0 then volFactor = 0 end
                    
                    -- Math.pow(x, 0.5) faz uma curva convexa (cai devagar no começo, rápido no fim)
                    targetVol = math.pow(volFactor, 0.5) * ITEM_SOUNDS_CONFIG.maxVolume
                end
            end

            -- Aplica Fade Suave entre o volume atual e o alvo
            if data.currentVolume < targetVol then
                data.currentVolume = math.min(targetVol, data.currentVolume + ITEM_SOUNDS_CONFIG.fadeSpeed)
            elseif data.currentVolume > targetVol then
                data.currentVolume = math.max(targetVol, data.currentVolume - ITEM_SOUNDS_CONFIG.fadeSpeed)
            end

            channel:setGain(data.currentVolume)

            if data.currentVolume <= 0.01 and targetVol == 0 then
                channel:stop()
                table.insert(pendingDeletion, key)
            end
        else
            table.insert(pendingDeletion, key)
        end
    end

    for _, key in ipairs(pendingDeletion) do
        activeSounds[key] = nil
    end

    updateEvent = scheduleEvent(updateSoundVolumes, ITEM_SOUNDS_CONFIG.updateInterval)
end

-- ============================================================================
-- SCANNER (Procura itens)
-- ============================================================================
local function scanMapForItems()
    local player = g_game.getLocalPlayer()
    if not player then
        scanEvent = scheduleEvent(scanMapForItems, ITEM_SOUNDS_CONFIG.scanInterval)
        return
    end

    local playerPos = player:getPosition()
    
    for _, data in pairs(activeSounds) do
        data.toDelete = true
    end

    -- Escaneia um pouco além do range padrão para garantir que pega o inicio do fade
    local scanRange = ITEM_SOUNDS_CONFIG.defaultRange + 2 

    for dx = -scanRange, scanRange do
        for dy = -scanRange, scanRange do
            local checkPos = {x = playerPos.x + dx, y = playerPos.y + dy, z = playerPos.z}
            local tile = g_map.getTile(checkPos)
            
            if tile then
                local things = tile:getThings()
                for _, thing in ipairs(things) do
                    if thing:isItem() then
                        local itemId = thing:getId()
                        local config = ITEMS[itemId]
                        
                        if config then
                            local posKey = getPosKey(checkPos)
                            
                            if activeSounds[posKey] then
                                activeSounds[posKey].toDelete = false
                                -- Atualiza config caso mude em runtime
                                activeSounds[posKey].range = config.range 
                                activeSounds[posKey].fullVolRange = config.fullVol or ITEM_SOUNDS_CONFIG.defaultFullVol
                            else
                                local channelId = getFreeChannel()
                                if channelId then
                                    local channel = g_sounds.getChannel(channelId)
                                    if channel then
                                        local soundFile = ITEM_SOUNDS_CONFIG.folder .. config.sound
                                        channel:stop()
                                        channel:setGain(0) 
                                        channel:enqueue(soundFile, 0)
                                        
                                        activeSounds[posKey] = {
                                            channelId = channelId,
                                            pos = checkPos,
                                            range = config.range,
                                            fullVolRange = config.fullVol or ITEM_SOUNDS_CONFIG.defaultFullVol,
                                            targetVolume = 0,
                                            currentVolume = 0,
                                            toDelete = false
                                        }
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    scanEvent = scheduleEvent(scanMapForItems, ITEM_SOUNDS_CONFIG.scanInterval)
end

-- ============================================================================
-- INICIALIZAÇÃO
-- ============================================================================

local function onGameStart()
    stopAllItemSounds()
    scanEvent = scheduleEvent(scanMapForItems, 1000)
    updateEvent = scheduleEvent(updateSoundVolumes, 1000)
end

local function onGameEnd()
    if scanEvent then removeEvent(scanEvent) end
    if updateEvent then removeEvent(updateEvent) end
    scanEvent = nil
    updateEvent = nil
    stopAllItemSounds()
end

function initItemSounds()
    connect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
    if g_game.isOnline() then onGameStart() end
end

function terminateItemSounds()
    disconnect(g_game, { onGameStart = onGameStart, onGameEnd = onGameEnd })
    onGameEnd()
end