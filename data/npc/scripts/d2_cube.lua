local keywordHandler=KeywordHandler:new(); local npcHandler=NpcHandler:new(keywordHandler); NpcSystem.parseParameters(npcHandler)
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid,t,msg) npcHandler:onCreatureSay(cid,t,msg) end
function onThink() npcHandler:onThink() end
function creatureSayCallback(cid,t,msg)
 if not npcHandler:isFocused(cid) then return false end
 if msgcontains(msg,'recipe') then npcHandler:say('Use 3 equal runes and a gem to upgrade; magic item plus rune and gem to craft. Runewords require a normal socketed base.',cid) end
 if msgcontains(msg,'gamble') then npcHandler:say('Gambling is enabled by the shop system; item quality scales with your level and MF.',cid) end
 return true
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT,creatureSayCallback); npcHandler:addModule(FocusModule:new())
