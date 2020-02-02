if SERVER then AddCSLuaFile() end

SWEP.PrintName = "Peacekeeper MK2"
SWEP.Author = "Hala"
SWEP.Instructions = "No Instructions"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "ar2"

resource.AddFile("sound/hla_pk_shoot")
resource.AddFile("sound/hla_pk_shoot(S)")
resource.AddFile("sound/hla_pk_magout")
resource.AddFile("sound/hla_pk_magin")

SWEP.Primary.ClipSize = 40
SWEP.Primary.DefaultClip = 40
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Recoil = 0
SWEP.Primary.ClipMax = 160
SWEP.UseHands = true
SWEP.Primary.MaxAmmo = 160

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_HEAVY
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.Weight = 50
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.HeadshotMultiplier = 2.7
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.InLoadoutFor = nil --ROLE_TRAITOR/ROLE_DETECTIVE
SWEP.LimitedStock = false
SWEP.AutoSpawnable = false


SWEP.CanBePickedUpByNPCs = true
SWEP.Slot = 2
SWEP.SlotPos = 3
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.ViewModel = "addons/!hla_pk/models/weapons/v_bo3_peacekeeper_mk2.mdl"
SWEP.WorldModel = "addons/!hla_pk/models/weapons/w_bo3_peacekeeper_mk2.mdl"
SWEP.ViewModelFlip = false
SWEP.AutoSpawnable = false
SWEP.AllowDrop = true
SWEP.Icon = "vgui/bo3_pkmk2"
SWEP.IronSightsPos = Vector(-3.01, -4, 2.341)
SWEP.IronSightsAng = Vector(0.47, 0.014, 0)

local ShootSound = Sound("hla_pk_shoot.wav")

function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   return self.HeadshotMultiplier
end

function SWEP:DoDrawCrosshair( x, y )
	surface.SetDrawColor( 0, 250, 255, 255 )
	surface.DrawOutlinedRect( x - 0, y - 0, 5, 5 )
	return true
end

function SWEP:PrimaryAttack()
	if( !self:CanPrimaryAttack() ) then return end
		self.Weapon:SetNextPrimaryFire( CurTime() + .125)
		self:EmitSound(ShootSound)
		self:ShootBullet( 20, 1, 1, .01)
		self:TakePrimaryAmmo(1)
		self.Owner:ViewPunch( Angle( .4, .1, .3 ))
	end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   self:DefaultReload( ACT_VM_RELOAD )
   self:SetIronsights( false )
end


function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )  -- View model animation
	self.Owner:MuzzleFlash() -- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 ) -- 3rd Person Animation

end