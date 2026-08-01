function onKill(creature, target)
  local monster = target:getMonster()
  if monster and D2C and D2C.onMonsterDeathFrozenCheck then
    D2C.onMonsterDeathFrozenCheck(monster, creature)
  end
  if monster and creature:isPlayer() and D2C and D2C.mercLevelUp then
    D2C.mercLevelUp(creature)
  end
  return true
end
