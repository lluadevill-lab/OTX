# Diablo II Rework — estado da implementação

Esta branch passa a tratar o OTX como um servidor ARPG. O código legado de Tibia continua sendo a camada de transporte/mapa; as regras D2 ficam isoladas para permitir evolução sem destruir compatibilidade.

## Camada adicionada

- `data/lib/diablo2_rules.lua`: sete classes, árvores iniciais, atributos, stamina, breakpoints, bloqueio/corrida, AR/ITD, absorção, leech, MF, XP por área, `/players X`, congelamento, imunidade/Conviction 1/5, runewords e catálogo de Cubo/afixos.
- `data/lib/diablo2.lua`: API anterior preservada para scripts existentes.
- `data/migrations/diablo2.sql`: estado persistente de personagem, stash compartilhado e catálogo de runewords.
- `data/talkactions/scripts/d2status.lua`: painel textual de diagnóstico.

## Limitação técnica honesta

Não existe neste repositório um cliente Diablo II. Alterar “UI e menus” não é possível apenas editando o servidor: o cliente Tibia precisa entender novos bytes, sprites, janelas e teclas. A implementação server-side está preparada, mas um rework visual completo requer um cliente customizado e um protocolo correspondente. Também é necessário criar itens no `items.xml`, monstros/áreas e scripts de evento para cada conteúdo.

## Ordem para continuar

1. Executar a migration e substituir as vocações do XML por IDs/classes D2.
2. Criar protocolo de personagem para enviar atributos, skill tree, charms, segundo set e stash.
3. Integrar `D2R.hit`, `D2R.block`, `D2R.absorb` e `D2R.leech` no pipeline C++ de combate.
4. Criar loot generator (iLvl/aLvl/TC, afixos, sockets, ethereal, charges) e Cubo.
5. Criar eventos de dificuldade, Ubers, mercenários, cadáveres, curses e loot compartilhado.
6. Implementar o cliente customizado com HUD, árvore, inventário e menus.

O arquivo `d2status.lua` é um teste imediato da camada e não pretende ser a UI final.
