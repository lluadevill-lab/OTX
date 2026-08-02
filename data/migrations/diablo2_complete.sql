-- Diablo II Complete Migration
-- Adds all needed columns and tables for full mechanics

-- Ensure base tables exist (players)
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_class VARCHAR(20) NOT NULL DEFAULT 'Barbarian';
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_difficulty TINYINT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_strength INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_dexterity INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_vitality INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_energy INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_skill_points INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_attr_points INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_weapon_set TINYINT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_mf INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_gf INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_fcr INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_fhr INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_ias INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_fbr INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_cb INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_ds INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_ow INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_kb TINYINT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_cannot_freeze TINYINT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_plr INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_stamina_cur INT NOT NULL DEFAULT 100;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_stamina_max INT NOT NULL DEFAULT 100;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_running TINYINT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_players TINYINT NOT NULL DEFAULT 1;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_merc_type TINYINT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_merc_level INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_soj_sold INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_gheed INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_torch INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN IF NOT EXISTS d2_annihilus INT NOT NULL DEFAULT 0;

-- Account stash separation personal vs shared
CREATE TABLE IF NOT EXISTS d2_account_stash (
  account_id INT NOT NULL,
  tab TINYINT NOT NULL,
  slot INT NOT NULL,
  item_id INT NOT NULL,
  count INT NOT NULL DEFAULT 1,
  attributes TEXT,
  is_shared TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY(account_id,tab,slot)
);

-- Runewords catalog 90+
CREATE TABLE IF NOT EXISTS d2_runewords (
  name VARCHAR(64) PRIMARY KEY,
  runes VARCHAR(128) NOT NULL,
  item_types VARCHAR(128) NOT NULL,
  sockets TINYINT NOT NULL,
  required_level INT NOT NULL,
  mods TEXT NOT NULL
);
INSERT IGNORE INTO d2_runewords VALUES
('Spirit','Tal,Thul,Ort,Amn','sword,shield',4,25,'+2 Skills, 25-35 FCR, 55 FHR, Cold/Light/Poison 35%'),
('Insight','Ral,Tir,Tal,Sol','polearm,staff,bow',4,27,'Lvl12-17 Meditation Aura, 35 FCR, 200-260 ED'),
('Stealth','Tal,Eth','armor',2,25,'25 FCR, 25 FRW/FHR, 6 Dex, 30 Poison Res'),
('Lore','Ort,Sol','helm',2,27,'+1 Skills, 10 Energy, 30 Light Res'),
('Enigma','Jah,Ith,Ber','armor',3,65,'+1 Teleport, +2 Skills, 45 FRW, Str'),
('Infinity','Ber,Mal,Ber,Ist','polearm',4,63,'Lvl12 Conviction Aura, -45-55 Enemy Light Res, 40 CB'),
('Grief','Eth,Tir,Lo,Mal,Ral','sword,axe',5,59,'35% CTC Lvl15 Venom, 30-40 IAS, +340-400 Damage'),
('Fortitude','El,Sol,Dol,Lo','armor,weapon',4,59,'300% ED, All Res 25-30'),
('Chains of Honor','Dol,Um,Ber,Ist','armor',4,63,'+2 Skills, 200% ED Demons, +65 All Res, 8 DR, 25 MF'),
('Call to Arms','Amn,Ral,Mal,Ist,Ohm','weapon',5,57,'+1 Skills, 40 IAS, BO/BC'),
('Heart of the Oak','Ko,Vex,Pul,Thul','staff,mace',4,55,'+3 Skills, 40 FCR'),
('Last Wish','Jah,Mal,Jah,Sur,Jah,Ber','sword,hammer,axe',6,65,'6% CTC Fade, 10% CTC Life Tap, Lvl17 Might, 60-70 CB');

-- Treasure Classes
CREATE TABLE IF NOT EXISTS d2_treasure_classes (
  name VARCHAR(64) PRIMARY KEY,
  drops TEXT NOT NULL,
  area_level INT NOT NULL,
  can_drop_runes TINYINT NOT NULL DEFAULT 0
);
INSERT IGNORE INTO d2_treasure_classes VALUES
('Act 1 Equip A','weap3,armo3,Act 1 Junk,Gold',1,0),
('Act 5 (H) Equip B','weap90,armo90,Act 5 (H) Good,Gold',85,1),
('Andariel','Andariel (H),Gold',12,1),
('Mephisto','Mephisto (H),Gold',26,1),
('Diablo','Diablo (H),Gold',40,1),
('Baal','Baal (H),Gold',60,1);

-- Prefixes/Suffixes
CREATE TABLE IF NOT EXISTS d2_affixes (
  name VARCHAR(64) PRIMARY KEY,
  type ENUM('prefix','suffix') NOT NULL,
  mod TEXT NOT NULL,
  alvl INT NOT NULL,
  ilvl INT NOT NULL,
  group_name VARCHAR(32)
);
INSERT IGNORE INTO d2_affixes VALUES
('Bronze','prefix','+20% Enhanced Damage',1,1,'damage'),
('Ruby','prefix','Fire Resist +20%',8,8,'res'),
('Shimmering','prefix','All Res +10%',25,25,'res'),
('of Strength','suffix','+10 Strength',1,1,'attr'),
('of the Titan','suffix','+20 Strength +30 Life',45,45,'attr'),
('of Excellence','suffix','+2 All Skills',60,60,'skills');

-- Gems 5 levels
CREATE TABLE IF NOT EXISTS d2_gems (
  type VARCHAR(32) NOT NULL,
  level_name VARCHAR(32) NOT NULL,
  weapon_mod VARCHAR(64),
  shield_mod VARCHAR(64),
  helm_armor_mod VARCHAR(64),
  PRIMARY KEY(type,level_name)
);
INSERT IGNORE INTO d2_gems VALUES
('Amethyst','Chipped','+ATK rating','+Defense','+Strength'),
('Amethyst','Perfect','+150 AR','+30 Defense','+15 Strength'),
('Topaz','Perfect','1-40 Light Damage','40% Light Res','40% MF'),
('Ruby','Perfect','20-30 Fire Damage','38% Fire Res','+38 Life');

-- Charms
CREATE TABLE IF NOT EXISTS d2_charms (
  name VARCHAR(64) PRIMARY KEY,
  size ENUM('small','medium','large','unique') NOT NULL,
  slots INT NOT NULL,
  mods TEXT NOT NULL,
  is_unique TINYINT NOT NULL DEFAULT 0,
  limit_per_char INT NOT NULL DEFAULT 99
);
INSERT IGNORE INTO d2_charms VALUES
('Small Charm','small',1,'+5 All Res, 7 MF',0,40),
('Large Charm','medium',2,'+35 Life',0,20),
('Grand Charm','large',3,'+1 Amazon Skills',0,10),
('Gheed\'s Fortune','unique',3,'80-160 GF, 20-40 MF',1,1),
('Hellfire Torch','unique',2,'+3 Random Class Skills, All Res 10-20',1,1),
('Annihilus','unique',1,'+1 All Skills, All Attr 10-20',1,1);

-- Keys and Uber events
CREATE TABLE IF NOT EXISTS d2_keys (
  name VARCHAR(32) PRIMARY KEY,
  boss VARCHAR(32) NOT NULL,
  act INT NOT NULL,
  drop_rate FLOAT NOT NULL
);
INSERT IGNORE INTO d2_keys VALUES
('Key of Terror','The Countess',1,0.1),
('Key of Hate','The Summoner',2,0.1),
('Key of Destruction','Nihlathak',5,0.1);

-- Global SoJ counter for Uber Diablo
CREATE TABLE IF NOT EXISTS d2_global_events (
  event_name VARCHAR(64) PRIMARY KEY,
  counter INT NOT NULL DEFAULT 0,
  active TINYINT NOT NULL DEFAULT 0
);
INSERT IGNORE INTO d2_global_events VALUES
('Uber Diablo SoJ',0,0),
('Pandemonium Open',0,0);

-- Corpses
CREATE TABLE IF NOT EXISTS d2_corpses (
  id VARCHAR(64) PRIMARY KEY,
  monster_name VARCHAR(64) NOT NULL,
  pos_x INT NOT NULL,
  pos_y INT NOT NULL,
  pos_z INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  consumed TINYINT NOT NULL DEFAULT 0,
  consumed_by VARCHAR(32),
  reason VARCHAR(32)
);

-- Stamina tick log optional
CREATE TABLE IF NOT EXISTS d2_stamina_log (
  player_id INT NOT NULL,
  cur INT NOT NULL,
  max_val INT NOT NULL,
  running TINYINT NOT NULL,
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
