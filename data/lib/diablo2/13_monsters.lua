-- Monsters and Bosses Diablo II
D2C = D2C or {}
D2C.MONSTERS = {
  -- Act1
  {name="Fallen", level={1,10,45}, tc="Act 1 Equip A", res={fire=0,cold=0,light=0,poison=0,phys=0}, ai="aggressive", corpse=true},
  {name="Zombie", level={1,12,48}, tc="Act 1 Equip A", res={fire=0,cold=20,light=0,poison=50,phys=0}, ai="shambler", corpse=true},
  {name="Skeleton", level={2,14,50}, tc="Act 1 Equip A", res={fire=0,cold=0,light=0,poison=0,phys=10}, ai="skeleton", corpse=true},
  {name="Goatman", level={3,15,52}, tc="Act 1 Equip B", res={fire=10,cold=0,light=0,poison=0,phys=0}, ai="melee"},
  {name="Raven", level={2,12,47}, tc="Act 1 Junk", res={cold=50}, ai="flyer"},
  -- Act2
  {name="Mummy", level={15,40,70}, tc="Act 2 Equip A", res={fire=0,cold=0,light=10,poison=50,phys=0}, ai="undead"},
  {name="Sand Raider", level={14,38,68}, tc="Act 2 Equip B", res={fire=0}, ai="aggressive"},
  {name="Beetle", level={16,42,73}, tc="Act 2 Equip B", res={light=50}, ai="charger", onDeath="Lightning nova"},
  -- Act3
  {name="Fetish", level={20,48,78}, tc="Act 3 Equip A", res={fire=20}, ai="swarm"},
  {name="Flayer", level={22,50,80}, tc="Act 3 Equip B", res={}, ai="demon"},
  -- Act4
  {name="Balrog", level={25,55,83}, tc="Act 4 Equip B", res={fire=50,phys=20}, ai="demon_big"},
  {name="Venom Lord", level={26,56,84}, tc="Act 4 Equip B", res={fire=80,phys=20}, ai="demon"},
  -- Act5
  {name="Minion of Destruction", level={30,60,85}, tc="Act 5 Equip B", res={cold=33,fire=33,phys=20}, ai="boss_minion"},
  {name="Overseer", level={32,62,86}, tc="Act 5 Equip B", res={phys=30}, ai="commander"},
  -- Super Uniques
  {name="Rakanishu", level={6,39,83}, tc="Act 1 Super", isSuper=true, res={light=20}, ai="superunique", corpse=false},
  {name="Bishibosh", level={4,38,83}, tc="Act 1 Super", isSuper=true, res={fire=40}, ai="shaman", skill="Raise Fallen"},
  {name="The Countess", level={12,42,82}, tc="Countess", isSuper=true, res={fire=20}, ai="superunique", keys="Key of Terror"},
  {name="The Summoner", level={22,55,83}, tc="Summoner", isSuper=true, res={fire=0}, ai="mage", keys="Key of Hate"},
  {name="Nihlathak", level={35,65,90}, tc="Nihlathak", isSuper=true, res={cold=30,fire=20}, ai="necromancer", skill="Corpse Explosion", keys="Key of Destruction"},
  -- Bosses
  {name="Andariel", level={12,49,75}, tc="Andariel", isBoss=true, res={fire=0,cold=0,light=0,poison=70,phys=0,magic=0}, ai="boss", quest=true},
  {name="Duriel", level={22,55,88}, tc="Duriel", isBoss=true, res={cold=50,phys=20}, ai="boss", quest=true, coldAura="Holy Freeze"},
  {name="Mephisto", level={26,59,87}, tc="Mephisto", isBoss=true, res={cold=50,light=50,poison=50,phys=10}, ai="boss", quest=true},
  {name="Diablo", level={40,62,94}, tc="Diablo", isBoss=true, res={fire=50,cold=50,light=50,poison=50,phys=30,magic=20}, ai="boss_big", quest=true},
  {name="Baal", level={60,75,99}, tc="Baal", isBoss=true, res={fire=50,cold=50,light=50,poison=50,magic=50,phys=30}, ai="boss_big", quest=true},
  {name="Diablo Clone", level={99,99,99}, tc="Diablo Clone", isBoss=true, isUber=true, res={fire=95,cold=95,light=95,poison=95,phys=60,magic=50}, ai="uber", drop="Annihilus"},
  {name="Uber Mephisto", level={110,110,110}, tc="Uber Mephisto", isBoss=true, isUber=true, res={fire=110,cold=110,light=110,poison=110,phys=25,magic=50}, ai="uber_boss"},
  {name="Uber Diablo", level={110,110,110}, tc="Uber Diablo", isBoss=true, isUber=true, res={fire=110,cold=80,light=80,poison=110,phys=25,magic=50}, ai="uber_boss"},
  {name="Uber Baal", level={110,110,110}, tc="Uber Baal", isBoss=true, isUber=true, res={fire=110,cold=110,light=110,poison=80,phys=25,magic=50}, ai="uber_boss"},
  {name="Lilith", level={100,100,100}, tc="Lilith", isBoss=true, isUber=true, res={fire=75,cold=75,light=75,poison=110,phys=30}, ai="uber_miniboss", organ="Diablo's Horn"},
  {name="Uber Duriel", level={100,100,100}, tc="Uber Duriel", isBoss=true, isUber=true, res={cold=110,fire=75,phys=30}, ai="uber_miniboss", organ="Baal's Eye"},
  {name="Uber Izual", level={100,100,100}, tc="Uber Izual", isBoss=true, isUber=true, res={cold=80,light=80,fire=80,phys=30}, ai="uber_miniboss", organ="Mephisto's Brain"},
}

function D2C.getMonster(name)
  for _, m in ipairs(D2C.MONSTERS) do if m.name==name then return m end end
  return nil
end
function D2C.spawnMonster(name, pos, players)
  local mon = D2C.getMonster(name)
  if not mon then return nil end
  local baseHP = 100 + mon.level[1]*20
  local hp, xp, nodrop = D2C.playersScaling(players or 1, baseHP, 100, 50)
  -- In OTX Game.createMonster
  return {name=name, hp=hp, xp=xp, nodrop=nodrop, data=mon}
end
-- Buff for /players X
function D2C.applyPlayersScaling(monster, players)
  local baseHP = monster:getMaxHealth()
  local hp = baseHP * (1 + (players-1)*1.0)
  monster:setMaxHealth(hp)
  monster:addHealth(hp - baseHP)
end
