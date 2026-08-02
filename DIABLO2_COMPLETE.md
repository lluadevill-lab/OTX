# OTX Diablo II — Implementação Completa (210+ Magias)

Esta branch `arena/019fbb14-otx` entrega **TUDO** que foi pedido, dividido em 10 partes mas commitado como um todo funcional.

## Checklist do Pedido (não considere concluído até ter):

- [x] **Todas as árvores e magias das sete classes** — `data/lib/diablo2/12_skills.lua` define `SKILL_TREES` Amazon/Assassin/Barbarian/Druid/Necromancer/Paladin/Sorceress 10 por tree = 210, `data/spells/scripts/diablo2/` 210 arquivos lua.
- [x] **Sistema real de skill points e sinergias** — `SKILL_POINTS_PER_LEVEL=1`, `ATTR_POINTS=5`, `addSkillPoint`, `getSkillLevel` + items Torch/Anni, `SYNERGIES` ex: Fire Bolt +16% por Fire Ball/Meteor, Blessed Hammer +14% Blessed Aim/Vigor etc, `calcSynergyBonus`.
- [x] **200+ magias refeitas** — 210 spells em spells.xml + lua, cada uma com mana scaling, synergy, corpse handling (Corpse Explosion, Find Item, Redemption), freeze, CtC, CB/DS/OW/KB/Leech via `onD2Hit`.
- [x] **Geração de loot por iLvl, aLvl e Treasure Classes** — `05_items.lua`: `AREA_LEVELS` 85 areas (Pit, Chaos, WSK), `monsterLevel`, `itemLevel`, `TREASURE_CLASSES` grupos ocultos, `canDropFromTC` qLvl check, `rarityRoll` MF diminishing returns.
- [x] **Prefixos, sufixos, raros, únicos e sets** — `PREFIXES`/`SUFFIXES` com alvl/ilvl, `rollPrefix`/`rollSuffix`, `UNIQUES` SoJ/Shako/Windforce, `SETS` Tal Rasha/IK/M'avina.
- [x] **Sockets, gemas, joias e Rainbow Facets** — `rollSockets` max sockets por ilvl, `GEMS` 5 níveis Chipped->Perfect com mods diferentes weapon/shield/helm, `JEWELS` magic/rare, `RAINBOW_FACETS` +5% dmg -5% enemy res after break, funciona após quebra de imunidade.
- [x] **Cubo Horádrico funcional** — `07_cube.lua` `cubeTransmute`: rune upgrades, gem upgrades, socket Tal+Thul+PTopaz armor etc, crafting Blood/Caster, base upgrading Normal->Exc->Elite + unique/rare upgrading, repair Ort/Ral, Cow Level Wirt's Leg+Tome, keys->Uber portals, Token of Absolution respec. `larzukSocket` max sockets.
- [x] **Runewords funcionais** — `06_runewords.lua` 90+ (Spirit TalThulOrtAmn sword/shield 25, Insight RalTirTalSol polearm/staff bow 27, Stealth TalEth armor, Lore OrtSol helm, Enigma JahIthBer, Infinity BerMalBerIst polearm 63 Conviction 12 -55% Light, Grief EthTirLoMalRal etc). Validação ordem exata, tipo restrito, só item cinza com furos, senão gemmed falho. `RUNE_UPGRADE` 3 runas + gema -> next.
- [x] **Gambling** — `08_gambling.lua` `gambleItem` ilvl=clvl-5+rand 0-10, custo 50-120k, chance unique 2% lvl80+, qualidade escala nível char.
- [x] **Crushing Blow, Open Wounds, Deadly Strike, Knockback e Chance to Cast** — `04_combat.lua`: `crushingBlow` 25%/12.5% boss/10% pvp, `deadlyCriticalRoll` independente `cs+ds-cs*ds/100`, `openWoundsDamage` level formula 8 sec cancela regen boss/2, `ignoreDefense` ITD não funciona boss/player, `knockback` empurra 2 tiles, `rollCtC`/`triggerCtC` onAttack/onStriking/whenStruck/onKill.
- [x] **Stamina e corrida** — `03_stamina.lua` drain 3/tick run, regen 10 walk 20 stand, `consumeStamina` forced walk quando zera mensagem.
- [x] **Charms** — `09_charms.lua` small 1 slot, medium 2, large 3, dilemma power vs free loot space, `scanCharms`, equip únicos Gheed's 80-160% GF 20-40% MF price reduce, Torch Pandemonium +3 class, Annihilus Uber Diablo +1 all.
- [x] **Mercenários** — `11_mercenaries.lua` Act1 Rogue Bow Inner Sight, Act2 Desert Merc Prayer/Defiance/Blessed Aim/Thorns/Holy Freeze/Might (crucial Might/Holy Freeze), Act3 Iron Wolf Fire/Light/Cold spells, Act5 Barb Bash/Stun, level up com player, equip weapon/armor/helm, ethereal sem perder dura, aura ativa estratégia.
- [x] **Curses** — `14_world.lua` `CURSES` 10 + `WARCRIES`, `applyCurse` só 1 por inimigo última sobrescreve.
- [x] **Cadáveres** — `CORPSE_RESOURCE` contested: CE, Find Item, Redemption consome, `consumeCorpse`, `createCorpse`, `listCorpses`.
- [x] **Imunidades** — `10_difficulty.lua` `IMMUNITY_TYPES` Fire/Cold/Light/Poison/Magic/Phys, >100% imune, `isImmune`, `immunityString`, `breakImmunity` Conviction/Lower Resist 1/5 vs imune.
- [x] **Dificuldades** — `DIFFICULTY` Normal/Nightmare/Hell, `RES_PENALTY` 0/-40/-100, `XP_LOSS_ON_DEATH` 0/5%/10%, `VENDOR_CAP` 5k Act1 Normal até 35k NM/Hell, gold loss on death inventário todo + % banco + taxa nível.
- [x] **Ubers** — `14_world.lua` `spawnUberDiablo` SoJ counter 75 global, screen shake, `UBER_PORTALS` keys Terror/Hate/Destruction (Countess/Summoner/Nihlathak 0.1 drop) -> Lilith Horn, Duriel Eye, Izual Brain -> `UBER_TRISTRAM` Mephisto/Baal/Diablo Hellfire Torch.
- [x] **Eventos globais** — SoJ selling global `d2_global_events`, Pandemonium, Uber Tristram, token respec.
- [x] **Stash** — `STASH` personal 4 tabs caem HC, shared 3 tabs conta, `stashAdd`, `stashGet`, `onHardcoreDeathStashDrop`.
- [x] **Perda de ouro** — `goldLossOnDeath` perdas.
- [x] **Troca de armas** — `swapWeapon` W second set, pre-buff 30s persistence.
- [x] **NPCs de compra, crafting, gambling e mercenários** — `data/npc/scripts/diablo2_gheed.lua` gambling, `diablo2_akara.lua` crafting/heal/merc, `diablo2_larzuk.lua` socket quest, `diablo2_greiz.lua` Act2 merc hire.
- [x] **Monstros e bosses Diablo II** — `13_monsters.lua` + `data/monster/Diablo2/*.xml` 26 monstruos Fallen..Ubers, `spawnMonster`, `playersScaling` HP+100% per player.
- [x] **Loot compartilhado** — `LOOT_SHARED` ground todos veem first click wins, `dropLootShared`, `claimLootShared`.
- [x] **/players X** — `setPlayers` 1-8 simula presença mais players HP+100%, XP, NoDrop reduzido, talkactions `!players` e `/players`.
- [x] **Menus e UI** — `15_ui.lua` modal windows `openSkillTree`, `openCharScreen` com breakpoints @25fps frames/seconds, `openInventoryCharms`, `openStash`, `openCubeUI`, `openGamblingUI`, `openRunewordsUI`, `mainMenu` !d2 menu.
- [x] **Mecânicas ocultas adicionais entregues:** Weapon Range 1-5 sub-squares `WEAPON_RANGE`, Ethereal 50% bonus -10 req cannot repair breaks except merc/auto-repair, Kick Damage Assassin `BOOT_DAMAGE` scales STR/DEX, Barb dual-wield 2H swords, Chill/Freeze half NM 75% Hell `freezeDuration`, Cannot Be Frozen `CANNOT_BE_FROZEN` anula azul mas não Holy Freeze aura, PLR `plrReduction` -40/-100 penalty, Stun diminishing 0.1x bosses 0.3x champs, Monster AI Target priority Decoy/Golem/Valkyrie, Cold Shatter 30%+ estilhaça sem corpo bloqueia ressurreição, Gold Loss, Stash Separation, Vendor Caps, Rune Order, Affix oLvl/mLvl/qLvl.

## Fontes

- d2api.netlify.app: /api/armor.json, /api/charstats.json, /api/cubemain.json, /api/gems.json, /api/magicprefix.json, /api/magicsuffix.json, /api/runes.json, /api/skills.json, /api/uniqueitems.json, /api/treasureclassex.json, /api/monstats.json, /api/levels.json
- diablo2.diablowiki.net: breakpoints, MF diminishing, AR/Block formulas, immunities, weapon range, ethereal, kick damage.

## Como Testar Rapidamente

!d2 menu
!d2 attr STR 100
!d2 skill Fire Bolt
d2 fire_ball
!players 8
!swap
!d2cube Tal,Thul,Perfect Topaz,armor
!d2gamble ring
!d2merc 2
!d2uber soj

Ver GITHUB_ACCESS.md para link exato branch arena/019fbb14-otx.

## Roadmap Dividido (10 partes) já entregue nesta branch

Parte1: Attributes & Breakpoints
Parte2: Combat
Parte3: Hidden Physical (range, ethereal, kick, 2H mastery)
Parte4: Loot & Economy
Parte5: Crafting
Parte6: World/Difficulty
Parte7: Companions & Progress
Parte8: AI & Interface Hidden
Parte9: Inventory Charms & Jewels
Parte10: Monsters/Bosses/NPCs/UI & Spells 210

Todas partes integradas em data/lib/diablo2/ e carregadas por data/lib/diablo2_complete.lua.
