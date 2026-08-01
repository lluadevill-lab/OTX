-- OTClient Module game_diablo2_gambling - opcode 152 - Gheed Gambling
local window = nil
function init()
  g_game.registerExtendedOpcode(152, function(protocol, opcode, buffer)
    local data = json.decode(buffer)
    if not data then return end
    if window then
      local label = window:recursiveGetChildById('infoLabel')
      if label then label:setText('Recebido: '..buffer:sub(1,200)) end
    end
  end)
  g_keyboard.bindKeyDown('F10', toggle)
  window = g_ui.displayUI('game_diablo2_gambling')
  window:hide()
end
function terminate()
  g_keyboard.unbindKeyDown('F10')
  g_game.unregisterExtendedOpcode(152)
  if window then window:destroy() window=nil end
end
function toggle()
  if not window then return end
  if window:isVisible() then window:hide() else
    g_game.sendExtendedOpcode(152, json.encode({action="open"}))
    window:show() window:raise() window:focus()
  end
end
function gambleRing() g_game.sendExtendedOpcode(152, json.encode({action="gamble:ring"})) end
function gambleAmulet() g_game.sendExtendedOpcode(152, json.encode({action="gamble:amulet"})) end
