if SERVER then AddCSLuaFile() end

SWEP.PrintName = "S-TAC 500"
SWEP.Author = "Hala"
SWEP.Instructions = "No Instructions"

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "ar2"

resource.AddFile("sound/hla_intrv_shoot")
resource.AddFile("sound/hla_intrv_magin")
resource.AddFile("sound/hla_intrv_magout")
resource.AddFile("sound/hla_intrv_deploy")
resource.AddFile("sound/hla_intrv_bolt")
resource.AddFile("sound/hla_boltfwd")
resource.AddFile("sound/hla_adsin")
resource.AddFile("sound/hla_adsout")

SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
SWEP.Primary.Recoil = 0
SWEP.Primary.ClipMax = 20
SWEP.UseHands = true

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
SWEP.ViewModel = "addons/!hla_intervention/models/weapons/tfa_l4d2/c_ctm200.mdl"
SWEP.WorldModel = "addons/!hla_intervention/models/weapons/tfa_l4d2/w_ctm200.mdl"
SWEP.ViewModelFlip = false
SWEP.AutoSpawnable = false
SWEP.AllowDrop = true
SWEP.Icon = " "
SWEP.IronSightsSensitivity = .25
SWEP.IronSightsPos = Vector(0.341, -5.0, 2.439)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.Offset = {Pos = {Up = 0, Right = 1, Forward = -3,}, Ang = {Up = 0, Right = 0, Forward = 180,}}

local ShootSound = Sound("hla_intrv_shoot.wav")
local Intrv_Deploy = Sound("hla_intrv_deploy.wav")
local Intrv_ADSIN = Sound("hla_intrv_adsin.wav")


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

function SWEP:PrimaryAttack()
	if( !self:CanPrimaryAttack() ) then return end
		self.Weapon:SetNextPrimaryFire( CurTime() + 1.8)
		self:ShootBullet( 58, 1, 1, .0001)
		self:EmitSound(ShootSound)
		self:TakePrimaryAmmo(1)
		self.Owner:ViewPunch( Angle( 0, 0, 0 ))
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