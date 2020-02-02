if SERVER then AddCSLuaFile() end

SWEP.PrintName = "MP7"
SWEP.Author = "Hala"
SWEP.Instructions = "No Instructions"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "smg"

resource.AddFile("sound/hla_mp7_magin")
resource.AddFile("sound/hla_mp7_magin2")
resource.AddFile("sound/hla_mp7_magout")

SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 35
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Recoil = 0
SWEP.Primary.ClipMax = 120
SWEP.UseHands = true

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
SWEP.ViewModel = "addons/!hla_mp7/models/razorswep/weapons/v_smg_mp7.mdl"
SWEP.WorldModel = "addons/!hla_mp7/models/razorswep/weapons/w_smg_mp7.mdl"
SWEP.ViewModelFlip = false
SWEP.AutoSpawnable = false
SWEP.AllowDrop = true
SWEP.Icon = " "
SWEP.IronSightsPos = Vector(-2.491, -4.422, 3.024)
SWEP.IronSightsAng = Vector(0.3, 0.1, 0)
SWEP.Offset = {Pos = {Up = 0, Right = 1, Forward = -3,}, Ang = {Up = 0, Right = 0, Forward = 180,}}

local ShootSound = Sound("hla_mp7_shoot.wav")

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
		self.Weapon:SetNextPrimaryFire( CurTime() + .075)
		self:ShootBullet( 13, 1, 1, .02)
		self:EmitSound(ShootSound)
		self:TakePrimaryAmmo(1)
		self.Owner:ViewPunch( Angle( 0, 0, 0 ))
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