function onSay(player, words, param)
  local n = tonumber(param) or 1
  if n<1 then n=1 end
  if n>8 then n=8 end
  D2C.setPlayers(player, n)
  return false
end
