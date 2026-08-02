-- UI, Menus, HUD for Diablo II with functional modal windows (clickable)
D2C = D2C or {}

function D2C.safeModal(player, id, title, msg, choices, buttons, callbackMap)
  -- Try new table constructor modal with callbacks (functional clickable)
  local ok, window = pcall(function()
    local w = ModalWindow {
      title = title,
      message = msg
    }
    if buttons then
      for _, b in ipairs(buttons) do
        if type(b) == "table" and b.text and b.callback then
          w:addButton(b.text, function(btn, choice) 
            if callbackMap and callbackMap[b.text] then callbackMap[b.text](choice) else b.callback(btn, choice) end
          end)
        else
          w:addButton(b.text or b, function() end)
        end
      end
    else
      w:addButton("Fechar", function() end)
    end
    if choices then
      for _, c in ipairs(choices) do
        w:addChoice(c)
      end
    end
    w:setDefaultEnterButton("Fechar")
    return w
  end)
  if ok and window then
    window:sendToPlayer(player)
    return true
  end
  -- Fallback old style modal + text
  local ok2 = pcall(function()
    local win = ModalWindow(id, title, msg)
    win:addButton(1, "Fechar")
    win:setDefaultEnterButton(1)
    if choices then
      for i, c in ipairs(choices) do
        if i<=30 then win:addChoice(i, c) end
      end
    end
    win:sendToPlayer(player)
  end)
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, title.." - "..msg)
  return ok2
end

function D2C.openSkillTree(player)
  local class = D2C.getClass(player)
  local skills = D2C.listSkillsForClass(class)
  local points = D2C.getAttr(player,"SKILL_POINTS")
  local msg = "Arvore de "..class.." | Pontos: "..points.."\nClique em uma skill e depois em UPAR para gastar 1 ponto.\nTier 1 precisa 0 pts, Tier 2 precisa 2 pts na arvore, Tier 3 precisa 4 pts, etc.\n\n"
  for _, sname in ipairs(skills) do
    local lvl = D2C.getSkillLevel(player,sname)
    local data = D2C.getSkill(sname)
    if data then
      local tier = tonumber(data.tier) or 1
      local tree = tostring(data.tree or "?")
      local lv = tonumber(lvl) or 0
      local syn = D2C.SYNERGIES[sname] and "Sinergia" or ""
      msg = msg..string.format("%s [T%d][%s] Lvl %d/20 %s\n", tostring(sname), tier, tree, lv, syn)
    end
    if #msg>1200 then break end
  end

  local window = ModalWindow {
    title = class.." - Skill Tree ["..points.." pts]",
    message = msg
  }
  window:addButton("UPAR", function(button, choice)
    if not choice then
      player:sendTextMessage(MESSAGE_STATUS_SMALL, "Selecione uma skill na lista primeiro!")
      return
    end
    local skillName = choice.text:match("^([^%[]+)")
    if skillName then skillName = skillName:match("^%s*(.-)%s*$") end
    -- Remove tier info
    skillName = skillName:gsub("%s*%[.*", ""):gsub("^%s+", ""):gsub("%s+$", "")
    local ok, res = D2C.addSkillPoint(player, skillName, 1)
    if ok then
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Skill "..skillName.." upada para "..res..". Pontos restantes: "..D2C.getAttr(player,"SKILL_POINTS"))
      D2C.openSkillTree(player) -- reabre atualizado
    else
      player:sendTextMessage(MESSAGE_STATUS_SMALL, res)
    end
  end)
  window:addButton("Fechar", function() end)
  window:addButton("Status", function() D2C.openCharScreen(player) end)
  for _, sname in ipairs(skills) do
    window:addChoice(sname)
  end
  window:sendToPlayer(player)
end

function D2C.openCharScreen(player)
  local class = D2C.getClass(player)
  local str = D2C.getAttr(player,"STR") + (D2C.CLASS_BASE[class] and D2C.CLASS_BASE[class].str or 20)
  local dex = D2C.getAttr(player,"DEX") + (D2C.CLASS_BASE[class] and D2C.CLASS_BASE[class].dex or 20)
  local vit = D2C.getAttr(player,"VIT") + (D2C.CLASS_BASE[class] and D2C.CLASS_BASE[class].vit or 20)
  local ene = D2C.getAttr(player,"ENE") + (D2C.CLASS_BASE[class] and D2C.CLASS_BASE[class].ene or 20)
  local life = D2C.calcLife(player)
  local mana = D2C.calcMana(player)
  local stamina = D2C.getAttr(player,"STAMINA_CUR")
  local okBlock, block = pcall(function() return D2C.blockChance(player, 25, false) end)
  if not okBlock then block = 0 end
  local fcrReached, fcrFrames, fcrSec = 0,0,0
  local fhrReached, fhrFrames = 0,0
  local iasReached, iasFrames = 0,0
  local fbrReached, fbrFrames = 0,0
  pcall(function() fcrReached, fcrFrames, fcrSec = D2C.getBreakpoint(player,"FCR") end)
  pcall(function() fhrReached, fhrFrames = D2C.getBreakpoint(player,"FHR") end)
  pcall(function() iasReached, iasFrames = D2C.getBreakpoint(player,"IAS") end)
  pcall(function() fbrReached, fbrFrames = D2C.getBreakpoint(player,"FBR") end)
  local diff = D2C.DIFF_NAMES[D2C.getAttr(player,"DIFF")] or "Normal"
  local ok, text = pcall(function()
    return string.format([[Classe: %s | Level: %d | Dif: %s
STR %d | DEX %d | VIT %d | ENE %d
Vida %d | Mana %d | Stamina %d/ %d
Block %.1f%% (max 75) Running /3
Breakpoints @%dfps: FCR %d (%d f %.2fs) FHR %d (%df) IAS %d (%df) FBR %d
MF %d%% GF %d%% CB %d%% DS %d%% OW %d%% KB %d
Merc: Act %d Lvl %d
WeaponSet: %d | CBF %d | PLR %d
SoJ Sold: %d | Res Penalty: %d
Pontos: Skill %d Attr %d
]], tostring(class), D2C.safeLevel(player), tostring(diff), tonumber(str) or 0, tonumber(dex) or 0, tonumber(vit) or 0, tonumber(ene) or 0, tonumber(life) or 0, tonumber(mana) or 0, tonumber(stamina) or 0, tonumber(D2C.calcStamina(player)) or 0, tonumber(block) or 0, tonumber(D2C.FPS) or 25, tonumber(fcrReached) or 0, tonumber(fcrFrames) or 0, tonumber(fcrSec) or 0, tonumber(fhrReached) or 0, tonumber(fhrFrames) or 0, tonumber(iasReached) or 0, tonumber(iasFrames) or 0, tonumber(fbrReached) or 0, tonumber(D2C.getAttr(player,"MF")) or 0, tonumber(D2C.getAttr(player,"GF")) or 0, tonumber(D2C.getAttr(player,"CB")) or 0, tonumber(D2C.getAttr(player,"DS")) or 0, tonumber(D2C.getAttr(player,"OW")) or 0, tonumber(D2C.getAttr(player,"KB")) or 0, tonumber(D2C.getAttr(player,"MERC_TYPE")) or 0, tonumber(D2C.getAttr(player,"MERC_LVL")) or 0, tonumber(D2C.getAttr(player,"WEAPON_SET")) or 0, tonumber(D2C.getAttr(player,"CANNOT_BE_FROZEN")) or 0, tonumber(D2C.getAttr(player,"PLR")) or 0, tonumber(D2C.getAttr(player,"SOJ_SOLD")) or 0, tonumber(D2C.RES_PENALTY[D2C.getAttr(player,"DIFF")] or 0), tonumber(D2C.getAttr(player,"SKILL_POINTS")) or 0, tonumber(D2C.getAttr(player,"ATTR_POINTS")) or 0)
  end)
  if not ok or not text then
    text = "Classe: "..tostring(class).." Level: "..D2C.safeLevel(player).." | Pontos Skill: "..D2C.getAttr(player,"SKILL_POINTS")
  end


  local window = ModalWindow {
    title = "Character Screen - "..class,
    message = text
  }
  window:addButton("Skills", function() D2C.openSkillTree(player) end)
  window:addButton("Charms", function() D2C.openInventoryCharms(player) end)
  window:addButton("Fechar", function() end)
  window:sendToPlayer(player)
  -- Sempre manda texto tambem para clientes sem modal
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, text)
end

function D2C.openInventoryCharms(player)
  local totalmods, count = D2C.scanCharms(player)
  local text = string.format("Charms: %d equipados | Mods: %s\nDilema: mochila cheia = forte mas sem espaco loot\n\nGheed's: %d Torch:%d Anni:%d\nSmall Charm 2143 1x1 +5 res 7%% MF\nLarge 2144 1x2 +35 life\nGrand 2145 1x3 +1 skills\nGheed 2146 80-160%% GF 20-40%% MF\nAnni 2147 +1 all\nTorch 2149 +3 class\n\nUse item 2143 no inventario para equipar charm (da MF)\n", count, table.concat(totalmods,", "), D2C.getAttr(player,"GHEEDS"), D2C.getAttr(player,"TORCH"), D2C.getAttr(player,"ANNIHILUS"))
  local window = ModalWindow {
    title = "Inventario + Charms",
    message = text
  }
  window:addButton("Fechar", function() end)
  window:addButton("Limpar", function() 
    D2C.setAttr(player,"GHEEDS",0)
    D2C.setAttr(player,"TORCH",0)
    D2C.setAttr(player,"ANNIHILUS",0)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,"Charms unicos removidos")
  end)
  window:sendToPlayer(player)
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, text)
end

function D2C.openStash(player)
  local text = "Bau: 4 abas pessoais (caem no HC) + 3 abas compartilhadas entre conta.\n\nPersonal tabs 0-3: 100 slots cada, dropa se morrer no Hardcore.\nShared tabs 4-6: 100 slots, conta toda, nao dropa.\n\nUse comando: !d2 stash (texto) ou fale com NPC Akara para ver visual.\n\nTabela d2_account_stash armazena: account_id, tab, slot, item_id, count, attributes, is_shared.\n\nPara mover item: arraste para Bau no cliente (se OTClient com estendido) ou use !d2 stash add <itemid> <tab>"
  D2C.safeModal(player, 1002, "Stash - Bau Compartilhado", text, nil, {{text="Fechar"}})
end

function D2C.openCubeUI(player)
  local text = "Cubo Horadrico (item 1988 container 3x4):\n\nCOMO USAR IGUAL DIABLO 2:\n1 - Compre o cubo com Akara (1000 gold) - item container\n2 - Abra o cubo (clique duplo) - abre como mochila 12 slots\n3 - Arraste itens PARA DENTRO do cubo (ex: 3x Thul)\n4 - Feche e USE o cubo (clique > Use) - ele transmuta!\n\nReceitas principais:\n- 3x Chipped Amethyst (2143) = Flawed Amethyst (2144)\n- 3x Thul (2286) + Chipped Topaz (2149) = Amn (2288)\n- 3x Amn (2288) + Chipped Amethyst (2143) = Sol (2290)\n- Tal (2274) + Thul (2286) + Perfect Topaz (2150) + armor Normal = socketed\n- Ral (2277) + Thul (2286) + Perfect Sapphire (2150) + helm = socketed\n- Ort (2285) + Weapon = repara\n- Wirt's Leg (2382) + Tome TP = Portal Cow Level lvl 90\n- Key Terror (2086) + Hate (2087) + Destruction (2088) = Portal Uber\n- 4 essencias = Token Absolution respec\n\nNao precisa mais digitar !d2cube texto, agora e container de verdade!"
  D2C.safeModal(player, 2005, "Cubo Horadrico - Container", text, nil, {{text="Fechar"}})
end

function D2C.openGamblingUI(player, npcName)
  local text = "Gambling com "..(npcName or "Gheed")..":\nGaste ouro, qualidade escala com nivel char.\nilvl = clvl -5 a +4, chance Unique 2% lvl80+\n\nCusto: Ring 80k (item 2143 etc), Amu 120k\n\nAgora gambling da ITEM REAL no inventario com descricao ilvl/qualidade!\n\nSeu ouro: "..player:getMoney().." MF: "..D2C.getAttr(player,"MF").."%\n\nUse o NPC Gheed: abre modal clicavel com botoes Ring 80k e Amulet 120k que ja entregam item."
  D2C.safeModal(player, 2001, "Gambling - Gheed", text, nil, {{text="Fechar"}})
end

function D2C.openRunewordsUI(player)
  local text="Runewords (52+ no servidor): ordem EXATA runas + tipo restrito + SO item cinza com furos.\n\nExemplos:\nSpirit Tal(2274)+Thul(2286)+Ort(2285)+Amn(2288) em sword/shield 4 furos Lvl25 +2 skills 25-35%% FCR\nInsight Ral(2277)+Tir(2265)+Tal(2274)+Sol(2290) polearm/staff 4 furos Lvl27 Meditation Aura\nStealth Tal+Eth(2268) armor 2 furos 25% FCR FRW FHR\nLore Ort+Sol helm 2 furos +1 skills\nEnigma Jah(13884)+Ith(2271)+Ber(8919) armor 3 furos Teleport\nInfinity Ber+Mal+Ber+Ist polearm 4 furos Conviction 12 -55%% Light\nGrief Eth+Tir+Lo+Mal+Ral sword/axe 5 furos +400 dano\n\nSe ordem errada ou tipo errado ou item azul/amarelo/verde/marrom: vira gemmed falho (item com runas mas sem bonus).\n\nUse item 25100+ runa no item cinza com furos via action."
  D2C.safeModal(player, 2006, "Runewords", text, nil, {{text="Fechar"}})
end

function D2C.mainMenu(player)
  local text = [[Diablo II - Menu Principal (CLICAVEL AGORA):

[Status] - char screen vida/mana/block breakpoints MF/GF/CB/DS/OW/KB
[Skills] - arvore 210 skills, clique pra upar gastando ponto
[Charms] - inventario charms Gheed/Torch/Anni
[Cube] - cubo horadrico container 3x4 real
[Runewords] - lista 52+ runewords
[Stash] - bau personal 4 tabs vs shared 3 tabs
[Merc] - merc Act2 Might/Holy Freeze
[Gamble] - gambling com itens reais
[Monstros] - bosses Andariel->Uber Tristram

Comandos rapidos:
!d2 status
!d2 skills
!d2 attr STR 10 (agora aceita SKILL_POINTS com _ )
!d2 attr SKILL_POINTS 30
!players 8
!swap / !w
!d2cube (antigo, mas agora use container 1988)
!d2gamble ring
!d2merc 2
!d2uber soj

Magias com efeito distinto (nao so dano):
d2 fire_bolt = fogo COMBAT_FIREDAMAGE + fire area
d2 ice_blast = gelo + freeze 3s half NM quarter Hell + CannotBeFrozen check
d2 lightning = raio - quebra imunidade 1/5
d2 poison_nova = veneno PLR reduz tempo
d2 bash = fisico CB/DS/OW/KB + stun diminishing
d2 corpse_explosion = consome corpo disputado
d2 teleport = FCR breakpoint @25 FPS
]]
  local window = ModalWindow {
    title = "Diablo II - Menu",
    message = text
  }
  window:addButton("Status", function() D2C.openCharScreen(player) end)
  window:addButton("Skills", function() D2C.openSkillTree(player) end)
  window:addButton("Charms", function() D2C.openInventoryCharms(player) end)
  window:addButton("Cube", function() D2C.openCubeUI(player) end)
  window:addButton("Runewords", function() D2C.openRunewordsUI(player) end)
  window:addButton("Fechar", function() end)
  window:sendToPlayer(player)
  player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, text)
end
