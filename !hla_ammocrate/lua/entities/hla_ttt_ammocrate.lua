AddCSLuaFile()

if SERVER then 
	AddCSLuaFile("hla_ttt_ammocrate.lua")
	resource.AddFile("materials/vgui/entities/ttt_ammocrate.png")
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

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "AmmoLeft")
end

function ENT:Initialize()
	self:SetModel(self.Model)
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	
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
	
	self:SetModelScale( self:GetModelScale() *.5, 1)
	self:SetHealth(150)
	
	if CLIENT then
		self:DisplayInfo()
	end
	
	self:SetColor(Color(132, 134, 140, 255))
	
	local preammo = self.AmmocrateAmmo
	self:SetAmmoLeft(preammo or 20)
	self:SetPlacer(nil)
	
	self.fingerprints = {}
end

function ENT:DisplayInfo()
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

function ENT:GiveAmmo( ply )
	local AmmoLeft = self:GetAmmoLeft()
	
	if AmmoLeft > 0 then
		self:SetAmmoLeft(AmmoLeft - 1)

		local ammos = {"item_box_buckshot_ttt", "item_ammo_357_ttt", "item_ammo_pistol_ttt", "item_ammo_smg1_ttt" }
		local randomAmmo = table.Random(ammos)
	
		local ammo = ents.Create(randomAmmo)
		local ammoPos = self:GetPos()
		ammoPos.z = ammoPos.z + 15 --So that the ammo doesn't get stuck in the ammo crate
		ammo:SetPos(ammoPos)
		ammo:Spawn()
		 
		local ammocrate = ammo:GetPhysicsObject()
		local a, b, c = math.random(-70,70) , math.random(-70,70) , math.random (10, 90)
		ammocrate:SetVelocity( Vector(a,b,c ) )
	
	else
		ply:ChatPrint("No ammo left!")
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
