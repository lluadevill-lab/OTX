-- OTX Diablo II rules engine. Server-side compatibility layer for a future custom client.
D2R = D2R or {}
D2R.STORAGE = {str=71000,dex=71001,vit=71002,ene=71003,stamina=71004,diff=71005,mf=71006,players=71007,
 fcr=71008,fhr=71009,ias=71010,fbr=71011,plr=71012,cannotFreeze=71013,weaponSet=71014,
 corpse=71015,curse=71016,hardcore=71017}
D2R.DIFFICULTY = {normal=0, nightmare=1, hell=2}
D2R.RESIST_PENALTY = {[0]=0,[1]=-40,[2]=-100}
D2R.BP = {fcr={0,9,20,37,63,105,200},fhr={0,7,15,27,48,86,200},ias={0,10,20,30,50,75,125},fbr={0,10,20,40,60,86,200}}
D2R.CLASSES = {'Amazon','Assassin','Barbarian','Druid','Necromancer','Paladin','Sorceress'}
D2R.SKILLS = {
 Amazon={'Jab','Multiple Shot','Guided Arrow','Decoy','Valkyrie','Lightning Fury'}, Assassin={'Tiger Strike','Dragon Talon','Burst of Speed','Cloak of Shadows','Shadow Master','Death Sentry'},
 Barbarian={'Bash','Double Swing','Whirlwind','Battle Orders','Taunt','Find Item'}, Druid={'Firestorm','Fissure','Oak Sage','Summon Spirit Wolf','Hurricane','Werewolf'},
 Necromancer={'Amplify Damage','Bone Spear','Raise Skeleton','Corpse Explosion','Decrepify','Lower Resist'}, Paladin={'Might','Holy Freeze','Blessed Hammer','Conviction','Redemption','Zeal'},
 Sorceress={'Fire Bolt','Frozen Orb','Static Field','Teleport','Blizzard','Energy Shield'} }
function D2R.val(p,k) return math.max(0,p:getStorageValue(D2R.STORAGE[k])) end
function D2R.set(p,k,v) p:setStorageValue(D2R.STORAGE[k],math.max(0,v)); return v end
function D2R.diff(p) return math.max(0,math.min(2,D2R.val(p,'diff'))) end
function D2R.breakpoint(v, key) local r=0; for _,x in ipairs(D2R.BP[key] or {}) do if v>=x then r=x else break end end return r end
function D2R.block(p, shield, running) local c=shield*(D2R.val(p,'dex')-15)/(2*math.max(1,p:getLevel())); if running then c=c/3 end return math.max(0,math.min(75,c)) end
function D2R.hit(a,t,ar,def,itd) if itd and t:isMonster() then def=0 end; return math.max(5,math.min(95,200*a:getLevel()/(a:getLevel()+t:getLevel())*ar/math.max(1,ar+def))) end
function D2R.absorb(d, fixed, pct) return math.max(0,(d-math.max(0,fixed))*(1-math.max(0,pct)/100)) end
function D2R.leech(p,d,life,mana) local m=({[0]=1,[1]=.5,[2]=.2})[D2R.diff(p)] or 1; p:addHealth(math.floor(d*life*m/100)); p:addMana(math.floor(d*mana*m/100)) end
function D2R.mf(mf,q) local denom={magic=1,rare=100,set=500,unique=2500}; return mf*100/(100+mf*(denom[q] or 100)) end
function D2R.xp(level,area,xp) local d=math.abs(level-area); return math.floor(xp*math.max(.05,1-d*.05)) end
function D2R.players(n,base) return base*(1+math.max(0,math.min(7,n-1))) end
function D2R.freezeDuration(seconds,p) if D2R.val(p,'cannotFreeze')>0 then return 0 end; return seconds*({[0]=1,[1]=.5,[2]=.25})[D2R.diff(p)] end
function D2R.immunity(resist, reduction) if resist<=100 then return resist end; return resist-math.floor(reduction/5) end
D2R.RUNEWORDS={Spirit={{'Tal','Thul','Ort','Amn'},{'sword','shield'}},Insight={{'Ral','Tir','Tal','Sol'},{'polearm','staff'}},Stealth={{'Tal','Eth'},{'armor'}},Lore={{'Ort','Sol'},{'helm'}}}
function D2R.runeword(name,runes,kind) local w=D2R.RUNEWORDS[name]; if not w or #w[1]~=#runes then return false end; for i=1,#runes do if w[1][i]~=runes[i] then return false end end; for _,x in ipairs(w[2]) do if x==kind then return true end end return false end
D2R.AFFIXES={prefix={'of the Whale','Mechanic\'s','Ruby','Amber','Shimmering'},suffix={'of Strength','of Dexterity','of the Apprentice','of Slaughter','of Absorption'}}
D2R.CUBE={rune_upgrade='3 runes + gem -> next rune',socket='item + quest token -> sockets',upgrade='unique/rare + rune -> exceptional/elite',craft='magic item + rune + gem -> crafted item'}
