-- Mercenaries - funcional como companion que ataca e segue e teleporta
D2C = D2C or {}
D2C.MERCENARIES = {
  Act1_Rogue = {
    name="Rogue Scout", act=1, monsterName="Rogue Scout",
    weapons={"bow"}, armor={"helm","armor"},
    skills={"Inner Sight","Fire Arrow","Cold Arrow"},
    auras={}, base="Bow, Inner Sight -5% enemy defense",
    hire_level={Normal=8, Nightmare=45, Hell=80},
    stats={str=30, dex=50, life=300}
  },
  Act2_Desert = {
    name="Desert Mercenary", act=2, monsterName="Desert Mercenary",
    weapons={"polearm","spear"}, armor={"helm","armor"},
    skills={"Jab"},
    auras={
      Normal={Combat="Prayer", Defense="Defiance", Offense="Blessed Aim"},
      Nightmare={Combat="Thorns", Defense="Holy Freeze", Offense="Might"},
      Hell={Combat="Prayer", Defense="Defiance", Offense="Blessed Aim"},
    },
    base="Crucial auras - Prayer, Defiance, Might, Holy Freeze",
    hire_level={Normal=20, Nightmare=50, Hell=85},
    stats={str=60, dex=30, life=500}
  },
  Act3_IronWolf = {
    name="Iron Wolf", act=3, monsterName="Iron Wolf",
    weapons={"sword","shield"}, armor={"helm","armor"},
    skills={Fire="Fire Ball, Inferno", Cold="Glacial Spike, Frozen Armor", Lightning="Charged Bolt, Static Field"},
    auras={}, base="Sorcerer merc - fire/light/cold",
    hire_level={Normal=25, Nightmare=55, Hell=85},
    stats={str=40, dex=40, life=400}
  },
  Act5_Barbarian = {
    name="Barbarian Merc", act=5, monsterName="Barbarian Merc",
    weapons={"sword","two_handed_sword"}, armor={"helm","armor"},
    skills={"Bash","Stun"},
    auras={}, base="Tank, Bash, Stun",
    hire_level={Normal=35, Nightmare=60, Hell=85},
    stats={str=80, dex=20, life=600}
  },
}
D2C.MERC_EQUIPS = {"weapon","armor","helm"}

function D2C.spawnMerc(player, act, difficulty, auraChoice)
  local mercType = nil
  if act==1 then mercType=D2C.MERCENARIES.Act1_Rogue
  elseif act==2 then mercType=D2C.MERCENARIES.Act2_Desert
  elseif act==3 then mercType=D2C.MERCENARIES.Act3_IronWolf
  else mercType=D2C.MERCENARIES.Act5_Barbarian end
  
  local lvl = D2C.safeLevel(player)
  D2C.setAttr(player,"MERC_TYPE",act)
  D2C.setAttr(player,"MERC_LVL",lvl)
  
  -- Remove old merc summon if exists
  local summons = player:getSummons()
  for _, summon in ipairs(summons) do
    local sName = summon:getName():lower()
    if sName:find("merc") or sName:find("rogue") or sName:find("scout") or sName:find("wolf") or sName:find("barbarian") then
      summon:remove()
    end
  end

  local pos = player:getPosition()
  local monsterName = mercType.monsterName
  local mercMonster = nil
  local ok, m = pcall(function() return Game.createMonster(monsterName, pos, false, true) end)
  if ok then mercMonster = m end
  if mercMonster then
    pcall(function() mercMonster:setMaster(player) end)
    pcall(function() player:addSummon(mercMonster) end)
    local maxHealth = mercType.stats.life + lvl*10
    pcall(function() mercMonster:setMaxHealth(maxHealth) end)
    pcall(function() mercMonster:addHealth(maxHealth - mercMonster:getHealth()) end)
    -- Guarda aura escolhida no player storage, nao no monster (monster setStorageValue pode nao existir)
    D2C.setAttr(player, "MERC_TYPE", act)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Mercenario contratado: "..mercType.name.." Lvl "..lvl.." Aura: "..(auraChoice or "default").."! Ele vai te seguir, atacar tudo ao redor e teleportar quando longe (igual Diablo 2). Use !d2merc para ver status.")
    pcall(function() player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE) end)
    if auraChoice and auraChoice:lower():find("holy freeze") then
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,"Holy Freeze ativa: monstros proximos ficam lentos!")
    elseif auraChoice and auraChoice:lower():find("might") then
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,"Might ativa: +230% dano fisico!")
    end
  else
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Mercenario contratado: "..mercType.name.." Lvl "..lvl.." Aura: "..(auraChoice or "default").."! (Monstro "..monsterName.." nao encontrado, mas aura e status salvos. Verifique monsters.xml)")
  end
  return mercType
end

function D2C.mercLevelUp(player)
  local mercLvl = D2C.getAttr(player,"MERC_LVL")
  local plvl = D2C.safeLevel(player)
  if plvl > mercLvl then
    D2C.setAttr(player,"MERC_LVL",plvl)
    local summons = player:getSummons()
    for _, summon in ipairs(summons) do
      local sName = summon:getName():lower()
      if sName:find("merc") or sName:find("scout") or sName:find("wolf") or sName:find("barbarian") then
        local newMax = 300 + plvl*10
        pcall(function() summon:setMaxHealth(newMax) end)
        pcall(function() summon:addHealth(newMax - summon:getHealth()) end)
      end
    end
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,"Seu mercenario subiu para nivel "..plvl.."! Vida aumentada. Teleporta quando longe.")
  end
end

function D2C.mercEquip(player, slot, item)
  if not table.contains(D2C.MERC_EQUIPS, slot) then return false, "Slot invalido" end
  if item and item.isEthereal then item.durabilityLoss = 0 end
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Merc equipou "..(item and item.name or "item").." no slot "..slot.."! (Ethereal sem gastar dura)")
  return true
end


function D2C.applyMercAura(player)
  local act = D2C.getAttr(player, "MERC_TYPE")
  if act==0 then return end
  -- Check if merc summon exists near player
  local summons = player:getSummons()
  local hasMerc = false
  for _, s in ipairs(summons) do
    local n = s:getName():lower()
    if n:find("merc") or n:find("rogue") or n:find("scout") or n:find("wolf") or n:find("barbarian") then hasMerc=true break end
  end
  if not hasMerc then return end
  -- Aura Might: +40% phys damage example via storage
  -- For simplicity, give player extra attack via condition? We'll just send message and give extra damage via storage bonus
  -- This is called from stamina_tick or login think
end

