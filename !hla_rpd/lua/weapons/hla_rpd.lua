if SERVER then AddCSLuaFile() end

SWEP.PrintName = "RPD"
SWEP.Author = "Hala"
SWEP.Instructions = "No Instructions"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "ar2"

resource.AddFile("sound/hla_rpd_shoot")
resource.AddFile("sound/hla_rpd_clipin")
resource.AddFile("sound/hla_rpd_clipout")
resource.AddFile("sound/hla_rpd_close")
resource.AddFile("sound/hla_rpd_hitclosed")
resource.AddFile("sound/hla_rpd_lift")
resource.AddFile("sound/hla_rpd_open")
resource.AddFile("sound/hla_rpd_reload_pull")


SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 300
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Recoil = 0
SWEP.Primary.ClipMax = 200
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
SWEP.ViewModel = "models/cod4/weapons/v_rpd.mdl"
SWEP.WorldModel = "models/cod4/weapons/w_rpd.mdl"
SWEP.ViewModelFlip = false
SWEP.AutoSpawnable = false
SWEP.AllowDrop = true
SWEP.Icon = "vgui/rpd_killicon"
SWEP.IronSightsPos = Vector(-3.39, -4, 3.141)
SWEP.IronSightsAng = Vector(0.47, 0.014, 0)

local ShootSound = Sound("hla_rpd_shoot.wav")
local SoundClipIN = Sound("hla_rpd_clipin.wav")
local SoundClipOUT = Sound("hla_rpd_clipout.wav")
local SoundClose = Sound("hla_rpd_close.wav")
local SoundCloseHIT = Sound("hla_rpd_hitclosed.wav")
local SoundLift = Sound("hla_rpd_lift.wav")
local SoundOpen = Sound("hla_rpd_open.wav")
local SoundPull = Sound("hla_rpd_reload_pull.wav")


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
		self.Weapon:SetNextPrimaryFire( CurTime() + .1)
		self:EmitSound(ShootSound)
		self:ShootBullet( 13, 1, 1, .01)
		self:TakePrimaryAmmo(1)
		self.Owner:ViewPunch( Angle( -.01, -.14, 0 ))
	end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   self:DefaultReload( ACT_VM_RELOAD )
   self:SetIronsights( false )
   timer.Simple(.4, function() self:EmitSound(SoundPull) end)
   timer.Simple(2.4, function() self:EmitSound(SoundOpen) end)
   timer.Simple(2.6, function() self:EmitSound(SoundClipOUT) end)
   timer.Simple(4.6, function() self:EmitSound(SoundClipIN) end)
   timer.Simple(6.6, function() self:EmitSound(SoundClose) end)
   timer.Simple(7.2, function() self:EmitSound(SoundCloseHIT) end)
   timer.Simple(8.4, function() self:EmitSound(SoundLift) end)
   
end

function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )  -- View model animation
	self.Owner:MuzzleFlash() -- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 ) -- 3rd Person Animation

end