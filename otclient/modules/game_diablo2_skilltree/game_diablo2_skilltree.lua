-- OTClient Module game_diablo2_skilltree - opcode 150 - Skill Tree - UPAR com clique
local window = nil
function init()
  g_game.registerExtendedOpcode(150, function(protocol, opcode, buffer)
    local data = json.decode(buffer)
    if not data then return end
    if window then
      local label = window:recursiveGetChildById('infoLabel')
      if label then label:setText('Recebido: '..buffer:sub(1,200)) end
    end
  end)
  g_keyboard.bindKeyDown('F8', toggle)
  window = g_ui.displayUI('game_diablo2_skilltree')
  window:hide()
end
function terminate()
  g_keyboard.unbindKeyDown('F8')
  g_game.unregisterExtendedOpcode(150)
  if window then window:destroy() window=nil end
end
function toggle()
  if not window then return end
  if window:isVisible() then window:hide() else
    g_game.sendExtendedOpcode(150, json.encode({action="open"}))
    window:show() window:raise() window:focus()
  end
end
function upSkill(name) g_game.sendExtendedOpcode(150, json.encode({action="upSkill:"..name})) end
