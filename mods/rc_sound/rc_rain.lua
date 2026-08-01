local RainClient = {
    opcode = 201,
    folder = "effects/", 
    currentFile = "",
    channelId = 55,       -- Canal da Chuva (Ambiente)
    sfxChannelId = 56     -- Canal dos Efeitos (Trovão)
}

function initRain()
    connect(g_game, { onGameStart = onGameStartRain, onGameEnd = onGameEndRain })
    if g_game.isOnline() then onGameStartRain() end
    g_logger.info("[RAIN] Modulo carregado.")
end

function terminateRain()
    disconnect(g_game, { onGameStart = onGameStartRain, onGameEnd = onGameEndRain })
    pcall(function() ProtocolGame.unregisterExtendedOpcode(RainClient.opcode) end)
    stopRain()
end

function onGameStartRain() ProtocolGame.registerExtendedOpcode(RainClient.opcode, onRainOpcode) end
function onGameEndRain() pcall(function() ProtocolGame.unregisterExtendedOpcode(RainClient.opcode) end) stopRain() end

function stopRain()
    local channel = g_sounds.getChannel(RainClient.channelId)
    if channel then channel:stop() end
    RainClient.currentFile = ""
end

function onRainOpcode(protocol, code, buffer)
    local status, data = pcall(function() return json.decode(buffer) end)
    if not status or not data then return end

    -- ============================================================
    -- 1. Tocar Efeito Sonoro (SFX - Trovão)
    -- ============================================================
    -- Usando a lógica do SEU script de exemplo
    if data.sfx then
        local fullPath = RainClient.folder .. data.sfx
        local sfxChannel = g_sounds.getChannel(RainClient.sfxChannelId)
        
        if sfxChannel then
            sfxChannel:stop()
            sfxChannel:setGain(1.0)
            
            -- Garante que o loop esteja desligado
            if sfxChannel.setLooping then 
                sfxChannel:setLooping(false) 
            end

            -- Técnica do seu script: Enqueue -> Delay -> Play
            sfxChannel:enqueue(fullPath, 0)

            scheduleEvent(function()
                if sfxChannel then
                    -- Alguns clientes precisam do stop antes do play forçado
                    sfxChannel:stop() 
                    if sfxChannel.setLooping then sfxChannel:setLooping(false) end
                    sfxChannel:play(fullPath)
                end
            end, 50) -- Delay pequeno de 50ms a 100ms
        end
        return 
    end

    -- ============================================================
    -- 2. Tocar Chuva Ambiente (Loop)
    -- ============================================================
    local filename = data.sound
    
    if not filename or filename == "stop" or filename == "" then
        if RainClient.currentFile ~= "" then stopRain() end
        return
    end

    if RainClient.currentFile ~= filename then
        local fullPath = RainClient.folder .. filename
        local channel = g_sounds.getChannel(RainClient.channelId)
        
        if channel then 
            channel:stop() 
            channel:enqueue(fullPath, 0)
            
            -- Para chuva, ativamos o loop
            if channel.setLooping then
                channel:setLooping(true)
            end

            channel:setGain(1.0)
            RainClient.currentFile = filename
        end
    end
end