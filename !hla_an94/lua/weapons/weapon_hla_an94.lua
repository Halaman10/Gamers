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
SWEP.Primary.Recoil = 1
SWEP.Primary.ClipMax = 90
SWEP.UseHands = true
SWEP.Primary.Sound = Sound( "AN94.Shoot" )
SWEP.Primary.Damage         = 23
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.02
SWEP.Primary.Delay          = 0.1

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

function SWEP:PrimaryAttack(worldsnd)

   self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
   self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not self:CanPrimaryAttack() then return end

   if not worldsnd then
      self:EmitSound( self.Primary.Sound, self.Primary.SoundLevel )
   elseif SERVER then
      sound.Play(self.Primary.Sound, self:GetPos(), self.Primary.SoundLevel)
   end

   self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone() )

   self:TakePrimaryAmmo( 1 )

   local owner = self:GetOwner()
   if not IsValid(owner) or owner:IsNPC() or (not owner.ViewPunch) then return end

   owner:ViewPunch( Angle( util.SharedRandom(self:GetClass(),-0.2,-0.1,0) * self.Primary.Recoil, util.SharedRandom(self:GetClass(),-0.1,0.1,1) * self.Primary.Recoil, 0 ) )
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
