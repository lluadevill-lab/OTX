-- OTClient Module game_diablo2_uber - opcode 158 - Uber Diablo & Pandemonium
local window = nil
function init()
  g_game.registerExtendedOpcode(158, function(protocol, opcode, buffer)
    local data = json.decode(buffer)
    if not data then return end
    if window then
      local label = window:recursiveGetChildById('infoLabel')
      if label then label:setText('Recebido: '..buffer:sub(1,200)) end
    end
  end)
  g_keyboard.bindKeyDown('Ctrl+U', toggle)
  window = g_ui.displayUI('game_diablo2_uber')
  window:hide()
end
function terminate()
  g_keyboard.unbindKeyDown('Ctrl+U')
  g_game.unregisterExtendedOpcode(158)
  if window then window:destroy() window=nil end
end
function toggle()
  if not window then return end
  if window:isVisible() then window:hide() else
    g_game.sendExtendedOpcode(158, json.encode({action="open"}))
    window:show() window:raise() window:focus()
  end
end
function sellSoJ() g_game.sendExtendedOpcode(158, json.encode({action="soj"})) end
