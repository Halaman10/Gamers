if SERVER then AddCSLuaFile() end

SWEP.PrintName = "MP7"
SWEP.Author = "Hala"
SWEP.Instructions = "No Instructions"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "smg"

SWEP.Primary.ClipSize = 35
SWEP.Primary.DefaultClip = 140
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Recoil = 1
SWEP.Primary.ClipMax = 105
SWEP.UseHands = true
SWEP.Primary.Sound = "mp7/hla_mp7_shoot.wav"
SWEP.Primary.Damage         = 13
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.01
SWEP.Primary.Delay          = 0.075

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

sound.Add({
    name =             "mp7.magout",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         1,
    sound =             "mp7/hla_mp7_magout.wav" 
})
sound.Add({
    name =             "mp7.foregrip",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         1,
    sound =             "mp7/hla_mp7_foregrip.wav" 
})
sound.Add({
    name =             "mp7.boltrelease",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         1,
    sound =             "mp7/hla_mp7_boltrelease.wav" 
})
sound.Add({
    name =             "mp7.handle",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         1,
    sound =             "mp7/hla_mp7_handle.wav" 
})
sound.Add({
    name =             "mp7.draw",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         1,
    sound =             "mp7/hla_mp7_draw.wav" 
})
sound.Add({
    name =             "mp7.magin",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         1,
    sound =             "mp7/hla_mp7_magin.wav" 
})
sound.Add({
    name =             "mp7.magin2",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         1,
    sound =             "mp7/hla_mp7_magin2.wav" 
})
sound.Add({
    name =             "mp7.magdraw",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         1,
    sound =             "mp7/hla_mp7_magdraw.wav" 
})
sound.Add(
{
    name = "Bullet.Concrete",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = SNDLVL_90dB,
    sound = 	{
		"physics/concrete/concrete_impact_bullet1.wav",
		"physics/concrete/concrete_impact_bullet2.wav",
		"physics/concrete/concrete_impact_bullet3.wav",
		"physics/concrete/concrete_impact_bullet4.wav"
		}
})
sound.Add(
{
    name = "Bullet.Flesh",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = SNDLVL_90dB,
    sound = 	{
		"physics/flesh/flesh_impact_bullet1.wav",
		"physics/flesh/flesh_impact_bullet2.wav",
		"physics/flesh/flesh_impact_bullet3.wav",
		"physics/flesh/flesh_impact_bullet4.wav",
		"physics/flesh/flesh_impact_bullet5.wav"
		}
})
sound.Add(
{
    name = "Bullet.Glass",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = SNDLVL_90dB,
    sound = 	{
		"physics/glass/glass_impact_bullet1.wav",
		"physics/glass/glass_impact_bullet2.wav",
		"physics/glass/glass_impact_bullet3.wav",
		"physics/glass/glass_impact_bullet4.wav",
		"physics/glass/glass_largesheet_break1.wav",
		"physics/glass/glass_largesheet_break2.wav",
		"physics/glass/glass_largesheet_break3.wav"
		}
})
sound.Add(
{
    name = "Bullet.Metal",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = SNDLVL_90dB,
    sound = 	{
		"physics/metal/metal_solid_impact_bullet1.wav",
		"physics/metal/metal_solid_impact_bullet2.wav",
		"physics/metal/metal_solid_impact_bullet3.wav",
		"physics/metal/metal_solid_impact_bullet4.wav"
		}
})
sound.Add(
{
    name = "Bullet.Tile",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = SNDLVL_90dB,
    sound = 	{
		"physics/plastic/plastic_box_impact_bullet1.wav",
		"physics/plastic/plastic_box_impact_bullet2.wav",
		"physics/plastic/plastic_box_impact_bullet3.wav",
		"physics/plastic/plastic_box_impact_bullet4.wav",
		"physics/plastic/plastic_box_impact_bullet5.wav"
		}
})
sound.Add(
{
    name = "Bullet.Dirt",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = SNDLVL_90dB,
    sound = 	{
		"physics/surfaces/sand_impact_bullet1.wav",
		"physics/surfaces/sand_impact_bullet2.wav",
		"physics/surfaces/sand_impact_bullet3.wav",
		"physics/surfaces/sand_impact_bullet4.wav"
		}
})
sound.Add(
{
    name = "Bullet.Wood",
    channel = CHAN_STATIC,
    volume = 1.0,
    soundlevel = SNDLVL_90dB,
    sound = 	{
		"physics/wood/wood_solid_impact_bullet1.wav",
		"physics/wood/wood_solid_impact_bullet2.wav",
		"physics/wood/wood_solid_impact_bullet3.wav",
		"physics/wood/wood_solid_impact_bullet4.wav",
		"physics/wood/wood_solid_impact_bullet5.wav"
		}
})
sound.Add(
{
    name = "Explosion.Boom",
    channel = CHAN_EXPLOSION,
    volume = 1.0,
    soundlevel = SNDLVL_150dB,
    sound = 	"GDC/ExplosionBoom.wav"

})