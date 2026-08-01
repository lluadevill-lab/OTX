SOUNDS_CONFIG = {
    checkInterval = 50,
    folder = 'music/',
    maxVolume = 100,
    fadeDistance = 5,
    fadeTime = 100,
    firstChannel = 10,
    effectChannel = 30
}

local OPCODE_SOUND = 50

SOUNDS = {
    { fromPos = { x = 700, y = 803, z = 7 }, toPos = { x = 733, y = 866, z = 7 }, sound = "Ocean.ogg" },
    { fromPos = { x = 695, y = 867, z = 7 }, toPos = { x = 742, y = 911, z = 7 }, sound = "Waterfall.ogg" },
    { fromPos = { x = 695, y = 911, z = 7 }, toPos = { x = 769, y = 967, z = 7 }, sound = "Ocean.ogg" },
    { fromPos = { x = 749, y = 926, z = 7 }, toPos = { x = 763, y = 934, z = 7 }, sound = "Waterfall.ogg" },
    { fromPos = { x = 751, y = 919, z = 8 }, toPos = { x = 763, y = 943, z = 8 }, sound = "Underwater.ogg" },
    { fromPos = { x = 700, y = 872, z = 5 }, toPos = { x = 763, y = 926, z = 5 }, sound = "Corvos.ogg" },
    { fromPos = { x = 717, y = 873, z = 5 }, toPos = { x = 733, y = 890, z = 5 }, sound = "Waterfall.ogg" },
    { fromPos = { x = 1393, y = 1072, z = 4 }, toPos = { x = 1411, y = 1082, z = 4 }, sound = "Waterfall.ogg" },
}

local soundData = {}
local toggleSoundEvent
local effectChannel

-- Função vazia necessária para evitar o crash no registro do Opcode
function onSoundOpcode(protocol, opcode, buffer)
end

function initSound()
    for i = 1, #SOUNDS do
        local s = SOUNDS[i]
        s.sound = SOUNDS_CONFIG.folder .. s.sound

        local channelId = SOUNDS_CONFIG.firstChannel + i
        local channel = g_sounds.getChannel(channelId)
        channel:stop()
        channel:setGain(0)

        soundData[i] = {
            channel = channel,
            playing = false,
            fadeEvent = nil
        }
    end

    effectChannel = g_sounds.getChannel(SOUNDS_CONFIG.effectChannel)
    effectChannel:setGain(100)

    -- Agora a função onSoundOpcode existe, então não vai dar erro
    ProtocolGame.registerExtendedOpcode(OPCODE_SOUND, onSoundOpcode)

    connect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd
    })

    if g_game.isOnline() then
        onGameStart()
    end
end

function terminateSound()
    ProtocolGame.unregisterExtendedOpcode(OPCODE_SOUND)
    onGameEnd()
end

function onGameStart()
    toggleSoundEvent = scheduleEvent(toggleSound, SOUNDS_CONFIG.checkInterval)
end

function onGameEnd()
    if toggleSoundEvent then
        removeEvent(toggleSoundEvent)
        toggleSoundEvent = nil
    end

    for _, d in pairs(soundData) do
        if d.fadeEvent then removeEvent(d.fadeEvent) end
        d.channel:stop()
        d.channel:setGain(0)
        d.playing = false
    end
end

function isInPos(pos, fromPos, toPos)
    return pos.z == fromPos.z
       and pos.x >= fromPos.x and pos.x <= toPos.x
       and pos.y >= fromPos.y and pos.y <= toPos.y
end

local function distanceToBorder(pos, area)
    return math.min(
        pos.x - area.fromPos.x,
        area.toPos.x - pos.x,
        pos.y - area.fromPos.y,
        area.toPos.y - pos.y
    )
end

local function calculateVolume(pos, area)
    local d = distanceToBorder(pos, area)
    local f = SOUNDS_CONFIG.fadeDistance
    if d >= f then return SOUNDS_CONFIG.maxVolume end
    return math.max(0, (d / f) * SOUNDS_CONFIG.maxVolume)
end

local function fadeTo(data, target)
    if data.fadeEvent then removeEvent(data.fadeEvent) end

    local start = data.channel:getGain()
    local steps = math.max(1, math.floor(SOUNDS_CONFIG.fadeTime / 50))
    local step = 0

    local function tick()
        step = step + 1
        local gain = start + (target - start) * (step / steps)
        data.channel:setGain(gain)

        if step < steps then
            data.fadeEvent = scheduleEvent(tick, 50)
        else
            data.channel:setGain(target)
            data.fadeEvent = nil
            if target == 0 then
                data.channel:stop()
                data.playing = false
            end
        end
    end

    tick()
end

function toggleSound()
    local player = g_game.getLocalPlayer()
    if not player then return end

    local pos = player:getPosition()

    for i, s in ipairs(SOUNDS) do
        local d = soundData[i]

        if isInPos(pos, s.fromPos, s.toPos) then
            local vol = calculateVolume(pos, s)

            if not d.playing then
                d.channel:enqueue(s.sound, 0)
                d.playing = true
            end

            fadeTo(d, vol)
        else
            if d.playing then
                fadeTo(d, 0)
            end
        end
    end

    toggleSoundEvent = scheduleEvent(toggleSound, SOUNDS_CONFIG.checkInterval)
end