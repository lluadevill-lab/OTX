# OTX Diablo II rules port

Esta branch adiciona a primeira camada jogável do projeto **OTX Diablo II** sem quebrar o protocolo Tibia 10/11. O servidor continua compilável e os sistemas podem ser expandidos pelo datapack enquanto um cliente customizado é desenvolvido.

## O que já está implementado

- `data/lib/diablo2.lua`: atributos STR/DEX/VIT/ENE persistidos em storages, penalidade por diferença de nível, breakpoints FCR/FHR/IAS/FBR, chance de bloqueio limitada a 75%, AR vs Defesa com ITD, resistências, leech com penalidade por dificuldade, Magic Find com retornos decrescentes e validação de runewords.
- `!d2status`: exibe os atributos e breakpoints atuais do personagem.
- Runewords iniciais: Spirit, Insight, Stealth e Lore (estrutura pronta para ser ampliada).
- O módulo é carregado globalmente em `data/global.lua`.

## Como testar

1. Compile normalmente (`cmake` + `make`) e importe `DATABASE.sql`.
2. Inicie o servidor com o `config.lua` existente.
3. Entre com um personagem e use `!d2status`.
4. Para conceder valores durante testes, use o sistema já existente de storages/admin ou chame `D2.add(player, 'strength', 10)` em um script.

Os storages começam em `71000` para reduzir colisões; altere os valores em um único lugar se seu datapack já usar essa faixa.

## Próximas camadas necessárias para “jogo completo”

A base OTX não contém um cliente Diablo II. Portanto UI/menus, inventário de charms, troca W, loot compartilhado, animações a 25 FPS e renderização de afixos exigem um cliente/protocolo customizado. A ordem recomendada é:

1. Persistência de itens/afixos (ilvl, alvl, TC, prefixos/sufixos, sockets, etéreo e charges).
2. Eventos de combate (Crushing Blow, Open Wounds, Deadly Strike, triggers e knockback).
3. três dificuldades, imunidades/quebra de imunidade, /players X e XP por zona.
4. Cubo, crafting, gambling, runas e receitas.
5. mercenários, sinergias, árvores de habilidades e eventos Uber.
6. cliente customizado e menus.

As fórmulas estão isoladas para permitir testes unitários e substituição sem reescrever o núcleo C++.
