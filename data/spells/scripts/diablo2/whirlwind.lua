function onCastSpell(creature, variant)
 local combat=Combat(); combat:setParameter(COMBAT_PARAM_TYPE,COMBAT_PHYSICALDAMAGE); combat:setParameter(COMBAT_PARAM_BLOCKARMOR,1); combat:setFormula(COMBAT_FORMULA_LEVELMAGIC, -1.0, 0, -2.0, -10); combat:setArea(createCombatArea(AREA_CIRCLE2X2)); return combat:execute(creature, variant)
end
