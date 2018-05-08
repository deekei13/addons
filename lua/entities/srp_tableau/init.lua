AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

nbCaracMax = 43
nbLigneMax = 7
nbMsgHistory = 5

function ENT:Initialize()
	self:SetModel("models/blackboard/blackboard.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetNetworkedVar("messageTableHistory",{"test","test2"})
	self:SetNetworkedVar("userTableHistory",{})

	self:SetNetworkedString("BlackboardText","")
end

function ENT:Use(ply)
	util.AddNetworkString( "BlackboardMenu" )

	net.Start("BlackboardMenu")
		net.WriteEntity(self)
		/*if (ply:IsUserGroup("superadmin") or ply:IsUserGroup("admin") or ply:IsUserGroup("operator") or ply:IsUserGroup("modo+") or ply:IsUserGroup("modo")) then
			net.WriteTable(self:GetNetworkedVar("messageTableHistory"))
			net.WriteTable(self:GetNetworkedVar("userTableHistory"))
		end*/
	net.Send(ply)
end

util.AddNetworkString("CompleteBlackboardText")
net.Receive("CompleteBlackboardText", function(len, ply)
	local ent = net.ReadEntity()
	local message = net.ReadString()
	local newMessage = ""
	for k, v in pairs(string.Explode("\n", message)) do
		for i=0, string.len(v) / nbCaracMax do
			if (k <= nbLigneMax) then
				newMessage = newMessage .. string.sub(v, 1 + (i * nbCaracMax), nbCaracMax + (i * nbCaracMax)) .."\n"
				k = k + 1
			end
		end
	end
	/*if (newMessage != ent:GetNetworkedString("BlackboardText")) then

		ent:SetNetworkedVar("messageTableHistory",table.insert(ent:GetNetworkedVar("messageTableHistory"), 1, message))
		ent:SetNetworkedVar("userTableHistory",table.insert(ent:GetNetworkedVar("userTableHistory"), 1, ply))
	end*/
	ent:SetNetworkedString("BlackboardText",newMessage)
	
end)