-- OTClient Module game_diablo2_stash - opcode 154 - Stash Personal/Shared
local window = nil
function init()
  g_game.registerExtendedOpcode(154, function(protocol, opcode, buffer)
    local data = json.decode(buffer)
    if not data then return end
    if window then
      local label = window:recursiveGetChildById('infoLabel')
      if label then label:setText('Recebido: '..buffer:sub(1,200)) end
    end
  end)
  g_keyboard.bindKeyDown('F12', toggle)
  window = g_ui.displayUI('game_diablo2_stash')
  window:hide()
end
function terminate()
  g_keyboard.unbindKeyDown('F12')
  g_game.unregisterExtendedOpcode(154)
  if window then window:destroy() window=nil end
end
function toggle()
  if not window then return end
  if window:isVisible() then window:hide() else
    g_game.sendExtendedOpcode(154, json.encode({action="open"}))
    window:show() window:raise() window:focus()
  end
end
