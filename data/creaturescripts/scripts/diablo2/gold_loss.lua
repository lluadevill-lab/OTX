function onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
  local player = creature:getPlayer()
  if player and D2C and D2C.goldLossOnDeath then
    D2C.goldLossOnDeath(player)
  end
  return true
end
