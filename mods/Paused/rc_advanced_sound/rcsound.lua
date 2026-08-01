-- ==========================================================
-- CONFIGURAÇÕES E DEFINIÇÕES DO NOVO SISTEMA DE SOM AVANÇADO
-- ==========================================================

-- Canais de Som Específicos
local Channels = {
    EFFECTS = SoundChannels.Effect,
    AMBIENT = SoundChannels.Ambient,
    FOOTSTEPS = g_sounds.getChannel(SoundChannels.Step),
    UI = SoundChannels.Interface,
}

-- Mapeamento de sons por EVENTO ID (O SERVIDOR VAI ENVIAR ESTES IDs)
SOUND_EVENT_MAP = {
    -- ID | { Arquivo de som, Canal, Volume (0-100), Alcance (tiles) }
    
    -- 1. SONS DE ANIMAÇÕES/EFEITOS DE HIT
    -- Sound ID: 100 - Som ao ser atingido por fogo (CONST_ME_HITBYFIRE)
    [999] = { sound = 'effects/corvos.ogg', channel = Channels.EFFECTS, volume = 40, range = 10 }, 
    
    -- 2. SONS DE USO DE ITENS
    -- Sound ID: 101 - Abrir/Fechar porta (Ex: Item ID 1000)
    [101] = { sound = 'music/door_open.ogg', channel = Channels.EFFECTS, volume = 50, range = 12 },
    -- Sound ID: 102 - Usar item de comida (Ex: Item ID 2000)
    [102] = { sound = 'music/eat_crunch.ogg', channel = Channels.EFFECTS, volume = 60, range = 8 },

    -- 3. SONS DE ENTIDADES/EVENTOS REPETITIVOS (Servidor)
    -- Sound ID: 200 - Uivo do Lobo
    [200] = { sound = 'music/howling.ogg', channel = Channels.AMBIENT, volume = 70, range = 20 },
    
    -- 4. SONS DE PASSOS (Defina um ID para cada tipo de chão que você quer sonorizar)
    -- Sound ID: 300 - Grama (Ex: Item ID de chão 101)
    [300] = { sound = 'music/grass_step.ogg', channel = Channels.FOOTSTEPS, volume = 20, range = 5 },
    -- Sound ID: 301 - Pedra (Ex: Item ID de chão 102)
    [301] = { sound = 'music/stone_step.ogg', channel = Channels.FOOTSTEPS, volume = 20, range = 5 },
    -- Sound ID: 302 - Madeira (Ex: Item ID de chão 103)
    [302] = { sound = 'music/wood_step.ogg', channel = Channels.FOOTSTEPS, volume = 20, range = 5 },
}

-- ID do Protocolo Customizado (DEVE ser um ID não usado)
local CUSTOM_SOUND_PROTOCOL_ID = 2000

-- ==========================================================
-- FUNÇÕES CORE
-- ==========================================================

-- Função principal para tocar som posicional (Spatial Audio)
function playPositionalSound(soundPath, position, volume, range, channel)
    local normalizedVolume = math.min(1.0, math.max(0.0, volume / 100.0))
    
    if g_resources.has(soundPath) then
        g_sounds.playSound(soundPath, position, normalizedVolume, range, channel)
    else
        g_logger.warning('Advanced Sound System: Sound file not found: ' .. soundPath)
    end
end

-- Handler de Protocolo: Recebe a mensagem do servidor
-- NOVO HANDLER COM DEBUG DE CHAT
function onCustomSoundProtocol(protocol, msg)
    local soundEventId = msg:getU16()
    local x = msg:getU32()
    local y = msg:getU32()
    local z = msg:getU8()
    
    -- Mensagem de debug visível no chat do jogo (amarelo)
    g_game.displayMessage("Sound Received: ID " .. soundEventId .. ", Pos: " .. x .. "," .. y .. "," .. z, MessageMode.ConsoleOrange)

    local soundData = SOUND_EVENT_MAP[soundEventId]

    if soundData then
        local pos = {x = x, y = y, z = z}
        
        playPositionalSound(
            soundData.sound,
            pos,
            soundData.volume,
            soundData.range,
            soundData.channel
        )
        return true
    else
        g_game.displayMessage("Advanced Sound System: Unknown ID: " .. soundEventId, MessageMode.ConsoleRed)
    end
    
    return false
end

-- ==========================================================
-- INICIALIZAÇÃO E TERMINAÇÃO DO MOD
-- ==========================================================

function init()
    g_protocol.addCustomMessageHandler(CUSTOM_SOUND_PROTOCOL_ID, onCustomSoundProtocol)

    -- NOVO: Adiciona a lógica para sons de animação aqui, pois não precisam de protocolo
    -- A animação é um evento que só o cliente sabe que ocorreu.
    connect(Game, { onAnimated = onAnimated })
    
    g_logger.info('Advanced Sound System loaded. Protocol ID: ' .. CUSTOM_SOUND_PROTOCOL_ID)
end

function onAnimated(thing, animationId)
    -- Verifica se a animação CONST_ME_HITBYFIRE corresponde ao nosso Sound ID 100
    if animationId == "CONST_ME_HITBYFIRE" then
        local soundData = SOUND_EVENT_MAP[100]
        if soundData then
            local pos = thing:getPosition()
            playPositionalSound(
                soundData.sound,
                pos,
                soundData.volume,
                soundData.range,
                soundData.channel
            )
        end
    end
    -- Adicione outras animações aqui se necessário
end


function terminate()
    g_protocol.removeCustomMessageHandler(CUSTOM_SOUND_PROTOCOL_ID)
    disconnect(Game, { onAnimated = onAnimated })
end