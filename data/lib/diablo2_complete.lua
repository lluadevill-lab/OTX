-- Master loader for Diablo II Complete - call from global.lua
if D2C and D2C.LOADED then return end
dofile('data/lib/diablo2/init.lua')

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

D2C.LOADED = true

function onD2Hit(attacker, defender, damage, params)
  params = params or {}
  if not attacker or not defender then return damage or 0, "hit" end
  local okHit, hitChance = pcall(function() return D2C.hitChance(attacker, defender, params.ar or 100, params.def or 50, params.itd) end)
  if not okHit then hitChance = 85 end
  local roll = math.random(100)
  if roll > hitChance then return 0, "miss" end
  local block = 0
  local okBlock, b = pcall(function() return D2C.blockChance(defender, params.shieldBlock or 20, params.running) end)
  if okBlock then block = b end
  if math.random(100) <= block then return 0, "blocked" end
  local cbDmg = 0
  if params.cb and math.random(100) <= params.cb then
    local okCB, dmgCB = pcall(function() return D2C.crushingBlow(defender, params.isBoss, defender.isPlayer and defender:isPlayer() or false) end)
    if okCB then damage = damage + dmgCB end
  end
  local okDeadly, dmgDeadly = pcall(function() return D2C.applyDeadly(damage, params.cs or 0, params.ds or 0) end)
  if okDeadly then damage = dmgDeadly end
  local okAbs, dmgAbs = pcall(function() return D2C.absorb(damage, params.fixedAbsorb or 0, params.pctAbsorb or 0, params.resist or 0) end)
  if okAbs then damage = dmgAbs end
  if params.lifeLeech or params.manaLeech then pcall(function() D2C.applyLeech(attacker, damage, params.lifeLeech or 0, params.manaLeech or 0) end) end
  if params.ow and math.random(100) <= params.ow then
    pcall(function()
      local owDmg = D2C.applyOpenWounds(defender, D2C.safeLevel(attacker), 8)
      damage = damage + math.floor(owDmg/8)
    end)
  end
  if params.kb then pcall(function() D2C.knockback(attacker, defender, true) end) end
  if params.ctc then pcall(function() D2C.triggerCtC(attacker, "onStriking", params.ctc) end) end
  return damage, "hit"
end

function onD2Death(monster, killer)
  local shattered = false
  pcall(function() shattered = D2C.onMonsterDeathFrozenCheck(monster, killer) end)
  local playersNearby = {}
  if Game and Game.getSpectators and monster and monster.getPosition then
    local ok, specs = pcall(function() return Game.getSpectators(monster:getPosition(), false, false, 10,10,10,10) end)
    if ok and specs then
      for _, p in ipairs(specs) do if p.isPlayer and p:isPlayer() then table.insert(playersNearby, p:getId()) end end
    end
  end
  pcall(function() D2C.dropLootShared(monster, {{name="Gold", count=math.random(50,200)}}, monster:getPosition(), playersNearby) end)
  return not shattered
end

print(">> Diablo II Complete Master Loaded - safeLevel + pcall")
