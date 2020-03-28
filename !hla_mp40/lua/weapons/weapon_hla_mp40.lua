if SERVER then AddCSLuaFile() end

SWEP.PrintName = "MP40"
SWEP.Author = "Hala"
SWEP.Instructions = "No Instructions"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "smg"

SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Recoil = 1.5
SWEP.Primary.ClipMax = 100
SWEP.UseHands = true
SWEP.Primary.Sound = "^mp40/hla_mp40_shoot.wav"
SWEP.Primary.Damage         = 17
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.01
SWEP.Primary.Delay          = 0.13

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_HEAVY
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.Weight = 50
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true
SWEP.HeadshotMultiplier = 2.0
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
SWEP.ViewModel = "models/c_bo4_mp40.mdl"
SWEP.WorldModel = "models/w_bo4_mp40.mdl"
SWEP.ViewModelFlip = false
SWEP.AutoSpawnable = false
SWEP.AllowDrop = true
SWEP.Icon = "vgui/hud/tfa_bo4_mp40"
SWEP.IronSightsPos = Vector(-4.401, -3.433, 3.007)
SWEP.IronSightsAng = Vector(1.406, 0, 0)


sound.Add({
    name =             "weapon_bo4_mp40.mag_out",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "mp40/hla_mp40_magout.wav" 
})
sound.Add({
    name =             "weapon_bo4_mp40.mag_in",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "mp40/hla_mp40_magin.wav" 
})
sound.Add({
    name =             "weapon_bo4_mp40.charge",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "mp40/hla_mp40_boltlock.wav" 
})
sound.Add({
    name =             "weapon_bo4_mp40.release",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "mp40/hla_mp40_boltrelease.wav" 
})
sound.Add({
    name =             "weapon_bo4_mp40.fire",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "^mp40/hla_mp40_shoot.wav" 
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
