--SDK
IncludeFile("Lib\\TOIR_SDK.lua")
--Check Champion
Karthus = class()
function OnLoad()
  if GetChampName(GetMyChamp()) == "Karthus" then
    __PrintTextGame("<b><font color=\"#2EFEF7\">LOVETAIWAN Karthus</font></b> <font color=\"#ffffff\">Loaded</font>")
    Karthus:Req()
  end
end

function Karthus:Req()
  pred = VPrediction(true)
  --HPred = HPrediction()
  SetLuaCombo(true)
  SetLuaLaneClear(true)
  self.JungleMinions = minionManager(MINION_JUNGLE, 2000, myHero, MINION_SORT_HEALTH_ASC)
  self.EnemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC)
  self.menu_ts = TargetSelector(1750, 0, myHero, true, true, true)


  self.Q = Spell(_Q,875)
  self.W = Spell(_W,1000)
  self.E = Spell(_E,560)
  self.R = Spell(_R,9000)

  self.Q:SetSkillShot(1.0,math.huge,165,false)
  self.W:SetSkillShot(0.25,math.huge,70,false)
  self.E:SetSkillShot(1,math.huge,505,false)
  self.R:SetSkillShot(1.0, math.huge, 9000, false)
  self.isRactive = false;

  Callback.Add("Tick", function(...) self:OnTick(...) end)
  Callback.Add("Draw", function(...) self:OnDraw(...) end)
  Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)
  Callback.Add("Update", function(...) self:OnUpdate(...) end)
  Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)
  self:KarthusMenu()
end


function Karthus:KarthusMenu()
  self.menu ="Taiwan Karthus"
  self.Use_Combo_Q = self:MenuBool("Combo Q",true)
  self.Use_Combo_W = self:MenuBool("Combo W",true)
  self.Use_Combo_E = self:MenuBool("Combo E",true)
  self.Use_Combo_R = self:MenuBool("Combo R",true)
  self.Rsafe = self:MenuSliderInt("Safe Range R", 900)
  self.Draw_Rs = self:MenuBool("Show Manual R Noti",true)
  self.Use_Auto_Q = self:MenuBool("Auto Q",true)
  self.AQMana = self:MenuSliderInt("Auto Q Mana%", 40)
  self.Use_Auto_E = self:MenuBool("Auto E",true)
  self.AEMana = self:MenuSliderInt("Auto E Mana%", 40)
  self.Use_Lc_Q = self:MenuBool("LaneClear Q",true)
  self.LQMana = self:MenuSliderInt("LaneClear Q Mana%", 40)
  self.Use_Lc_E = self:MenuBool("LaneClear E",true)
  self.LCEMana = self:MenuSliderInt("LaneClear E Mana", 40)
  self.Evade_R = self:MenuBool("No Evade During R",true)
  self.AntiGapclose = self:MenuBool("Anti-Gap W",true)
  self.Combo = self:MenuKeyBinding("Combo",32)
  self.LaneClear = self:MenuKeyBinding("LaneClear",86)
end

function Karthus:OnProcessSpell(unit,spell)
  if not unit.IsMe and self.isRactive and self.Evade_R then
      SetEvade(true)
      end
  end

function Karthus:OnDraw()
	for i,hero in pairs(GetEnemyHeroes()) do
		if IsValidTarget(hero, 9000) then
			target = GetAIHero(hero)
			if IsValidTarget(target.Addr, self.Range) and GetDamage("R", target) > target.HP then
				local a,b = WorldToScreen(target.x, target.y, target.z)
        DrawTextD3DX(a, b, "R CAN KILL!", Lua_ARGB(255, 255, 0, 10))
				--__PrintDebug(tostring(GetAllBuffNameActive(target.Addr)))
			end
      if IsValidTarget(target.Addr, self.Range) and GetDamage("R", target) > target.HP and self.Draw_Rs then
        local a,b = WorldToScreen(myHero.x, myHero.y, myHero.z)
				DrawTextD3DX(a, b, "Press R!", Lua_ARGB(255, 255, 0, 10))
      end
		end
	end

	if self.menu_Draw_Already then
		if self.menu_Draw_Q then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.Q.range, Lua_ARGB(255,255,0,0))
		end
		if self.menu_Draw_W and self.W:IsReady() then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.W.range, Lua_ARGB(255,255,0,0))
		end
		if self.menu_Draw_E and self.E:IsReady() then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.E.range, Lua_ARGB(255,0,255,0))
		end
	else
		if self.menu_Draw_Q then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.Q.range, Lua_ARGB(255,255,0,0))
		end
		if self.menu_Draw_W then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.W.range, Lua_ARGB(255,255,0,0))
		end
		if self.menu_Draw_E then
			DrawCircleGame(myHero.x , myHero.y, myHero.z, self.E.range, Lua_ARGB(255,0,255,0))
		end
	end
end

function Karthus:OnDrawMenu()
  if Menu_Begin(self.menu) then
    if Menu_Begin("Combo Settings") then
      self.Use_Combo_Q = Menu_Bool("Combo Q",self.Use_Combo_Q,self.menu)
      self.Use_Combo_W = Menu_Bool("Combo W",self.Use_Combo_W,self.menu)
      self.Use_Combo_E = Menu_Bool("Combo E",self.Use_Combo_E,self.menu)
      self.Use_Combo_R = Menu_Bool("Combo R",self.Use_Combo_R,self.menu)
      Menu_End()
    end
    if Menu_Begin("LaneClear Settings") then
      self.Use_Lc_Q = Menu_Bool("LaneClear Q",self.Use_Lc_Q,self.menu)
      self.LQMana = Menu_SliderInt("LaneClear Q Mana%", self.LQMana, 0, 100, self.menu)
      self.Use_Lc_E = Menu_Bool("LaneClear E",self.Use_Lc_E,self.menu)
      self.LCEMana = Menu_SliderInt("LaneClear E Mana%", self.LCEMana, 0, 100, self.menu)
      Menu_End()
    end
    if Menu_Begin("Auto Settigns") then
      self.Use_Auto_Q = Menu_Bool("Auto Q",self.Use_Auto_Q,self.menu)
      self.AQMana = Menu_SliderInt("Auto Q Mana%", self.AQMana, 0, 100, self.menu)
      self.Use_Auto_E = Menu_Bool("Auto E",self.Use_Auto_E,self.menu)
      self.AEMana = Menu_SliderInt("Auto E Mana%", self.AEMana, 0, 100, self.menu)
      Menu_End()
    end
   if Menu_Begin("Misc") then
      self.Evade_R = Menu_Bool("No Evade During R",self.Evade_R,self.menu)
      self.AntiGapclose = Menu_Bool("Anti-Gap W",self.AntiGapclose,self.menu)
      self.Draw_Rs = Menu_Bool("Show Manual R Noti",self.Draw_Rs,self.menu)
      self.Rsafe = Menu_SliderInt("Safe Range R", self.Rsafe, 0, 9000, self.menu)
      Menu_End()
      end
   if Menu_Begin("Keys") then
          self.Combo = Menu_KeyBinding("Combo", self.Combo, self.menu)
          self.LaneClear = Menu_KeyBinding("LaneClear", self.LaneClear, self.menu)
          Menu_End()
          end
  Menu_End()
  end
end

function Karthus:QLogic()
    local UseQ = GetTargetSelector(self.Q.range)
    Enemy = GetAIHero(UseQ)
    if not self.isRactive and CanCast(_Q) and IsValidTarget(Enemy, self.Q.range) then
        local QPosition, HitChance, Position = pred:GetCircularCastPosition(Enemy, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
		if HitChance >= 2 then
			CastSpellToPos(QPosition.x, QPosition.z, _Q)
        end
    end 
end 

function Karthus:AutoQ()
    local UseQ = GetTargetSelector(self.Q.range)
    Enemy = GetAIHero(UseQ)
    if not self.isRactive and CanCast(_Q) and IsValidTarget(Enemy, self.Q.range) and self.Use_Auto_Q and GetPercentMP(myHero.Addr) >= self.AQMana then
        local AQPosition, HitChance, Position = pred:GetCircularCastPosition(Enemy, self.Q.delay, self.Q.width, self.Q.range, self.Q.speed, myHero, false)
		if HitChance >= 2 then
			CastSpellToPos(AQPosition.x, AQPosition.z, _Q)
        end
    end 
end 

--[[function Karthus:QLogic()
	local pTarg   = GetTargetSelector(1175, 1);
	local castPosX, castPosZ, unitPosX, unitPosZ, hitChance, _aoeTargetsHitCount = GetPredictionCore(pTarg, 0, 1.0, 140, 1175, 150, self.x, self.z, true, false, 1, 0, 2, 0, 0, 5)
	DrawCircleGame(castPosX, 0, castPosZ, 70, Lua_ARGB(185, 130, 180, 0))	
	DrawCircleGame(unitPosX, 0, unitPosZ, 50, Lua_ARGB(255, 250, 250, 0))	
	if CanCast(_Q) and pTarg and hitChance >= 6 then
		--KPos pos(outPred.GetCastPosition().x, outPred.GetCastPosition().y, outPred.GetCastPosition().z);
		--__PrintDebug(' hitChance ' ..tostring(hitChance))
		if GetKeyPress(32) == 1 or GetKeyPress(67) == 1 or GetKeyPress(86) == 1 then
			CastSpellToPos(castPosX, castPosZ, _Q)
		end
	end
end--]]

function Karthus:WLogic()
  local target = GetTargetSelector(self.W.range, 0)
  if not self.isRactive and target ~= 0 and self.Use_Combo_W and CanCast(_W) then
    if CanCast(_W) then
      tar = GetAIHero(target)
      local CastPosition, HitChance, Position = pred:GetLineCastPosition(tar,self.W.delay,self.W.width,self.W.range,self.W.speed,myHero,false)
      --local WPos, WHitChance = HPred:GetPredict(self.HPred_W_M, tar, myHero)
      if HitChance >= 2 then
      --self.W:Cast(target)
        CastSpellToPos(CastPosition.x,CastPosition.z,_W)
      end
    end
  end
end

function Karthus:AutoE()
  local target = GetTargetSelector(self.E.range, 0)
  --[[if myHero.HasBuff("KarthusDefile") and target == 0 and CanCast(_E) then
    CastSpellTarget(myHero.Addr, _E)
    end--]]
  if not myHero.HasBuff("KarthusDefile") and not self.isRactive and target ~= 0 and self.Use_Auto_E and CanCast(_E) and GetPercentMP(myHero.Addr) >= self.AEMana then
    if CanCast(_E) then
      tar = GetAIHero(target)
      local CastPosition, HitChance, Position = pred:GetCircularAOECastPosition(tar,self.E.delay,self.E.width,self.E.range,self.E.speed,myHero,false)
      if HitChance >= 2 then
        CastSpellToPos(CastPosition.x,CastPosition.z,_E)
      end
    end
  end
end

function Karthus:Eoff()
  local target = GetTargetOrb()
    if myHero.HasBuff("KarthusDefile") and target == 0 and CanCast(_E) then
    CastSpellTarget(myHero.Addr, _E)
    end
end

function Karthus:ELogic()
  local target = GetTargetSelector(self.E.range, 0)
  if myHero.HasBuff("KarthusDefile") and target == 0 and CanCast(_E) then
    CastSpellTarget(myHero.Addr, _E)
    end
  if not myHero.HasBuff("KarthusDefile") and not self.isRactive and target ~= 0 and self.Use_Combo_E and CanCast(_E) then
    if CanCast(_E) then
      tar = GetAIHero(target)
      local CastPosition, HitChance, Position = pred:GetCircularAOECastPosition(tar,self.E.delay,self.E.width,self.E.range,self.E.speed,myHero,false)
      if HitChance >= 2 then
        CastSpellToPos(CastPosition.x,CastPosition.z,_E)
      end
    end
  end
end

function Karthus:RLogic()
	local targetR = GetTargetSelector(self.R.range)
	if IsValidTarget(targetR, self.R.range) and not IsValidTarget(targetR, self.Rsafe) then
    targetR = GetAIHero(targetR)
    if targetR ~= 0 and self.Use_Combo_R and GetDamage("R", targetR) > targetR.HP and CanCast(_R) then
      CastSpellTarget(myHero.Addr, _R)
    end
  end
end

function Karthus:JGLogic()
  if CanCast(_Q) and self.Use_Lc_Q and (GetType(GetTargetOrb()) == 3) then
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

  local target = GetUnit(GetTargetOrb())
  if not myHero.HasBuff("KarthusDefile") and CanCast(_E) and self.Use_Lc_E and GetKeyPress(self.LaneClear) > 0 and GetAllUnitAroundAnObject(myHero.Addr, self.E.range) > 3
   and GetPercentMP(myHero.Addr) >= self.LCEMana then
    if IsValidTarget(target, self.E.range) then
          CastSpellTarget(myHero.Addr, _E)
          --__PrintTextGame("on")
    end
  end
  if not myHero.HasBuff("KarthusDefile") and CanCast(_E) and self.Use_Lc_E and (GetType(GetTargetOrb()) == 3) then
    if (GetObjName(GetTargetOrb()) ~= "PlantSatchel" and GetObjName(GetTargetOrb()) ~= "PlantHealth" and GetObjName(GetTargetOrb()) ~= "PlantVision") then
        target = GetUnit(GetTargetOrb())
        if IsValidTarget(target, self.E.range) then
          local JEPosition, HitChance, Position = pred:GetCircularCastPosition(target, self.E.delay, self.E.width, self.E.range, self.E.speed, myHero, false)
		      if HitChance >= 2 then
			    CastSpellToPos(JEPosition.x, JEPosition.z, _E)    
        end
      end 
    end  
  end
  self.EnemyMinions:update()
  for i ,minion in pairs(self.EnemyMinions.objects) do
    if not myHero.HasBuff("KarthusDefile") and not self.isRactive and minion ~= 0 and CanCast(_Q) and self.Use_Lc_Q and IsValidTarget(minion,self.Q.range) and GetPercentMP(myHero.Addr) >= self.LQMana and not IsDead(minion.Addr) and minion.Type == 1 then
    CastSpellToPos(minion.x,minion.z,_Q)
    end
  end
  --[[self.EnemyMinions:update()
  for i ,minion in pairs(self.EnemyMinions.objects) do
    if not self.isRactive and minion ~= 0 and CanCast(_E) and self.Use_Lc_E and IsValidTarget(minion,self.E.range) and GetPercentMP(myHero.Addr) >= self.LCEMana and not IsDead(minion.Addr) and minion.Type == 1 then
      CastSpellTarget(myHero.Addr, _E)
    end
  end--]]
end

function Karthus:GapClose()
    for i,enm in pairs(GetEnemyHeroes()) do
        if enm ~= nil and CanCast(_W) then
            local hero = GetAIHero(enm)
            local TargetDashing, CanHitDashing, DashPosition = pred:IsDashing(hero, self.W.delay, self.W.width, self.W.speed, myHero, false)
            if DashPosition ~= nil and GetDistance(DashPosition) <= self.W.range- 200 then
                CastSpellToPos(DashPosition.x,DashPosition.z,_W)
            end
        end
    end
end

function Karthus:MenuBool(stringKey, bool)
    return ReadIniBoolean(self.menu, stringKey, bool)
end

function Karthus:MenuSliderInt(stringKey, valueDefault)
    return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Karthus:MenuKeyBinding(stringKey, valueDefault)
    return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Karthus:OnUpdate()
  self:RLogic()
  self:AutoE() 
  self:AutoQ() 
  self:Eoff()
  if isRactive and self.Evade_R then
    SetEvade(true)
    end  
end 

function Karthus:OnTick()
  if IsDead(myHero.Addr) or IsTyping() or IsDodging() then return end

  if self.AntiGapclose then
  self:GapClose()
  end
	

  if GetKeyPress(self.Combo) > 0 then
      self:QLogic()
      self:WLogic()
      self:ELogic()
   end

  if GetKeyPress(self.LaneClear) > 0 then
      self:JGLogic()
   end
   if self.isRactive and self.Evade_R then
        SetEvade(true)
      end
end
