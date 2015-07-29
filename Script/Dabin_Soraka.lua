_G.Dabin_Soraka_Version = '1.0'

if myHero.charName ~= "Soraka" then return end

class "Dabin_Soraka"

require 'HPrediction'
require 'VPrediction'

function Dabin_Soraka:ScriptMsg(msg)
  print("<font color=\"#daa520\"><b>Dabin Soraka:<\b><\font> <font color=\"#FFFFFF\">"..msg.."</font>")
end

-------------------------------------------------------------
-------------------------------------------------------------

local Host = "raw.github.com"

local ScriptFilePath = SCRIPT_PATH..GetCurrentEnv().FILE_NAME

local ScriptPath = "/Dabin/bol/Dabin_Soraka".."?rand="..math.random(1,10000)
local UpdateURL = "https://"..Host..ScriptPath

local VersionPath = "/Dabin/bol/Dabin_Soraka.version".."?rand="..math.random(1,10000)
local VersionData = tonumber(GetWebResult(Host, VersionPath))

if VersionData then

  ServerVersion = type(VersionData) == "number" and VersionData or nil
  
  if ServerVersion then
  
    if tonumber(Version) < ServerVersion then
      Dabin_Soraka:ScriptMsg("New version available: v"..VersionData)
      Dabin_Soraka:ScriptMsg("Updating, please don't press F9.")
      DelayAction(function() DownloadFile(UpdateURL, ScriptFilePath, function () Dabin_Soraka:ScriptMsg("Successfully updated.: v"..Version.." => v"..VersionData..", Press F9 twice to load the updated version.") end) end, 3)
    else
      Dabin_Soraka:ScriptMsg("You've got the latest version: v"..Version)
    end
    
  else
    Dabin_Soraka:ScriptMsg("Error downloading server version.")
  end
  
else
  Dabin_Soraka:ScriptMsg("Error downloading version info.")
end

-------------------------------------------------------------
-------------------------------------------------------------

function OnLoad()

  Dabin_Soraka = Dabin_Soraka()
  self:Menu()

end
-------------------------------------------------------------
-------------------------------------------------------------

function Dabin_Soraka:__init()

end

-------------------------------------------------------------
-------------------------------------------------------------

function Dabin_Soraka:Variables()

  self.HPred = HPrediction()

  self.IsRecall = false
  self.RrebornLoaded, self.MMALoaded, self.SxOrbLoaded, self.SOWLoaded = false, false, false, false

  if myHero.:GetSpellData(SUMMONER_1).name:find("sommonerdot") then
    self.Ignite = SUMMONER_1
  else if myHero.:GetSpellData(SUMMONER_2).name:find("sommonerdot") then
    self.Ignite = SUMMONER_2
end

  self.Q = {range = 970, radius = , ready}
  self.W = {range = 550, ready}
  self.E = {range = 925, radius = , ready}
  self.R = {ready}
  self.I = {range = 600, ready}

  self.Items =
  {["bane"] = {id= , range = , slot = nill, ready}}
  self.Items =
  {["HP"] = {id= , slot = nill, ready}}
  self.Items =
  {["MP"] = {id= , slot = nill, ready}}

  local S5SR = false
  local TT = false  
  
  if GetGame().map.index == 15 then
    S5SR = true
  elseif GetGame().map.index == 4 then
    TT = true
  end
  
  if S5SR then
    self.FocusJungleNames =
    {
    "SRU_Baron12.1.1",
    "SRU_Blue1.1.1",
    "SRU_Blue7.1.1",
    "Sru_Crab15.1.1",
    "Sru_Crab16.1.1",
    "SRU_Dragon6.1.1",
    "SRU_Gromp13.1.1",
    "SRU_Gromp14.1.1",
    "SRU_Krug5.1.2",
    "SRU_Krug11.1.2",
    "SRU_Murkwolf2.1.1",
    "SRU_Murkwolf8.1.1",
    "SRU_Razorbeak3.1.1",
    "SRU_Razorbeak9.1.1",
    "SRU_Red4.1.1",
    "SRU_Red10.1.1"
    }
    self.JungleMobNames =
    {
    "SRU_BlueMini1.1.2",
    "SRU_BlueMini7.1.2",
    "SRU_BlueMini21.1.3",
    "SRU_BlueMini27.1.3",
    "SRU_KrugMini5.1.1",
    "SRU_KrugMini11.1.1",
    "SRU_MurkwolfMini2.1.2",
    "SRU_MurkwolfMini2.1.3",
    "SRU_MurkwolfMini8.1.2",
    "SRU_MurkwolfMini8.1.3",
    "SRU_RazorbeakMini3.1.2",
    "SRU_RazorbeakMini3.1.3",
    "SRU_RazorbeakMini3.1.4",
    "SRU_RazorbeakMini9.1.2",
    "SRU_RazorbeakMini9.1.3",
    "SRU_RazorbeakMini9.1.4",
    "SRU_RedMini4.1.2",
    "SRU_RedMini4.1.3",
    "SRU_RedMini10.1.2",
    "SRU_RedMini10.1.3"
    }
  elseif TT then
    self.FocusJungleNames =
    {
    "TT_NWraith1.1.1",
    "TT_NGolem2.1.1",
    "TT_NWolf3.1.1",
    "TT_NWraith4.1.1",
    "TT_NGolem5.1.1",
    "TT_NWolf6.1.1",
    "TT_Spiderboss8.1.1"
    }   
    self.JungleMobNames =
    {
    "TT_NWraith21.1.2",
    "TT_NWraith21.1.3",
    "TT_NGolem22.1.2",
    "TT_NWolf23.1.2",
    "TT_NWolf23.1.3",
    "TT_NWraith24.1.2",
    "TT_NWraith24.1.3",
    "TT_NGolem25.1.1",
    "TT_NWolf26.1.2",
    "TT_NWolf26.1.3"
    }
  else    self.FocusJungleNames =
    {
    }   
    self.JungleMobNames =
    {
    }
  end

  self.QTS = TargetSelector(TARGET_LESS_CAST, self.Q.range, DAMAGE_MAGIC, false)
  self.ETS = TargetSelector(TARGET_LESS_CAST, self.E.range, DAMAGE_MAGIC, false)
  self.STS = TargetSelector(TARGET_LOW_HP, self.S.range)
end

-------------------------------------------------------------
-------------------------------------------------------------

function Dabin_Soraka:Orbwalk()

  if _G.AutoCarry then

  if _G.Reborn_Initialised then
  self.RebornLoaded = true
  self.ScriptMsg("Found SAC: Reborn")
end

    elseif _G.Reborn_Loaded then
  DelayAction(function() self:Orbwalk()end, 1)
    elseif _G.MMA_IsLoaded then
  self.MMALoaded = true
  self.ScriptMsg("Found MMA")
    elseif FileExist(LIB_PATH .."SxOrbWalk.lua") then

  reequire 'SxOrbWalk'

  self.SxOrbMenu = scriptConfig("SxOrb", "SxOrb")

  self.SxOrb = SxOrbWalk()
  self.SxOrb:LoadToMenu(self.SxOrbMenu)

  self.SxOrbLoaded = true
  self.ScriptMsg("Found SxOrb.")
    elseif FileExist(LIB_PATH .."SOW.lua") then

  require 'SOW'
  require 'VPrediction'

  self.VP = VPrediction()
  self.SOWVP = SOW(self.VP)

  self.Menu:addSubMenu("Orbwalk (SOW)", "Orbwalk")
  self.Menu.Orbwalk:addparam("Info", "SOW", SCRIPT_PARAM_INFO,"")
  self.SOWVP:LoadedToMenu(self.Menu.Orbwalk)

  self.SOWLoaded = true
  self.ScriptMsg("Found SOW.")
    else
  self.ScriptMsg("Orbwalk not founded.")
    end
end

-------------------------------------------------------------
-------------------------------------------------------------

function Dabin_Soraka:Menu()
	
  self.Menu = scriptConfig("Dabin Soraka", "Dabin Soraka")
    self.Menu:addSubMenu("HitChance", "HitChance")
    self.Menu.HitChance:addParam("Combo(1.3)", "ComboH", SCRIPT_PARAM_SLICE, 1.3, 1, 3, 1)
    self.Menu.HitChance:addParam("Harass(1.9)", "HarassH", SCRIPT_PARAM_SLICE, 1.9, 1, 3, 1)

    self.Menu:addSubMenu("Combo", "Combo")
    self.Menu.Combo:addParam("use Q", "UseQ", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Combo:addParam("use W", "UseW", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Combo:addParam("use E", "UseE", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Combo:addParam("use R", "UseR", SCRIPT_PARAM_ONOFF, true)
	
    self.Menu:addSubMenu("Harass", "Harass")
    self.Menu.Harass:addParam("use Q", "UseQ", SCRIPT_PARAM_ONOFF, true)
    self.Menu.Harass:addParam("use E", "UseE", SCRIPT_PARAM_ONOFF, true)

    self.Menu:addSubMenu("Health Potions", "PotionHP")
    self.Menu.PotionHP:addParam("HPONOFF", "Use Auto Potion", SCRIPT_PARAM_ONOFF, true)
    self.Menu.PotionHP:addParam("health", "If My Health below % is <", SCRIPT_PARAM_SLICE, 60, 0, 100, 0) 
    self.Menu:addSubMenu("Mana Potions", "PotionMP")
    self.Menu.PotionMP:addParam("Key", "Use Auto Potion", SCRIPT_PARAM_ONOFF, true)
    self.Menu.PotionMP:addParam("health", "If My Mana below % is <", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

    self.Menu:addSubMenu("Auto Heal", "AutoHeal")
    self.Menu.AutoHeal:addparam("AutoW", "AutoR", SCRIPT_PARAM_ONOFF, true)
    self.Menu.AutoHeal:addparam("AllyHPW", "AllyHPW", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
    self.Menu.AutoHeal:addparam("AutoR", "AutoR", SCRIPT_PARAM_ONOFF, true)
    self.Menu.AutoHeal:addparam("AllyHPR", "AllyHPR", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
    self.Menu.AutoHeal:addparam("HP %< then AutoHeal Stop", "Stop", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
end

-------------------------------------------------------------
-------------------------------------------------------------

function Dabin_Soraka:Tick()

  if myHero.dead then
    return
  end
  
--Checks Targets
  self:Checks()
  self:Targets()
  
--Combo
  if self.Menu.Combo.On then
    self:Combo()
  end
  
--Clear
  if self.Menu.Clear.Farm.On then
    self:Farm()
  end

--Harass
  if self.Menu.Harass.On or (self.Menu.Harass.On2 and not self.IsRecall) then
    self:Harass()
  end
  
--LastHit
  if self.Menu.LastHit.On then
    self:LastHit()
  end
  
--KillSteal
  if self.Menu.KillSteal.On then
    self:KillSteal()
  end

--Auto Cast Heal(W,R)
  If self.Menu.Auto.On then
    self.AutoHeal()
end

--Auto Potion(HP)
  If self.Menu.PotionHP.On then
    self.PotionHP()

--Auto Potion(MP)
  If self.Menu.PotionMP.On then
    self.PotionMP()

end

-------------------------------------------------------------

function Dabin_Soraka:Combo()
함수내용
end

-------------------------------------------------------------

function Dabin_Soraka:Harass()
함수내용
end

-------------------------------------------------------------

function Dabin_Soraka:AutoHeal()
  If self.W:Ready() then
    for ally,inpairs(GetAllyHeroes()) do
      If ally.health < self.Menu.AutoHeal.AllyHPW and GetDistance(ally, myHero) <= W.range
        self.W:Cast(ally)
      end
    end
  end
end

-------------------------------------------------------------

function Dabin_Soraka:PotionHP()
  If self.

end

-------------------------------------------------------------

function Dabin_Soraka:PotionMP()
  If self.
end

-------------------------------------------------------------

function Dabin_Soraka:Checks()

  self.Q.ready = myHero:CanUseSpell(_Q) == READY
  self.W.ready = myHero:CanUseSpell(_W) == READY
  self.E.ready = myHero:CanUseSpell(_E) == READY
  self.R.ready = myHero:CanUseSpell(_R) == READY
  self.I.ready = self.Ignite ~= nil and myHero:CanUseSpell(self.Ignite) == READY
  
  for _, item in pairs(self.Items) do
    item.slot = GetInventorySlotItem(item.id)
  end

  self.EnemyMinions:update()
  self.JungleMobs:update()
  
end

--------------------------------------------------------------
