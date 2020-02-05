if SERVER then AddCSLuaFile() end

SWEP.PrintName = "RPD"
SWEP.Author = "Hala"
SWEP.Instructions = "No Instructions"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "ar2"

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 300
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Recoil = 1.5
SWEP.Primary.ClipMax = 200
SWEP.UseHands = true
SWEP.Primary.Sound = Sound( "Weapon_CoD4_RPD.Single" )
SWEP.Primary.Damage         = 13
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = 0.01
SWEP.Primary.Delay          = 0.1

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
SWEP.IronSightsAng = Vector(-2.47, 0.014, 0)

sound.Add({

name = "Weapon_CoD4_RPD.Single",
channel = CHAN_WEAPON,
level = 140,
sound = "^rpd/hla_rpd_shoot.wav"

})
sound.Add({

name = "Weapon_CoD4_RPD.Chamber",
channel = CHAN_ITEM,
volume = 0.5,
sound = "rpd/hla_rpd_reload_pull.wav"

})
sound.Add({

name = "Weapon_CoD4_RPD.ClipIn",
channel = CHAN_ITEM,
volume = 0.5,
sound = "rpd/hla_rpd_clipin.wav"

})
sound.Add(
{
name = "Weapon_CoD4_RPD.ClipOut",
channel = CHAN_ITEM,
volume = 0.5,
sound = "rpd/hla_rpd_clipout.wav"
} )
sound.Add({

name = "Weapon_CoD4_RPD.Close",
channel = CHAN_ITEM,
volume = 0.5,
sound = "rpd/hla_rpd_close.wav"

})
sound.Add({

name = "Weapon_CoD4_RPD.Hit",
channel = CHAN_ITEM,
volume = 0.5,
sound = "rpd/hla_rpd_hitclosed.wav"

})
sound.Add({

name = "Weapon_CoD4_RPD.Lift",
channel = CHAN_ITEM,
volume = 0.5,
sound = "rpd/hla_rpd_lift.wav"

})
sound.Add({

name = "Weapon_CoD4_RPD.Open",
channel = CHAN_ITEM,
volume = 0.5,
sound = "rpd/hla_rpd_open.wav"

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