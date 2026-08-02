-- Breakpoints 25 FPS engine
-- FCR Faster Cast Rate, FHR Faster Hit Recovery, IAS Increased Attack Speed, FBR Faster Block Rate
-- Values extracted from diablowiki.net / d2 breakpoints tables
D2C = D2C or {}
D2C.BREAKPOINTS = {
  -- Sorc: most demanded
  Sorceress = {
    FCR = {0,9,20,37,63,105,200},
    FHR = {0,7,15,27,48,86,200},
    FBR = {0,5,13,26,52,86,200},
    IAS = {0,10,20,37,63,105,200},
  },
  Paladin = {
    FCR = {0,9,18,30,48,75,125},
    FHR = {0,7,15,27,48,86,200},
    FBR = {0,13,32,86,200},
    IAS = {0,10,20,30,50,75,125},
  },
  Amazon = {
    FCR = {0,11,22,35,56,89,147},
    FHR = {0,6,13,20,32,52,86,174,360},
    FBR = {0,6,13,20,32,52,86,174,360},
    IAS = {0,8,16,22,26,36,46,60,80,95,120,147},
  },
  Barbarian = {
    FCR = {0,9,20,37,63,105,200},
    FHR = {0,7,15,27,48,86,200},
    FBR = {0,8,20,40,86,200},
    IAS = {0,8,15,25,35,50,70,90,120,170},
  },
  Druid = {
    FCR = {0,9,20,42,65,99,163},
    FHR = {0,7,15,27,48,86,200},
    FBR = {0,12,32,86,200},
    IAS = {0,8,15,26,40,60,90,120},
  },
  Necromancer = {
    FCR = {0,9,20,39,65,105,200},
    FHR = {0,6,13,20,32,52,86,174},
    FBR = {0,6,13,20,32,52,86,174},
    IAS = {0,10,20,35,60,90,140},
  },
  Assassin = {
    FCR = {0,8,16,27,42,65,102,174},
    FHR = {0,6,13,20,32,52,86,174},
    FBR = {0,8,18,30,48,86,200},
    IAS = {0,8,15,27,42,60,86,125},
  },
  Generic = {
    FCR = {0,9,20,37,63,105,200},
    FHR = {0,7,15,27,48,86,200},
    IAS = {0,10,20,30,50,75,125},
    FBR = {0,10,20,40,60,86,200},
  }
}
function D2C.getBreakpoint(player, kind) -- kind = FCR, FHR, IAS, FBR
  local cls = D2C.getClass(player)
  local tbl = (D2C.BREAKPOINTS[cls] and D2C.BREAKPOINTS[cls][kind]) or D2C.BREAKPOINTS.Generic[kind]
  local cur = D2C.getAttr(player, kind)
  local reached = 0
  local frame = 15 -- default frames
  for i, bp in ipairs(tbl) do
    if cur >= bp then reached = bp; frame = frame - 1 end
  end
  frame = math.max(2, frame)
  local fps = D2C.FPS
  local seconds = frame / fps
  return reached, frame, seconds
end
-- Weapon IAS depends on base weapon speed WSM
D2C.WSM = { -- Weapon Speed Modifier negatives faster
  dagger=-30, claw=-20, short_sword=-10, scimitar=-20,
  long_sword=0, war_axe=0, mace=10, scepter=0,
  falchion=10, great_sword=10, executioner=20, halberd=20, pike=20,
  bow=-10, crossbow=10, staff=0
}
function D2C.calcIASFrames(player, weaponType)
  local ias = D2C.getAttr(player,"IAS")
  local wsm = D2C.WSM[weaponType] or 0
  local eias = ias - wsm -- effective IAS simplified
  eias = math.max(-80, math.min(175, eias))
  -- formula: frames = 256 * base / (100+eias) simplified
  local base = 10
  local frames = math.floor(256*base/(100+eias))
  return frames
end
