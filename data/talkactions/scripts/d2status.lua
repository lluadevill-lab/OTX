function onSay(player, words, param)
  local function v(name) return D2.get(player, name) end
  local diff = ({[0]='Normal',[1]='Pesadelo',[2]='Inferno'})[v('difficulty')] or 'Normal'
  local text = string.format('D2 | STR %d DEX %d VIT %d ENE %d | MF %d%% | FCR %d FHR %d IAS %d | %s',
    v('strength'), v('dexterity'), v('vitality'), v('energy'), v('mf'), v('fcr'), v('fhr'), v('ias'), diff)
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, text)
  return false
end
