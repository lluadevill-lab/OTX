local SoundEmitters = {
    opcode = 202,
    -- CORREÇÃO DO CAMINHO: Aponta para dentro da sua pasta de mods
    folder = "/mods/rc_sound/effects/songs/", 
    updateInterval = 100,
    maxDistance = 15,
    activeEmitters = {} 
}

function initEmitters()
    connect(g_game, { onGameEnd = stopAllEmitters })
    ProtocolGame.registerExtendedOpcode(SoundEmitters.opcode, onEmitterOpcode)
    scheduleEvent(updateEmittersLoop, 100)
    g_logger.info("[EMITTERS] Sistema de Audio 3D Iniciado.")
end

function terminateEmitters()
    disconnect(g_game, { onGameEnd = stopAllEmitters })
    ProtocolGame.unregisterExtendedOpcode(SoundEmitters.opcode)
    stopAllEmitters()
end

function stopAllEmitters()
    for key, emitter in pairs(SoundEmitters.activeEmitters) do
        if emitter.channel then emitter.channel:stop() end
    end
    SoundEmitters.activeEmitters = {}
end

function getPosKey(pos) return pos.x .. "_" .. pos.y .. "_" .. pos.z end

function updateEmittersLoop()
    local player = g_game.getLocalPlayer()
    if player then
        local playerPos = player:getPosition()
        for key, emitter in pairs(SoundEmitters.activeEmitters) do
            if emitter.channel then
                local dx = math.abs(playerPos.x - emitter.pos.x)
                local dy = math.abs(playerPos.y - emitter.pos.y)
                local dist = math.sqrt(dx*dx + dy*dy)
                
                local volume = 1.0 - (dist / SoundEmitters.maxDistance)
                if volume < 0 then volume = 0 end
                
                emitter.channel:setGain(volume)
            end
        end
    end
    scheduleEvent(updateEmittersLoop, SoundEmitters.updateInterval)
end

function onEmitterOpcode(protocol, code, buffer)
    -- Log para provar que o servidor mandou
    g_logger.info("[EMITTER] Opcode recebido: " .. tostring(buffer))

    local status, data = pcall(function() return json.decode(buffer) end)
    if not status or not data then 
        g_logger.error("[EMITTER] Erro no JSON.")
        return 
    end

    local action = data.action
    local pos = data.pos
    local key = getPosKey(pos)

    if action == "play" then
        local filename = data.file
        
        -- Verifica se já está tocando o mesmo
        if SoundEmitters.activeEmitters[key] and SoundEmitters.activeEmitters[key].file == filename then
            return
        end
        
        if SoundEmitters.activeEmitters[key] then
            SoundEmitters.activeEmitters[key].channel:stop()
        end

        local channelId = 40 + math.random(10)
        local channel = g_sounds.getChannel(channelId)
        
        if channel then
            channel:stop()
            
            local fullPath = SoundEmitters.folder .. filename
            
            -- Debug do caminho
            g_logger.info("[EMITTER] Tentando tocar: " .. fullPath)
            
            -- Tenta verificar se o arquivo existe (Funciona na maioria dos OTClients)
            if g_resources and g_resources.fileExists then
                if not g_resources.fileExists(fullPath) then
                    g_logger.error("[EMITTER] ARQUIVO NAO ENCONTRADO NO CAMINHO: " .. fullPath)
                    g_logger.warning("[EMITTER] Dica: Mova os arquivos para 'data/sounds/effects/' e mude a config folder para 'effects/'")
                end
            end

            channel:enqueue(fullPath, 0)
            if channel.setLooping then channel:setLooping(false) end
            channel:setGain(0) 
            
            SoundEmitters.activeEmitters[key] = {
                channel = channel,
                pos = pos,
                file = filename
            }
        end

    elseif action == "stop" then
        if SoundEmitters.activeEmitters[key] then
            SoundEmitters.activeEmitters[key].channel:stop()
            SoundEmitters.activeEmitters[key] = nil
            g_logger.info("[EMITTER] Som parado em " .. key)
        end
    end
end