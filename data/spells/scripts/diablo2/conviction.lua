function onCastSpell(creature, variant)
 local target=Creature(variant:getNumber()); if not target then return false end
 local lvl=creature:getLevel(); local reduction=math.min(85,10+lvl/3)
 target:setStorageValue(71020, reduction)
 target:say('CONVICTION', TALKTYPE_MONSTER_SAY)
 return true
end
