function onSay(player, words, param)
  if D2C and D2C.openCharScreen then
    D2C.openCharScreen(player)
  else
    local function v(name) 
      if D2 and D2.get then return D2.get(player,name) else return 0 end
    end
    local text = string.format('D2 | STR %d DEX %d VIT %d ENE %d | MF %d | FCR %d FHR %d IAS %d', v('strength'), v('dexterity'), v('vitality'), v('energy'), v('mf'), v('fcr'), v('fhr'), v('ias'))
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, text)
  end
  return false
end
