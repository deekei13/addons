include("shared.lua")

surface.CreateFont( "ChalkFont", {
font = "KG Chasing Pavements",
size = 30,
weight = 1000,
blursize = 0,
scanlines = 0,
antialias = true,
shadow = false
} )

function ENT:Draw()
	self:DrawModel()
end

local function DrawBlackboardText()
	for _, ent in ipairs(ents.FindByClass("srp_tableau")) do
		local ang = ent:GetAngles()
		local pos = ent:GetPos(ent:LocalToWorld(Vector(10, 0, 50))) + ent:GetUp( ) * 32 + ent:GetForward( ) * 1

		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), -90)

		if table.HasValue( ents.FindInSphere( LocalPlayer():GetPos(), 1500 ), ent) then
			cam.Start3D2D(pos, Angle(ang.x, ang.y, ang.z), 0.25)
				draw.DrawText(ent:GetNWString( "BlackboardText" ), "ChalkFont", 2, 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end
end
hook.Add("PostDrawTranslucentRenderables", "DrawBlackboardText", DrawBlackboardText)

net.Receive("BlackboardMenu", function()
local entity = net.ReadEntity()
local msgHistory = net.ReadTable()
local userHistory = net.ReadTable()

local HistoryPanel = vgui.Create("DFrame")
HistoryPanel:SetVisible( false )
if (table.Count(msgHistory) > 0 and table.Count(userHistory) > 0) then
	HistoryPanel:SetSize(500, 140)
	HistoryPanel:SetTitle("Historique")
	HistoryPanel:SetBackgroundBlur( true )
	HistoryPanel:ShowCloseButton( false )
	HistoryPanel:SetDraggable( false )
	HistoryPanel:SetVisible( true )
	HistoryPanel:Center( false )
	HistoryPanel:SetPos(ScrW() / 2 - 250, ScrH() / 2 + 100)
	HistoryPanel:MakePopup()
	HistoryPanel.Paint = function(self)
		draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(145,145,145,100))
	end

	local DermaListView = vgui.Create("DListView", HistoryPanel)
	DermaListView:SetPos(10, 25)
	DermaListView:SetSize(480, 105)
	DermaListView:SetMultiSelect(false)
	DermaListView:AddColumn("Pseudo"):SetFixedWidth( 100 );
	DermaListView:AddColumn("Message"):SetFixedWidth( 380 );
	for k,v in pairs(msgHistory) do
		if (userHistory[k]:IsValid()) then
	    	DermaListView:AddLine(userHistory[k]:GetName(),string.gsub(v,"\n","  "))
	    else
	    	DermaListView:AddLine("Joueur déconnecté",string.gsub(v,"\n","  "))
	    end
	end
end

local BlackboardPanel = vgui.Create("DFrame")
BlackboardPanel:SetSize(300, 175)
BlackboardPanel:SetTitle("Доска")
BlackboardPanel:SetBackgroundBlur( true )
BlackboardPanel:ShowCloseButton( false )
BlackboardPanel:SetDraggable( false )
BlackboardPanel:SetVisible( true )
BlackboardPanel:Center( true )
BlackboardPanel:MakePopup()
BlackboardPanel.Paint = function(self)
	draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(145,145,145,100))
end

local BlackboardEntry = vgui.Create( "DTextEntry", BlackboardPanel )
BlackboardEntry:SetText(entity:GetNWString( "BlackboardText" ))
BlackboardEntry:SetPos(25, 35)
BlackboardEntry:SetTall(90)
BlackboardEntry:SetWide(250)
BlackboardEntry:SetMultiline(true)

local BlackboardButton = vgui.Create("DButton", BlackboardPanel)
BlackboardButton:SetSize(85, 20)
BlackboardButton:SetPos(105, 140)
BlackboardButton:SetText("Написать")
BlackboardButton:SetTextColor(color_white)
BlackboardButton.Paint = function(self)
	draw.RoundedBox(4,0,0,self:GetWide(),self:GetTall(),Color(0,0,0,200))
end
BlackboardButton.DoClick = function()
	local text = string.len(BlackboardEntry:GetValue())
	if IsValid(entity) then
		net.Start("CompleteBlackboardText")
			net.WriteEntity(entity)
			net.WriteString(BlackboardEntry:GetValue())
		net.SendToServer()
	end
	BlackboardPanel:Remove()
	HistoryPanel:Remove()
end
end)