-- Charms: Small, Medium, Large, passive bonus por ocupar espaço mochila
D2C = D2C or {}
D2C.CHARMS = {
  small = {size=1, name="Small Charm", mods={"+5 All Res","7% MF","+20 Life","+17 Mana"}},
  medium = {size=2, name="Large Charm", mods={"+10 Max Damage, +15 AR","+35 Life","+6% MF"}},
  large = {size=3, name="Grand Charm", mods={"+1 Amazon Skills","+1 Barb Skills","+1 Necro Skills","+175 Poison Damage"}},
}
D2C.UNIQUE_CHARMS = {
  Gheed = {name="Gheed's Fortune", size=3, limit=1, mods="80-160% GF, 20-40% MF, 10-15% Vendor Price Reduction", desc="Gheed's Fortune (MF e redução)"},
  Torch = {name="Hellfire Torch", size=2, limit=1, mods="+3 Random Class Skills, All Attr 10-20, All Res 10-20, +8 Light Radius, 5% CTC Lvl10 Firestorm", drop="Pandemonium Event", storage="TORCH"},
  Annihilus = {name="Annihilus", size=1, limit=1, mods="+1 All Skills, All Attr 10-20, All Res 10-20, +5-10% Experience Gained", drop="Uber Diablo", storage="ANNIHILUS"},
}
function D2C.charmPowerVsSpace(inventory, charms)
  -- dilema: mochila cheia de amuletos vs espaço livre para loot
  local used=0
  local maxSlots = 40 -- 10x4 grid Diablo II
  local power=0
  for _, ch in ipairs(charms) do
    local data = D2C.CHARMS[ch.sizeType] or D2C.CHARMS.small
    used = used + data.size
    power = power + (data.size*10)
  end
  local free = maxSlots - used
  return {used=used, free=free, power=power, isFull=free<=0}
end
function D2C.equipCharm(player, charm)
  if charm.name == "Gheed's Fortune" then
    if D2C.getAttr(player,"GHEEDS")>0 then
      player:sendTextMessage(MESSAGE_STATUS_SMALL,"Apenas 1 Gheed's por personagem")
      return false
    end
    D2C.setAttr(player,"GHEEDS",1)
    D2C.setAttr(player,"MF", D2C.getAttr(player,"MF")+30)
  elseif charm.name == "Annihilus" then
    if D2C.getAttr(player,"ANNIHILUS")>0 then
      player:sendTextMessage(MESSAGE_STATUS_SMALL,"Apenas 1 Annihilus por personagem")
      return false
    end
    D2C.setAttr(player,"ANNIHILUS",1)
  elseif charm.name == "Hellfire Torch" then
    if D2C.getAttr(player,"TORCH")>0 then
      player:sendTextMessage(MESSAGE_STATUS_SMALL,"Apenas 1 Hellfire Torch por personagem")
      return false
    end
    D2C.setAttr(player,"TORCH",1)
  end
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Charm equipado passivamente: "..charm.name)
  return true
end
-- inventory scanning for OTX: check items with charm attribute
function D2C.scanCharms(player)
  local totalmods={}
  local count=0
  -- In OTX inventory slots 1-10 are backpack; we count storage markers
  if D2C.getAttr(player,"GHEEDS")>0 then table.insert(totalmods,"MF +40%") count=count+1 end
  if D2C.getAttr(player,"ANNIHILUS")>0 then table.insert(totalmods,"+1 Skills All Res") count=count+1 end
  if D2C.getAttr(player,"TORCH")>0 then table.insert(totalmods,"+3 Skills class") count=count+1 end
  return totalmods, count
end
