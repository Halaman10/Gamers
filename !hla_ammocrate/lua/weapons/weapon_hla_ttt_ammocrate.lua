if SERVER then 
	AddCSLuaFile("weapon_hla_ttt_ammocrate.lua")
	resource.AddFile("materials/vgui/entities/ttt_ammocrate.png")
	resource.AddFile("materials/vgui/entities/ttt_ammocrate_nobg.png")
end

SWEP.HoldType						= "normal"

if CLIENT then
	SWEP.PrintName					= "Ammo Crate"
	SWEP.Slot						= 6
	
	SWEP.ViewModelFOV				= 10
	SWEP.DrawCrossHair				= false
	
	SWEP.EquipMenuData = {
		type = "Weapon",
		desc = "An ammocrate that drops ammo when you press your use button on it."
	};
	
	SWEP.Icon						= "materials/vgui/entities/ttt_ammocrate.png"
end

SWEP.Base							= "weapon_tttbase"

SWEP.ViewModel						= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel						= "models/Items/item_item_crate.mdl"

SWEP.Primary.ClipSize				= -1
SWEP.Primary.DefaultClip			= -1
SWEP.Primary.Automatic				= true
SWEP.Primary.Ammo					= "none"
SWEP.Primary.Delay					= 1.0

SWEP.Secondary.ClipSize				= -1
SWEP.Secondary.DefaultClip			= -1
SWEP.Secondary.Automatic			= true
SWEP.Secondary.Ammo					= "none"
SWEP.Secondary.Delay				= 1.0

--Putting it in the T/D shop
SWEP.Kind							= WEAPON_EQUIP
SWEP.CanBuy							= {ROLE_TRAITOR}
SWEP.LimitedStock					= true
SWEP.WeaponID						= AMMO_AMMOCRATE

SWEP.AllowDrop						= false
SWEP.NoSights						= true

--REMOVES FROM INVENTORY OnDrop
function SWEP:OnDrop()
	self:Remove()
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay)
	self:AmmoBoxDrop()
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay)
	self:AmmoBoxDrop()
end

local throwsound = Sound("Weapon_SLAM.SatchelThrow")

function SWEP:AmmoBoxDrop()
	if SERVER then
		local ply = self:GetOwner()
		if not IsValid(ply) then return end
		
		if self.Planted then return end
		
		local vsrc = ply:GetShootPos()
		local vang = ply:GetAimVector()
		local vvel = ply:GetVelocity()
		
		local vthrow = vvel + vang * 200
		
		local ammo = ents.Create("hla_ttt_ammocrate")
		ammo:SetPos(vsrc + vang * 10)
		ammo:Spawn()
		
		ammo:SetPlacer(ply)
		
		ammo:PhysWake()
		local phys = ammo:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(vthrow)
		end
		self:Remove()
		local ammoCounter = 20
		
		self.Planted = true
	end
	self:EmitSound(throwsound)
end

function SWEP:Reload()
	return false
end

function SWEP:OnRemove()
	if CLIENT and IsValid(self:GetOwner()) and self:GetOwner() == LocalPlayer() and self:GetOwner():Alive() then
		RunConsoleCommand("lastinv")
	end
end

if CLIENT then
	function SWEP:Initialize()
		self:AddHUDHelp("Press M1 to drop ammobox", nil, true)
		
		return self.BaseClass.Initialize(self)
	end
end

function SWEP:Deploy()
	if SERVER and IsValid(self:GetOwner()) then
		self:GetOwner():DrawViewModel(false)
	end
	return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end

