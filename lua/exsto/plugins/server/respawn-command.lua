--Created for Exsto by Shank - http://steamcommunity.com/nicatronTg

local PLUGIN = exsto.CreatePlugin()

PLUGIN:SetInfo({
	ID = "exsto-respawn",
	Name = "Respawn Players",
	Disc = "Respawn players who think they're big jobs and can't be killed",
	Owner = "Shank",
})

if !SERVER then return end

function PLUGIN.Respawn(self, ply, target)
	target:Spawn()
	
	if exsto.CurrentGamemode == "terrortown" then target:SetTeam( 1 ) end
	
	return {
		Activator = ply,
		Player = target,
		Wording = " respawned ",
		Secondary = ""
	}
end

PLUGIN:AddCommand( "respawn", {
	Call = PLUGIN.Respawn,
	Desc = "Allows a player to respawn a dead player.",
	Console = { "spawn", },
	Chat = { "!spawn" },
	ReturnOrder = "Target",
	Args = {Target="PLAYER"},
	Category = "Administration",
})
PLUGIN:RequestQuickmenuSlot( "respawn", "Spawn" )

PLUGIN:Register()