local cook_here = false
local cooks_list = {}

-- Functions
local function IsCookTeam( Team )
	if RPExtraTeams then
		if Team==TEAM_COOK or ( RPExtraTeams[Team] and RPExtraTeams[Team].cook ) then
			return true
		end
	end
	return false
end

-- Lua refresh
if RPExtraTeams then
	cook_here = false
	for _,pl in ipairs( player.GetAll() ) do
		if IsCookTeam( pl:Team() ) then
			cook_here = true
			cooks_list[pl] = true
		end
	end
end

-- Updater
local function RefreshCookHere()
	local pl = next( cooks_list )
	if pl then
		cook_here = true
	else
		cook_here = false
	end
end
hook.Add( "PlayerDisconnected", "darkrp_no_cook_no_hunger", function( ply )
	cooks_list[ply] = nil
	RefreshCookHere()
end )
hook.Add( "OnPlayerChangedTeam", "darkrp_no_cook_no_hunger", function( ply, oldTeam, newTeam )
	if IsCookTeam( newTeam ) then
		cooks_list[ply] = true
	else
		cooks_list[ply] = nil
	end
	RefreshCookHere()
end )

-- Nowadays HungerMod
local function hungerUpdate()
	if not cook_here then
		return true
	end
end
hook.Add( "hungerUpdate", "darkrp_no_cook_no_hunger", hungerUpdate )

-- Old HungerMod
hook.Add( "PostGamemodeLoaded", "darkrp_no_cook_no_hunger", function()
	local HookTable = hook.GetTable()
	if  istable( HookTable )
	and istable( HookTable["Think"] )
	and isfunction( HookTable["Think"]["HMThink"] ) then
		local old_HMThink = HookTable["Think"]["HMThink"]
		hook.Add( "Think", "HMThink", function( ... )
			if cook_here then
				return old_HMThink( ... )
			end
		end )
	end
end )

-- Advanced Cooking Mod
hook.Add( "thirstUpdate", "darkrp_no_cook_no_hunger", hungerUpdate )
