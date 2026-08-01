
local skillWindow = nil
function init()
  g_game.registerExtendedOpcode(150, function(protocol, opcode, buffer)
    local data = json.decode(buffer)
    if not data then return end
    if data.action == "skillTreeUpdate" then
      -- update UI
    end
  end)
  g_keyboard.bindKeyDown('F8', function() g_game.sendExtendedOpcode(150, json.encode({action="openSkillTree"})) end)
end
function terminate()
  g_game.unregisterExtendedOpcode(150)
  g_keyboard.unbindKeyDown('F8')
end
