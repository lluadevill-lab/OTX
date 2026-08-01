-- Diablo II character state. Run once after DATABASE.sql.
ALTER TABLE players ADD COLUMN d2_difficulty TINYINT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN d2_strength INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN d2_dexterity INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN d2_vitality INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN d2_energy INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN d2_skill_points INT NOT NULL DEFAULT 0;
ALTER TABLE players ADD COLUMN d2_weapon_set TINYINT NOT NULL DEFAULT 0;
CREATE TABLE IF NOT EXISTS d2_account_stash (account_id INT NOT NULL, tab TINYINT NOT NULL, item_id INT NOT NULL, attributes TEXT, PRIMARY KEY(account_id,tab,item_id));
CREATE TABLE IF NOT EXISTS d2_runewords (name VARCHAR(32) PRIMARY KEY, runes VARCHAR(128) NOT NULL, item_types VARCHAR(128) NOT NULL);
INSERT IGNORE INTO d2_runewords VALUES ('Spirit','Tal,Thul,Ort,Amn','sword,shield'),('Insight','Ral,Tir,Tal,Sol','polearm,staff'),('Stealth','Tal,Eth','armor'),('Lore','Ort,Sol','helm');
