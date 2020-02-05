if SERVER then AddCSLuaFile() end

SWEP.PrintName = "Peacekeeper"
SWEP.Author = "Hala"
SWEP.Instructions = "No Instructions"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "ar2"

resource.AddFile("sound/hla_pk_shoot")
resource.AddFile("sound/hla_pk_shoot_sil")
resource.AddFile("sound/hla_pk_magout")
resource.AddFile("sound/hla_pk_magin")

SWEP.Primary.ClipSize = 40
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Recoil = 1
SWEP.Primary.ClipMax = 120
SWEP.UseHands = true
SWEP.Primary.MaxAmmo = 120
SWEP.Primary.Sound = Sound("bo3_pkmk2.Single")
SWEP.Primary.Damage         = 21
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.01
SWEP.Primary.Delay          = 0.11

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
SWEP.HeadshotMultiplier = 2.3
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

sound.Add({
	name = 			"bo3_pkmk2.Single",
	channel = 		CHAN_ITEM,
	volume = 		1,
	sound = 			"pk/hla_pk_shoot.wav"
})

sound.Add({
	name = 			"bo3_pkmk2.Suppressed",
	channel = 		CHAN_ITEM,
	volume = 		1,
	sound = 			"pk/hla_pk_shoot_sil.wav"
})

sound.Add({
	name = 			"bo3_pkmk2.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1,
	sound = 			"pk/hla_pk_magout.wav"
})

sound.Add({
	name = 			"bo3_pkmk2.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1,
	sound = 			"pk/hla_pk_magin.wav"
})

sound.Add({
	name = 			"bo3_pkmk2.Bolt_Back",
	channel = 		CHAN_ITEM,
	volume = 		1,
	sound = 			"pk/hla_pk_boltback.wav"
})

sound.Add({
	name = 			"bo3_pkmk2.Bolt_Forward",
	channel = 		CHAN_ITEM,
	volume = 		1,
	sound = 			"pk/hla_pk_boltforward.wav"
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