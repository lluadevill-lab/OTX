-- OTClient Module game_diablo2_cube - opcode 153 - Horadric Cube Container
local window = nil
function init()
  g_game.registerExtendedOpcode(153, function(protocol, opcode, buffer)
    local data = json.decode(buffer)
    if not data then return end
    if window then
      local label = window:recursiveGetChildById('infoLabel')
      if label then label:setText('Recebido: '..buffer:sub(1,200)) end
    end
  end)
  g_keyboard.bindKeyDown('F11', toggle)
  window = g_ui.displayUI('game_diablo2_cube')
  window:hide()
end
function terminate()
  g_keyboard.unbindKeyDown('F11')
  g_game.unregisterExtendedOpcode(153)
  if window then window:destroy() window=nil end
end
function toggle()
  if not window then return end
  if window:isVisible() then window:hide() else
    g_game.sendExtendedOpcode(153, json.encode({action="open"}))
    window:show() window:raise() window:focus()
  end
end
function transmute(r) g_game.sendExtendedOpcode(153, json.encode({action="cube:"..r})) end
