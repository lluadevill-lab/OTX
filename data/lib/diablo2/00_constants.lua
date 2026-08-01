-- D2 Constants - derived from d2api.netlify.app and diablowiki.net
-- Storage base to avoid collisions: use 80000+
D2C = D2C or {}
D2C.STORAGE_BASE = 80000
D2C.STORAGES = {
  STR=80000, DEX=80001, VIT=80002, ENE=80003,
  LVL=80004, XP=80005, SKILL_POINTS=80006, ATTR_POINTS=80007,
  FCR=80008, FHR=80009, IAS=80010, FBR=80011,
  FRW=80012, MF=80013, GF=80014,
  STAMINA_CUR=80015, STAMINA_MAX=80016, RUNNING=80017,
  DIFF=80018, PLAYERS=80019,
  BLOCK_BONUS=80020, DEFENSE=80021,
  LIFE_LEECH=80022, MANA_LEECH=80023,
  CB=80024, DS=80025, OW=80026, KB=80027, CTC=80028,
  PLR=80029, CANNOT_FREEZE=80030, CANNOT_BE_FROZEN=80030,
  WEAPON_SET=80031, GOLD_LOSS=80032,
  CORPSE_COUNT=80033, CURSE_ACTIVE=80034,
  CHARM_SLOTS=80035,
  MERC_TYPE=80036, MERC_LVL=80037,
  ANNIHILUS=80038, TORCH=80039, GHEEDS=80040,
  SOJ_SOLD=80041, UBER_DIABLO_SPAWN=80042,
  LAST_KEY_DROP=80043,
}

D2C.DIFFICULTY = {NORMAL=0, NIGHTMARE=1, HELL=2}
D2C.DIFF_NAMES = {[0]="Normal",[1]="Pesadelo",[2]="Inferno"}
D2C.RES_PENALTY = {[0]=0,[1]=-40,[2]=-100}
D2C.XP_LOSS_ON_DEATH = {[0]=0,[1]=0.05,[2]=0.10}
D2C.VENDOR_CAP = {[0]=5000,[1]=35000,[2]=35000} -- scaled per act, max 35k

D2C.ATTRIBUTES = {"Força","Destreza","Vitalidade","Energia"}
-- Class base stats according to diablowiki.net charstats.json
D2C.CLASS_BASE = {
  Amazon     = {str=20, dex=25, vit=20, ene=15, lifePerVit=2, manaPerEne=1.5, staminaPerVit=1, lifePerLvl=2, manaPerLvl=1.5},
  Assassin   = {str=20, dex=20, vit=20, ene=25, lifePerVit=2, manaPerEne=1.75, staminaPerVit=1.25, lifePerLvl=2, manaPerLvl=1.5},
  Barbarian  = {str=30, dex=20, vit=25, ene=10, lifePerVit=4, manaPerEne=1, staminaPerVit=1, lifePerLvl=2, manaPerLvl=1},
  Druid      = {str=15, dex=20, vit=25, ene=20, lifePerVit=2, manaPerEne=2, staminaPerVit=1, lifePerLvl=2, manaPerLvl=2},
  Necromancer= {str=15, dex=25, vit=15, ene=25, lifePerVit=1.5, manaPerEne=2, staminaPerVit=1, lifePerLvl=1.5, manaPerLvl=2},
  Paladin    = {str=25, dex=20, vit=25, ene=15, lifePerVit=3, manaPerEne=1.5, staminaPerVit=1, lifePerLvl=2, manaPerLvl=1.5},
  Sorceress  = {str=10, dex=25, vit=10, ene=35, lifePerVit=1.5, manaPerEne=2, staminaPerVit=1, lifePerLvl=1.5, manaPerLvl=2},
}
D2C.CLASSES = {"Amazon","Assassin","Barbarian","Druid","Necromancer","Paladin","Sorceress"}

-- Weapon Range hidden 1-5 sub-squares
D2C.WEAPON_RANGE = {
  dagger=1, claw=1, short_sword=1, scimitar=1,
  long_sword=2, war_axe=2, mace=2, scepter=2,
  claymore=3, great_axe=3, halberd=3, spear=3, polearm=4, pike=5,
  sorc_staff=2, druid_staff=2,
}
-- Ethereal: 50% more base damage/def, -10 req, can't be repaired
D2C.ETHEREAL_BONUS = 0.5
D2C.ETHEREAL_REQ_REDUCTION = 10

-- Frame data: game 25 FPS
D2C.FPS = 25

-- Difficulty scaling per players
function D2C.playersScaling(players, baseHP, baseXP, baseNoDrop)
  players = math.max(1, math.min(8, players or 1))
  local hp = baseHP * (1 + (players-1)*1.0) -- +100% per player
  local xp = baseXP * (players * 0.5) -- bonus xp
  local nodrop = math.max(0, baseNoDrop - (players-1)*10) -- reduced nodrop
  return hp, xp, nodrop
end
