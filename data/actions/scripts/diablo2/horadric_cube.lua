-- Horadric Cube action - container especial 3x4 que transmuta itens dentro igual Diablo 2
function onUse(player, item, fromPosition, target, toPosition, isHotkey)
  if not item:isContainer() then
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "Este cubo nao e container! Use um Horadric Cube 1988.")
    return false
  end

  local size = item:getSize()
  if size == 0 then
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Cubo vazio. Coloque itens dentro: 3 runas iguais + gema -> proxima runa, Tal+Thul+PTopaz+armor Normal -> socketed, Ral+Thul+PAmy+weapon Normal -> Exceptional, etc. Depois use o cubo novamente para transmutar.")
    -- Abre modal com receitas para ajudar (texto, nao so comando)
    local window = ModalWindow(2005, "Horadric Cube - Receitas", "Coloque itens dentro do cubo (arraste) e use o cubo novamente.\n\nReceitas principais:\n- 3x Chipped Amethyst = Flawed Amethyst (e assim por diante todas gemas)\n- 3x Thul + Chipped Topaz = Amn\n- 3x Amn + Chipped Amethyst = Sol\n- Ral+Ort+Tal = Ancient's Pledge? Nao, Ral Ort Tal = Ancient's Pledge shield 50% res\n- Tal+Thul+Perfect Topaz + armor Normal = armor com furos\n- Ral+Thul+Perfect Sapphire + helm Normal = helm com furos\n- Ral+Amn+Perfect Amethyst + weapon Normal = weapon com furos\n- Ort+Ral+Weapon = repara arma\n- Wirt's Leg (2382) + Tome TP (qualquer) = Portal Cow Level (Moo Moo Farm)\n- Key Terror+Hate+Destruction (2086+2087+2088) = Portal Uber\n- Twisted + Burning + Charged + Festering Essence = Token Absolution (respec)\n- Ral+Thul+Perfect Amethyst + Normal Weapon = Exceptional Weapon\n- Ko+Lem+Perfect Diamond + Exceptional = Elite\n\nItens no cubo agora: "..size)
    window:addButton(1, "Fechar")
    window:addButton(2, "Transmutar")
    window:sendToPlayer(player)
    return true
  end

  -- Coleta nomes dos itens dentro
  local inputs = {}
  local container = Container(item.uid)
  if container then
    for i = 0, container:getSize() - 1 do
      local inner = container:getItem(i)
      if inner then
        local name = inner:getName()
        -- Para runas, usa nome base sem "Rune" ? Nosso cubeTransmute espera "Thul" etc.
        -- Vamos extrair nome da runa
        name = name:gsub(" Rune", ""):gsub(" rune", "")
        table.insert(inputs, name)
        -- Guarda id para remover depois
      end
    end
  else
    -- Fallback antigo
    for i=0, size-1 do
      local inner = item:getItem(i)
      if inner then table.insert(inputs, inner:getName():gsub(" Rune","")) end
    end
  end

  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Cubo contem: "..table.concat(inputs, ", "))

  -- Tenta transmutar
  local out, desc = D2C.cubeTransmute(player, inputs)
  if not out then
    player:sendTextMessage(MESSAGE_STATUS_SMALL, "Receita invalida: "..(desc or "Cubo nao fez nada. Veja !d2cube para lista."))
    return true
  end

  -- Remove todos itens dentro do cubo
  if container then
    for i = container:getSize()-1, 0, -1 do
      local inner = container:getItem(i)
      if inner then inner:remove() end
    end
  end

  -- Da o resultado dentro do cubo ou no inventario
  local outIdMap = {
    ["Flawed Amethyst"] = 2144,
    ["Amethyst"] = 2145,
    ["Flawless Amethyst"] = 2146,
    ["Perfect Amethyst"] = 2147,
    ["Flawed Topaz"] = 2149, -- placeholder
    ["Perfect Topaz"] = 2150,
    ["Perfect Ruby"] = 2146,
    ["Perfect Sapphire"] = 2150,
    ["Amn"] = 2288,
    ["Sol"] = 2290,
    ["Shael"] = 2301,
    ["Dol"] = 2302,
    ["Hel"] = 2304,
    ["Io"] = 2305,
    ["Lum"] = 2310,
    ["Ko"] = 2313,
    ["Fal"] = 2315,
    ["Lem"] = 2316,
    ["Pul"] = 2262,
    ["Um"] = 2278,
    ["Mal"] = 2279,
    ["Ist"] = 2292,
    ["Gul"] = 2293,
    ["Vex"] = 2308,
    ["Ohm"] = 2348,
    ["Lo"] = 23722,
    ["Sur"] = 23723,
    ["Ber"] = 8919,
    ["Jah"] = 13884,
    ["Cham"] = 2303,
    ["Zod"] = 2307,
    ["socketed_armor"] = 2144,
    ["socketed_helm"] = 2143,
    ["socketed_weapon"] = 2274,
    ["socketed_shield"] = 2143,
    ["Exceptional Weapon"] = 2383, -- giant sword etc exemplo
    ["Elite Weapon"] = 2390,
    ["Exceptional Armor"] = 2463,
    ["Elite Armor"] = 2466,
    ["Portal to Cow Level"] = 2382,
    ["Portal to Uber Bosses"] = 2086,
    ["Token of Absolution"] = 2165,
    ["Repaired Weapon"] = 2383,
    ["Repaired Armor"] = 2463,
  }

  local outId = outIdMap[out] or 2147 -- default perfect amethyst
  if type(outId) == "number" then
    local added = item:addItem(outId, 1)
    if not added then
      player:addItem(outId, 1)
    end
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Cubo transmutou: "..table.concat(inputs, " + ").." => "..out.." ("..outId..") | "..(desc or ""))
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
  else
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Cubo: "..out.." - "..(desc or ""))
  end

  return true
end
