if SERVER then AddCSLuaFile() end

SWEP.PrintName = "AZ-59"
SWEP.Author = "Hala"
SWEP.Instructions = "No Instructions"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "ar2"

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Recoil = 0
SWEP.Primary.ClipMax = 90
SWEP.UseHands = true
SWEP.Primary.Sound = Sound( "AN94.Shoot" )

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
SWEP.ViewModel = "addons/!hla_an94/models/c_abakan.mdl"
SWEP.WorldModel = "addons/!hla_an94/models/w_abakan.mdl"
SWEP.ViewModelFlip = false
SWEP.AutoSpawnable = false
SWEP.AllowDrop = true
SWEP.Icon = "vgui/killicons/tfa_ins2_abakan"
SWEP.IronSightsPos = Vector(-3.01, -4, 2.841)
SWEP.IronSightsAng = Vector(0.47, 0.014, 0)

sound.Add({
    name =             "AN94.Shoot",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "^an94/hla_an94_shoot.wav" 
})
sound.Add({
    name =             "TFA_INS2.AN94.2",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "an94/suppressed_fp.wav" 
})
sound.Add({
    name =             "TFA_INS2.AN94.Boltback",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "an94/boltbackcombo.wav" 
})
sound.Add({
    name =             "TFA_INS2.AN94.Boltrelease",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "an94/boltforward.wav" 
})
sound.Add({
    name =             "TFA_INS2.AN94.Empty",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "an94/empty.wav" 
})
sound.Add({
    name =             "TFA_INS2.AN94.Magin",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "an94/hla_an94_magin.wav" 
})
sound.Add({
    name =             "TFA_INS2.AN94.Magout",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "an94/hla_an94_magout.wav" 
})
sound.Add({
    name =             "TFA_INS2.AN94.Rattle",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "an94/rattle.wav" 
})

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
		self:ShootBullet( 23, 1, 1, .02)
		self:TakePrimaryAmmo(1)
		self.Owner:ViewPunch( Angle( .05, .34, 0 ))
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