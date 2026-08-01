local EFFECTS_CONFIG = {
    opcode = 51,
    folder = 'effects/',
    channelId = 40,
    defaultVolume = 100,
    forcePlayDelay = 100
}

function onSoundEffectOpcode(protocol, opcode, buffer)
    if not buffer or buffer == '' then return end
    if not g_sounds.isAudioEnabled() then return end

    local parts = string.explode(buffer, ":")
    local filename = parts[1]
    local volume = tonumber(parts[2]) or EFFECTS_CONFIG.defaultVolume
    local path = EFFECTS_CONFIG.folder .. filename

    local channel = g_sounds.getChannel(EFFECTS_CONFIG.channelId)

    channel:stop()
    channel:setGain(volume)
    
    channel:enqueue(path, 0)

    scheduleEvent(function()
        channel:stop()
        channel:setGain(volume)
        channel:play(path)
    end, EFFECTS_CONFIG.forcePlayDelay)
end

function initEffects()
    ProtocolGame.registerExtendedOpcode(EFFECTS_CONFIG.opcode, onSoundEffectOpcode)
end

function terminateEffects()
    pcall(function()
        ProtocolGame.unregisterExtendedOpcode(EFFECTS_CONFIG.opcode)
    end)
end