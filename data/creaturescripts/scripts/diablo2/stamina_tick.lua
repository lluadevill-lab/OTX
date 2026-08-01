function onThink(creature, interval)
  local player = creature:getPlayer()
  if not player then return true end
  if D2C and D2C.updateStaminaTick then D2C.updateStaminaTick(player) end
  return true
end
