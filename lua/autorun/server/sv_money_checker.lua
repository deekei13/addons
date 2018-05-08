util.AddNetworkString( "openmonc" )

hook.Add( "PlayerSay", "PlayerSayExample", function( ply, text, team )
	if ( string.sub( text, 1, 5 ) == "!monc" ) then

		net.Start('openmonc')
		net.Send(ply)
		print("Test")

	end
end )