-- ============================================
-- ADVANCED SFX MODULE (CLIENT-ONLY)
-- ============================================

-- CANAIS
local SFX_CHANNELS = {
    EFFECT  = g_sounds.getChannel(SoundChannels.Effect),
    AMBIENT = g_sounds.getChannel(SoundChannels.Ambient),
    STEP    = g_sounds.getChannel(SoundChannels.Step),
    UI      = g_sounds.getChannel(SoundChannels.Interface)
}

-- EVENTOS DE SOM
SFX_EVENTS = {
    -- SERVER → CLIENT VIA PROTOCOLO
    [100] = {sound = "effects/corvos.ogg",  channel = SFX_CHANNELS.EFFECT, volume = 60, range = 12},
    [101] = {sound = "effects/door_open.ogg", channel = SFX_CHANNELS.EFFECT, volume = 50, range = 10},

    -- ANIMAÇÕES (CONST_ME)
    CONST_ME_FIREATTACK = {sound = "effects/corvos.ogg", channel = SFX_CHANNELS.EFFECT, volume = 55, range = 10},
    CONST_ME_HITBYPOISON = {sound = "effects/poison_hit.ogg", channel = SFX_CHANNELS.EFFECT, volume = 60, range = 10},

    -- CREATURE TRIGGERS
    CREATURE_SOUNDS = {
        ["Wolf"] = {sound = "ambient/corvos.ogg", channel = SFX_CHANNELS.AMBIENT, volume = 40, range = 18},
        ["Dragon"] = {sound = "ambient/dragon.ogg", channel = SFX_CHANNELS.AMBIENT, volume = 60, range = 18},
    },

    -- ITENS
    ITEM_USE = {
        [13297] = "effects/corvos.ogg",       -- comida
        [3496] = "effects/stone_drop.ogg" -- item colocado
    }
}

CUSTOM_SFX_PROTOCOL = 2222

local function onServerSfx(protocol, msg)
    local sfxId = msg:getU16()
    local pos = msg:getPosition()
    g_logger.info("Recebido SFX ID: " .. sfxId)
    g_sounds.playSound(sfxId, pos)
end

function init()
    g_protocol.addCustomMessageHandler(CUSTOM_SFX_PROTOCOL, onServerSfx)

    connect(Game, { onAnimated = onAnimated })
    connect(Creature, { onAppear = onCreatureAppear })
    connect(g_game, { onUseInventoryItem = onUseInventoryItem })
    connect(g_game, { onDropItem = onDropItem })

    g_logger.info("[ADVANCED_SFX] loaded.")
end

function terminate()
    g_protocol.removeCustomMessageHandler(CUSTOM_SFX_PROTOCOL)

    disconnect(Game, { onAnimated = onAnimated })
    disconnect(Creature, { onAppear = onCreatureAppear })
    disconnect(g_game, { onUseInventoryItem = onUseInventoryItem })
    disconnect(g_game, { onDropItem = onDropItem })
end
