-- Diablo II rules layer for OTX 3.10.
-- All values are server-side and deliberately exposed as small functions so the
-- client can later render a D2-style character/inventory screen.
D2 = D2 or {}
D2.STORAGE = { strength = 71000, dexterity = 71001, vitality = 71002, energy = 71003,
  mf = 71004, fcr = 71005, fhr = 71006, ias = 71007, fbr = 71008, run = 71009,
  difficulty = 71010, players = 71011 }
D2.DIFFICULTY = { normal = 0, nightmare = 1, hell = 2 }
D2.RESIST_PENALTY = { [0] = 0, [1] = -40, [2] = -100 }

function D2.get(player, stat)
  return math.max(0, player:getStorageValue(D2.STORAGE[stat]))
end
function D2.add(player, stat, amount)
  local value = D2.get(player, stat) + amount
  player:setStorageValue(D2.STORAGE[stat], value)
  return value
end
function D2.levelPenalty(level, areaLevel)
  local delta = math.abs(level - areaLevel)
  if delta <= 5 then return 1.0 end
  if delta <= 10 then return 0.75 end
  return math.max(0.05, 1.0 - delta * 0.05)
end
function D2.breakpoint(value, table_) -- returns the animation frame rate breakpoint reached
  local reached = 0
  for _, bp in ipairs(table_) do if value >= bp then reached = bp else break end end
  return reached
end
D2.BREAKPOINTS = {
  fcr = {0, 9, 20, 37, 63, 105, 200}, fhr = {0, 7, 15, 27, 48, 86, 200},
  ias = {0, 10, 20, 30, 50, 75, 125}, fbr = {0, 10, 20, 40, 60, 86,  block = 75}
}
function D2.blockChance(player, shieldBlock)
  local dex = D2.get(player, 'dexterity')
  local level = math.max(1, player:getLevel())
  local chance = (shieldBlock * (dex - 15)) / (2.0 * level)
  if player:isCreature() and player:getCondition(CONDITION_HASTE) then chance = chance / 3 end
  return math.max(0, math.min(75, chance))
end
function D2.attackChance(attacker, target, ar, defense, itd)
  if itd and target:isMonster() then defense = 0 end
  local a = math.max(1, attacker:getLevel()); local t = math.max(1, target:getLevel())
  return math.max(5, math.min(95, (2 * a / (a + t)) * (ar / math.max(1, ar + defense)) * 100))
end
function D2.applyResist(damage, resist)
  return math.max(0, damage * (1 - math.max(-100, math.min(100, resist)) / 100))
end
function D2.leech(player, physicalDamage, lifePct, manaPct)
  local diff = D2.get(player, 'difficulty'); local multiplier = ({[0]=1,[1]=0.5,[2]=0.2})[diff] or 1
  player:addHealth(math.floor(physicalDamage * lifePct / 100 * multiplier))
  player:addMana(math.floor(physicalDamage * manaPct / 100 * multiplier))
end
function D2.magicFindQuality(mf)
  -- D2-style diminishing returns for qualities above magical.
  return { magic = mf, rare = mf * 100 / (100 + mf), set = mf * 500 / (500 + mf), unique = mf * 2500 / (2500 + mf) }
end
D2.RUNEWORDS = {
  Spirit = { runes = {'Tal','Thul','Ort','Amn'}, types = {'sword','shield'}, mods = '+2 skills, 25-35 FCR, mana, FHR' },
  Insight = { runes = {'Ral','Tir','Tal','Sol'}, types = {'polearm','staff'}, mods = 'Meditation aura, enhanced damage, mana' },
  Stealth = { runes = {'Tal','Eth'}, types = {'armor'}, mods = '25 FCR, faster run, poison resist' },
  Lore = { runes = {'Ort','Sol'}, types = {'helm'}, mods = '+1 skills, lightning resist, damage reduction' }
}
function D2.matchesRuneword(name, runes, itemType)
  local word = D2.RUNEWORDS[name]; if not word or #runes ~= #word.runes then return false end
  for i = 1, #runes do if runes[i] ~= word.runes[i] then return false end end
  for _, t in ipairs(word.types) do if t == itemType then return true end end
  return false
end
