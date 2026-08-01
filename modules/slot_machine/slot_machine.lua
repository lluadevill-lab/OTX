local config = {
	stones = {
		[1]  = {12668,"leafStone"},
		[2]  = {12656,"fireStone"},
		[3]  = {12666,"waterStone"},
		[4]  = {12663,"iceStone"},
		[5]  = {12657,"crystalStone"},
		[6]  = {11450,"darknessStone"},
		[7]  = {11452,"enigmaStone"},
		[8]  = {11453,"heartStone"},
		[9]  = {11446,"punchStone"},
		[10] = {11445,"rockStone"},
		[11] = {11444,"thunderStone"},
		[12] = {11443,"venomStone"}
	}
}

local window
local slot1
local slot2
local slot3

function init()
	connect(g_game, { onGameEnd = onGameEnd })
	ProtocolGame.registerExtendedOpcode(12, function() end)

	window = g_ui.displayUI('slot_machine.otui')
	window:hide()

	slot1 = window:recursiveGetChildById('slot1')
	slot2 = window:recursiveGetChildById('slot2')
	slot3 = window:recursiveGetChildById('slot3')

	btnMachine = modules.client_topmenu.addRightButton(
		'Slot Machine',
		tr('Slot Machine'),
		'/images/game/machine/icone_machine',
		toggle
	)
end

function terminate()
	disconnect(g_game, { onGameEnd = onGameEnd })
	ProtocolGame.unregisterExtendedOpcode(12)
	window:destroy()
	btnMachine:destroy()
end

function toggle()
	if window:isVisible() then
		window:hide()
	else
		window:show()
	end
end

function onGameEnd()
	window:hide()
end

function Jogar()
	local qtd = #config.stones
	local s1 = math.random(1, qtd)
	local s2 = math.random(1, qtd)
	local s3 = math.random(1, qtd)

	slot1:setImageSource('/images/game/machine/Stones/' .. config.stones[s1][2])
	slot2:setImageSource('/images/game/machine/Stones/' .. config.stones[s2][2])
	slot3:setImageSource('/images/game/machine/Stones/' .. config.stones[s3][2])

	local reward = 1
	if s1 == s2 and s2 == s3 then
		reward = config.stones[s1][1]
		displayInfoBox(tr('Slot Machine'), tr('Voce ganhou uma ' .. config.stones[s1][2]))
	end

	g_game.getProtocolGame():sendExtendedOpcode(12, reward)
end
