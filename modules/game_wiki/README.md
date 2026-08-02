# Game Wiki - OTX Client Module

Módulo de Wiki dentro do client OTC.

## O que faz
- Adiciona botão **Wiki** no topmenu (ícone ciclopedia)
- Abre janela principal com todos os tópicos solicitados em grade de botões
- Ao clicar num tópico, abre painel de detalhes com:
  - Título
  - Texto rolável (lorem ipsum por padrão)
  - Botão **Voltar** (volta para lista)
  - Botão **Fechar** (fecha janela)

## Tópicos incluídos (35)
Auto Loot, BagLoot, Bank, Bestiary, Change Vocation, Death Recover, Exp & Loot, Extra Information, Find NPC, Forge, Houses, Infusion Attributes, Instanced hunts, Items, Mana/Life Leech, MC & Bot, Minimap, Monsters, Monsters Demoniacs, Non-PvP, Online Points, Premium Account, Promotions, Quests, Rookie Battle, Roulette, Soul Bosses, Spells, Stamina, Summons, Tasks, Trainers, Traveling, Treasure Chest, Vocation Guide

## Arquivos
- `game_wiki.otmod` - definição do módulo
- `wiki.otui` - layout UI com MainWindow, ScrollablePanel, botões Voltar/Fechar
- `wiki.lua` - lógica e conteúdo editável

## Como editar o conteúdo real
Abra `wiki.lua` e edite a tabela `wikiData`.

Exemplo:
```lua
wikiData["Auto Loot"] = [[
Seu texto aqui...
Pode ser multi-linha.
Use [[ ]] para bloco longo.
]]

wikiData["Bank"] = [[
Sistema de Bank...
]]
```

O texto é automaticamente rolável. Quanto maior, mais scroll aparece.

Você também pode usar as APIs:
```lua
modules.game_wiki.setTopicContent("Bank", "Novo texto")
modules.game_wiki.addCustomTopic("Novo Topico", "Conteudo")
```

## Instalação
O módulo já está em `modules/game_wiki`. O OTCV8 carrega automaticamente via `g_modules.autoLoadModules()`.
- Ícone usa `/images/topbuttons/ciclopedia` existente no layout retro. Se quiser ícone custom, adicione em `layouts/retro/images/topbuttons/wiki.png` e troque o path em `wiki.lua`.

## Fluxo UI
- `show()` -> mostra lista
- `showTopic(name)` -> mostra detalhes do tópico
- `showList()` -> volta para lista (botão Voltar)
- `hide()` -> fecha janela (botão Fechar)
- `backOrClose()` -> ESC: se estiver em detalhes volta, senão fecha.

Aproveite!
