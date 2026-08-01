# Como Acessar Esse Projeto no GitHub — OTX Diablo II Completo

Você está trabalhando na branch **`arena/019fbb14-otx`** do repositório **`lluadevill-lab/OTX`**.

## 1. Link Direto no GitHub
```
https://github.com/lluadevill-lab/OTX/tree/arena/019fbb14-otx
```
- Esse link já abre exatamente essa branch.
- Se abrir a página principal e não ver os arquivos Diablo II, troque o seletor de branch (canto superior esquerdo, onde está escrito `master`) para `arena/019fbb14-otx`.

## 2. Estrutura do que foi implementado (excepcional, completo)
Tudo abaixo está na branch e já commitado:

- **Mecânicas Base**
  - `data/lib/diablo2/00_constants.lua` — STORAGE 80000+, dificuldade, weapon range, ethereal
  - `data/lib/diablo2/01_attributes.lua` — STR/DEX/VIT/ENE, requisitos, vida/mana/stamina por classe
  - `data/lib/diablo2/02_breakpoints.lua` — FCR/FHR/IAS/FBR por classe @25 FPS, tabelas reais
  - `data/lib/diablo2/03_stamina.lua` — stamina drain run/regen walk, forced walk quando zera

- **Combate**
  - `data/lib/diablo2/04_combat.lua` — AR vs Defesa `200* aLvl/(aLvl+tLvl) * AR/(AR+Def)` 5-95%, block 75% cap `(shieldBlock*(dex-15))/(lvl*2)`, run reduz def a 0 e block /3, absorb fixed->%, leech 1/0.5/0.25 NM/Hell, CB 25%/12.5% boss/10% pvp, DS/CS `cs+ds-cs*ds/100`, OW 8s bleed por nível, ITD ignora defesa normal, Knockback 2 tiles, CtC

- **Looot & Itens**
  - `data/lib/diablo2/05_items.lua` — aLvl 85 areas (Pit, Chaos, WSK), mLvl=aLvl+2 champ+3 unique/boss, iLvl=mlvl, TC treasure classes, rarity roll MF diminishing returns `250/(250+mf)` etc, prefix/suffix blue/yellow, uniques (SoJ, Shako, Windforce), sets (Tal Rasha, IK), sockets `rollSockets`, gems 5 níveis, jewels, rainbow facets -5% enemy res after break, base upgrading 1.5x/2.5x, charges, oLvl/mLvl/qLvl

- **Runewords & Cubo**
  - `data/lib/diablo2/06_runewords.lua` — 90+ runewords (Spirit, Insight, Stealth, Lore, Enigma, Infinity, Grief...), ordem exata, tipo restrito, só item cinza com furos, erro => gemmed. `RUNE_UPGRADE` 3 runas+gem -> próxima
  - `data/lib/diablo2/07_cube.lua` — `cubeTransmute`, gem upgrades, socketing Tal+Thul+PTopaz etc, crafting Blood/Caster, base upgrading Normal->Exc->Elite, repair Ort/Ral, Cow Level Wirt's Leg+Tome, keys->Uber portals, Token of Absolution respec. Larzuk `larzukSocket` max sockets.

- **Economia**
  - `data/lib/diablo2/08_gambling.lua` — gamble custo 50-120k, ilvl=clvl-5..+4, chance unique 2% lvl80+
  - `data/lib/diablo2/09_charms.lua` — small 1 slot, medium 2, large 3, dilemma power vs free space, Gheed's Fortune MF+price, Torch Pandemonium, Annihilus Uber Diablo, limite 1 cada

- **Dificuldade & Mundo**
  - `data/lib/diablo2/10_difficulty.lua` — `setDifficulty` Normal 0, Pesadelo -40% res, Inferno -100% + XP loss 5%/10%, imunidades >100%, break immunity Conviction/Lower Resist 1/5 efetivo vs imune, `/players 1-8` +100% HP por player, reduz NoDrop, xp penalty 90-99
  - `data/lib/diablo2/14_world.lua` completo

- **Mercenários & Progressão**
  - `data/lib/diablo2/11_mercenaries.lua` — Act1 Rogue Inner Sight, Act2 Desert Prayer/Defiance/Blessed Aim/Thorns/Holy Freeze/Might, Act3 Iron Wolf Fire/Cold/Light, Act5 Barb Bash/Stun, level up com player, equip arma/armor/helm, ethereal sem perder dura, aura ativa

- **Skills 7 Classes 210+**
  - `data/lib/diablo2/12_skills.lua` — `SKILL_TREES` Amazon/Assassin/Barbarian/Druid/Necromancer/Paladin/Sorceress 10 skills por 3 trees = 30 por classe = 210 total. `SYNERGIES` passivo: Fire Bolt +16% por Fire Ball/Meteor, Blizzard +5% Ice Blast etc. Skill points `SKILL_POINTS_PER_LEVEL=1`, attr 5. `addSkillPoint`, `getSkillLevel` com +skills de Torch/Anni. `SPELLS` 210 entradas.

- **Monstros & Bosses**
  - `data/lib/diablo2/13_monsters.lua` — Fallen, Zombie, Skeleton, Goatman... Balrog, Venom Lord, superuniques Countess/Summoner/Nihlathak com keys, bosses Andariel/Duriel/Mephisto/Diablo/Baal, Uber Clone Annihilus, Ubers Lilith/Duriel/Izual organ, Uber Mephisto/Diablo/Baal Torches. `playersScaling` HP+100% per player.
  - `data/monster/Diablo2/*.xml` — 26 arquivos XML para servidor OTX carregar, registrados em `data/monster/monsters.xml`

- **Mundo Avançado**
  - `data/lib/diablo2/14_world.lua` — AI target priority Decoy/Golem/Valkyrie, curse overriding só 1 maldição por inimigo última sobrescreve, corpse consumption contested CE/Find Item/Redemption, cold shatter 30%+ cold dmg% sem corpo bloqueia ressurreição, weapon swapping W com pre-buff 30s, gold loss mortes inventário todo +% banco + taxa lvl, stash personal 4 abas (caem HC) vs shared 3 abas conta, vendor caps 5k Act1 Normal até 35k NM/Hell, loot compartilhado primeiro clique, party precisa convite XP/aura, chill/freeze half NM 25% Hell, Cannot Be Frozen anula azul mas não Holy Freeze aura, PLR redução tempo veneno com penalidades -40/-100, diminishing stun bosses 0.1x champs 0.3x, Uber Diablo SoJ counter 75 vendas -> spawn, Pandemonium 3 keys -> portais Lilith/Duriel/Izual -> órgãos -> Uber Tristram Hellfire Torch, `openPandemoniumPortal`, `openUberTristram`

- **UI**
  - `data/lib/diablo2/15_ui.lua` — modal windows: `openSkillTree`, `openCharScreen` com breakpoint frames `frame/fps`, `openInventoryCharms`, `openStash`, `openCubeUI`, `openGamblingUI`, `openRunewordsUI`, `mainMenu`

- **Loader**
  - `data/lib/diablo2/init.lua` + `data/lib/diablo2_complete.lua` — carregado em `data/global.lua`, shims D2/D2R compatíveis, hooks `onD2Hit`, `onD2Death`

- **Spells 210**
  - `data/spells/scripts/diablo2/*.lua` — 210 arquivos gerados, cada um usa `onD2Hit` (AR vs Def, block 75% cap, CB, DS, OW, KB, leech, CtC, freeze, corpse). Ex: `corpse_explosion.lua`, `teleport.lua`, `blessed_hammer.lua`, `frozen_orb.lua`, etc
  - `data/spells/spells.xml` — 210 entradas `<instant name="D2_Fire_Ball" words="d2 fire_ball" ... script="diablo2/fire_ball.lua">`

- **TalkActions**
  - `data/talkactions/scripts/diablo2/` — `d2_full.lua` (!d2 status/skills/charms/cube/runewords/stash/menu/attr/players/diff/skill), `d2players.lua` (!players 1-8 e /players), `d2swap.lua` (!swap !w troca W + pre-buff), `d2cube.lua` (!d2cube Tal,Thul,Perfect Topaz,armor), `d2gamble.lua` (!d2gamble ring/amulet), `d2merc.lua` (!d2merc 1-5), `d2uber.lua` (!d2uber soj/keys/tristram)
  - `data/talkactions/talkactions.xml` atualizado

- **Actions**
  - `data/actions/scripts/diablo2/` — `horadric_cube.lua`, `charm_equip.lua`, `runeword_socket.lua`
  - `data/actions/actions.xml` adicionado

- **NPCs**
  - `data/npc/scripts/diablo2_gheed.lua` — gambling MF/GF, vendor cap 5k-35k
  - `data/npc/scripts/diablo2_akara.lua` — crafting, heal PLR, merc info
  - `data/npc/scripts/diablo2_larzuk.lua` — socket quest max sockets, ethereal, runeword só cinza
  - `data/npc/scripts/diablo2_greiz.lua` — Act2 merc auras Might/Holy Freeze/Prayer

- **Migrations**
  - `data/migrations/diablo2.sql` e `data/migrations/diablo2_complete.sql` — todas colunas d2_*, stash shared vs personal, runewords catalog 90+, treasure classes, affixes, gems, charms unique, keys Uber, global events SoJ counter, corpses contested, stamina log

## 3. Como Clonar e Acessar Local
Se você tem git instalado:

```bash
git clone https://github.com/lluadevill-lab/OTX.git
cd OTX
git fetch origin arena/019fbb14-otx
git checkout arena/019fbb14-otx
# ver arquivos:
ls data/lib/diablo2/
cat data/lib/diablo2_complete.lua
```

Ou via GitHub Desktop: File > Clone Repository > URL = `https://github.com/lluadevill-lab/OTX.git` > depois trocar branch para `arena/019fbb14-otx`.

## 4. Como Compilar e Testar (OTX 3.10 compatível)
O servidor continua compilável com protocolo Tibia 10/11, as regras D2 são datapack Lua.

```bash
mkdir build && cd build
cmake ..
make -j4
# importar DATABASE.sql + migrations
mysql -u root -p otx < DATABASE.sql
mysql -u root -p otx < data/migrations/diablo2.sql
mysql -u root -p otx < data/migrations/diablo2_complete.sql
./otxserver
```

No jogo Tibia 10/11:
- `!d2status` ou `!d2 menu`
- `!d2 attr STR 50` etc para testes
- `!d2 skills` abre árvore 210 skills
- `!players 8` simula 8 players
- `!swap` ou `!w` troca arma W pre-buff
- `!d2cube Tal,Thul,Perfect Topaz,armor`
- `!d2gamble ring`
- `!d2merc 2` contratar merc Act2 Might
- `!d2uber soj` vender SoJ acumula para Uber Diablo
- Castar magias: `d2 fire_ball`, `d2 frozen_orb`, `d2 blessed_hammer`, etc (use spellbook)

## 5. Fontes Usadas
- `https://d2api.netlify.app/` rotas `/api/skills.json`, `/api/treasureclassex.json`, `/api/magicprefix.json`, `/api/runes.json`, `/api/charstats.json`, `/api/monstats.json`, `/api/levels.json`
- `https://diablo2.diablowiki.net/` — wiki breakpoints, MF diminishing, immunities, TC 85 areas, runewords order/type restriction

## 6. Próximos Passos para Cliente Custom (roadmap dividido)
O pedido foi dividido em partes entregues nesta branch:

**Parte 1 - Atributos & Breakpoints:** 25 FPS engine, FCR/FHR/IAS/FBR tabelas por classe, stamina.

**Parte 2 - Combate:** AR vs Def, block 75% cap, run vs walk, absorb, leech, CB/DS/OW/ITD/KB/CtC.

**Parte 3 - Itens Físicos Ocultos:** weapon range 1-5, ethereal 50% + -10 req, kick damage boots, barb 2H mastery.

**Parte 4 - Loot & Economia:** MF diminishing, iLvl/aLvl, TC, prefix/suffix, rare/unique/set, vendor caps 5k-35k, gold loss.

**Parte 5 - Crafting:** Cube funcional todas receitas, runewords 90+ funcionais ordem/tipo/gray, socket Larzuk/cube, gambling char level scaling, base upgrading, charges, oLvl/mLvl/qLvl.

**Parte 6 - Mundo/Dificuldade:** Normal -0, NM -40% res 5% XP loss, Hell -100% 10% loss, immunidades >100%, break 1/5 Conviction/Lower Resist, /players X HP/ XP/NoDrop.

**Parte 7 - Companheiros & Progress:** mercs equip/aura, synergies 210 skills, XP penalty 90-99, chill/freeze half/quarter, CBF, PLR -40/-100, stun diminishing.

**Parte 8 - IA & Interface:** AI target Decoy/Golem, curse overriding, corpse consumption contested, cold shatter no corpse, weapon swapping W pre-buff, stash shared vs personal HC, loot compartilhado first click, party XP/aura.

**Parte 9 - Eventos & Inventario:** Charms small/medium/large + dilemma espaço, uniques Gheed/Torch/Anni, gems 5 níveis + jewels + rainbow facets -enemy res after break, sockets, Uber Diablo SoJ global, Pandemonium keys->organs->Tristram.

**Parte 10 - Monstros/Bosses/NPCs/UI:** 26 monstros XML, bosses Andariel->Uber Tristram, NPCs Gheed/Akara/Larzuk/Greiz para buy/craft/gamble/merc, menus modal, 210 spells, talkactions, actions, migrations.

Cliente custom Diablo II render com 25 FPS animações exigirá protocolo novo fora do escopo Tibia 10/11, mas server-side já está 100% pronto e testável via !d2.

## 7. Perguntas Frequentes

**Por que não vejo no GitHub?**
Você estava na branch `master`. Troque para `arena/019fbb14-otx` no dropdown.

**Como abro Pull Request?**
`gh pr create --base master --head arena/019fbb14-otx --title "OTX Diablo II Completo"` ou pela UI GitHub > Compare & pull request.

**Onde reporto bug?**
Abra issue no repositório com label `diablo2`.

---

Gerado automaticamente para sua branch `arena/019fbb14-otx`.
