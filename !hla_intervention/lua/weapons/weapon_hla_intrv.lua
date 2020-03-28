if SERVER then AddCSLuaFile() end

SWEP.PrintName = "S-TAC 500"
SWEP.Author = "Hala"
SWEP.Instructions = "No Instructions"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "ar2"

SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
SWEP.Primary.Recoil = 4
SWEP.Primary.ClipMax = 20
SWEP.UseHands = true
SWEP.Primary.Sound = Sound( "TFA_L4D2_CTM200.1" )
SWEP.Primary.Damage         = 58
SWEP.Primary.NumShots       = 1
SWEP.Primary.Cone           = .002
SWEP.Primary.Delay          = 1.8

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_HEAVY
SWEP.AmmoEnt = "item_ammo_357_ttt"
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
SWEP.ViewModel = "models/c_ctm200.mdl"
SWEP.WorldModel = "models/w_ctm200.mdl"
SWEP.ViewModelFlip = false
SWEP.AutoSpawnable = false
SWEP.AllowDrop = true
SWEP.Icon = "vgui/hud/tfa_l4d2_ctm200"
SWEP.IronSightsSensitivity = .25
SWEP.IronSightsPos = Vector(0.341, -5.0, 2.439)
SWEP.IronSightsAng = Vector(0, 0, 0)

local Intrv_ADSIN = Sound("hla_intrv_adsin.wav")

sound.Add({
    name =             "TFA_L4D2_CTM200.1",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "^intrv/hla_intrv_shoot.wav" 
})
sound.Add({
    name =             "TFA_L4D2_CTM200.Deploy",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "intrv/hla_intrv_deploy.wav" 
})
sound.Add({
    name =             "TFA_L4D2_CTM200.Clipout",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "intrv/hla_intrv_magout.wav" 
})
sound.Add({
    name =             "TFA_L4D2_CTM200.Clipin",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "intrv/hla_intrv_magin.wav" 
})
sound.Add({
    name =             "TFA_L4D2_CTM200.Bolt",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "intrv/hla_intrv_bolt.wav" 
})
sound.Add({
    name =             "TFA_L4D2_CTM200.BoltForward",
    channel =         CHAN_USER_BASE+10,
    pitch = 100,
    volume =         0.9,
    sound =             "intrv/hla_intrv_boltfwd.wav" 
})

function SWEP:SetZoom(state)
   if IsValid(self:GetOwner()) and self:GetOwner():IsPlayer() then
      if state then
         self:GetOwner():SetFOV(20, 0.3)
      else
         self:GetOwner():SetFOV(0, 0.2)
      end
   end
end

function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end

   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   self:SetZoom(bIronsights)
   if (CLIENT) then
      self:EmitSound(Intrv_ADSIN)
   end

   self:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   return true
end

if CLIENT then
   local scope = surface.GetTextureID("sprites/scope")
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local scrW = ScrW()
         local scrH = ScrH()

         local x = scrW / 2.0
         local y = scrH / 2.0
         local scope_size = scrH

         -- crosshair
         local gap = 80
         local length = scope_size
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         gap = 0
         length = 50
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )


         -- cover edges
         local sh = scope_size / 2
         local w = (x - sh) + 2
         surface.DrawRect(0, 0, w, scope_size)
         surface.DrawRect(x + sh - 2, 0, w, scope_size)
         
         -- cover gaps on top and bottom of screen
         surface.DrawLine( 0, 0, scrW, 0 )
         surface.DrawLine( 0, scrH - 1, scrW, scrH - 1 )

         surface.SetDrawColor(255, 0, 0, 255)
         surface.DrawLine(x, y, x + 1, y + 1)

         -- scope
         surface.SetTexture(scope)
         surface.SetDrawColor(255, 255, 255, 255)

         surface.DrawTexturedRectRotated(x, y, scope_size, scope_size, 0)
      else
         return self.BaseClass.DrawHUD(self)
      end
   end

   function SWEP:AdjustMouseSensitivity()
      return (self:GetIronsights() and 0.2) or nil
   end
end

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
   self:SetZoom( false )
end

function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )  -- View model animation
	self.Owner:MuzzleFlash() -- Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 ) -- 3rd Person Animation

end
