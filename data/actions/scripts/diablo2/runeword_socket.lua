function onUse(player, item, fromPosition, target, toPosition, isHotkey)
  -- target is the gray item to socket runes into
  if not target or not target:isItem() then
    player:sendTextMessage(MESSAGE_STATUS_SMALL,"Use a runa no item cinza com furos")
    return false
  end
  -- Simplified: rune item name = Tal etc
  local runeName = item:getName() -- e.g., Tal Rune
  runeName = runeName:gsub(" Rune","")
  local itemType = target:getType():getName():lower()
  local isGray = true -- simplified check
  local ok, rwName = D2C.validateRuneword({runeName}, itemType, isGray)
  if ok then
    D2C.applyRuneword(player, target, rwName)
  else
    player:sendTextMessage(MESSAGE_STATUS_SMALL,"Runeword falhou: "..(rwName or "ordem errada"))
  end
  return true
end
