-- Diablo II Extended Opcode handler - cliente OTClient envia opcode 150 para acoes clicaveis
function onExtendedOpcode(player, opcode, buffer)
  if opcode ~= 150 then return true end
  local status, data = pcall(function() return json.decode(buffer) end)
  if not status then data = {action = buffer} end
  local action = data.action or buffer
  if action == "openSkillTree" then
    D2C.openSkillTree(player)
    return true
  elseif action:find("upSkill:") then
    local skillName = action:match("upSkill:(.+)")
    if skillName then
      local ok, res = D2C.addSkillPoint(player, skillName, 1)
      if ok then
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Skill "..skillName.." upada para "..res.." via UI clicavel!")
        player:sendExtendedOpcode(150, json.encode({action="skillTreeUpdate", skill=skillName, level=res, points=D2C.getAttr(player,"SKILL_POINTS")}))
        D2C.openSkillTree(player)
      else
        player:sendTextMessage(MESSAGE_STATUS_SMALL, res)
        player:sendExtendedOpcode(150, json.encode({action="error", message=res}))
      end
    end
    return true
  elseif action:find("attr:") then
    local attr, val = action:match("attr:([%w_]+):(%d+)")
    if attr and val then
      D2C.setAttr(player, attr:upper(), tonumber(val))
      player:sendExtendedOpcode(150, json.encode({action="attrUpdate", attr=attr, val=val}))
      D2C.openCharScreen(player)
    end
    return true
  elseif action == "openCharScreen" then
    D2C.openCharScreen(player)
    return true
  elseif action:find("gamble:") then
    local tipo = action:match("gamble:(%w+)")
    if tipo then
      local item = D2C.doGamble(player, nil, tipo)
      if item then
        player:sendExtendedOpcode(150, json.encode({action="gambleResult", type=tipo, ilvl=item.ilvl, quality=item.quality}))
      end
    end
    return true
  elseif action == "openCube" then
    D2C.openCubeUI(player)
    return true
  elseif action:find("cube:") then
    local recipe = action:match("cube:(.+)")
    if recipe then
      local inputs = {}
      for part in recipe:gmatch("[^,]+") do table.insert(inputs, part:match("^%s*(.-)%s*$")) end
      local out, desc = D2C.cubeTransmute(player, inputs)
      if out then
        player:sendExtendedOpcode(150, json.encode({action="cubeResult", output=out, desc=desc}))
      else
        player:sendExtendedOpcode(150, json.encode({action="cubeError", desc=desc}))
      end
    end
    return true
  end
  return true
end
