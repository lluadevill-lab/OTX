local OPCODE_HOUSE_BUILDER = 69
local window

function init()
  ProtocolGame.registerExtendedOpcode(OPCODE_HOUSE_BUILDER, function() end)

  g_keyboard.bindKeyDown('Ctrl+B', toggle)

  window = g_ui.displayUI('house_builder.otui')
  window:hide()
end

function terminate()
  ProtocolGame.unregisterExtendedOpcode(OPCODE_HOUSE_BUILDER)
  if window then window:destroy() end
end

function toggle()
  if window:isVisible() then
    window:hide()
  else
    window:show()
    window:raise()
    window:focus()
  end
end

function sendBuild(itemId)
  g_game.getProtocolGame():sendExtendedOpcode(OPCODE_HOUSE_BUILDER, tostring(itemId))
end
