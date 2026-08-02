-- Horadric Cube functional
D2C = D2C or {}
D2C.CUBE_RECIPES = {
  -- Rune upgrades (handled above)
  -- Gem upgrades
  {inputs={{"Chipped Amethyst",3}}, output="Flawed Amethyst", desc="3 Chipped Amethyst -> Flawed"},
  {inputs={{"Flawed Amethyst",3}}, output="Amethyst", desc="3 Flawed -> Normal"},
  {inputs={{"Amethyst",3}}, output="Flawless Amethyst", desc="3 Normal -> Flawless"},
  {inputs={{"Flawless Amethyst",3}}, output="Perfect Amethyst", desc="3 Flawless -> Perfect"},
  -- same for all gems
  {inputs={{"Chipped Topaz",3}}, output="Flawed Topaz"},
  {inputs={{"Chipped Sapphire",3}}, output="Flawed Sapphire"},
  {inputs={{"Chipped Emerald",3}}, output="Flawed Emerald"},
  {inputs={{"Chipped Ruby",3}}, output="Flawed Ruby"},
  {inputs={{"Chipped Diamond",3}}, output="Flawed Diamond"},
  -- Socketing
  {inputs={{"Tal",1},{"Thul",1},{"Perfect Topaz",1},{"body_armor",1, {isNormal=true}}}, output="socketed_armor", desc="Tal+Thul+PTopaz + normal armor -> socketed"},
  {inputs={{"Ral",1},{"Thul",1},{"Perfect Sapphire",1},{"helm",1, {isNormal=true}}}, output="socketed_helm"},
  {inputs={{"Ral",1},{"Amn",1},{"Perfect Amethyst",1},{"weapon",1, {isNormal=true}}}, output="socketed_weapon"},
  {inputs={{"Tal",1},{"Amn",1},{"Perfect Ruby",1},{"shield",1, {isNormal=true}}}, output="socketed_shield"},
  -- Adding socket to weapon via Larzuk alternative
  -- Crafting
  {inputs={{"Magic weapon",1},{"Ral",1},{"Amn",1},{"Perfect Amethyst",1}}, output="Crafted Blood weapon", desc="Magic weapon + Ral + Amn + PAmy -> Crafted Blood"},
  {inputs={{"Magic armor",1},{"Thul",1},{"Perfect Topaz",1},{"PAmethyst",1}}, output="Crafted Caster armor"},
  {inputs={{"Magic ring",1},{"Amn",1},{"Perfect Ruby",1},{"Jewel",1}}, output="Crafted Blood ring"},
  -- Base upgrading
  {inputs={{"Ral",1},{"Thul",1},{"Perfect Amethyst",1},{"Normal Weapon",1}}, output="Exceptional Weapon", desc="Normal -> Exceptional"},
  {inputs={{"Ko",1},{"Lem",1},{"Perfect Diamond",1},{"Exceptional Weapon",1}}, output="Elite Weapon", desc="Exceptional -> Elite"},
  {inputs={{"Tal",1},{"Shael",1},{"Perfect Diamond",1},{"Normal Armor",1}}, output="Exceptional Armor"},
  {inputs={{"Ko",1},{"Pul",1},{"Perfect Amethyst",1},{"Exceptional Armor",1}}, output="Elite Armor"},
  -- Unique upgrading
  {inputs={{"Ral",1},{"Thul",1},{"Perfect Amethyst",1},{"Unique Normal Weapon",1}}, output="Exceptional Unique Weapon"},
  {inputs={{"Ko",1},{"Lem",1},{"Perfect Diamond",1},{"Exceptional Unique Weapon",1}}, output="Elite Unique Weapon"},
  -- Repair ethereal? No
  {inputs={{"Ort",1},{"Weapon",1}}, output="Repaired Weapon", desc="Ort + Weapon -> Fully Repaired"},
  {inputs={{"Ral",1},{"Armor",1}}, output="Repaired Armor"},
  -- Portal
  {inputs={{"Wirt's Leg",1},{"Tome of Town Portal",1}}, output="Portal to Cow Level", desc="Abre portal secreto vacas"},
  {inputs={{"Key of Terror",1},{"Key of Hate",1},{"Key of Destruction",1}}, output="Portal to Uber Bosses", desc="3 chaves -> portal Lilith/Duriel/Izual"},
  -- Essences
  {inputs={{"Twisted Essence",1},{"Burning Essence",1},{"Charged Essence",1},{"Festering Essence",1}}, output="Token of Absolution", desc="Respec"},
}

function D2C.cubeTransmute(player, inputs)
  -- inputs = list of item names/ids
  -- find matching recipe
  for _, rec in ipairs(D2C.CUBE_RECIPES) do
    local matched = true
    -- simplified check: if inputs contain required count
    -- in real engine, check exact item count/types
    -- here iterate recipe inputs
    for _, req in ipairs(rec.inputs) do
      local name = req[1]
      local cnt = req[2] or 1
      local found = 0
      for _, inp in ipairs(inputs) do
        if inp == name then found = found+1 end
      end
      if found < cnt then matched=false break end
    end
    if matched then
      return rec.output, rec.desc
    end
  end
  -- try rune upgrade recipes
  for _, ru in ipairs(D2C.RUNE_UPGRADE) do
    local countNeeded = ru.count
    local have = 0
    for _, inp in ipairs(inputs) do if inp==ru.from then have=have+1 end end
    if have >= countNeeded then
      local hasGem = false
      for _, inp in ipairs(inputs) do if inp==ru.gem then hasGem=true end end
      if hasGem then return ru.to, "Upgrade "..ru.from.." x"..countNeeded.." + "..ru.gem.." -> "..ru.to end
    end
  end
  return nil, "Receita inválida - Cubo não fez nada"
end

-- Socketing via Larzuk quest (Ato5)
function D2C.larzukSocket(item, isSuperior, isEthereal)
  -- Returns max sockets based on ilvl and item type
  local ilvl = item.ilvl or 1
  local maxSockets = D2C.SOCKET_MAX.normal or 4
  if item.baseType == "armor" then
    if ilvl <= 40 then maxSockets = math.min(maxSockets, 3)
    elseif ilvl <=60 then maxSockets = math.min(maxSockets,4)
    end
  end
  -- Larzuk always gives max sockets possible
  item.sockets = maxSockets
  item.isSocketedByLarzuk = true
  return maxSockets
end

-- Horadric Cube container logic for OTX actions
function D2C.cubeUse(player, cubeItem)
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Cubo Horádrico: coloque itens dentro e use !d2cube para transmutar.")
  -- action script will handle
end
