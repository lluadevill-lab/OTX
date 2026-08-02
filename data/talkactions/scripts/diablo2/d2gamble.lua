function onSay(player, words, param)
  local type = param:trim()=="" and "ring" or param:trim()
  local item = D2C.doGamble(player, nil, type)
  if item then
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,string.format("Gamble %s ilvl %d %s", type, item.ilvl, item.quality))
  end
  return false
end
