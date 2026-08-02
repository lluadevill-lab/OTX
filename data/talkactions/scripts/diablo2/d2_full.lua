-- Diablo II Full interface talkaction
function onSay(player, words, param)
  local originalParam = param
  param = param:lower():trim()
  if param == "status" or param == "" then
    D2C.openCharScreen(player)
  elseif param == "skills" or param == "skill" then
    D2C.openSkillTree(player)
  elseif param == "charms" then
    D2C.openInventoryCharms(player)
  elseif param == "cube" then
    D2C.openCubeUI(player)
  elseif param == "runewords" or param == "rw" then
    D2C.openRunewordsUI(player)
  elseif param == "stash" then
    D2C.openStash(player)
  elseif param == "menu" then
    D2C.mainMenu(player)
  elseif param:find("attr") then
    local attr, val = param:match("attr ([%w_]+) (%d+)")
    if attr and val then
      local ok = D2C.setAttr(player, attr:upper(), tonumber(val))
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Atributo "..attr:upper().." set "..val.." (storage "..(D2C.STORAGES[attr:upper()] or 0)..")")
      -- Refresh char screen
      D2C.openCharScreen(player)
    else
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Use: !d2 attr STR 10 | DEX | VIT | ENE | FCR | FHR | IAS | FBR | MF | SKILL_POINTS 10 | CB 20 etc")
    end
  elseif param:find("players") then
    local n = tonumber(param:match("players (%d+)")) or 1
    D2C.setPlayers(player, n)
  elseif param:find("diff") then
    local diff = param:match("diff (%d)") or param:match("diff (%a+)")
    if diff=="0" or diff=="normal" then D2C.setDifficulty(player,0)
    elseif diff=="1" or diff=="pesadelo" or diff=="nightmare" then D2C.setDifficulty(player,1)
    elseif diff=="2" or diff=="inferno" or diff=="hell" then D2C.setDifficulty(player,2)
    end
  elseif param:find("skill ") then
    local sk = originalParam:match("[Ss][Kk][Ii][Ll][Ll] (.+)")
    if sk then
      -- Try exact name first, then capitalize each word
      local function capWords(s) return s:gsub("(%a)([%w_']*)", function(first, rest) return first:upper()..rest:lower() end) end
      local skillName = capWords(sk:trim())
      local ok, res = D2C.addSkillPoint(player, skillName, 1)
      if not ok then
        -- Try direct as typed (for names like Fire Bolt)
        ok, res = D2C.addSkillPoint(player, sk:trim(), 1)
        if not ok then
          -- Try title case per word
          local parts = {}
          for w in sk:gmatch("%S+") do table.insert(parts, w:sub(1,1):upper()..w:sub(2):lower()) end
          skillName = table.concat(parts, " ")
          ok, res = D2C.addSkillPoint(player, skillName, 1)
        end
      end
      if ok then player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Skill "..sk.." upada para "..res) 
      else player:sendTextMessage(MESSAGE_STATUS_SMALL, res) end
    end
  else
    D2C.mainMenu(player)
  end
  return false
end
