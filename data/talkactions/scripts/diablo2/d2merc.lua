function onSay(player, words, param)
  local act = tonumber(param) or 2
  local merc = D2C.spawnMerc(player, act, 1, "Might")
  return false
end
