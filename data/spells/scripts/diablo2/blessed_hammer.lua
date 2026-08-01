function onCastSpell(creature, variant)
 local p=creature:getPosition(); local damage=math.floor(creature:getLevel()*2.5+creature:getMagicLevel()*8)
 local combat=Combat(); combat:setParameter(COMBAT_PARAM_TYPE,COMBAT_HOLYDAMAGE); combat:setParameter(COMBAT_PARAM_DAMAGE, -damage); combat:setArea(createCombatArea(AREA_CIRCLE3X3)); return combat:execute(creature, variant)
end
