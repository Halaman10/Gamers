if SERVER then AddCSLuaFile() end

SWEP.PrintName = "MP7"
SWEP.Author = "Hala"
SWEP.Instructions = "No Instructions"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "smg"

resource.AddFile("sound/hla_mp7_shoot")
resource.AddFile("sound/hla_mp7_magin")
resource.AddFile("sound/hla_mp7_magin2")
resource.AddFile("sound/hla_mp7_magout")
resource.AddFile("sound/hla_mp7_forgrip")
resource.AddFile("sound/hla_mp7_boltrelease")
resource.AddFile("sound/hla_mp7_draw")
resource.AddFile("sound/hla_mp7_handle")
resource.AddFile("sound/hla_mp7_magdraw")


SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 140
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Recoil = 0
SWEP.Primary.ClipMax = 105
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
SWEP.Icon = "vgui/gdcw_mp7"
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
		self:ShootBullet( 13, 1, 1, .03)
		self:EmitSound(ShootSound)
		self:TakePrimaryAmmo(1)
		self.Owner:ViewPunch( Angle( .37, .4, 0 ))
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

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "hla_mp7_magout.wav"
instbl["name"] = "MP7.magout"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "hla_mp7_foregrip.wav"
instbl["name"] = "MP7.foregrip"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "hla_mp7_boltrelease.wav"
instbl["name"] = "MP7.boltrelease"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "hla_mp7_handle.wav"
instbl["name"] = "MP7.handle"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "hla_mp7_draw.wav"
instbl["name"] = "MP7.draw"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "hla_mp7_magin.wav"
instbl["name"] = "MP7.magin"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "hla_mp7_magin2.wav"
instbl["name"] = "MP7.magin2"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "hla_mp7_magdraw.wav"
instbl["name"] = "MP7.magdraw"

sound.Add(instbl)
