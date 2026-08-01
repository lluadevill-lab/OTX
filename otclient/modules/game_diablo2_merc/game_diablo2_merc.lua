-- OTClient Module game_diablo2_merc - opcode 157 - Mercenarios Act
local window = nil
function init()
  g_game.registerExtendedOpcode(157, function(protocol, opcode, buffer)
    local data = json.decode(buffer)
    if not data then return end
    if window then
      local label = window:recursiveGetChildById('infoLabel')
      if label then label:setText('Recebido: '..buffer:sub(1,200)) end
    end
  end)
  g_keyboard.bindKeyDown('Ctrl+M', toggle)
  window = g_ui.displayUI('game_diablo2_merc')
  window:hide()
end
function terminate()
  g_keyboard.unbindKeyDown('Ctrl+M')
  g_game.unregisterExtendedOpcode(157)
  if window then window:destroy() window=nil end
end
function toggle()
  if not window then return end
  if window:isVisible() then window:hide() else
    g_game.sendExtendedOpcode(157, json.encode({action="open"}))
    window:show() window:raise() window:focus()
  end
end
function hireMerc(a) g_game.sendExtendedOpcode(157, json.encode({action="hire:"..a})) end
