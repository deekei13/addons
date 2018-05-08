AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
    self:SetModel("models/props_lab/box01a.mdl")
    self:SetModelScale(.5)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    local Phys=self:GetPhysicsObject()
    Phys:Wake()
    Phys:SetMass(3)
    self:SetModelScale(.5)
    self:SetUseType(SIMPLE_USE)
	self:SetColor(Color(100,100,100,255))
end
function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
end
function ENT:Think()
    --
end
function ENT:Use(activator)
    if(activator:HasWeapon("wep_jack_job_drpradio"))then
		local Wep=activator:GetWeapon("wep_jack_job_drpradio")
		if not(Wep:GetEarpiece())then
			Wep:SetEarpiece(true)
			activator:EmitSound("snd_jack_job_radioswitch.wav",60,130)
			self:Remove()
		end
	end
end
function ENT:OnRemove()
    --
end