-- Master loader for Diablo II Complete - call from global.lua
-- Ensures backward compatibility with old D2, D2R modules

-- Avoid double load
if D2C and D2C.LOADED then return end

dofile('data/lib/diablo2/init.lua')

-- Compatibility shims for old API
D2 = D2 or {}
D2R = D2R or {}
D2.get = D2.get or function(p,s) return D2C.getAttr(p,s) end
D2.add = D2.add or function(p,s,a) return D2C.setAttr(p,s,(D2C.getAttr(p,s)+a)) end
D2R.val = D2R.val or function(p,k) return D2C.getAttr(p,k:upper()) end
D2R.diff = D2R.diff or function(p) return D2C.getAttr(p,"DIFF") end
D2R.block = D2R.block or function(p,shield,run) return D2C.blockChance(p,shield,run) end
D2R.hit = D2R.hit or function(a,t,ar,def,itd) return D2C.hitChance(a,t,ar,def,itd) end
D2R.absorb = D2R.absorb or function(d,f,pct) return D2C.absorb(d,f,pct) end
D2R.leech = D2R.leech or function(p,d,l,m) return D2C.applyLeech(p,d,l,m) end
D2R.mf = D2R.mf or function(mf,q) 
  local e = {magic=mf, rare=mf*600/(600+mf), set=mf*500/(500+mf), unique=mf*250/(250+mf)}
  return e[q] or mf
end

-- Export global helpers for spells/actions
D2C.LOADED = true

-- Hooks for combat integration (to be called from C++ or Lua creaturescripts)
function onD2Hit(attacker, defender, damage, params)
  -- params: ar, def, itd, cs, ds, cb, ow, kb, leech, ctc
  params = params or {}
  local hitChance = D2C.hitChance(attacker, defender, params.ar or 100, params.def or 50, params.itd)
  local roll = math.random(100)
  if roll > hitChance then return 0, "miss" end

  -- Block check
  local block = D2C.blockChance(defender, params.shieldBlock or 20, params.running)
  if math.random(100) <= block then return 0, "blocked" end

  -- Crushing Blow
  local cbDmg = 0
  if params.cb and math.random(100) <= params.cb then
    cbDmg = D2C.crushingBlow(defender, params.isBoss, defender:isPlayer())
    damage = damage + cbDmg
  end

  -- Deadly/Critical
  damage = D2C.applyDeadly(damage, params.cs or 0, params.ds or 0)

  -- Absorption
  damage = D2C.absorb(damage, params.fixedAbsorb or 0, params.pctAbsorb or 0, params.resist or 0)

  -- Leech
  if params.lifeLeech or params.manaLeech then
    D2C.applyLeech(attacker, damage, params.lifeLeech or 0, params.manaLeech or 0)
  end

  -- Open Wounds
  if params.ow and math.random(100) <= params.ow then
    local owDmg, dur = D2C.applyOpenWounds(defender, attacker:getLevel(), 8)
    damage = damage + math.floor(owDmg/8) -- first tick
  end

  -- Knockback
  if params.kb then D2C.knockback(attacker, defender, true) end

  -- CtC on striking
  if params.ctc then D2C.triggerCtC(attacker, "onStriking", params.ctc) end

  return damage, "hit"
end

function onD2Death(monster, killer)
  -- corpse, shatter, loot shared
  local shattered = D2C.onMonsterDeathFrozenCheck(monster, killer)
  -- loot shared
  local playersNearby = {}
  for _, p in ipairs(Game.getSpectators(monster:getPosition(), false, false, 10,10,10,10)) do
    if p:isPlayer() then table.insert(playersNearby, p:getId()) end
  end
  D2C.dropLootShared(monster, {{name="Gold", count=math.random(50,200)}}, monster:getPosition(), playersNearby)
  -- SoJ counter for Uber Diablo if monster drops SoJ? Alternatively sold check elsewhere
  return not shattered
end

print(">> Diablo II Complete Master Loaded")
