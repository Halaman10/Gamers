if SERVER then 
	AddCSLuaFile("hla_ttt_ammocrate.lua")
	resource.AddFile("materials/vgui/entities/ttt_ammocrate.png")
	resource.AddFile("materials/vgui/entities/ttt_ammocrate_nobg.png")
end

if CLIENT then
	--This entity can get DNA-sampled
	ENT.Icon = "materials/vgui/entities/ttt_ammocrate"
	ENT.PrintName = "Ammo Crate"
	
	local GetPTranslation = LANG.GetParamTranslation
	
	ENT.TargetIDHint = {
		name = "Ammo Crate",
		hint = "Press E to get ammo for your gun",
		fmt  = function(ent, txt)
				return
										{ usekey = Key("+use", "USE"),
										  num    = ent:GetAmmoLeft() or 0 }
				end 
	};
	local entList = {}
	local ammoMaterial = Material("materials/vgui/entities/ttt_ammocrate_nobg.png", "no clamp")

    hook.Add("OnEntityCreated", "CheckForProp", function(ent)
        if(!IsValid(ent) or not trackingEnts[ent:GetClass()]) then return end

        	table.insert(entList, ent)

    	hook.Add( "HUDPaint", "ToScreenExample", function()
			if(LocalPlayer():GetRole() != ROLE_TRAITOR) then return end
            	-- Get a list of all props and draw a marker on screen for each prop
            	for i = 1, #entList do
					v = entList[i]
                	local point = v:GetPos() + v:OBBCenter() -- Gets the position of the entity, specifically the center
                	local data2D = point:ToScreen() -- Gets the position of the entity on your screen
    
                	-- The position is not visible from our screen, don't draw and continue onto the next prop
                	if ( not data2D.visible ) then continue end
                	-- Draw a simple text over where the prop is
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(ammoMaterial)
					surface.DrawTexturedRectRotated(data2D.x, data2D.y, 35, 35, 0)
				end
		end)
    end)    
    hook.Add("EntityRemoved", "Removing?", function(ent)
        if(IsValid(ent) && trackingEnts[ent:GetClass()]) then

        table.Empty(entList)
        end
    end)
end

ENT.AmmocrateAmmo = 20
ENT.Type = "anim"
ENT.Model = Model("models/Items/item_item_crate.mdl")

ENT.CanHavePrints = true
ENT.MaxAmmo = 20
ENT.MaxStored = 20
ENT.RechargeRate = 1
ENT.RechargeFreq = 1

ENT.NextAmmo = 0
ENT.AmmoRate = 0.25
ENT.AmmoFreq = 0.5

AccessorFunc(ENT, "Placer", "Placer")

trackingEnts = {
	["hla_ttt_ammocrate"] = true
}


function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "AmmoLeft")
end

function ENT:Initialize(ply)
	self:SetModel(self.Model)
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	
	local ammoSymbol = Material("materials/vgui/entities/ttt_ammocrate.png")

	local b = 32
	self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b, b, b))
	
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	if SERVER then
		
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(200)
		end
		
		self:SetUseType(SIMPLE_USE)
	end
	
	self:SetModelScale( self:GetModelScale() *.75, 1)
	self:SetHealth(150)
	
	if CLIENT then
		self:DisplayInfo()
	end
	
	self:SetColor(Color(65, 56, 58))
	
	local preammo = self.AmmocrateAmmo
	self:SetAmmoLeft(preammo or 20)
	self:SetPlacer(nil)
	
	self.fingerprints = {}
end

function ENT:DisplayInfo(ply)
	local GetPTranslation = LANG.GetParamTranslation
	local hintammo = self:GetAmmoLeft()
	
	self.TargetIDHint = {
		name= "Ammo Crate",
		hint= "Press " .. Key("+use", "USE") .. " to get ammo! Ammo Remaining: %d",
		fmt=function(ent, str)
			return Format(str, IsValid(self) and self:GetAmmoLeft() or 0)
		end
	}
end

function ENT:GiveAmmo( ply )			--BUG: Gives ammo if holding their magneto, holster or crowbar.
	local AmmoLeft = self:GetAmmoLeft()
	local wep = ply:GetActiveWeapon()
	local restricted = {
		["weapon_zm_carry"] = true,
		["weapon_zm_improvised"] = true, 
		["weapon_ttt_unarmed"] = true, 
		["weapon_ttt_wtester"] = true
	}

	if AmmoLeft > 0 then
		self:SetAmmoLeft(AmmoLeft - 1)

		local reserveAmmo = ply:GetAmmoCount(wep:GetPrimaryAmmoType())
		local primaryammo = wep.Primary.Ammo
		local secondaryammo = wep.Secondary.Ammo
		
		for k, v in ipairs(ply:GetWeapons(), ply:GetAmmo()) do
			if (v.Primary.Ammo) then
					if reserveAmmo < 150 then						--To ensure players don't have too much ammo.
					ply:GiveAmmo(30, v.Primary.Ammo)				--Gives ammo to their weapons
					ply:GiveAmmo(30, v.Secondary.Ammo)
				else
					if AmmoLeft < 20 then
					self:SetAmmoLeft(AmmoLeft)						--Since we tried to take ammo it will deduct it	and we want to get the ammo back in the box.											
				end	
					ply:ChatPrint("You have maximum reserve ammo!")		--Tells them that they can't get more ammo since they have max reserve ammo.
				end														
			end
		end	
	else
		ply:ChatPrint("No ammo left!")								--Writes in chat that there is no more ammo in the box.
	end
	hook.Run("TTTPlayerUsedAmmoCrate", ply, self, restocked)
end


function ENT:Use(ply)
	if IsValid(ply) and ply:IsPlayer() and ply:IsActive() then
		local t = CurTime()
		if t > self.NextAmmo then
			self:GiveAmmo(ply)
			self.NextAmmo = t + self.AmmoRate
		end
		if not table.HasValue(self.fingerprints, ply) then
			table.insert(self.fingerprints, ply)
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
	
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	
	local att = dmginfo:GetAttacker()
	if IsPlayer(att) then
		DamageLog(Format("%s damaged the ammo crate", att:Nick(), dmginfo:GetDamage()))
	end
	
	if self:Health() < 0 then
	   util.EquipmentDestroyed(self:GetPos())
				DamageLog(Format("%s destroyed the ammo crate", att:Nick(), dmginfo:GetDamage()))
		self:Remove()
		
	end
end
