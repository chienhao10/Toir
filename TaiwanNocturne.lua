--1key R noti and press go
--SDK
IncludeFile("Lib\\TOIR_SDK.lua")
--Check Champion
Nocturne = class()
function OnLoad()
  if GetChampName(GetMyChamp()) == "Nocturne" then
    __PrintTextGame("<b><font color=\"#2EFEF7\">LOVETAIWAN 台湾夢魇 Nocturne</font></b> <font color=\"#ffffff\">Loaded</font>")
    Nocturne:Load()
  end
end

function Nocturne:Load()

    self.intspell =
    {
	["KatarinaR"] = true,
	["AlZaharNetherGrasp"] = true,
	["TwistedFateR"] = true,
	["VelkozR"] = true,
	["InfiniteDuress"] = true,
	["JhinR"] = true,
	["CaitlynAceintheHole"] = true,
	["UrgotSwap2"] = true,
	["LucianR"] = true,
	["GalioIdolOfDurand"] = true,
	["MissFortuneBulletTime"] = true,
	["XerathLocusPulse"] = true,
	["VarusQ"] = true,
	["Crowstorm"] = true
    }

	self.wspell =
	{
    ["KatarinaR"] = true,
    ["LeonaSolarFlare"] = true,
    ["LeonaZenithBlade"] = true,
    ["LeonaShieldOfDaybreakAttack"] = true,
	["AlZaharNetherGrasp"] = true,
	["VelkozR"] = true,
	["InfiniteDuress"] = true,
	["JhinR"] = true,
	["CaitlynAceintheHole"] = true,
	["UrgotSwap2"] = true,
	["LucianR"] = true,
	["GalioIdolOfDurand"] = true,
	["MissFortuneBulletTime"] = true,
	["XerathLocusPulse"] = true,
	["VarusQ"] = true,
	["Crowstorm"] = true,
    ["AhriOrbofDeception"] = true,
	["AhriOrbReturn"] = true,
	["BandageToss"] = true,
	["CurseoftheSadMummy"] = true,
	["FlashFrost"] = true,
	["Incinerate"] = true,
	["InfernalGuardian"] = true,
	["Volley"] = true,
	["EnchantedCrystalArrow"] = true,
	["AzirQ"] = true,
	["BardQ"] = true,
	["BardR"] = true,
	["RocketGrab"] = true,
    ["StaticField"] = true,
	["BrandBlaze"] = true,
	["BrandFissure"] = true,
	["BraumQ"] = true,
	["BraumRWrapper"] = true,
	["CaitlynEntrapment"] = true,
	["CassiopeiaNoxiousBlast"] = true,
	["CassiopeiaPetrifyingGaze"] = true,
	["Rupture"] = true,
	["DariusCleave"] = true,
	["DariusAxeGrabCone"] = true,
	["DianaArc"] = true,
	["DianaArcArc"] = true
	}

  pred = VPrediction(true)
  --HPred = HPrediction()

  self.JungleMinions = minionManager(MINION_JUNGLE, 2000, myHero, MINION_SORT_HEALTH_ASC)
  self.EnemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC)
  self.menu_ts = TargetSelector(1750, 0, myHero, true, true, true)


  self.Q = Spell(_Q,1250)
  self.W = Spell(_W,150)
  self.E = Spell(_E,495)
  self.R = Spell(_R,4600)

  self.Q:SetSkillShot(0.25,1350,60,false)
  self.W:SetActive()
  self.E:SetTargetted()
  self.R:SetTargetted()

  Callback.Add("Tick", function(...) self:OnTick(...) end)
  Callback.Add("Draw", function(...) self:OnDraw(...) end)
  Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)
  Callback.Add("Update", function(...) self:OnUpdate(...) end)
  Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)
  self:NocturneMenu()
  self.isRactive = false;

end

function Nocturne:NocturneMenu()
  self.menu ="Taiwan Nocturne"
  self.Use_Combo_Q = self:MenuBool("Combo Q",true)
  self.Use_Combo_W = self:MenuBool("Combo W",true)
  self.Use_Combo_E = self:MenuBool("Combo E",true)
  self.Use_Combo_R = self:MenuBool("Combo R",false)
  self.RRange = self:MenuSliderInt("Out of X Range R", 1100)
  --self.OKR = self:MenuKeyBinding("一键R杀", 84)
  self.Draw_noR = self:MenuBool("No R Range",true)
  self.Draw_QER = self:MenuBool("Show RQE Kill Target",true)
  self.Use_Harass_Q = self:MenuBool("Harass Q",true)
  self.Use_Harass_E = self:MenuBool("Harass E",false)
  self.Use_Auto_E = self:MenuBool("Auto E",false)
  self.AEMana = self:MenuSliderInt("Auto E Mana", 40)
  self.Use_Lc_Q = self:MenuBool("LaneClear Q",true)
  self.LQMana = self:MenuSliderInt("LaneClear Q Mana", 40)
  self.Use_Lc_E = self:MenuBool("LaneClear E",true)
  self.LCEMana = self:MenuSliderInt("LaneClear E Mana", 40)
  self.Use_Int_E = self:MenuBool("E Interrupt",true)
  self.AntiGapclose = self:MenuBool("Anti-Gap E",true)
  self.Combo = self:MenuKeyBinding("Combo",32)
  self.Harass = self:MenuKeyBinding("Harass", 67)
  self.LaneClear = self:MenuKeyBinding("LaneClear",86)
  self.menu_SkinEnable = self:MenuBool("SkinHack-Might Not Safe", false)
  self.menu_SkinIndex = self:MenuSliderInt("Skin", 11)
end

function Nocturne:OnProcessSpell(unit,spell)
	if unit.IsEnemy and self.intspell[spell.Name] and IsValidTarget(unit, self.E.range) and CanCast(_E) and self.Use_Int_E then
		CastSpellTarget(unit.Addr, _E)
        --__PrintTextGame("E Int")
	end
    if unit.IsEnemy and self.Use_Combo_W and self.wspell[spell.Name] and IsValidTarget(unit, self.E.Range)
   then
     --__PrintTextGame("Block W")
			self.W:Cast(myHero.Addr)
	end
end

function Nocturne:OnDraw()
	for i,hero in pairs(GetEnemyHeroes()) do
		if IsValidTarget(hero, 4000) then
			target = GetAIHero(hero)
			if IsValidTarget(target.Addr, self.Range) and GetDamage("R", target) + GetDamage("Q", target) + GetDamage("E", target) > target.HP and self.Draw_QER then
				local a,b = WorldToScreen(target.x, target.y, target.z)
                DrawTextD3DX(a, b, "R+Q+E CAN KILL!", Lua_ARGB(255, 255, 0, 10))
				__PrintTextGame("<font color=\"#DC143C\">R+Q+E CAN KILL! Press Key NOW！</font>")
			end
        end
	end

    if self.Draw_noR and self.R:IsReady() then
        DrawCircleGame(myHero.x , myHero.y, myHero.z, self.RRange, Lua_ARGB(0, 255, 191,0))
    end  

    if self.menu_Draw_Already then
		if self.menu_Draw_Q and self.Q:IsReady() then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.Q.range, Lua_ARGB(255,255,0,0))
		end
		if self.menu_Draw_E and self.E:IsReady() then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.E.range, Lua_ARGB(255,255,0,0))
		end
		if self.menu_DraE_R and self.R:IsReady() then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.R.range, Lua_ARGB(255,0,255,0))
		end
    else  
		if self.menu_Draw_Q then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.Q.range, Lua_ARGB(255,255,0,0))
		end
		if self.menu_Draw_E then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.E.range, Lua_ARGB(255,255,0,0))
		end
		if self.menu_Draw_R then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.R.range, Lua_ARGB(255,0,255,0))
		end
	end
end

function Nocturne:OnDrawMenu()
  if Menu_Begin(self.menu) then
    if Menu_Begin("Combo Settings") then
      self.Use_Combo_Q = Menu_Bool("Combo Q",self.Use_Combo_Q,self.menu)
      self.Use_Combo_W = Menu_Bool("Combo W",self.Use_Combo_W,self.menu)
      self.Use_Combo_E = Menu_Bool("Combo E",self.Use_Combo_E,self.menu)
      self.Use_Combo_R = Menu_Bool("Combo R",self.Use_Combo_R,self.menu)
      self.RRange = Menu_SliderInt("Out of X Range R", self.RRange, 0, 4600, self.menu)
      --self.OKR = Menu_KeyBinding("一键R杀",self.OKR,self.menu)
      Menu_End()
    end
    if Menu_Begin("Harass Settings") then
      self.Use_Harass_Q = Menu_Bool("Harass Q",self.Use_Harass_Q,self.menu)
      self.Use_Harass_E = Menu_Bool("Harass E",self.Use_Harass_E,self.menu)
      Menu_End()
    end
    if Menu_Begin("LaneClear Settings") then
      self.Use_Lc_Q = Menu_Bool("LaneClear Q",self.Use_Lc_Q,self.menu)
      self.LQMana = Menu_SliderInt("LaneClear Q Mana", self.LQMana, 0, 100, self.menu)
      self.Use_Lc_E = Menu_Bool("LaneClear E",self.Use_Lc_E,self.menu)
      self.LCEMana = Menu_SliderInt("LaneClear E Mana", self.LCEMana, 0, 100, self.menu)
      Menu_End()
    end
    if Menu_Begin("Auto Settings") then
      self.Use_Auto_E = Menu_Bool("Auto E",self.Use_Auto_E,self.menu)
      self.AEMana = Menu_SliderInt("Auto E Mana", self.AEMana, 0, 100, self.menu)
      Menu_End()
    end
   if Menu_Begin("Misc") then
      self.AntiGapclose = Menu_Bool("Anti-Gap E",self.AntiGapclose,self.menu)
      self.Use_Int_E = Menu_Bool("E Interrupt",self.Use_Int_E,self.menu)
      self.menu_SkinEnable = Menu_Bool("SkinHack-Might Not Safe", self.menu_SkinEnable, self.menu)
      self.menu_SkinIndex = Menu_SliderInt("Skin", self.menu_SkinIndex, 0, 20, self.menu)
      Menu_End()
      end
    if (Menu_Begin("Drawings")) then
      self.menu_Draw_Already = Menu_Bool("Draw Only No CD Spells", self.menu_Draw_Already, self.menu)
      self.menu_Draw_Q = Menu_Bool("Draw Q", self.menu_Draw_Q, self.menu)
      self.menu_Draw_E = Menu_Bool("Draw E", self.menu_Draw_E, self.menu)
      self.menu_Draw_R = Menu_Bool("Draw R", self.menu_Draw_R, self.menu)
      self.Draw_noR = Menu_Bool("Draw No R Range",self.Draw_noR,self.menu)
      self.Draw_QER = Menu_Bool("Draw RQE Kill Target",self.Draw_QER,self.menu)
      Menu_End()
      end
   if Menu_Begin("Keys") then
      self.Combo = Menu_KeyBinding("Combo", self.Combo, self.menu)
      self.Harass = Menu_KeyBinding("Harass", self.Harass, self.menu)
      self.LaneClear = Menu_KeyBinding("LaneClear", self.LaneClear, self.menu)
        Menu_End()
      end
  Menu_End()
  end
end

function Nocturne:AutoE()
    local target = GetTargetSelector(self.E.range)
        if IsValidTarget(target,self.E.range) and target ~= nil and CanCast(_E) and self.Use_Auto_E and GetPercentMP(myHero.Addr) >= self.AEMana then
            CastSpellTarget(target, _E)
        end
end

function Nocturne:QELogic()
    local UseQ = GetTargetSelector(self.Q.range)
    Enemy = GetAIHero(UseQ)
    if CanCast(_Q) and IsValidTarget(Enemy, self.Q.range) and self.Use_Harass_Q then
        local QPosition, HitChance, Position = pred:GetCircularCastPosition(Enemy, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
        if HitChance >= 2 then
            --__PrintTextGame("harq")
			CastSpellToPos(QPosition.x, QPosition.z, _Q)
        end
    end 

    local TargetE = GetTargetSelector(self.E.range)
	if TargetE ~= nil and IsValidTarget(TargetE, self.E.range) and CanCast(_E) and self.Use_Harass_E then
        targetE = GetAIHero(TargetE)
        if GetDistance(TargetE) < self.E.range then
			CastSpellTarget(target.Addr, _E)
		end
    end
end

function Nocturne:QLogic()
    local UseQ = GetTargetSelector(self.Q.range)
    Enemy = GetAIHero(UseQ)
    if CanCast(_Q) and IsValidTarget(Enemy, self.Q.range) and self.Use_Combo_Q then
        local QPosition, HitChance, Position = pred:GetCircularCastPosition(Enemy, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
        if HitChance >= 2 then
			CastSpellToPos(QPosition.x, QPosition.z, _Q)
        end
    end 
end 

--[[
function Nocturne:ELogic()
    local UseE = GetTargetSelector(self.E.range)
    Enemy = GetAIHero(UseE)
    if Enemy ~= nil and IsValidTarget(Enemy, self.E.range) and CanCast(_E) and self.Use_Combo_E then
        targetE = GetAIHero(Enemy)
        __PrintTextGame("ee")
			CastSpellTarget(targetE.addr, _E)
    end
end--]]

function Nocturne:ELogic()
    local TargetE = GetTargetSelector(self.E.range)
	if TargetE ~= nil and IsValidTarget(TargetE, self.E.range) and CanCast(_E) and self.Use_Combo_E then
        targetE = GetAIHero(TargetE)
        if GetDistance(TargetE) < self.E.range then
			CastSpellTarget(target.Addr, _E)
		end
    end
end

function Nocturne:RLogic()
    local TargetR = GetTargetSelector(self.R.range)
	if TargetR ~= nil and IsValidTarget(TargetR, self.R.range) and not IsValidTarget(TargetR, self.RRange) and CanCast(_R) then
        targetR = GetAIHero(TargetR)
        if self.Use_Combo_R then
            CastSpellTarget(targetR.Addr, _R)
		end
    end
end

function Nocturne:JGLogic()
  if CanCast(_Q) and self.Use_Lc_Q and (GetType(GetTargetOrb()) == 3) and GetPercentMP(myHero.Addr) >= self.LQMana then
    if (GetObjName(GetTargetOrb()) ~= "PlantSatchel" and GetObjName(GetTargetOrb()) ~= "PlantHealth" and GetObjName(GetTargetOrb()) ~= "PlantVision") then
        target = GetUnit(GetTargetOrb())
        if IsValidTarget(target, self.Q.range) then
          local JQPosition, HitChance, Position = pred:GetCircularCastPosition(target, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
		      if HitChance >= 2 then
			    CastSpellToPos(JQPosition.x, JQPosition.z, _Q)    
        end
      end
    end 
  end

  if CanCast(_E) and self.Use_Lc_E and (GetType(GetTargetOrb()) == 3) and GetPercentMP(myHero.Addr) >= self.LCEMana then
    if (GetObjName(GetTargetOrb()) ~= "PlantSatchel" and GetObjName(GetTargetOrb()) ~= "PlantHealth" and GetObjName(GetTargetOrb()) ~= "PlantVision") then
        target = GetUnit(GetTargetOrb())
        if IsValidTarget(target, self.E.range) then
			CastSpellTarget(target.Addr, _E)    
        end
    end 
  end  

  self.EnemyMinions:update()
  for i ,minion in pairs(self.EnemyMinions.objects) do
    if minion ~= 0 and CanCast(_Q) and self.Use_Lc_Q and IsValidTarget(minion,self.Q.range) and GetPercentMP(myHero.Addr) >= self.LQMana and not IsDead(minion.Addr) and minion.Type == 1 then
    CastSpellToPos(minion.x,minion.z,_Q)
    end
  end
end

function Nocturne:OKRK()
    local TargetR = GetTargetSelector(self.R.range)
    if TargetR ~= nil and IsValidTarget(TargetR.Addr, self.R.range) and GetDamage("R", TargetR) + GetDamage("Q", TargetR) + GetDamage("E", TargetR) > TargetR.HP then
        targetR = GetAIHero(TargetR)
        if CanCast(_R) and CanCast(_Q) and CanCast(_E) then
            CastSpellTarget(targetR.Addr, _R)
            self.QLogic()
            self.ELogic()
		end
    end
end

function Nocturne:GapClose()
    for i,enm in pairs(GetEnemyHeroes()) do
        if enm ~= nil and CanCast(_E) then
            local hero = GetAIHero(enm)
            local TargetDashing, CanHitDashing, DashPosition = pred:IsDashing(hero, 0.09, 65, 2000, myHero, false)
            if DashPosition ~= nil and GetDistance(DashPosition) <= self.E.range then
                CastSpellTarget(hero.Addr,_E)
            end
        end
    end
end

function Nocturne:MenuBool(stringKey, bool)
    return ReadIniBoolean(self.menu, stringKey, bool)
end

function Nocturne:MenuSliderInt(stringKey, valueDefault)
    return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Nocturne:MenuKeyBinding(stringKey, valueDefault)
    return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Nocturne:OnUpdate()
  self:AutoE() 
end 

function Nocturne:OnTick()
  SetLuaCombo(true)
  SetLuaHarass(true)
  SetLuaLaneClear(true)
  SetPrintErrorLog(false)

  if self.menu_SkinEnable then
    ModSkin(self.menu_SkinIndex)
  end
  if IsDead(myHero.Addr) or IsTyping() or IsDodging() then return end

  if self.AntiGapclose then
  self:GapClose()
  end
  if GetKeyPress(self.Combo) > 0 then
        self:QLogic()
        self:ELogic()
        self:RLogic()
    end
  if GetKeyPress(self.Harass) > 0 then
        self:QELogic()
    end
  if GetKeyPress(self.LaneClear) > 0 then
        self:JGLogic()
    end
  
  --[[if GetKeyPress(self.OKR) > 0 then
      self:OKRK()
  end--]]
end