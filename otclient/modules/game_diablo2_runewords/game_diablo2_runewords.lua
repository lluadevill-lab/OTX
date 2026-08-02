-- OTClient Module game_diablo2_runewords - opcode 156 - Runewords Lista
local window = nil
function init()
  g_game.registerExtendedOpcode(156, function(protocol, opcode, buffer)
    local data = json.decode(buffer)
    if not data then return end
    if window then
      local label = window:recursiveGetChildById('infoLabel')
      if label then label:setText('Recebido: '..buffer:sub(1,200)) end
    end
  end)
  g_keyboard.bindKeyDown('Ctrl+R', toggle)
  window = g_ui.displayUI('game_diablo2_runewords')
  window:hide()
end
function terminate()
  g_keyboard.unbindKeyDown('Ctrl+R')
  g_game.unregisterExtendedOpcode(156)
  if window then window:destroy() window=nil end
end
function toggle()
  if not window then return end
  if window:isVisible() then window:hide() else
    g_game.sendExtendedOpcode(156, json.encode({action="open"}))
    window:show() window:raise() window:focus()
  end
end
