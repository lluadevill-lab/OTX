function onSay(player, words, param)
  if param=="soj" then
    local spawned, total = D2C.sellSoJ(player)
    if spawned then
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED,"Uber Diablo spawned! Global SoJ count reset.")
    else
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"SoJ vendidos: "..total.."/"..D2C.SOJ_COUNTER_MAX)
    end
  elseif param=="keys" then
    D2C.openPandemoniumPortal(player, {"Terror","Hate","Destruction"})
  elseif param=="tristram" then
    D2C.openUberTristram(player, {"Diablo's Horn","Baal's Eye","Mephisto's Brain"})
  else
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"!d2uber soj | keys | tristram")
  end
  return false
end
