
surface.CreateFont( "mcmain", {
font = "CloseCaption_Bold",
size = 18,
weight = 800,
antialias = true,
} )

surface.CreateFont( "mcusername", {
font = "CloseCaption_Bold",
size = 22,
weight = 800,
antialias = true,
} )

surface.CreateFont( "mctitle", {
font = "CloseCaption_Bold",
size = 15,
weight = 800,
antialias = true,
} )

surface.CreateFont( "mcx", {
font = "CloseCaption_Bold",
size = 25,
weight = 800,
antialias = true,
} )

surface.CreateFont( "mccom", {
font = "CloseCaption_Bold",
size = 20,
weight = 1000,
antialias = true,
} )

surface.CreateFont( "mccomrem", {
font = "CloseCaption_Bold",
size = 14,
weight = 1000,
antialias = true,
} )

local function formatNumber(n) -- Formats money to have "," every 3rd number.
	if not n then return "" end
	if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    local sep = sep or ","
    local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end

net.Receive('openmonc', function() -- Once resived open the UI
	print("Opening Money Checker") -- Print to console that is is open

	local blur = Material("pp/blurscreen") -- The blur background
	local function DrawBlur(panel, amount)
	        local x, y = panel:LocalToScreen(0, 0)
	        local scrW, scrH = ScrW(), ScrH()
	        surface.SetDrawColor(255, 255, 255)
	        surface.SetMaterial(blur)
	        for i = 1, 6 do
	                blur:SetFloat("$blur", (i / 3) * (amount or 6))
	                blur:Recompute()
	                render.UpdateScreenEffectTexture()
	                surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	        end
	end

	moneycheck = vgui.Create("DFrame") -- Main frame
	moneycheck:SetSize( ScrW() * 0.5, ScrH() *0.95 )
	moneycheck:SetTitle("")
	moneycheck:Center()
	moneycheck:MakePopup()
	moneycheck:ShowCloseButton(false)
	moneycheck:SetDraggable(true)
	function moneycheck:Paint( w, h )
		DrawBlur(moneycheck, 3)
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 85 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 40, 40, 40 ) )
      	draw.SimpleText( "Money Checker - Remove, Add & Set players money!", "mctitle", w/2, 5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end


	local mcplay = moneycheck:Add("DScrollPanel")
	mcplay:SetPos(0,25)
	mcplay:SetSize(moneycheck:GetWide()+mcplay:GetVBar():GetWide(), moneycheck:GetTall()-27)

	mcplay:GetVBar().Paint = function()end
	mcplay:GetVBar().btnUp.Paint = function() return true end
	mcplay:GetVBar().btnDown.Paint = function() return true end
	mcplay:GetVBar().btnGrip.Paint = function() return true end

	function mcplay:OnScrollbarAppear() return true end

	moneycheck.Update = function()
		mcplay:Clear()
		for k, v in pairs(player.GetAll()) do

			local mcpan = mcplay:Add("DPanel")
			mcpan:SetSize(mcplay:GetWide()-mcplay:GetVBar():GetWide(), 40)
			mcpan:SetPos(0, k * 42 - 41)

			local avatar = mcpan:Add("AvatarImage")
			avatar:SetPos(0, 0)	
			avatar:SetSize(40, 40)
			avatar:SetPlayer(v)

			local mcsetmon = vgui.Create("DButton", mcpan)
			mcsetmon:SetSize(60,30)
			mcsetmon:SetPos(moneycheck:GetWide()-70,5)
			mcsetmon:SetText("")
			function mcsetmon:Paint( w, h )
				draw.RoundedBox( 2, 0, 0, w, h, Color( 0, 100, 260 ) )
				draw.SimpleText( "SET", "mccom", w/2, h/7, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
			end

			mcsetmon.DoClick = function( self )
				mcsetmonamount = vgui.Create("DFrame")
				mcsetmonamount:SetSize( 300, 50 )
				mcsetmonamount:SetTitle("Set Money Amount E.G: 4000")
				mcsetmonamount:Center()
				mcsetmonamount:MakePopup()
				mcsetmonamount:ShowCloseButton(true)
				mcsetmonamount:SetDraggable(true)

				mcsetmonamountnom = vgui.Create( "DTextEntry", mcsetmonamount )
				mcsetmonamountnom:SetPos( 0, 25 )
				mcsetmonamountnom:SetSize( 300, 25 )
				mcsetmonamountnom:SetText( "" )
				mcsetmonamountnom.OnEnter = function( self )
					LocalPlayer():ConCommand( "darkrp setmoney".."\""..v:Name().."\""..self:GetValue() )
					mcsetmonamount:Close()
					chat.AddText( Color( 100, 255, 110 ), "[Money Checker] ", Color(0, 100, 260), "Set ",Color(0, 200, 0), "$"..self:GetValue(), Color( 255, 255, 255), " for ", team.GetColor(v:Team()), v:Name() )
				end
			end

			local mcremovemon = vgui.Create("DButton", mcpan)
			mcremovemon:SetSize(60,30)
			mcremovemon:SetPos(moneycheck:GetWide()-140,5)
			mcremovemon:SetText("")
			function mcremovemon:Paint( w, h )
				draw.RoundedBox( 2, 0, 0, w, h, Color( 160, 0, 40 ) )
				draw.SimpleText( "REMOVE", "mccomrem", w/2, 8, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
			end

			mcremovemon.DoClick = function( self )
				mcremmonamount = vgui.Create("DFrame")
				mcremmonamount:SetSize( 300, 50 )
				mcremmonamount:SetTitle("Add Money Amount E.G: 200")
				mcremmonamount:Center()
				mcremmonamount:MakePopup()
				mcremmonamount:ShowCloseButton(true)
				mcremmonamount:SetDraggable(true)

				mcremmonamountnom = vgui.Create( "DTextEntry", mcremmonamount )
				mcremmonamountnom:SetPos( 0, 25 )
				mcremmonamountnom:SetSize( 300, 25 )
				mcremmonamountnom:SetText( "" )
				mcremmonamountnom.OnEnter = function( self )
					LocalPlayer():ConCommand( "darkrp setmoney".."\""..v:Name().."\""..v:getDarkRPVar( "money" )-self:GetValue() )
					mcremmonamount:Close()
					chat.AddText( Color( 100, 255, 110 ), "[Money Checker] ", Color( 160, 0, 40  ), "Removed ",Color(0, 200, 0), "$"..self:GetValue(), Color( 255, 255, 255), " from ", team.GetColor(v:Team()), v:Name() )
				end
			end

			local mcaddmon = vgui.Create("DButton", mcpan)
			mcaddmon:SetSize(60,30)
			mcaddmon:SetPos(moneycheck:GetWide()-210,5)
			mcaddmon:SetText("")
			function mcaddmon:Paint( w, h )
				draw.RoundedBox( 2, 0, 0, w, h, Color( 0, 160, 0 ) )
				draw.SimpleText( "ADD", "mccom", w/2, h/7, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
			end

			mcaddmon.DoClick = function( self )
				mcaddmonamount = vgui.Create("DFrame")
				mcaddmonamount:SetSize( 300, 50 )
				mcaddmonamount:SetTitle("Add Money Amount E.G: 200")
				mcaddmonamount:Center()
				mcaddmonamount:MakePopup()
				mcaddmonamount:ShowCloseButton(true)
				mcaddmonamount:SetDraggable(true) 

				mcaddmonamountnom = vgui.Create( "DTextEntry", mcaddmonamount )
				mcaddmonamountnom:SetPos( 0, 25 )
				mcaddmonamountnom:SetSize( 300, 25 )
				mcaddmonamountnom:SetText( "" )
				mcaddmonamountnom.OnEnter = function( self )
					LocalPlayer():ConCommand( "darkrp addmoney".."\""..v:Name().."\""..self:GetValue() )
					mcaddmonamount:Close()
					chat.AddText( Color( 100, 255, 110 ), "[Money Checker] ", Color( 0, 160, 0 ), "Added ",Color(0, 200, 0), "$"..self:GetValue(), Color( 255, 255, 255), " to ", team.GetColor(v:Team()), v:Name() )
				end
			end


			mcpan.Paint = function(self, w, h)
				if not v:IsValid() then
					moneycheck.Update()
					return
				end
				surface.SetDrawColor(Color(255,255,255,255))
	      		surface.DrawRect(0, 0, w, h)

      			draw.SimpleText( v:Name(), "mcusername", 45, h/4, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
      			draw.SimpleText( "$"..formatNumber(v:getDarkRPVar( "money" )), "mcusername", w/2, h/4, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
			end
		end
	end

	local close = vgui.Create("DButton", moneycheck)
	close:SetSize(25,25)
	close:SetPos(moneycheck:GetWide() - 25,0)
	close:SetText("")
	function close:Paint( w, h )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 180, 0, 0 ) )
		draw.SimpleText( "X", "mcx", w/2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end

	close.DoClick = function()
		moneycheck:Close()
	end

	moneycheck.Update()
end)
