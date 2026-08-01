function onSay(player, words, param)
  if param=="" then
    D2C.openCubeUI(player)
    return false
  end
  local inputs = param:split(",")
  for i=1,#inputs do inputs[i]=inputs[i]:trim() end
  local out, desc = D2C.cubeTransmute(player, inputs)
  if out then
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Cubo: "..table.concat(inputs," + ").." => "..out.." | "..(desc or ""))
  else
    player:sendTextMessage(MESSAGE_STATUS_SMALL, desc or "Receita invalida")
  end
  return false
end
