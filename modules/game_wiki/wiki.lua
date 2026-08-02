wikiWindow = nil
wikiButton = nil

local listPanel = nil
local detailPanel = nil
local detailTitle = nil
local detailText = nil
local topicsScrollPanel = nil
local detailScrollPanel = nil
local topicsScrollBar = nil
local detailScrollBar = nil

local topicOrder = {
  "Auto Loot",
  "BagLoot",
  "Bank",
  "Bestiary",
  "Change Vocation",
  "Death Recover",
  "Exp & Loot",
  "Extra Information",
  "Find NPC",
  "Forge",
  "Houses",
  "Infusion Attributes",
  "Instanced hunts",
  "Items",
  "Mana/Life Leech",
  "MC & Bot",
  "Minimap",
  "Monsters",
  "Monsters Demoniacs",
  "Non-PvP",
  "Online Points",
  "Premium Account",
  "Promotions",
  "Quests",
  "Rookie Battle",
  "Roulette",
  "Soul Bosses",
  "Spells",
  "Stamina",
  "Summons",
  "Tasks",
  "Trainers",
  "Traveling",
  "Treasure Chest",
  "Vocation Guide",
}

wikiData = {}

wikiData["Auto Loot"] = [[
== AUTO LOOT ==

O QUE E:
Sistema que coleta automaticamente itens definidos por voce assim que a criatura morre.
Tambem existe o Quick Loot para contas free, que precisa de clique manual no corpo.

REGRAS IMPORTANTES:
- Todo gold dropado vai direto para o banco, nao precisa adicionar no autoloot.
- Auto Loot tem prioridade sobre BagLoot. Se quiser garantir que o item va para sua BP e nao para BagLoot, adicione no Auto Loot.
- Disponivel para contas premium na versao automatica.

COMANDOS:
!autoloot add, <nome do item> -> adiciona item na lista. Ex: !autoloot add, royal helmet
!autoloot remove, <nome do item> -> remove item da lista
!autoloot list -> mostra todos itens configurados
!autoloot clear -> limpa toda lista
!autoloot <nome do monstro>, <valor> -> adiciona todos itens do monstro com valor de NPC >= valor. Ex: !autoloot dragon lord, 10000
Se nao informar valor, padrao e 1000. Use 0 para adicionar todos os itens.

QUICK LOOT (FREE):
!quickloot add, <item> -> adiciona
!quickloot remove, <item> -> remove
!quickloot list -> lista
Funciona com lista, mas precisa clicar no corpo para coletar rapido.

DICAS:
- Mantenha lista enxuta para nao lotar BP.
- Combine com Bank para gold automatico.
- Use valor minimo de 5000+ para pegar so itens bons.
]]

wikiData["BagLoot"] = [[
== BAGLOOT ==

O QUE E:
Sistema que envia loot pesado direto para um NPC de armazenamento, permitindo vender depois sem carregar peso.
Perfeito para knights ou hunts longas.

COMO FUNCIONA:
- Ao matar monstro, itens que nao estao no Auto Loot e que tem valor em NPC podem ir para BagLoot automaticamente se voce tiver o sistema ativado.
- Depois de juntar bastante loot, va ate o NPC do BagLoot na cidade e venda tudo de uma vez.
- Todo gold do BagLoot tambem vai para o banco.

UPGRADE:
- No inicio seu BagLoot so aceita itens de valor baixo.
- Para aceitar itens cada vez mais caros, voce precisa fazer upgrade.
- Como fazer upgrade:
  1) Comprar upgrade diretamente do NPC de BagLoot com gold ou pontos.
  2) Completar rankings do Bestiary. Cada bestiario completo da pontos que aumentam o nivel do BagLoot.

COMANDOS:
!bagloot -> abre janela do BagLoot
!bagloot balance -> ve quanto tem para vender
!bagloot sell -> vende tudo
!bagloot upgrade -> ve nivel atual e proximo upgrade

DICAS:
- Use Auto Loot para itens raros que voce quer na BP, e BagLoot para itens de valor medio pesado.
- Faca tasks do Bestiary para upar BagLoot de graca.
- Sempre venda antes de trocar de cidade, cada cidade pode ter NPC diferente.

RELACAO COM BESTIARY:
Cada monstro morto conta no Bestiary. Ao completar etapas, voce ganha experiencia e libera upgrade automatico do BagLoot.
Mensagem aparece no canal Bestiary.
]]

wikiData["Bank"] = [[
== BANK ==

O QUE E:
Sistema bancario central do servidor. Todo gold dropado no chao ou via Auto Loot / BagLoot vai direto para seu banco.
Voce nao precisa carregar gold na BP, fica tudo no banco seguro contra morte.

COMANDOS PRINCIPAIS:
!bank -> abre janela do banco
!balance ou !bank balance -> mostra saldo atual
!bank deposit, <valor> ou !bank deposit all -> deposita gold da BP no banco
!bank withdraw, <valor> -> saca gold do banco para BP
!bank transfer, <nome>, <valor> -> transfere gold para outro jogador
!bank statement -> extrato das ultimas transacoes

REGRAS:
- Ao morrer, gold no banco nao e perdido.
- Venda de itens no NPC ja cai direto no banco.
- Gold no chao de hunts tambem vai direto se voce tiver Auto Loot ativo ou pegar manual.

DICAS:
- Deixe sempre gold na BP apenas para comprar supplies.
- Use transfer para pagar amigos ou guild.
- Verifique extrato para controlar lucros de hunt.

SEGURANCA:
- Sistema de banco e 100% seguro contra roubo.
- Nao compartilhe senha ou token com outros jogadores.
]]

wikiData["Bestiary"] = [[
== BESTIARY ==

O QUE E:
Sistema de registro automatico de mortes de monstros. Vale para TODOS os monstros do jogo.
Cada kill e contabilizada e mostrada em mensagem no canal Bestiary.

COMO FUNCIONA:
- Mate monstros normalmente.
- Cada morte conta para o progresso do bestiario daquele monstro.
- Ao atingir metas (ex: 250, 500, 1000 kills) voce completa etapas.

RECOMPENSAS:
- Experiencia extra ao completar cada etapa.
- Upgrade automatico do nivel do BagLoot, liberando itens mais caros.
- Pontos de charms em alguns servidores (se ativado) para comprar bonus contra monstros.
- Ranking interno de quem mais completa bestiarios.

CANAL:
- Entre no canal Bestiary para ver progresso em tempo real.
- Mensagem tipo: You have killed 250/1000 Dragons.

DICAS:
- Cace em lugares variados para completar varios bestiarios ao mesmo tempo.
- Use Auto Loot para nao perder tempo e focar em matar.
- Bestiary e forma passiva de ganhar bonus sem fazer nada alem de cacar.
- Combine com Tasks do Grizzly para ganhar duas vezes: task + bestiary.

ESTRATEGIA:
- Comece por monstros faceis: rats, trolls, orcs, minotaurs.
- Depois va para dragons, hydras, demons, etc.
- Cada bestiario completo ajuda a upar BagLoot, que ajuda a ganhar mais dinheiro.
]]

wikiData["Change Vocation"] = [[
== CHANGE VOCATION ==

O QUE E:
Sistema que permite trocar de vocacao do seu personagem sem precisar criar outro char.

COMO FUNCIONA:
- Compre o item Vocation Change Book na loja de pontos (Shop) do site ou in-game.
- De use no livro e escolha a nova vocacao entre: Sorcerer, Druid, Paladin, Knight.
- Existe conversao de skills e magic level de acordo com formulas balanceadas.

FORMULAS DE CONVERSAO (BASE CALABRESOT):
- Master Sorcerer ou Elder Druid -> Monk: Magic Level * 0.93 vira skill de lutar, e Magic * 0.36 vira Magic Level de Monk (se Monk estiver habilitado).
- Elite Knight -> Monk: Magic * 3.95 vira Magic de Monk, Melee top * 0.93 vira Fist, Shielding * 0.9 vira Shielding de Monk.
- Royal Paladin -> Monk: Magic * 1.1 vira Magic, Distance * 0.93 vira Fist, Shielding * 0.9 vira Shielding.

REGRAS:
- Ao trocar, todas as gems equipadas sao reroladas com novos modificadores apropriados para nova classe.
- Progresso de Supreme Bonuses especificos da vocacao antiga e resetado e precisa ser refeito do zero.
- Itens de vocacao antiga que nao podem ser usados na nova devem ser guardados ou vendidos.
- Cooldown de troca: geralmente 7 dias para evitar abuso.

COMANDOS:
!changevocation -> se tiver o livro na BP, abre janela de troca
!vocation -> mostra vocacao atual e se pode trocar

DICAS:
- Troque apenas se tiver certeza, pois perde alguns progressos.
- Ideal para testar outra vocacao no mesmo char e manter level e outfits.
- Facil para quem enjoa rapido ou quer ajudar guild com falta de alguma vocacao.
]]

wikiData["Death Recover"] = [[
== DEATH RECOVER ==

O QUE E:
Sistema que permite recuperar parte do que voce perdeu ao morrer, como experiencia, itens, ou ate voltar no local da morte.

COMO FUNCIONA:
- Ao morrer, seu corpo fica no local da morte por um tempo determinado (ex: 10 minutos).
- Voce pode usar comando para recuperar ou voltar rapido.
- Existe taxa de custo para usar, dependendo do level e itens.

COMANDOS:
!deathrecover ou !dr -> mostra informacoes da ultima morte: local, tempo restante, custo
!deathrecover buy -> paga taxa e recupera itens que cairam no chao ou recupera bless parcial
!deathrecover go -> teleporta voce de volta para local da morte (se ainda dentro do tempo)

CUSTOS:
- Custo varia com level e valor dos itens perdidos.
- Pode ser cobrado em gold do banco.
- Contas premium tem desconto de 30% no custo.

REGRAS:
- So funciona se voce morreu para monstro, nao para player em area PvP (depende de regra do servidor).
- Tempo limite de 10 a 15 minutos apos morte.
- Se morrer de novo antes de recuperar, perde direito da morte anterior.

DICAS:
- Nao se preocupe se morrer longe, use !dr go para voltar rapido.
- Sempre mantenha gold no banco para pagar taxa se precisar.
- Melhor que perder backpack inteira em hunt cara.

BENEFICIOS:
- Evita frustracao de perder itens raros por lag ou desconexao.
- Ajuda iniciantes ate level 60 que tem bless gratis.
]]

wikiData["Exp & Loot"] = [[
== EXP & LOOT ==

TAXAS DO SERVIDOR (CALABRESOT):
- Experiencia inicial: 5x com stages (diminui conforme sobe level para manter desafio)
- Magic Level: 5x
- Skills: 9x
- Loot: 3x

STAGES DE EXP:
- Level 1 a 50: 10x ou 5x (depende de configuracao atual)
- Level 51 a 100: 7x
- Level 101 a 150: 5x
- Level 151 a 200: 3x
- Level 201+: 2x ou 1.5x
Verifique !stages para tabela atualizada.

STAMINA BONUS:
- Nas 3 primeiras horas de stamina voce ganha 50% a mais de XP.
- Stamina verde = 40:00 a 42:00 = bonus ativo
- Laranja = 01:00 a 39:59 = exp normal
- Abaixo de 01:00 = exp reduzida

LOOT:
- Loot 3x significa 3 vezes mais chance e quantidade que tibia global.
- Gold automatico vai para banco.
- Itens de quest e raros tem chance aumentada em eventos.

COMANDOS:
!exp -> mostra quanto falta para proximo level e porcentagem
!stamina -> mostra stamina atual
!stages -> mostra tabela de stages

DICAS:
- Aproveite as 3 horas de stamina por dia para upar mais rapido.
- Cace em party com 2 ou mais players para ganhar bonus de XP compartilhada.
- Use prey boost se disponivel para aumentar exp em criatura especifica.

OFFLINE TRAINING:
- Quando deslogado treinando, voce ainda ganha skill mas nao exp.
- Para exp, precisa estar online cacando.

EVENTOS:
- Em finais de semana pode ter Double Exp e Double Loot.
- Fique ligado no chat global e no site.
]]

wikiData["Extra Information"] = [[
== EXTRA INFORMATION ==

O QUE E:
Secao com informacoes extras, comandos uteis, e curiosidades do servidor que nao se encaixam nas outras categorias.

COMANDOS UTEIS GERAIS:
!online -> mostra quantos players online e lista
!uptime -> tempo que servidor esta online sem reiniciar
!serverinfo -> informacoes do servidor, rates, versao
!commands -> lista todos comandos disponiveis
!info -> informacoes do seu char: level, voc, guild, etc
!kills -> mostra suas mortes e frags
!frags -> mostra frags recentes e skull
!bless ou !blessings -> mostra quais bless voce tem
!buyhouse -> lista casas disponiveis para compra
!leavehouse -> abandona sua casa
!deathlist -> lista suas ultimas mortes

FUNCOES EXTRAS:
- !autoloot, !bagloot ja explicados
- !bank ja explicado
- !trainer -> vai para ilha de treino privada (se tiver casa)
- !task -> abre janela de tasks

ATUALIZACOES:
- Patch notes sao postados no site e discord.
- Sempre leia as notas para saber de novos sistemas.

DICAS GERAIS:
- Use o Client 8.0 oficial do servidor para evitar bugs.
- Mantenha antivirus desativado para pasta do cliente para evitar falso positivo.
- Denuncie bugs para staff para ganhar recompensa.

CANAL HELP:
- Entre no canal Help para tirar duvidas com tutores e players.
- Respeite regras, sem spam ou ofensas.
]]

wikiData["Find NPC"] = [[
== FIND NPC ==

O QUE E:
Sistema que ajuda a encontrar NPCs pelo mapa sem precisar decorar localizacao.

COMO FUNCIONA:
- Use magia de busca ou comando para localizar NPCs proximos.
- Sistema mostra direcao e distancia ate o NPC, similar ao exiva.

MAGIA:
Spell: exiva npc res ou !findnpc <nome>
Nome: Find NPC
Grupo: Suporte
Vocacao: Todas
Level Minimo: 8
Mana: 20
Cooldown: 2 segundos
Efeito: indica direcao para NPC mais proximo com aquele nome. Se nao achar, avisa.

EXEMPLOS:
!findnpc Grizzly Adams -> mostra onde esta o NPC de tasks
!findnpc Rashid -> mostra onde esta Rashid (se estiver na cidade do dia)
exiva npc res "boat" -> acha NPC de barco

OUTRA FUNCAO:
- Tambem existe exiva moe res para achar monstros influenciados da Forge (Find Fiend).
  Spell: exiva moe res
  Mostra direcao para Fiendish creature mais proxima, informa dificuldade se tiver bestiary completo.

DICAS:
- Use para achar NPCs de quests que voce nunca visitou.
- Otimo para iniciantes que nao conhecem mapa.
- Se NPC nao for encontrado, verifique se digitou nome correto ou se ele so aparece em horario especifico.

LISTA DE NPCS COMUNS:
- Grizzly Adams (tasks) -> acima do DP de Thais
- Rashid (itens raros) -> muda de cidade por dia
- NPC Bank -> em todo DP
- NPC BagLoot -> em todo DP
- NPC de barco -> em cidades portuarias
]]

wikiData["Forge"] = [[
== FORGE - EXALTATION FORGE ==

O QUE E:
Sistema de melhoria permanente de equipamentos por Tiers. Inspirado no sistema oficial do Tibia, mas com ajustes do CalabresOT.
Voce pode melhorar armas, armaduras e capacetes para ganhar efeitos passivos que ativam em combate.

ONDE USAR:
- Va ate Adventurers Guild. Use Adventurer Stone em qualquer templo para ir rapido.
- Procure a Exaltation Forge, use nela para abrir janela do sistema.
- Materiais: Dust, Slivers, Exalted Cores.

MATERIAIS:
- Dust: recurso ligado ao personagem, nao negociavel, dropado ao matar Influenced Monsters (monstros com aura brilhante que aparecem aleatoriamente, forca de 1 a 5 stacks). Ao matar, todos que participaram da luta ganham Dust.
- Slivers: versao negociavel, dropado de Fiendish Monsters (muito mais fortes, equivalente a 15 stacks de Influenced). So quem deu last hit ou grupo responsavel pode lootear Slivers do corpo.
- Exalted Core: feito convertendo materiais na propria forja.

CONVERSOES NA FORJA:
- 60 Dust -> 3 Slivers
- 50 Slivers -> 1 Exalted Core
- Aumentar limite maximo de Dust (comeca em 100, pode ir ate 255). Cada aumento custa Dust. Ex: 100 para 101 custa 25 Dust, 120 para 121 custa 45 Dust.

FUSAO (FUSION):
- Precisa de 2 itens IDENTICOS do mesmo Tier (ex: Cobra Axe Tier 2 + Cobra Axe Tier 2)
- Itens nao podem estar com imbuement.
- Custo: 100 Dust + Gold (valor depende da classe e Tier) + opcional Exalted Core para aumentar chance.
- Chance base: 50% sucesso, pode subir para 65% com Exalted Core.
- Se sucesso: recebe Exaltation Chest na BP principal com item Tier +1. Outro item e consumido.
- Se falha: um item permanece igual, Dust/Gold/Core consumidos, segundo item perde 1 Tier ou quebra se Tier 0. Pode usar Exalted Core extra para reduzir chance de perda de 100% para 50%.
- Existe pequena chance de bonus de sorte: gold nao consumido, dust nao consumido, segundo item nao consumido, item ganha 2 Tiers, etc.

TRANSFERENCIA (TRANSFER):
- Transfere Tier de um item para outro da mesma classe (classe 1 a 4, baseada na raridade do item).
- Requisitos: 100 Dust + 1 Exalted Core + Gold + 1 item Tier 0 que vai receber + 1 item Tier 2+ que vai ser consumido.
- Sucesso sempre 100%, mas perde 1 Tier na transferencia (ex: Tier 5 vira Tier 4 no item destino).
- Itens classe 1 nao podem ir alem de Tier 1.
- Transferencia pode ser entre tipos diferentes dentro da mesma classe (ex: Cobra Club -> Falcon Plate).

EFEITOS POR TIER:
- Armas: Onslaught -> chance de causar dano extra critico cumulativo
- Armaduras: Ruse -> chance de suavizar dano recebido, similar a Dodge mas contra qualquer criatura
- Capacetes: Momentum -> reduz cooldown de magias do grupo secundario em 2 segundos, permitindo usar 2 magias de ataque seguidas (ex: Exevo Tera Hur + Exevo Tera Hur para Druid)

DICAS:
- Comece upando itens que voce usa por muito tempo no mid/late game.
- Para itens raros ou de quest dificeis de repor, use Transferencia em vez de Fusao, e mais seguro.
- Remova imbuements antes de usar forja, senao nao entra.
- Use magia exiva moe res (Find Fiend) para achar Fiendish e farmar Slivers rapido.

CUSTOS ALTOS:
- Sistema e caro, so vale para level alto.
- Ex: Sanguine Legs Tier 4 pode custar 1.5kkk se feito via fusao.
]]

wikiData["Houses"] = [[
== HOUSES ==

O QUE E:
Sistema de casas para voce ter seu proprio espaco, guardar itens, treinar com privacidade, e mostrar status.

COMO ALUGAR:
- Use !buyhouse para ver casas disponiveis.
- Va ate a casa, de look na porta e veja preco e tamanho.
- De use na porta e confirme compra se tiver gold no banco suficiente.
- Aluguel e pago mensalmente ou semanalmente dependendo da configuracao.

COMANDOS:
!buyhouse -> lista casas livres e precos
!leavehouse -> abandona casa atual (perde itens dentro se nao tirar)
!house -> informacoes da sua casa: nome, aluguel, tempo restante
!house guest list -> lista quem pode entrar
!house guest add, <nome> -> adiciona convidado
!house guest remove, <nome> -> remove convidado
!house door list -> lista portas
!house door buy -> compra porta extra (se permitido)

FUNCOES NA CASA:
- !trainer -> se voce tem casa, pode usar para ir para ilha de treino privada. Treino com 20% menos rate que treino com Orc Healer publico, mas com total privacidade e sem ser atrapalhado.
- Depositar itens no chao, guardar em containers.
- Botar cama para deslogar com bonus de regiao (recovery zone).
- Usar comando de invite de party dentro da casa.

REGRAS:
- Voce precisa ser premium para ter casa.
- Se nao pagar aluguel a tempo, perde a casa e itens vao para depot com taxa.
- Nao pode ter mais de 1 casa por conta, mas pode ter casas em chars diferentes se usar contas diferentes? Verifique regra atual.
- Casas sao leiloadas as vezes em eventos.

DICAS:
- Compre casa perto de DP ou barco para facilitar acesso.
- Use casa para treinar afk com seguranca com !trainer.
- Organize loot raro em containers trancados dentro da casa.
- Bote protecao de acesso para evitar roubo de amigos falsos.

TIPOS DE CASAS:
- Flats (pequenas), casas medias, guildhalls (grandes).
- Guildhalls exigem guild level minimo e mais gold.
]]

wikiData["Infusion Attributes"] = [[
== INFUSION ATTRIBUTES ==

O QUE E:
Sistema que permite adicionar atributos extras em itens, alem dos imbuements normais.
Voce pode infundir poderes elementais, de skills, de protecao, etc.

COMO FUNCIONA:
- Procure NPC de Infusion ou maquina de Infusion (geralmente perto da Forge).
- Precisa de itens base + pedras de atributo + gold + talvez pontos de infusao.
- Cada item tem slots de atributo, parecido com imbuement mas permanente.

TIPOS DE ATRIBUTOS:
- Fire, Ice, Energy, Earth, Death, Holy protection -> aumenta protecao contra elemento
- Mana Leech, Life Leech -> similar a imbuement mas pode stackar
- Critical Extra -> chance extra de critico
- Magic Level, Melee Skills, Distance -> bonus direto de skill
- Speed, Capacity -> bonus de utilidade

NIVEIS:
- Cada atributo tem tier de 1 a 5. Quanto maior tier, maior bonus e maior custo.
- Tier 1: bonus pequeno, barato
- Tier 5: bonus alto, muito caro e risco de falha

COMANDOS:
!infusion -> abre janela de infusion
!infusion list -> lista atributos disponiveis para item na mao
!infusion add, <atributo> <tier> -> tenta adicionar
!infusion remove, <slot> -> remove atributo (perde materiais)

RISCOS:
- Falha pode destruir pedra ou diminuir tier do item.
- Use protecao de falha comprada na Shop para aumentar chance.

DICAS:
- Infunda apenas itens que vai usar por longo tempo.
- Comece com atributos baratos Tier 1 para testar.
- Combine Infusion com Imbuement e Forge para item extremamente forte.
- Foque em protecao elemental para hunt especifica (ex: fire protection para dragons).
]]

wikiData["Instanced hunts"] = [[
== INSTANCED HUNTS ==

O QUE E:
Hunts privadas instanciadas so para voce ou sua party. Ninguem te atrapalha, sem KS, sem disputa de respawn.

COMO ENTRAR:
- Fale com NPC de Instanced Hunts (geralmente no templo ou adventurer guild).
- Escolha a hunt desejada entre lista: Dragons, Hydras, Demons, etc.
- Pague taxa em gold, pontos ou precisa de item de acesso (hunt ticket).
- Sera teleportado para instancia privada que dura tempo limitado (ex: 1 hora).

TIPOS DE INSTANCIAS:
- Solo: so voce entra, balanceado para 1 player.
- Party: de 2 a 4 players, monstros mais fortes e mais loot.
- Hard Mode: monsters com mais HP e dano, mas loot melhor e chance maior de raros.

REGRAS:
- Instancia some apos tempo ou se todos sairem/morrerem.
- Se morrer dentro, pode voltar via comando !instance return se ainda dentro do tempo.
- Loot e exp normais, mas sem competicao.
- Algumas instancias tem cooldown de 20 horas para evitar farm infinito.

COMANDOS:
!instance -> abre menu de instancias
!instance list -> lista suas instancias ativas e tempo restante
!instance leave -> sai da instancia atual
!instance invite, <nome> -> convida amigo para sua instancia

BENEFICIOS:
- Perfeito para fazer bestiary sem KS.
- Otimo para fazer tasks do Grizzly em paz.
- Bom para testar dano e loot sem interferencia.

DICAS:
- Use instancia para completar bestiario de monstro disputado como Behemoths, Demons.
- Leve supplies suficientes, pois nao tera NPC dentro.
- Junte party para pagar taxa dividida e aumentar eficiencia.
]]

wikiData["Items"] = [[
== ITEMS - GAME ITEMS ==

O QUE E:
Lista de itens customizados e modificados do CalabresOT, alem dos itens normais do Tibia 8.0.

CATEGORIAS:
- Equipamentos: armaduras, capacetes, armas, escudos, pernas, botas com atributos melhores que original.
- Itens de upgrade: Dust, Slivers, Exalted Cores, pedras de infusion, gemas.
- Consumiveis: potions custom com mais cura, runas com dano maior, comidas que dao bonus.
- Itens de quest: chaves, documentos, itens raros para quests custom.
- Decoracao: itens para decorar casa com efeitos.
- Montarias e Addons: itens para liberar montaria ou addon.

COMO VER:
- !items -> abre market de itens custom (se habilitado)
- !iteminfo, <nome> -> mostra atributos do item
- Site: secao Game Items ou Wiki Items lista todos com stats.

ITENS IMPORTANTES:
- Premium Scroll: da premium account ao usar.
- Exp Scroll: da bonus de exp temporario.
- Training Ticket: permite treinar offline por tempo.
- Vocation Change Book: troca de vocacao.
- BagLoot Upgrade Token: aumenta nivel do BagLoot.

DICAS:
- Sempre de look nos itens dropados, muitos customs tem look com atributos.
- Compare com itens normais, as vezes um item level 50 custom e melhor que item level 100 normal.
- Guarde itens de upgrade, valem muito no market.
- Venda itens customs que nao usa no Market para outros players.

TRADE:
- Use Market do site ou Market in-game para vender.
- Cuidado com golpes, sempre confira valor.

CUSTOMIZACAO:
- Voce pode usar Forge para Tier, Imbuement para leech/critico, Infusion para atributos extras no mesmo item.
]]

wikiData["Mana/Life Leech"] = [[
== MANA / LIFE LEECH ==

O QUE E:
Sistema de roubo de vida e mana baseado em imbuements ou atributos de itens.
Permite recuperar HP e Mana ao dar dano em monstros.

COMO FUNCIONA:
- Imbuement de Life Leech: % do dano causado vira cura de vida.
- Imbuement de Mana Leech: % do dano causado vira recuperacao de mana.
- Funciona melhor com dano alto e em area.

ONDE FAZER IMBUE:
- Va ate NPC de Imbuement ou maquina no templo.
- Precisa de itens de criatura (ex: Vampire Teeth, Rope Belts, etc) + gold.
- Cada imbuement tem 3 niveis: Basic, Intricate, Powerful. Quanto maior nivel, maior porcentagem de leech.

VALORES DE REFERENCIA (pode variar no servidor):
- Basic Life Leech: 5% do dano vira HP
- Intricate: 15%
- Powerful: 25% a 35%
- Basic Mana Leech: 3% vira mana
- Powerful: 15%+
- Dura 20 horas de uso em combate.

COMANDOS:
!imbue -> abre janela de imbuement
!imbue list -> lista imbuements possiveis no item da mao
!imbue info, <slot> -> mostra tempo restante

COMBINACAO:
- Combine Life + Mana Leech + Critical para hunt sustentavel sem precisar de muita potion.
- Knights usam muito Life Leech para nao precisar de healer.
- Mages usam Mana Leech para gastar menos runas de mana.

DICAS:
- Imbua arma principal, nao arma secundaria.
- Leve gold suficiente, imbuement Powerful custa caro.
- Para profitar, use leech em hunts com muitos monstros em area.

ALTERNATIVA:
- Infusion Attributes tambem pode dar leech permanente sem tempo de duracao, mas mais caro.
]]

wikiData["MC & Bot"] = [[
== MC & BOT - REGRAS ==

O QUE E:
Regras sobre uso de multi-client (MC) e bot / programas ilegais.

MC (MULTI CLIENT):
- O servidor permite MC, mas com limite.
- Limite padrao: 4 personagens por IP (pode variar).
- Sistema de bonus: para cada char online alem do primeiro, voce ganha 7.5% de exp extra e 5% de skill extra, ativado com 2 ou mais chars e limite de 4 por IP.
- Nao abuse de MC para travar respawn ou atrapalhar outros players.

BOT E PROGRAMAS ILEGAIS:
- Uso de bot para cacar automatico E PROIBIDO e da ban permanente.
- O sistema de anti-bot detecta movimentos repetitivos, tempo online excessivo, etc.
- Programas permitidos: cliente oficial, OTC permitido pelo servidor, com funcoes de Auto Loot, Light, etc mas sem auto-target ou auto-cavebot.
- Qualquer programa que jogue por voce e proibido.

PUNICOES:
- 1a vez bot: ban 7 dias
- 2a vez: ban 30 dias
- 3a vez: ban permanente
- MC abusivo para dominar boss: advertencia e depois ban

COMO DENUNCIAR:
- Use !report, <nome>, <motivo> ou abra ticket no site/discord.
- Grave video se possivel.

DICAS PARA NAO SER CONFUNDIDO COM BOT:
- Responda no chat quando alguem falar com voce.
- Varie rota de hunt.
- Nao fique 12h+ sem parar no mesmo respawn sem pausa.

JOGUE LIMPO:
- Servidor quer competicao justa.
- Use sistemas legais como Auto Loot, BagLoot, Instanced Hunts para facilitar sem precisar de bot.
]]

wikiData["Minimap"] = [[
== MINIMAP ==

O QUE E:
Mapa completo do jogo ja explorado, para voce nao precisar andar tudo de novo.
No CalabresOT voce pode baixar minimap full.

COMO BAIXAR:
- No site, secao Downloads -> Minimap Full.
- Ou comando in-game: !download minimap (se disponivel)
- Extraia arquivo .otmm para pasta do cliente ou para %appdata%/OTCv8/ minimap.

O QUE INCLUI:
- Todo mapa de Tibia 8.0 explorado, incluindo cavernas, quests, cidades.
- Spawns custom do servidor ja marcados.
- Cidades novas e areas custom.

COMANDOS:
!minimap -> abre minimap maior
!minimap mark, <nome> -> adiciona marcador personalizado no mapa
!minimap clear -> limpa marcadores

DICAS:
- Marque locais importantes: entrada de quest, boss, local de task.
- Use minimap para achar NPCs com !findnpc.
- Minimap full facilita muito para iniciantes que nao conhecem mapa 8.0.

ATUALIZACAO:
- Quando servidor adiciona novas areas custom, baixe novo minimap.
- Sempre faca backup do seu minimap atual antes de substituir.

COMPATIBILIDADE:
- Funciona tanto no client oficial quanto OTCv8.
- Se minimap nao aparecer, verifique se colocou na pasta correta e reiniciou client.
]]

wikiData["Monsters"] = [[
== MONSTERS ==

O QUE E:
Lista de monstros do servidor, incluindo monstros normais do 8.0 e customs exclusivos do CalabresOT.

COMO VER INFORMACOES:
- !monster, <nome> ou !bestiary, <nome> -> mostra HP, exp, loot, fraquezas
- Janela Bestiary in-game -> mostra progresso de kills
- Site -> secao Monsters ou Wiki -> Monsters lista completa

CATEGORIAS:
- Comuns: rotworm, orc, minotaur, dragon, cyclops, etc
- Medios: hydra, behemoth, demon skeleton, giant spider, etc
- Fortes: demon, frost dragon, hydra, warlock, etc
- Bosses: Orshabaal, Ferumbras, Morgaroth, custom bosses do servidor
- Influenced: monstros com aura brilhante, mais fortes, dropam Dust para Forge. Forca de 1 a 5 stacks.
- Fiendish: versao super forte de monstro normal, equivalente a 15 stacks de Influenced, dropam Slivers. Ache com exiva moe res.

LOOT:
- Use comando !lootinfo, <nome do monstro> para ver loot possivel e chance.
- Loot vai para Auto Loot ou BagLoot automaticamente se configurado.
- Gold vai direto para banco.

DICAS:
- Use Bestiary para saber onde cada monstro nasce mais.
- Para Forge, foque em matar Influenced e Fiendish.
- Para tasks, fale com Grizzly Adams, ele manda matar monstros especificos com recompensa boa.

CUSTOM MONSTERS:
- CalabresOT tem monsters exclusivos com mecanicas diferentes, como Monsters Demoniacs, Soul Bosses, etc.
- Sempre de look no monstro para ver se tem informacao extra.
]]

wikiData["Monsters Demoniacs"] = [[
== MONSTERS DEMONIACS ==

O QUE E:
Versao demoniaca e mais forte de monstros normais, exclusiva do CalabresOT.
Sao como mini-bosses que aparecem aleatoriamente ou em areas especificas.

CARACTERISTICAS:
- HP 5x a 10x mais que monstro normal
- Dano muito maior, pode matar facil se nao tiver cuidado
- Tem aura vermelha ou preta, e nome com prefixo Demoniac (ex: Demoniac Dragon, Demoniac Demon)
- Drop muito melhor: chance maior de itens raros, gold extra, Dust e Slivers
- Da mais experiencia: 3x a 5x mais exp que normal
- Conta para Bestiary mas com peso maior (1 kill de demoniac pode contar como 5 normais)

ONDE APARECEM:
- Em respawns de nivel medio a alto, com pequena chance de spawnar no lugar de monstro normal.
- Em eventos de invasao demoniaca anunciados no chat global.
- Em areas especiais: Demoniac Lair, Forgotten Lands, etc.
- Comando !demonics -> mostra se tem invasao ativa e local

RECOMPENSAS:
- Loot raro: Demon Armor, Magic Plate Armor, itens de imbuement em quantidade
- Itens de quest demoniaca para trocar com NPC
- Pontos para ranking demoniac
- Chance de dropar Demoniac Essence para craft

COMANDOS:
!demonics -> lista demoniacs vivos no mapa (se tiver premium)
!demoniacpoints -> ve seus pontos

DICAS:
- Nao enfrente sozinho se for level baixo, chame party.
- Use protecao elemental adequada (fire protection para Demoniac Dragons, etc)
- Se ver mensagem "A Demoniac Dragon has spawned in...", va rapido, morre rapido e dropa bem.
- Guarde Demoniac Essence, vale muito.

ESTRATEGIA:
- Knights: use exeta res para puxar e tankar
- Paladins: kiting com mas san
- Mages: use wave e UE com cuidado, tem muita vida
]]

wikiData["Non-PvP"] = [[
== NON-PVP ==

O QUE E:
Sistema de protecao contra PvP para jogadores que nao gostam de ser atacados por outros players.

REGRAS GERAIS DO SERVIDOR:
- CalabresOT e majoritariamente Non-PvP, mas tem areas PvP opcionais.
- Protecao ate level 40: voce nao pode ser atacado por outros players ate level 40 e nem atacar.
- Apos level 40, PvP so e permitido em areas especificas ou se voce ativar modo PvP ou entrar em guild war.
- Bless gratis ate level 60 para ajudar iniciantes.

AREAS NON-PVP:
- Todas as cidades e templos sao 100% Non-PvP, sem dano de player.
- Areas de hunt principais como dragons, cyclopolis, etc sao Non-PvP por padrao para evitar KS com dano.
- Areas PvP sao marcadas com aviso ao entrar: "Voce entrou em zona PvP, cuidado!"

AREAS PVP OPCIONAIS:
- Battlefield (Beta): arena PvP com recompensas.
- Guild Wars: quando duas guilds estao em guerra, membros podem se atacar em qualquer lugar.
- Rookie Battle: evento PvP para low levels com regras especiais.
- War Zone: zona especifica no mapa para PvP liberado.

COMANDOS:
!pvp -> mostra seu modo PvP atual e permite ativar/desativar (se disponivel)
!protection -> mostra nivel de protecao restante (ate level 40)
!bless -> verifica bless

SKULL SYSTEM:
- Mesmo em area Non-PvP, se voce atacar alguem que esta com PvP ativo, pode pegar skull.
- Skull branco, vermelho, black depende de quantos frags.

DICAS:
- Aproveite protecao ate 40 para upar tranquilo sem medo de PK.
- Se nao gosta de PvP, evite entrar em Battlefield ou War Zone.
- Use bless sempre, mesmo gratis ate 60, depois compre para nao perder level e itens.

VANTAGENS NON-PVP:
- Foco total em PvE, quests, tasks, bestiary, sem stress de morrer para player.
- Melhor para quem joga mais casual ou quer upar tranquilo.
]]

wikiData["Online Points"] = [[
== ONLINE POINTS ==

O QUE E:
Sistema que recompensa voce por ficar online, mesmo afk, e por deixar varios chars online.

SISTEMA 1 - PONTOS POR TEMPO ONLINE:
- Voce ganha 1 ponto a cada 15 minutos online.
- Pontos podem ser trocados por diversos itens na loja de pontos: Premium Scroll, Addons, Montarias, Itens de Imbuement, Gold, Exp Boost, etc.
- Comando !onlinepoints ou !points para ver saldo.
- NPC de troca fica no templo ou via comando !shop.

SISTEMA 2 - BONUS DE EXP POR MULTIPLOS CHARS ONLINE:
- Para cada personagem extra que voce deixar online (alem do principal), voce ganha bonus:
  7.5% de exp extra por char
  5% de skill extra por char
- Bonus ativado com 2 ou mais personagens online.
- Limite de 4 personagens por IP para contar bonus.
- Exemplo: 1 char principal + 3 chars AFK no temple = 22.5% exp extra + 15% skill extra.

REGRAS:
- Precisa estar realmente online, nao conta se estiver deslogado no trainer offline.
- Sistema anti-afk: se ficar totalmente parado por muito tempo sem nenhuma acao, pode parar de contar. De um passo ou fale algo de vez em quando.
- Pontos nao sao transferiveis entre contas, mas itens comprados podem ser.

LOJA DE PONTOS - EXEMPLOS:
- Premium Scroll (30 dias) = 120 pontos
- Addon Doll = 80 pontos
- Montaria = 100 pontos
- BagLoot Upgrade Token = 15 pontos
- Gold 1kk = 10 pontos
- Exp Boost 1 hora 50% = 5 pontos

DICAS:
- Deixe chars secundarios AFK no DP enquanto caca com main para ganhar bonus.
- Junte pontos para pegar Premium de graca sem doar.
- Verifique promocoes de Double Points em finais de semana.

COMANDOS:
!onlinepoints
!points
!onlinetime -> ve tempo total online
!shop -> abre loja de pontos
]]

wikiData["Premium Account"] = [[
== PREMIUM ACCOUNT ==

O QUE E:
Conta premium que libera beneficios exclusivos e ajuda a manter servidor online.

COMO CONSEGUIR:
- Doe R$ 15,00 ou equivalente no site (15 points = premium 30 dias)
- Ou compre Premium Scroll de outros players no Market ou com Online Points.
- Use item Premium Scroll para ativar.

BENEFICIOS PREMIUM:
- Acesso a ilha de comerciantes (area com NPCs especiais, trainers melhores, etc)
- 50% a mais de exp nas 3 primeiras horas de stamina
- Protecao extra de 15% a menos de perda de exp e skills ao morrer
- Pode ter casa propria (free account nao pode)
- Desconto no custo de bless (ate 30% mais barato)
- Acesso a Auto Loot automatico (free so tem Quick Loot manual)
- Acesso a area de hunts premium com monstros melhores
- Pode usar !trainer para ilha privada
- Pode usar BagLoot com nivel mais alto e upgrades mais baratos
- Pode participar de alguns eventos exclusivos premium
- Prioridade em fila de login quando servidor lotado
- Acesso a comandos extras: !autoloot completo, !bank transfer, etc

DURACAO:
- 30 dias por scroll ou doacao.
- Pode acumular: se usar 2 scrolls de 30 dias, fica 60 dias premium.
- Verifique tempo restante com !premium ou !account.

CUSTO:
- 15 points = 30 dias (R$ 15,00)
- As vezes tem promocao: pague 3 meses e ganhe 1 mes gratis.

DICAS:
- Se nao quer doar, junte Online Points (1 ponto a cada 15 min) e troque por Premium Scroll (120 pontos).
- Premium vale muito a pena para quem joga todo dia, exp bonus faz diferenca enorme.
- Venda Premium Scrolls no Market para ganhar gold se tiver pontos sobrando.

AJUDA AO SERVIDOR:
- Ao comprar premium, voce ajuda a pagar host, desenvolvimento, anti-DDoS, etc.
- Servidor depende de doacoes para continuar online e com atualizacoes.
]]

wikiData["Promotions"] = [[
== PROMOTIONS - PROMOCOES ==

O QUE E:
Eventos de promocao que dao bonus para quem doa ou joga em periodos especificos.

TIPOS DE PROMOCAO:

1) DOUBLE POINTS DONATION:
- Ao doar, voce ganha o dobro de points.
- Ex: Doou R$ 30,00 que normalmente daria 30 points, na promocao ganha 60 points.
- Acontece em finais de semana especiais, ferias, aniversario do servidor.

2) EXTRA PREMIUM DAYS:
- Ao comprar premium, ganha dias extras.
- Ex: Compre 30 dias, ganhe 15 dias gratis = 45 dias no total.

3) DISCOUNT SHOP:
- Itens da loja de pontos com desconto de 20% a 50%.
- Ex: Addon que custa 80 pontos, na promocao custa 40.

4) DOUBLE EXP / DOUBLE LOOT / DOUBLE SKILL WEEKEND:
- Nao e promocao de doacao, mas de jogo. Todo mundo ganha 2x exp, loot, skill durante fim de semana.
- Anunciado no site, discord, e chat global.

5) BONUS ITEM ON DONATION:
- Ao doar acima de certo valor, ganha item bonus: Mount rara, Outfit raro, etc.
- Ex: Doe 100 pontos e ganhe Golden Outfit.

COMO SABER SE TEM PROMOCAO:
- Site: banner na pagina principal avisa promocao ativa.
- In-game: mensagem global quando promocao comeca.
- Discord: canal #promocoes.

COMANDOS:
!promotions -> mostra promocoes ativas se houver
!shop -> ve precos com desconto se tiver

DICAS:
- Guarde dinheiro para doar apenas em Double Points, vale muito mais a pena.
- Siga discord e instagram do servidor para nao perder promocoes.
- Promocoes de Double Exp sao otimas para upar char novo rapido.

HISTORICO:
- Promocoes acontecem geralmente todo mes, e sempre em datas comemorativas: Natal, Ano Novo, Carnaval, Aniversario do servidor.
]]

wikiData["Quests"] = [[
== QUESTS ==

O QUE E:
Missoes espalhadas pelo mapa que dao recompensas: exp, itens raros, outfits, addons, acesso a areas.

TIPOS DE QUESTS:

1) TASKS DO GRIZZLY ADAMS:
- NPC fica acima do DP de Thais.
- Tasks para todos leveis, desde level 8 ate 500+.
- Ex: Mate 100 rats, ganhe 5000 exp e 1000 gold.
- Ex: Mate 300 dragons, ganhe 50k exp e chance de rare item.
- Comando !task ou fale com NPC.
- Muito boas para iniciantes ganharem dinheiro.

2) QUESTS NORMAIS DO TIBIA 8.0:
- Annihilator, Demon Helmet, Pits of Inferno, etc.
- Recompensas classicas.

3) QUESTS CUSTOM CALABRESOT:
- The Calabrian Quest: quest principal custom do servidor com historia propia.
- Instanced Hunts Quests: complete hunts instanciadas para liberar novas.
- Soul Bosses Quest: mate Soul Bosses para ganhar soul points e trocar por itens.
- Treasure Chest Quest: ache bauss escondidos pelo mapa.

4) DAILY QUESTS:
- Quests que resetam todo dia.
- Ex: Mate 500 monstros de qualquer tipo, ganhe 10 Online Points.

COMANDOS:
!quest ou !quests -> abre janela de quests ativas e concluidas
!task -> tasks do Grizzly
!questinfo, <nome> -> info de quest especifica
!daily -> lista daily quests

DICAS:
- Sempre pegue tasks antes de ir cacar, voce ganha recompensa extra sem esforco extra.
- Quests custom geralmente tem level minimo, verifique !questinfo.
- Faca quests em party para bosses dificeis.
- Algumas quests dao acesso a areas premium ou itens que nao podem ser comprados.

RECOMPENSAS COMUNS:
- Exp grande
- Itens raros (ex: Demon Armor, Crown Legs)
- Addons e montarias
- Pontos e gold
- Acesso a novas hunts

COMECE POR:
- Tasks nivel 8-40 com Grizzly para ganhar dinheiro inicial.
- Depois Desert Quest, etc.
]]

wikiData["Rookie Battle"] = [[
== ROOKIE BATTLE ==

O QUE E:
Evento PvP seguro apenas para jogadores de level baixo (rookies), para aprender PvP sem perder muito.

COMO FUNCIONA:
- Evento acontece automaticamente em horarios marcados (ex: todo dia as 18h e 22h) ou quando staff inicia.
- So pode entrar quem esta entre level 20 e 50 (pode variar).
- Todos sao teleportados para arena especial fechada.
- Recebe supplies gratis dentro da arena: potions, runas, etc.
- PvP liberado apenas dentro da arena, sem perder level, bless, ou itens ao morrer.
- Duracao de 10 a 15 minutos, quem fizer mais frags vence.

REGRAS:
- Nao perde exp ou itens ao morrer dentro.
- Pode atacar qualquer um dentro, nao tem protecao de guild.
- Usar battle para treinar combos e runas.
- No final, ranking mostra top 3 com mais kills.
- Recompensa para top 3: exp, gold, pontos, itens.

COMANDOS:
!rookiebattle -> entra no evento se estiver acontecendo e voce tiver level permitido
!battlestats -> ve suas estatisticas em rookie battles
!battleleave -> sai da arena

BENEFICIOS:
- Aprende PvP sem risco.
- Ganha recompensas mesmo se perder.
- Conhece outros players low level para formar guild ou party.
- Se diverte sem stress de perder level.

DICAS:
- Leve hotkeys configuradas com potions e runas de ataque.
- Foque em um alvo por vez, nao tente lutar contra 5 ao mesmo tempo.
- Use paredes da arena para se curar e correr.
- Rookie Battle e otimo para testar nova vocacao em PvP antes de ir para war real.

HORARIOS:
- Verifique !events para proximos horarios.
- Geralmente 2x por dia.
]]

wikiData["Roulette"] = [[
== ROULETTE - ROLETA ==

O QUE E:
Sistema de cassino dentro do jogo onde voce aposta gold ou pontos e pode multiplicar ou perder tudo. 100% sorte.

ONDE FICA:
- Cassino no DP de Thais ou via comando !roulette que abre janela do jogo.
- NPC Dealer no subsolo do DP.

COMO JOGAR:
- Escolha quanto quer apostar: gold do banco ou points.
- Escolha tipo de aposta:
  - Cor: Vermelho ou Preto (paga 2x, chance 48%)
  - Numero exato: 0 a 36 (paga 35x, chance baixa)
  - Par ou Impar (paga 2x)
  - Alto (19-36) ou Baixo (1-18) (paga 2x)
  - Duzia: 1-12, 13-24, 25-36 (paga 3x)
  - Coluna (paga 3x)
- Role a roleta e veja resultado.

COMANDOS:
!roulette -> abre interface da roleta
!roulette bet, <tipo>, <valor> -> aposta rapido via comando
!roulette balance -> ve quanto tem para apostar
!roulette history -> ve ultimos resultados

EXEMPLO:
!roulette bet, red, 10000 -> aposta 10k no vermelho
!roulette bet, number 7, 1000 -> aposta 1k no numero 7
!roulette bet, even, 5000 -> aposta 5k no par

REGRAS:
- Aposta minima: 1000 gold ou 1 point
- Aposta maxima: 1kk gold ou 50 points por rodada (pode variar)
- Servidor tem 5% de vantagem (house edge), como cassino real.
- Nao existe metodo garantido de ganhar, e sorte.

DICAS:
- Nao aposte o que nao pode perder.
- Sistema e para diversao, nao para ganhar dinheiro.
- Pare quando estiver ganhando, nao tente recuperar tudo se perder.
- Use gold extra que sobrou de hunt, nao gold reservado para supplies.

RESPONSABILIDADE:
- Se voce tem problemas com jogo de azar, nao use o sistema.
- Staff nao devolve gold perdido na roleta.

CURIOSIDADE:
- Alguns players ja ganharam mais de 100kk na roleta apostando numero exato.
- Outros perderam tudo em sequencia de azar.
]]

wikiData["Soul Bosses"] = [[
== SOUL BOSSES ==

O QUE E:
Bosses especiais que dropam Soul Points, usados para comprar itens raros, e que aumentam sua Soul (alma) do personagem.

COMO FUNCIONA:
- Soul Bosses spawnam em areas especiais, geralmente uma vez por dia ou com cooldown de horas.
- Precisa de certo nivel de Soul para entrar em algumas areas (ex: precisa de 100 soul para entrar no Soul Sanctum).
- Ao matar Soul Boss, voce ganha Soul Points.

O QUE E SOUL:
- Soul e um atributo do char que diminui quando voce usa runas ou morre.
- Soul regenera com o tempo, treinando, ou matando Soul Bosses.
- Maximo de Soul e 200 ou 300 (depende de premium).

LISTA DE SOUL BOSSES COMUNS:
- Lady Soul: facil, 50k HP, dropa 5 Soul Points
- Soul Reaper: medio, 150k HP, dropa 15 Points
- Soul Overlord: dificil, 500k HP, dropa 40 Points, precisa party
- Soul Devourer: boss final semanal, 2M HP, dropa 100 Points e chance de item raro soul

ONDE ENCONTRAR:
- !soulbosses -> lista bosses e tempo para proximo spawn
- Teleport de Soul Area no templo (precisa soul minima)
- Alguns spawnam aleatoriamente no mapa com aviso global: "Soul Reaper has spawned near..."

RECOMPENSAS DE SOUL POINTS:
- Troque com NPC Soul Master no templo por:
  - Soul Armor, Soul Legs, itens com bonus de soul
  - Addon de Soul
  - Montaria Soul War Horse
  - Exp e gold
- Use soul para usar runas de area forte (ex: UE custa soul)

COMANDOS:
!soul -> ve sua soul atual e max
!soulpoints -> ve seus pontos acumulados
!soulbosses -> lista bosses

DICAS:
- Matem Soul Bosses em party para ser mais facil.
- Junte Soul Points para comprar itens que nao podem ser obtidos de outro jeito.
- Mantenha soul sempre alta (treine com utevo mas res que recupera soul rapido: 1 soul a cada 2 min atacando, 1 a cada 3 min offline treinando).
- Soul Bosses sao disputados, chegue cedo e chame amigos.
]]

wikiData["Spells"] = [[
== SPELLS - MAGIAS ==

O QUE E:
Lista de magias custom e normais do servidor. CalabresOT tem magias extras alem do 8.0 normal.

MAGIAS NORMAIS 8.0:
- Exura, Exura Ico, Exura Gran Ico, Utura, etc para cura
- Exori, Exori Gran, Exori Mas, etc para ataque
- Utevo Lux, Utevo Res, etc para utilidade

MAGIAS CUSTOM DO CALABRESOT:

1) UTEVO MAS RES - SUMMON TRAINER:
- Vocacao: Todas
- Level: 8
- Mana: 20
- Efeito: Summons um Orc Healer que te ataca e se cura, perfeito para treinar skills. Recupera stamina e soul mais rapido: 1 stamina a cada 2 min atacando, 1 a cada 3 min offline atacando.
- Comando: cast ou falar "utevo mas res"

2) EXIVA MOE RES - FIND FIEND:
- Vocacao: Todas
- Level: 25
- Mana: 20
- Cooldown: 2s
- Efeito: Indica direcao para Fiendish creature mais proxima para farmar Dust/Slivers da Forge. Similar ao exiva. Se tiver bestiary completo da criatura, mostra dificuldade.

3) EXIVA NPC RES - FIND NPC:
- Vocacao: Todas
- Level: 8
- Mana: 20
- Efeito: Acha NPC pelo nome. Ex: exiva npc res "Grizzly Adams"

4) EXANA MORT - DEATH RECOVER TELEPORT (se habilitado):
- Level: 30
- Efeito: Teleporta de volta para local da morte dentro de 10 min.

5) UTEVO TEMPO - SPEED BOOST TEMPORARIO:
- Da speed por 30 segundos

COMO APRENDER MAGIAS:
- Compre spellbooks no NPC de magias de cada cidade.
- Ou use comando !spells para ver lista e !learnspell, <nome>
- Algumas magias custom sao aprendidas automaticamente ao logar.

COMANDOS:
!spells -> lista todas magias que voce conhece e pode aprender
!spellinfo, <nome> -> mostra mana, level, efeito
!cooldowns -> mostra cooldowns atuais

DICAS:
- Configure hotkeys F1-F12 com magias mais usadas.
- Use utevo mas res para treinar afk sem precisar de slime ou monk.
- Use exiva moe res sempre que quiser farmar materiais da Forge rapido.
]]

wikiData["Stamina"] = [[
== STAMINA ==

O QUE E:
Sistema que controla bonus de experiencia e loot baseado no tempo que voce passa cacando.

COMO FUNCIONA:
- Stamina maxima: 42 horas (42:00)
- Stamina verde (bonus): 40:00 a 42:00 -> 50% exp extra, loot normal
- Stamina laranja (normal): 01:00 a 39:59 -> exp e loot normais
- Stamina baixa: 00:01 a 00:59 -> so 50% exp e 75% loot
- Sem stamina: 00:00 -> sem exp e apenas 25% loot

REGENERACAO:
- Para regenerar, precisa estar deslogado ou em area de protecao (DP, casa, temple) descansando.
- Offline: cada 6 horas offline recupera 1 hora de stamina verde, e cada 3 horas offline recupera 1 hora de stamina laranja.
- Treinando com utevo mas res (atacando Orc Healer): recupera 1 stamina a cada 2 minutos.
- Offline treinando (attacking anything): recupera 1 stamina a cada 3 minutos.
- Logar e deslogar muito atrasa regen em 10 minutos cada vez.

TAXAS DO CALABRESOT:
- Nas 3 primeiras horas de stamina (verde) voce ganha 50% exp extra por ser premium? Na verdade todos ganham 50% extra nas 3h de stamina, premium ganha ainda mais? Verifique.
- No CalabresOT, taxa e: 3h de stamina com 50% bonus de exp para todos, premium com mais vantagens.

COMANDOS:
!stamina -> mostra stamina atual e tempo ate proxima hora
!staminainfo -> explica sistema

DICAS:
- Tente jogar apenas nas 3 horas verdes por dia para max eficiencia. Depois disso, exp cai muito.
- Se voce joga 5 horas seguidas (3h verdes + 2h laranja), vai precisar de 18h + 6h = 24h offline para recuperar tudo.
- Use tempo verde para hunts dificeis que dao mais exp, e tempo laranja baixo para tasks faceis ou farm de gold.
- Deixe char treinando com utevo mas res enquanto faz outra coisa, recupera stamina e soul ao mesmo tempo.

RELACAO COM EXP:
- Sempre verifique stamina antes de ir hunt seria.
- Se stamina estiver abaixo de 14h, ja considera 50% exp e 75% loot, nao vale tanto a pena.
]]

wikiData["Summons"] = [[
== SUMMONS ==

O QUE E:
Sistema que permite invocar criaturas para te ajudar a cacar ou treinar.

TIPOS DE SUMMON:

1) SUMMON DE TREINO - ORC HEALER:
- Magia: utevo mas res
- Qualquer vocacao, level 8
- Summons Orc Healer que te ataca e se cura constantemente.
- Nao morre facil, perfeito para treinar shield, melee, distance.
- Recupera stamina e soul mais rapido enquanto treina com ele.

2) SUMMONS DE BATALHA - MONSTROS DE VERDADE:
- Algumas vocacoes podem summonar monstros para lutar ao seu lado (ex: Druid e Sorcerer).
- Magia: utevo res <nome do monstro> (ex: utevo res "fire elemental")
- Precisa de mana e level, e consome mana por segundo para manter summon.
- Lista de summons possiveis:
  - Level 15: Orc Warrior
  - Level 25: Fire Elemental, Monk
  - Level 35: Demon Skeleton, Fire Devil
  - Level 55: Hydra (se habilitado), etc
- Limite de 1 summon por vez, ou 2 se premium com bonus.

3) SUMMONS DE EVENTO:
- Em alguns eventos, voce pode summonar bosses temporarios para testar.

COMANDOS:
!summons -> lista summons disponiveis para sua voc e level
!summoninfo, <nome> -> info do summon
!unsummon ou utevo res ina -> remove summon atual

DICAS:
- Summons sao otimos para paladins uparem sozinhos com blocker.
- Use summon para tankar enquanto voce ataca de longe.
- Nao deixe summon morrer em area com muitos monstros, ele nao volta sozinho.
- Summons de treino (Orc Healer) sao diferentes de summons de batalha, nao confundir.

MANA COST:
- Utevo mas res custa 20 mana e dura infinito ate voce matar o Orc ou deslogar.
- Summons de batalha custam mana inicial + mana por segundo para manter. Se acabar mana, summon some.
]]

wikiData["Tasks"] = [[
== TASKS ==

O QUE E:
Sistema de missoes de matar monstros com recompensa, ideal para iniciantes e para ganhar dinheiro extra.

NPC: GRIZZLY ADAMS
- Fica logo acima do DP de Thais.
- Fala com ele: Hi -> Tasks -> ele lista tasks disponiveis para seu level.
- Tasks para todos leveis, de level 8 ate 500+.

COMO FUNCIONA:
- Pegue a task com Grizzly.
- Mate a quantidade pedida (ex: 100 trolls, 200 dragons, 50 demons).
- Volte no NPC e reporte: Hi -> Report ou !task report.
- Ganhe recompensa: exp, gold, itens, pontos de task, chance de item raro.

EXEMPLOS DE TASKS:
- Level 8-20: 100 rats, 100 trolls, 50 orcs
- Level 20-40: 150 minotaurs, 100 cyclops, 150 orcs
- Level 40-80: 200 dragons, 250 giant spiders, 300 hydras
- Level 80-150: 300 behemoths, 250 demons, 400 wyrms
- Level 150+: 500 demons, 400 hellhounds, 600 juggernauts, etc

RECOMPENSAS:
- Exp grande (as vezes mais que a propria hunt)
- Gold (ex: 5000 a 100000 por task)
- Itens: Boots of Haste, Crown Armor, etc dependendo da task
- Task Points: pontos especiais para trocar com NPC por itens raros
- Bestiary progress conta junto, entao voce upa bestiary e task ao mesmo tempo

COMANDOS:
!task -> abre janela de tasks ativas
!task list -> lista tasks disponiveis
!task report -> reporta task completa sem precisar ir no NPC (se habilitado)
!task points -> ve seus task points

DICAS:
- Sempre pegue task antes de ir cacar, e free reward.
- Foque em uma task por vez para nao confundir contagem.
- Tasks sao a melhor forma de ganhar dinheiro no inicio: level 20-40 fazendo minotaurs e cyclops da muito gold.
- Combine tasks com Instanced Hunts para fazer sem KS.

TASK POINTS SHOP:
- Com task points voce pode comprar:
  - Exp scrolls
  - Imbuement items
  - Outfits e addons
  - Montarias
]]

wikiData["Trainers"] = [[
== TRAINERS ==

O QUE E:
Sistema de treino de skills e magic level, tanto offline quanto online.

TRAINERS FIXOS - NAO EXISTEM:
- CalabresOT nao tem trainers fixos como OT normal (estatuas de treino).
- Isso e proposital para ser mais nostagico e desafiador.

METODO 1 - ORC HEALER (ONLINE):
- Magia: utevo mas res
- Disponivel para TODAS vocacoes e TODOS levels, custa 20 mana
- Summons um Orc Healer que te ataca sem parar, mas se cura muito, entao nunca morre.
- Voce ataca ele de volta para treinar melee, distance, shielding, etc.
- Vantagem: recupera stamina e soul mais rapido enquanto treina:
  - 1 stamina a cada 2 minutos atacando qualquer coisa (incluindo Healer)
  - 1 soul a cada 2 minutos
- Offline treinando: 1 stamina a cada 3 minutos, 1 soul a cada 3 minutos
- Perfeito para treinar afk enquanto assiste algo

METODO 2 - ILHA PRIVADA (!TRAINER):
- Comando: !trainer
- Requisito: Ter casa propria (premium)
- Voce e teleportado para ilha sozinho com 5 orc healers e depo trainers.
- Rate de skill 20% menor que metodo publico, mas com total privacidade e sem ser atrapalhado.
- Pode ficar la quanto tempo quiser.
- Comando !trainer leave para voltar

METODO 3 - OFFLINE TRAINER:
- Quando deslogado, voce pode selecionar offline training no menu de logout
- Escolha skill para treinar: melee, distance, magic
- Enquanto offline, voce treina lentamente, ganha skill mas nao exp
- Precisa de premium para treino offline mais eficiente
- Maximo 12 horas de offline training por vez

COMANDOS:
!trainer -> vai para ilha privada (precisa casa)
!trainers -> ve trainers online e metodos
utevo mas res -> summona trainer publico

DICAS:
- Deixe char treinando com Orc Healer durante a noite afk com cavebot de anti-kick? Mas cuidado para nao ser considerado bot, mexa de vez em quando.
- Use casa para treino privado se tem medo de PK ou KS
- Combine treino com recuperacao de stamina: treine enquanto recupera stamina verde para proxima hunt
- Skills sao 9x no servidor, entao upa relativamente rapido comparado a global.

METAS DE SKILL:
- Knight level 100: skill 90/90 bom, 100/100 muito bom
- Paladin level 100: distance 90 bom
- Mage level 100: magic 70 bom
]]

wikiData["Traveling"] = [[
== TRAVELING - VIAGENS ==

O QUE E:
Sistema de viagens entre cidades e areas do mapa.

FORMAS DE VIAJAR:

1) BARCO (SAILOR):
- NPCs de barco em cidades portuarias: Thais, Carlin, Venore, Ab'Dendriel, Edron, etc
- Fale: Hi -> Sail -> escolha destino -> Yes
- Custo varia: 10 a 200 gold dependendo da distancia
- Alguns destinos so liberam apos fazer quest ou ter level minimo

2) TAPETE MAGICO (DJINNS):
- Se voce fez Djinn Quest, pode viajar via tapete entre cidades djinn
- Fale com NPC viajante djinn

3) BROOM OU MONTARIA VOADORA (se habilitado):
- Alguns servidores tem broom que teleporta rapido

4) TELEPORT DE TEMPLO - ADVENTURER STONE:
- Item Adventurer Stone pode ser usado em qualquer templo para ir para Adventurers Guild
- De la voce pode ir para varios lugares: Forge, Instanced Hunts, Soul Area, etc
- Comando: !adventurer ou use stone

5) COMANDO !TRAVEL:
- Comando rapido para viajar se tiver premium e gold no banco
- !travel, <cidade> -> ex: !travel thais, !travel edron

6) PORTAIS E TELEPORTES FIXOS:
- Portais no templo que levam para areas de hunt populares
- Ex: Portal para Hydras, Demons, etc, as vezes precisa de level

CUSTOS:
- Viagens de barco sao baratas
- Viagens via !travel cobram taxa um pouco maior pela comodidade
- Viagens para areas premium ou instanciadas podem custar mais

DICAS:
- Sempre explore a cidade nova a pe primeiro para conhecer, depois use barco
- Tenha sempre 500 gold no banco para emergencias de viagem
- Use Adventurer Stone como hub central para ir rapido para Forge e outras areas
- Marque no minimap os NPCs de barco importantes

CIDADES PRINCIPAIS:
- Thais (central)
- Carlin
- Venore
- Ab'Dendriel
- Edron
- Darashia
- Ankrahmun
- Port Hope
- Liberty Bay
- Yalahar (se habilitado)
- E cidades custom do servidor
]]

wikiData["Treasure Chest"] = [[
== TREASURE CHEST ==

O QUE E:
Sistema de bau de tesouro diario ou semanal que da recompensas aleatorias e itens raros.

COMO FUNCIONA:

1) DAILY TREASURE CHEST:
- Todo dia voce pode abrir 1 bau de tesouro gratis
- Fica no templo ou em area de quests (geralmente perto do DP)
- Comando !treasure ou va ate o bau fisico e de use
- Recompensas: gold, exp, imbuement items, chance de item raro, online points, etc

2) TREASURE CHESTS ESPALHADOS PELO MAPA:
- Baus escondidos pelo mapa em locais dificeis de achar
- Precisa explorar cavernas, montanhas, etc
- Alguns precisam de chave que dropa de monstro especifico
- Recompensas melhores que daily

3) TREASURE MAPS:
- Dropa de monstros fortes (behemoths, demons, etc) um Treasure Map
- Use mapa para ver dica de onde esta o tesouro enterrado
- Va ate local e use shovel para desenterrar bau

RECOMPENSAS POSSIVEIS:
- Gold: 10k a 500k
- Gems: small diamonds, etc que valem muito
- Itens de imbuement: rope belts, silencer claws, etc
- Itens raros: golden armor, magic plate armor (chance muito baixa)
- Points: 1 a 10 online points
- Exp scrolls, premium scroll fragmentos

COOLDOWN:
- Daily: 20 horas entre cada abertura
- Baus de mapa: uma vez por mapa, mapa e consumido ao usar
- Baus espalhados: respawn de 1 a 7 dias

COMANDOS:
!treasure -> tenta abrir bau diario se estiver perto ou abre janela
!treasuremaps -> lista mapas que voce tem
!treasurepoints -> ve pontos de tesouro

DICAS:
- Pegue daily TODO DIA, e free e acumula muito ao longo do tempo
- Guarde treasure maps e abra varios de uma vez em grupo para dividir dicas
- Explore bem o mapa, muitos baus escondidos nunca foram achados
- Leve party para baus que ficam em area perigosa (ex: meio de demon spawn)

EVENTO:
- As vezes tem evento de Double Treasure, onde bau da dobro de recompensa.
]]

wikiData["Vocation Guide"] = [[
== VOCATION GUIDE - GUIA DE VOCACOES ==

O QUE E:
Guia rapido das 4 vocacoes principais do jogo e suas vantagens no CalabresOT.

1) SORCERER - MASTER SORCERER (MS):
- Foco: Dano magico massivo em area (UE) e single target com SD
- Vantagens: Maior dano do jogo, essencial para hunts em area e bosses, faz dinheiro com runas
- Desvantagens: Fragil, pouca vida, precisa de boa mira e mana management
- Melhor para: Players que gostam de causar dano e upar rapido em party
- Skills: Magic Level alto e crucial
- Dica: Use wand para dar dano e runas SD para burst. Treine magic sempre.

2) DRUID - ELDER DRUID (ED):
- Foco: Cura, suporte, e tambem dano de gelo e terra
- Vantagens: Pode curar amigos ( sio ), faz UH, essencial em toda party, dano bom com icicles e avalanches
- Desvantagens: Fragil como sorcerer, mas com cura propria
- Melhor para: Players que gostam de ajudar time e ser sempre chamado para hunts
- Skills: Magic Level alto, igual sorcerer
- Dica: Aprenda a curar rapido com hotkeys de sio e exura sio. Seja amigo de todo mundo.

3) PALADIN - ROYAL PALADIN (RP):
- Foco: Dano a distancia (bows e crossbows), dano sustentavel e profita muito
- Vantagens: Mais equilibrado, boa vida, dano otimo com bolts e arrows, faz muito dinheiro porque gasta pouco
- Desvantagens: Upa um pouco mais devagar no inicio, depende de municao
- Melhor para: Players que querem lucrar e jogar solo de forma segura
- Skills: Distance Fighting e Magic (para cura)
- Dica: Use mas san e exori san para area, e exevo mas san para boss. Imbua com critico e leech.

4) KNIGHT - ELITE KNIGHT (EK):
- Foco: Tank, blocker, combate corpo a corpo
- Vantagens: Muita vida, muita defesa, pode segurar muitos monstros, indispensavel para bosses e hunts dificeis
- Desvantagens: Dano menor que outras vocs no inicio, gasta mais com potions, precisa de skill alta para ser bom
- Melhor para: Players que gostam de liderar, tankar, e ser corajoso na frente
- Skills: Sword, Axe ou Club + Shielding
- Dica: Treine muito com Orc Healer. Use exeta res para puxar monstros para voce. Seja bom blocker e todo mundo vai querer voce na party.

ESCOLHENDO VOCACAO:
- Primeira vez? Va de Druid ou Paladin para aprender com mais seguranca.
- Quer dano maximo? Sorcerer.
- Quer ser tank e lider? Knight.
- Pode trocar depois com Vocation Change Book da Shop se enjoar.

RATES DO SERVIDOR:
- Magic: 5x, Skills: 9x, entao upar magic e skills e mais rapido que global.

COMANDOS:
!vocation -> info da sua vocacao
!spells -> magias da sua vocacao
]]

-- fallback para qualquer topico nao preenchido (nao deve acontecer)
local function buildFallback(topic)
  return "== " .. string.upper(topic) .. " ==\n\nInformacao sobre " .. topic .. " ainda esta sendo preparada.\nPor favor volte mais tarde ou consulte o site oficial.\n\nDICAS GERAIS:\n- Use !commands para lista de comandos\n- Consulte NPCs no jogo para mais detalhes\n- Veja site https://calabresot.com/wiki para info atualizada\n"
end

for _, title in ipairs(topicOrder) do
  if not wikiData[title] or wikiData[title]=="" then
    wikiData[title]=buildFallback(title)
  end
end

local function getChild(id)
  if not wikiWindow then return nil end
  if wikiWindow.recursiveGetChildById then
    return wikiWindow:recursiveGetChildById(id)
  else
    return wikiWindow:getChildById(id)
  end
end

function init()
  connect(g_game, {
    onGameStart = online,
    onGameEnd = offline
  })

  g_ui.importStyle('wiki')

  wikiWindow = g_ui.displayUI('wiki')
  wikiWindow:hide()

  listPanel = getChild('listPanel')
  detailPanel = getChild('detailPanel')
  detailTitle = getChild('detailTitle')
  detailText = getChild('detailText')
  topicsScrollPanel = getChild('topicsScrollPanel')
  detailScrollPanel = getChild('detailScrollPanel')
  topicsScrollBar = getChild('topicsScrollBar')
  detailScrollBar = getChild('detailScrollBar')

  populateTopics()

  if modules.client_topmenu then
    wikiButton = modules.client_topmenu.addLeftGameButton('wikiButton', tr('Wiki'), '/images/topbuttons/ciclopedia', toggle, false, 6)
  else
    scheduleEvent(function()
      if modules.client_topmenu and not wikiButton then
        wikiButton = modules.client_topmenu.addLeftGameButton('wikiButton', tr('Wiki'), '/images/topbuttons/ciclopedia', toggle, false, 6)
        if g_game.isOnline() then wikiButton:show() else wikiButton:hide() end
      end
    end, 1000)
  end

  if g_game.isOnline() then
    online()
  else
    offline()
  end
end

function terminate()
  disconnect(g_game, {
    onGameStart = online,
    onGameEnd = offline
  })

  if wikiWindow then
    wikiWindow:destroy()
    wikiWindow = nil
  end

  if wikiButton then
    wikiButton:destroy()
    wikiButton = nil
  end

  listPanel = nil
  detailPanel = nil
  detailTitle = nil
  detailText = nil
  topicsScrollPanel = nil
  detailScrollPanel = nil
end

function online()
  if wikiButton then
    wikiButton:show()
  end
end

function offline()
  hide()
  if wikiButton then
    wikiButton:hide()
  end
end

function populateTopics()
  if not topicsScrollPanel then return end
  topicsScrollPanel:destroyChildren()

  local columns = 3
  if g_app.isMobile() then
    columns = 1
  end

  local currentRow = nil
  local countInRow = 0

  for idx, title in ipairs(topicOrder) do
    if not currentRow or countInRow >= columns then
      currentRow = g_ui.createWidget('WikiRow', topicsScrollPanel)
      if currentRow then
        currentRow:setId('wikiRow_' .. math.floor((idx-1)/columns + 1))
      end
      countInRow = 0
    end

    if currentRow then
      local button = g_ui.createWidget('WikiButton', currentRow)
      if button then
        button:setText(title)
        local safeId = title:gsub("%s+", "_"):gsub("&", "and"):gsub("[^%w_]", "")
        button:setId('wikiBtn_' .. safeId)
        button:setTooltip(tr('Clique para ver informacoes sobre ') .. title)
        button.onClick = function()
          showTopic(title)
        end
        countInRow = countInRow + 1
      end
    end
  end

  if topicsScrollPanel.updateScrollBars then
    scheduleEvent(function()
      if topicsScrollPanel and topicsScrollPanel.updateScrollBars then
        topicsScrollPanel:updateScrollBars()
      end
      if topicsScrollBar then
        topicsScrollBar:setValue(0)
      end
    end, 50)
  end
end

function showTopic(topicName)
  if not wikiWindow or not detailTitle or not detailText then return end

  local text = wikiData[topicName]
  if not text or text == "" then
    text = "Informacao sobre " .. topicName .. " nao encontrada."
  end

  detailTitle:setText(topicName)
  detailText:setText(text)

  if detailScrollBar then
    detailScrollBar:setValue(0)
  end
  if detailScrollPanel then
    addEvent(function()
      if detailScrollBar then
        detailScrollBar:setValue(0)
      end
      if detailScrollPanel then
        detailScrollPanel:updateScrollBars()
      end
    end, 50)
  end

  if listPanel then listPanel:hide() end
  if detailPanel then detailPanel:show() end

  if not wikiWindow:isVisible() then
    wikiWindow:show()
    wikiWindow:raise()
    wikiWindow:focus()
  end
end

function showList()
  if not wikiWindow then return end
  if detailPanel then detailPanel:hide() end
  if listPanel then listPanel:show() end
  if topicsScrollBar then
    topicsScrollBar:setValue(0)
  end
end

function hide()
  if wikiWindow then
    wikiWindow:hide()
    showList()
  end
end

function show()
  if wikiWindow then
    showList()
    wikiWindow:show()
    wikiWindow:raise()
    wikiWindow:focus()
  end
end

function toggle()
  if wikiWindow and wikiWindow:isVisible() then
    hide()
  else
    show()
  end
end

function backOrClose()
  if not wikiWindow or not wikiWindow:isVisible() then return end
  if detailPanel and detailPanel:isVisible() then
    showList()
  else
    hide()
  end
end

function addCustomTopic(title, content)
  if not title then return end
  for _, t in ipairs(topicOrder) do
    if t == title then
      wikiData[title] = content
      if detailTitle and detailTitle:getText() == title then
        detailText:setText(wikiData[title])
      end
      return
    end
  end
  table.insert(topicOrder, title)
  wikiData[title] = content
  populateTopics()
end

function setTopicContent(title, content)
  wikiData[title] = content
  if detailTitle and detailTitle:getText() == title and detailText then
    detailText:setText(content)
  end
end

function getTopicContent(title)
  return wikiData[title]
end
