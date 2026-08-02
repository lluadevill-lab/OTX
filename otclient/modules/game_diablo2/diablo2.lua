-- OTClient Main Diablo II Module - handles all 10 opcodes 150-159 with hotkeys F8-F12 Ctrl+ combos
-- This is the main module that guarantees loading even if others fail

local windows = {}

function init()
  -- Register all 10 opcodes
  for opcode = 150, 159 do
    g_game.registerExtendedOpcode(opcode, function(protocol, op, buffer)
      local ok, data = pcall(function() return json.decode(buffer) end)
      if not ok or not data then return end
      local action = data.action or ""
      -- Show message in console
      if modules.game_textmessage then
        modules.game_textmessage.displayStatusMessage("[D2-"..opcode.."] "..action)
      end
      -- Update UI if window exists
      local winName = "diablo2_"..opcode
      -- Generic handling
      if data.action and data.action:find("skillTreeUpdate") then
        if windows[150] then
          local label = windows[150]:recursiveGetChildById('infoLabel')
          if label then label:setText('Skill '..(data.skill or '')..' Lvl '..(data.level or '')..' Points '..(data.points or '')) end
        end
      end
    end)
  end

  -- Hotkeys F8-F12, Ctrl+C,R,M,U,L
  g_keyboard.bindKeyDown('F8', function() toggleSkillTree() end)
  g_keyboard.bindKeyDown('F9', function() g_game.sendExtendedOpcode(151, json.encode({action="openCharScreen"})) end)
  g_keyboard.bindKeyDown('F10', function() g_game.sendExtendedOpcode(152, json.encode({action="openGamble"})) end)
  g_keyboard.bindKeyDown('F11', function() g_game.sendExtendedOpcode(153, json.encode({action="openCube"})) end)
  g_keyboard.bindKeyDown('F12', function() g_game.sendExtendedOpcode(154, json.encode({action="openStash"})) end)
  g_keyboard.bindKeyDown('Ctrl+C', function() g_game.sendExtendedOpcode(155, json.encode({action="openCharms"})) end)
  g_keyboard.bindKeyDown('Ctrl+R', function() g_game.sendExtendedOpcode(156, json.encode({action="openRunewords"})) end)
  g_keyboard.bindKeyDown('Ctrl+M', function() g_game.sendExtendedOpcode(157, json.encode({action="openMerc"})) end)
  g_keyboard.bindKeyDown('Ctrl+U', function() g_game.sendExtendedOpcode(158, json.encode({action="openUber"})) end)
  g_keyboard.bindKeyDown('Ctrl+L', function() g_game.sendExtendedOpcode(159, json.encode({action="openLoot"})) end)

  -- Create main menu window
  local otui = [[
MainWindow
  id: diablo2MainWindow
  !text: tr('Diablo II - Menu (F8 Skills, F9 Status, F10 Gamble, F11 Cube, F12 Stash)')
  size: 400 400
  @onEscape: self:hide()

  Label
    id: infoLabel
    text: Diablo II - 10 systems ready. Press F8-F12, Ctrl+C,R,M,U,L
    anchors.top: parent.top
    margin: 5

  Button
    id: skillTreeBtn
    !text: tr('Skill Tree F8')
    anchors.top: prev.bottom
    margin-top: 10
    width: 350
    anchors.horizontalCenter: parent.horizontalCenter
    @onClick: g_game.sendExtendedOpcode(150, json.encode({action="openSkillTree"}))

  Button
    id: charScreenBtn
    !text: tr('Char Screen F9')
    anchors.top: prev.bottom
    margin-top: 5
    width: 350
    anchors.horizontalCenter: parent.horizontalCenter
    @onClick: g_game.sendExtendedOpcode(151, json.encode({action="openCharScreen"}))

  Button
    id: gambleBtn
    !text: tr('Gheed Gambling F10')
    anchors.top: prev.bottom
    margin-top: 5
    width: 350
    anchors.horizontalCenter: parent.horizontalCenter
    @onClick: g_game.sendExtendedOpcode(152, json.encode({action="openGamble"}))

  Button
    id: cubeBtn
    !text: tr('Horadric Cube F11')
    anchors.top: prev.bottom
    margin-top: 5
    width: 350
    anchors.horizontalCenter: parent.horizontalCenter
    @onClick: g_game.sendExtendedOpcode(153, json.encode({action="openCube"}))

  Button
    id: stashBtn
    !text: tr('Stash F12')
    anchors.top: prev.bottom
    margin-top: 5
    width: 350
    anchors.horizontalCenter: parent.horizontalCenter
    @onClick: g_game.sendExtendedOpcode(154, json.encode({action="openStash"}))

  Button
    id: charmsBtn
    !text: tr('Charms Ctrl+C')
    anchors.top: prev.bottom
    margin-top: 5
    width: 350
    anchors.horizontalCenter: parent.horizontalCenter
    @onClick: g_game.sendExtendedOpcode(155, json.encode({action="openCharms"}))

  Button
    id: runewordsBtn
    !text: tr('Runewords Ctrl+R')
    anchors.top: prev.bottom
    margin-top: 5
    width: 350
    anchors.horizontalCenter: parent.horizontalCenter
    @onClick: g_game.sendExtendedOpcode(156, json.encode({action="openRunewords"}))

  Button
    id: mercBtn
    !text: tr('Mercenarios Ctrl+M')
    anchors.top: prev.bottom
    margin-top: 5
    width: 350
    anchors.horizontalCenter: parent.horizontalCenter
    @onClick: g_game.sendExtendedOpcode(157, json.encode({action="openMerc"}))

  Button
    id: uberBtn
    !text: tr('Uber Diablo Ctrl+U')
    anchors.top: prev.bottom
    margin-top: 5
    width: 350
    anchors.horizontalCenter: parent.horizontalCenter
    @onClick: g_game.sendExtendedOpcode(158, json.encode({action="openUber"}))

  Button
    id: lootBtn
    !text: tr('Loot Compartilhado Ctrl+L')
    anchors.top: prev.bottom
    margin-top: 5
    width: 350
    anchors.horizontalCenter: parent.horizontalCenter
    @onClick: g_game.sendExtendedOpcode(159, json.encode({action="openLoot"}))

  Button
    id: closeButton
    !text: tr('Fechar')
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    margin-bottom: 5
    width: 100
    @onClick: self:getParent():hide()
]]

  local ui = g_ui.createWidgetFromText(otui, g_ui.getRootWidget())
  ui:hide()
  windows[0] = ui -- main menu
  -- Individual windows for each system will be created on demand via extended opcode
end

function terminate()
  for i=150,159 do
    g_game.unregisterExtendedOpcode(i)
  end
  g_keyboard.unbindKeyDown('F8')
  g_keyboard.unbindKeyDown('F9')
  g_keyboard.unbindKeyDown('F10')
  g_keyboard.unbindKeyDown('F11')
  g_keyboard.unbindKeyDown('F12')
  g_keyboard.unbindKeyDown('Ctrl+C')
  g_keyboard.unbindKeyDown('Ctrl+R')
  g_keyboard.unbindKeyDown('Ctrl+M')
  g_keyboard.unbindKeyDown('Ctrl+U')
  g_keyboard.unbindKeyDown('Ctrl+L')
  for _, win in pairs(windows) do
    if win then win:destroy() end
  end
end

function toggleSkillTree()
  g_game.sendExtendedOpcode(150, json.encode({action="openSkillTree"}))
end
