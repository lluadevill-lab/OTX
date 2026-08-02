function onUse(player, item, fromPosition, target, toPosition, isHotkey)
  -- target is the gray item to socket runes into (in OTX 3.10 target is Item, use getId check not isItem)
  if not target or not target.getId then
    player:sendTextMessage(MESSAGE_STATUS_SMALL,"Use a runa em cima de um item cinza com furos no chao ou inventario")
    return false
  end
  -- Verifica se target é item (tem getId) e nao é criatura
  if target.isCreature and target:isCreature() then
    player:sendTextMessage(MESSAGE_STATUS_SMALL,"Use a runa no item cinza com furos, nao em criatura")
    return false
  end
  local runeName = item:getName()
  runeName = runeName:gsub(" Rune",""):gsub(" rune","")
  local okType, itemType = pcall(function() return target:getType():getName():lower() end)
  if not okType then itemType = "sword" end
  local isGray = true
  local ok, rwName = D2C.validateRuneword({runeName}, itemType, isGray)
  if ok then
    D2C.applyRuneword(player, target, rwName)
  else
    player:sendTextMessage(MESSAGE_STATUS_SMALL,"Runeword falhou: "..(rwName or "ordem errada ou tipo errado. So itens cinzas com furos"))
  end
  return true
end
