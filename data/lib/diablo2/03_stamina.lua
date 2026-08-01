-- Stamina / Corrida
D2C = D2C or {}
D2C.STAMINA_DRAIN_RUN = 3 -- per tick while running
D2C.STAMINA_REGEN_WALK = 10 -- per tick while walking
D2C.STAMINA_REGEN_STAND = 20

function D2C.isRunning(player)
  return D2C.getAttr(player,"RUNNING") == 1
end
function D2C.setRunning(player, running)
  D2C.setAttr(player,"RUNNING", running and 1 or 0)
end
function D2C.consumeStamina(player, amount)
  local cur = D2C.getAttr(player,"STAMINA_CUR")
  if cur <= 0 then cur = D2C.calcStamina(player) end
  cur = cur - (amount or D2C.STAMINA_DRAIN_RUN)
  if cur < 0 then cur = 0; D2C.setRunning(player,false) end
  D2C.setAttr(player,"STAMINA_CUR", cur)
  if cur == 0 then
    -- forced walk: reduce speed condition
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "Sem fôlego! Forçado a andar.")
  end
  return cur
end
function D2C.regenStamina(player, amount)
  local cur = D2C.getAttr(player,"STAMINA_CUR")
  local max = D2C.calcStamina(player)
  if cur < 0 then cur = max end
  cur = math.min(max, cur + (amount or D2C.STAMINA_REGEN_WALK))
  D2C.setAttr(player,"STAMINA_CUR", cur)
  D2C.setAttr(player,"STAMINA_MAX", max)
  return cur
end
function D2C.updateStaminaTick(player)
  if D2C.isRunning(player) then
    return D2C.consumeStamina(player, D2C.STAMINA_DRAIN_RUN)
  else
    return D2C.regenStamina(player, D2C.STAMINA_REGEN_STAND)
  end
end
